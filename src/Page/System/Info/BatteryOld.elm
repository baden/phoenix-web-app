module Page.System.Info.Battery exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import API.System.Battery as Battery exposing (Battery)
import AppState
import Components.ChartSvg as ChartSvg
import Components.Dates exposing (dateFormatFull)
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, div)
import Html.Attributes as HA exposing (class, href)
import Html.Events as HE
import Page.System.Info.Types exposing (..)
import Round
import Time
import Types.Dt as DT


chartView : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
chartView appState model system =
    let
        sleep =
            case system.params.sleep of
                Nothing ->
                    120

                -- Значение по умолчанию
                Just sleepValue ->
                    sleepValue
    in
    Html.div [ HA.class "row", HA.style "margin-bottom" "0" ] <|
        case system.battery of
            Nothing ->
                [ Html.div [ HA.class "col s12 m5 l4 right-align", HE.onClick OnBatteryClick ] [ ChartSvg.chartSvg 0 "?" "gray" ]
                , Html.div [ HA.class "col s12 m7 l8 left-align" ] [ Html.p [] [ Html.text "Информация еще не доступна" ] ]
                ]

            Just battery ->
                let
                    used =
                        calculation battery.counters lifetime

                    percentage =
                        100 * (battery.init_capacity - used) / battery.init_capacity

                    p_as_text =
                        (percentage |> Round.round 1) ++ "%"

                    colour =
                        if percentage > 66 then
                            "green"

                        else if percentage > 33 then
                            "yellow"

                        else
                            "red"

                    lifetime =
                        (appState.now |> Time.posixToMillis) // 1000 - (battery.init_dt |> DT.toInt)
                in
                [ Html.div [ HA.class "col s12 m5 l4 right-align", HE.onClick OnBatteryClick ] [ ChartSvg.chartSvg percentage p_as_text colour ]
                , Html.div [ HA.class "col s12 m7 l8 left-align batView" ] <|
                    case model.batteryExtendView of
                        BVP1 ->
                            batteryView1 appState battery used sleep

                        BVP2 ->
                            batteryView2 appState battery used lifetime

                        BVP3 ->
                            batteryView3 appState battery model system
                ]



-- grad =
--     HA.style "background" "linear-gradient(0deg, rgba(244,244,244,1) 0%, rgba(255,255,255,1) 100%)"


batteryView1 : AppState.AppState -> Battery -> Float -> Int -> List (Html Msg)
batteryView1 appState battery used sleep =
    let
        capacity =
            battery.init_capacity - used
    in
    -- [ Html.p [] [ Html.text "Предполагаемое время работы:" ]
    [ Html.p [] [ Html.text "Предполагаемое время работы" ]
    , Html.p [] [ Html.text <| "В режиме Ожидание: " ++ expect_at_sleep capacity sleep ]
    , Html.p [] [ Html.text <| "В режиме Поиск: " ++ expect_at_tracking capacity ]
    ]


batteryView2 : AppState.AppState -> Battery -> Float -> Int -> List (Html Msg)
batteryView2 appState battery used lifetime =
    [ Html.hr [] []
    , Html.p [] [ Html.text "Статистика работы:" ]
    , Html.p [] [ Html.text <| "Начальная емкость батареи: " ++ String.fromFloat battery.init_capacity ++ "мАч" ]
    , Html.p [] [ Html.text <| "Начало эксплуатации: " ++ (battery.init_dt |> DT.toPosix |> dateFormatFull appState.timeZone) ]
    , duration "Общее время эксплуатации: " lifetime

    -- Не убирать пока закоментированные блоки, вдруг нужна отладка
    --
    -- , duration "Работа GSM-модуля: " battery.counters.gsm
    -- , duration "Работа GPS-модуля: " battery.counters.gps
    -- , duration "Работа акселерометра: " battery.counters.accel
    --
    -- -- , Html.p [ HA.title <| String.fromInt battery.counters.gsm ++ " сек" ] [ Html.text <| "Работа GSM-модуля: " ++ (duration battery.counters.gsm) ]
    -- -- , Html.p [] [ Html.text <| "Работа GPS-модуля: " ++ (duration battery.counters.gps) ]
    -- -- , Html.p [] [ Html.text <| "Работа акселерометра: " ++ (duration battery.counters.accel) ]
    -- , Html.p [] [ Html.text <| "Включений GSM-модуля: " ++ (String.fromInt battery.counters.gsm_on) ++ " раз" ]
    -- , Html.p [] [ Html.text <| "Сеансов связи с сервером: " ++ (String.fromInt battery.counters.sessions) ++ " раз" ]
    , Html.p [] [ Html.text <| "Израсходовано энергии батареи: " ++ Round.round 1 used ++ " мАч" ]

    -- , Html.p [] [ Html.text <| "Остаточная емкость батареи: " ++ (battery.init_capacity - used |> Round.round 1) ++ " мАч" ]
    , Html.p [] [ UI.cmdTextIconButton "tools" "Обслуживание батареи" OnBatteryMaintance ]
    , Html.hr [] []
    ]


batteryView3 : AppState.AppState -> Battery -> Model -> SystemDocumentInfo -> List (Html Msg)
batteryView3 appState battery model system =
    [ Html.hr [] []
    , Html.h6 [] [ Html.text "Обслуживание батареи" ]
    , Html.p [] [ UI.cmdTextIconButton "screwdriver" "Замена батареи" (OnBatteryChange <| BC_Change "5800") ]
    , Html.p [] [ UI.cmdTextIconButton "car-battery" "Изменить начальную емкость" (OnBatteryChange <| BC_Capacity <| String.fromFloat battery.init_capacity) ]
    , Html.p [] [ UI.cmdTextIconButton "times-circle" "Закрыть" OnBatteryMaintanceDone ]
    , Html.hr [] []
    ]
        ++ batteryCapacityDialogView model system.id


batteryCapacityDialogView : Model -> String -> List (UI Msg)
batteryCapacityDialogView model sysId =
    case model.newBatteryCapacity of
        BC_None ->
            []

        BC_Change capacity ->
            [ UI.modal
                "Замена батареи"
                [ UI.ModalText "Замена батареи должна осуществляться специалистом."
                , UI.ModalText "Используйте оригинальную батарею SAFT LSH 14, 5800мАч."
                , UI.ModalText "Если у вы устанавливаете другой тип батареи, укажите ее начальную емкость (мАч):"
                , UI.ModalHtml <| UI.formInputInline "" capacity (OnBatteryChange << BC_Change)
                ]
                [ UI.cmdButton "Применить" (OnBatteryCapacityConfirm sysId capacity)
                , UI.cmdButton "Отменить" OnBatteryCapacityCancel
                ]
            , UI.modal_overlay OnBatteryCapacityCancel
            ]

        BC_Capacity capacity ->
            [ UI.modal
                "Емкость батареи"
                [ UI.ModalText "Если у вас установлен другой тип батареи, укажите ее начальную емкость (мАч):"
                , UI.ModalHtml <| UI.formInputInline "" capacity (OnBatteryChange << BC_Capacity)
                ]
                [ UI.cmdButton "Применить" (OnBatteryCapacityConfirm sysId capacity)
                , UI.cmdButton "Отменить" OnBatteryCapacityCancel
                ]
            , UI.modal_overlay OnBatteryCapacityCancel
            ]


duration : String -> Int -> Html Msg
duration title_ secs =
    let
        d =
            if secs < 60 then
                String.fromInt secs ++ " сек"

            else if secs < 60 * 60 then
                (String.fromInt <| secs // 60) ++ " мин"

            else
                let
                    h =
                        secs // 3600

                    m =
                        (secs - h * 3600) // 60
                in
                String.fromInt h ++ " ч " ++ String.fromInt m ++ " мин"
    in
    Html.p [ HA.title <| String.fromInt secs ++ " сек" ] [ Html.text <| title_ ++ " " ++ d ]



-- 0. Собственный саморазряд батареи - 1% в год (5800/365/24 = 6.6мкАч)
-- 2. Емкость одного сеанса связи в режиме Ожидание – 0,367mAh.
-- 3. Ток потребления во время сна в режиме Ожидание – 14,0mkA (сейчас 57,0mkA).
-- 4. Ток потребления во время сна в режиме Слежение – 38,0mkA (сейчас 57,0mkA).
-- 5. Ток потребления в режиме активного трекинга – 36,0mA. (GSM+GPS?)


drain_self : Int -> Float
drain_self s =
    -- Тут базовое потребление + собственный саморазряд - 0.010мА + 0.0066 мА
    -- (toFloat s) * (0.01 + 0.0066) / 3600
    -- (опытные образцы )Тут базовое потребление + собственный саморазряд - 0.030мА + 0.0066 мА
    toFloat s * (0.03 + 0.0066) / 3600


drain_gsm : Int -> Float
drain_gsm s =
    -- Ток потребления GSM взят с потолка - 1мА
    toFloat s * 1.0 / 3600


drain_cpu : Int -> Float
drain_cpu s =
    -- Ток потребления процессора пока он не спит
    toFloat s * 0.7 / 3600


drain_gps : Int -> Float
drain_gps s =
    -- Ток потребления GPS взят с потолка - 34мА
    toFloat s * 27.0 / 3600


drain_accel : Int -> Float
drain_accel s =
    -- В серийной версии будет 38.0мкА
    toFloat s * 0.038 / 3600


drain_gsm_on : Int -> Float
drain_gsm_on s =
    -- Ток потребления GSM взят с потолка (как сеанс связи с сервером) - 0,3667mAh.
    toFloat s * 0.3667 * 2.0 / 3


drain_session : Int -> Float
drain_session s =
    toFloat s * 0.3667 * 1.0 / 3


calculation : Battery.Counters -> Int -> Float
calculation { gsm, gps, accel, gsm_on, sessions } lifetime =
    drain_self lifetime
        + drain_gsm gsm
        + drain_gps gps
        + drain_accel accel
        + drain_gsm_on gsm_on
        + drain_session sessions



-- sleep =
--     -- Тут проблема определения кол-ва сеансов связи в сутки
--     -- пока считаем что их 4 в сутки (каждые 6 часов)
--     6


expect_at_sleep : Float -> Int -> String
expect_at_sleep capacity sleep =
    let
        sessions =
            24 / (toFloat sleep / 60)

        one_session_drain =
            drain_gsm_on 1
                + drain_gsm 20
                + drain_cpu 20
                + drain_session 1

        drainD =
            capacity
                / (drain_self 86400 + sessions * one_session_drain)
                |> truncate

        y =
            drainD // 365

        d =
            drainD - y * 365

        m =
            d // 30

        ss =
            if y > 10 then
                String.fromInt y ++ year_suffix y

            else if y > 0 then
                String.fromInt y ++ year_suffix y ++ " " ++ month_full (String.fromInt <| d // 30)

            else if d > 29 then
                month_full (String.fromInt m) ++ " " ++ days_full (d - m * 30)

            else
                -- (String.fromInt <| d) ++ "сут"
                days_full d
    in
    -- ss ++ " (" ++ String.fromInt drainD ++ "д)"
    ss


expect_at_tracking : Float -> String
expect_at_tracking capacity =
    let
        -- будем считать 80% времени работы
        secsInH =
            3600

        drain_each_hour =
            (drain_gsm_on 1
                + drain_session 60
                + drain_gps secsInH
                + drain_gsm secsInH
                + drain_cpu secsInH
            )
                * 0.8

        drainH =
            capacity / drain_each_hour |> truncate

        d =
            drainH // 24

        h =
            drainH - d * 24

        m =
            d // 30
    in
    if m > 0 then
        month_full (String.fromInt m) ++ " " ++ days_full (d - m * 30)

    else if d > 0 then
        days_full d ++ " " ++ hours_full h
        -- String.fromInt d ++ "сут " ++ String.fromInt h ++ "ч"

    else
        hours_full h



-- String.fromInt h ++ "ч"


year_suffix : Int -> String
year_suffix y =
    case y of
        1 ->
            " год"

        2 ->
            " года"

        3 ->
            " года"

        4 ->
            " года"

        _ ->
            " лет"


month_full : String -> String
month_full m =
    case m of
        "0" ->
            ""

        "1" ->
            m ++ " месяц"

        "2" ->
            m ++ " месяца"

        "3" ->
            m ++ " месяца"

        "4" ->
            m ++ " месяца"

        _ ->
            m ++ " месяцев"


days_full : Int -> String
days_full d =
    let
        sd =
            String.fromInt d
    in
    if d == 0 then
        ""

    else if d == 1 then
        sd ++ " день"

    else if d == 2 || d == 3 || d == 4 then
        sd ++ " дня"

    else if d > 30 then
        "3" ++ days_full (d - 30)

    else if d > 20 then
        "2" ++ days_full (d - 20)

    else
        sd ++ " дней"


hours_full : Int -> String
hours_full h =
    let
        sh =
            String.fromInt h
    in
    if h == 0 then
        ""

    else if h == 1 then
        sh ++ " час"

    else if h == 2 || h == 3 || h == 4 then
        sh ++ " часа"

    else if h > 20 then
        "2" ++ hours_full (h - 20)

    else
        sh ++ " часов"



-- 1 - день
-- 2 - дня
-- 3 - дня
-- 4 - дня
-- 5 - дней
-- 6 - дней
-- 7 - дней
-- ..
-- 20 - дней
-- 21
-- (last_session |> DT.toPosix |> dateTimeFormat tz)
