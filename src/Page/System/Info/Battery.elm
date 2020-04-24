module Page.System.Info.Battery exposing (..)

import Page.System.Info.Types exposing (Model, Msg, Msg(..))
import Html exposing (Html, div, a)
import Html.Attributes as HA exposing (class, href)
import Html.Events as HE
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import Components.ChartSvg as ChartSvg
import API.System.Battery as Battery exposing (Battery)
import Types.Dt as DT
import Components.Dates exposing (dateFormatFull)
import AppState
import Round
import Time


chartView : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
chartView appState model system =
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
                    , Html.div [ HA.class "col s12 m7 l8 left-align" ] <|
                        (if model.batteryExtendView then
                            batteryView2 appState battery used lifetime
                         else
                            batteryView1 appState battery used
                        )
                    ]


batteryView1 : AppState.AppState -> Battery -> Float -> List (Html Msg)
batteryView1 appState battery used =
    let
        capacity =
            battery.init_capacity - used
    in
        [ Html.p [] [ Html.text "Ожидаемое время работы:" ]
        , Html.p [] [ Html.text <| "В режиме ожидания: ≈ " ++ (expect_at_sleep capacity) ]
        , Html.p [] [ Html.text <| "В режиме поиска: ≈ " ++ (expect_at_tracking capacity) ]
        ]


batteryView2 : AppState.AppState -> Battery -> Float -> Int -> List (Html Msg)
batteryView2 appState battery used lifetime =
    [ Html.p [] [ Html.text "Статистика работы:" ]
    , Html.p [] [ Html.text <| "Начальная емкость батареи: " ++ (String.fromFloat battery.init_capacity) ++ "мАч" ]
    , Html.p [] [ Html.text <| "Начало эксплуатации: " ++ (battery.init_dt |> DT.toPosix |> dateFormatFull appState.timeZone) ]
    , duration "Общее время эксплуатации: " lifetime
    , duration "Работа GSM-модуля: " battery.counters.gsm
    , duration "Работа GPS-модуля: " battery.counters.gps
    , duration "Работа акселерометра: " battery.counters.accel

    -- , Html.p [ HA.title <| String.fromInt battery.counters.gsm ++ " сек" ] [ Html.text <| "Работа GSM-модуля: " ++ (duration battery.counters.gsm) ]
    -- , Html.p [] [ Html.text <| "Работа GPS-модуля: " ++ (duration battery.counters.gps) ]
    -- , Html.p [] [ Html.text <| "Работа акселерометра: " ++ (duration battery.counters.accel) ]
    , Html.p [] [ Html.text <| "Включений GSM-модуля: " ++ (String.fromInt battery.counters.gsm_on) ++ " раз" ]
    , Html.p [] [ Html.text <| "Сеансов связи с сервером: " ++ (String.fromInt battery.counters.sessions) ++ " раз" ]
    , Html.p [] [ Html.text <| "Израсходовано энергии батареи: " ++ (Round.round 1 used) ++ " мАч" ]
    , Html.p [] [ Html.text <| "Остаточная емкость батареи: " ++ (battery.init_capacity - used |> Round.round 1) ++ " мАч" ]
    ]


duration : String -> Int -> Html Msg
duration title_ secs =
    let
        d =
            if secs < 60 then
                (String.fromInt secs) ++ " сек"
            else if secs < 60 * 60 then
                (String.fromInt <| secs // 60) ++ " мин"
            else
                let
                    h =
                        secs // 3600

                    m =
                        (secs - h * 3600) // 60
                in
                    (String.fromInt h) ++ " ч " ++ (String.fromInt m) ++ " мин"
    in
        Html.p [ HA.title <| String.fromInt secs ++ " сек" ] [ Html.text <| title_ ++ " " ++ d ]



-- 0. Собственный саморазряд батареи - 1% в год (5800/365/24 = 6.6мкАч)
-- 2. Емкость одного сеанса связи в режиме Ожидание – 0,367mAh.
-- 3. Ток потребления во время сна в режиме Ожидание – 14,0mkA (сейчас 57,0mkA).
-- 4. Ток потребления во время сна в режиме Слежение – 38,0mkA (сейчас 57,0mkA).
-- 5. Ток потребления в режиме активного трекинга – 36,0mA. (GSM+GPS?)


drain_self : Int -> Float
drain_self s =
    -- Тут базовое потребление + собственный саморазряд
    (toFloat s) * (0.0066 + 0.014) / 3600


drain_gsm : Int -> Float
drain_gsm s =
    -- Ток потребления GSM взят с потолка - 2мА
    (toFloat s) * 2.0 / 3600


drain_gps : Int -> Float
drain_gps s =
    -- Ток потребления GSM взят с потолка - 34мА
    (toFloat s) * 34.0 / 3600


drain_accel : Int -> Float
drain_accel s =
    -- В серийной версии будет 38.0мкА
    (toFloat s) * 0.038 / 3600


drain_gsm_on : Int -> Float
drain_gsm_on s =
    -- Ток потребления GSM взят с потолка (как сеанс связи с сервером) - 0,367mAh.
    (toFloat s) * 0.367


drain_session : Int -> Float
drain_session s =
    (toFloat s) * 0.367


calculation : Battery.Counters -> Int -> Float
calculation { gsm, gps, accel, gsm_on, sessions } lifetime =
    (drain_self lifetime)
        + (drain_gsm gsm)
        + (drain_gps gps)
        + (drain_accel accel)
        + (drain_gsm_on gsm_on)
        + (drain_session sessions)


sleep =
    -- Тут проблема определения кол-ва сеансов связи в сутки
    -- пока считаем что их 4 в сутки (каждые 6 часов)
    6


expect_at_sleep : Float -> String
expect_at_sleep capacity =
    let
        sessions =
            24 / sleep

        one_session_drain =
            ((drain_gsm_on 1)
                + (drain_gsm 20)
                + (drain_session 1)
            )

        drainD =
            capacity
                / ((drain_self 86400) + sessions * one_session_drain)
                |> truncate

        y =
            drainD // 365

        d =
            drainD - y * 365
    in
        if y > 0 then
            (String.fromInt y) ++ (year_suffix y) ++ " " ++ (String.fromInt <| d // 30) ++ " мес"
        else
            (String.fromInt <| d // 30) ++ " мес"


expect_at_tracking : Float -> String
expect_at_tracking capacity =
    let
        drain_each_hour =
            ((drain_gsm_on 1)
                -- саморазряд, базовое потребление, акселерометр и подобную мелочевку можно не учитывать
                -- + (drain_self 3600)
                -- включен все время
                + (drain_gsm 3600)
                -- раз в минуту
                + (drain_session 60)
                -- включен 1/3 времени
                + (drain_gps 1200)
            )

        drainH =
            capacity / drain_each_hour |> truncate

        d =
            drainH // 24

        h =
            drainH - d * 24
    in
        if d > 0 then
            String.fromInt d ++ " д " ++ String.fromInt h ++ " ч"
        else
            String.fromInt h ++ " ч"


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



-- (last_session |> DT.toPosix |> dateTimeFormat tz)
