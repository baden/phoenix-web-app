module API.System.Battery exposing (..)

import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Types.Dt as DT
import AppState



-- init_capacity: 5800
-- init_dt: 1587726596
-- last_update: 1587728224
-- counters:
-- -- accel: 462
-- -- gps: 392
-- -- gsm: 484
-- -- gsm_on: 3
-- -- sessions: 0


type alias Battery =
    { init_capacity : Float
    , init_dt : DT.Dt
    , last_update : DT.Dt
    , counters : Counters
    }


type alias Counters =
    { gsm : Int
    , gps : Int
    , accel : Int
    , gsm_on : Int
    , sessions : Int
    }


batteryDecoder : JD.Decoder Battery
batteryDecoder =
    JD.succeed Battery
        |> required "init_capacity" JD.float
        |> required "init_dt" DT.decoder
        |> required "last_update" DT.decoder
        |> required "counters" counterDecoder


counterDecoder : JD.Decoder Counters
counterDecoder =
    JD.succeed Counters
        |> required "gsm" JD.int
        |> required "gps" JD.int
        |> required "accel" JD.int
        |> required "gsm_on" JD.int
        |> required "sessions" JD.int



-- Calculations


calculation : Counters -> Int -> Float
calculation { gsm, gps, accel, gsm_on, sessions } lifetime =
    drain_self lifetime
        + drain_gsm gsm
        + drain_gps gps
        + drain_accel accel
        + drain_gsm_on gsm_on
        + drain_session sessions



-- Private
-- 0. Собственный саморазряд батареи - 1% в год (5800/365/24 = 6.6мкАч)
-- 2. Емкость одного сеанса связи в режиме Ожидание – 0,367mAh.
-- 3. Ток потребления во время сна в режиме Ожидание – 14,0mkA (сейчас 57,0mkA).
-- 4. Ток потребления во время сна в режиме Слежение – 38,0mkA (сейчас 57,0mkA).
-- 5. Ток потребления в режиме активного трекинга – 36,0mA. (GSM+GPS?)


fixer =
    -- Брать за начальную емкость батареи значение не 100%, а в 1.2 раза меньше
    1.2


drain_self : Int -> Float
drain_self s =
    -- Тут базовое потребление + собственный саморазряд - 0.010мА + 0.0066 мА
    -- (toFloat s) * (0.01 + 0.0066) / 3600
    -- (опытные образцы )Тут базовое потребление + собственный саморазряд - 0.030мА + 0.0066 мА
    -- fixer * toFloat s * (0.03 + 0.0066) / 3600
    -- (серийный Феникс)Тут базовое потребление + собственный саморазряд - 0.030мА + 0.0066 мА
    -- fixer * toFloat s * 0.016 / 3600
    -- (серийный Феникс с учетом саморазряда 3%)Тут базовое потребление + собственный саморазряд - 0.030мА + 0.0066 мА
    toFloat s * 0.036 / 3600


drain_gsm : Int -> Float
drain_gsm s =
    -- Ток потребления GSM взят с потолка - 1мА
    toFloat s * 1.0 / 3600


drain_cpu : Int -> Float
drain_cpu s =
    -- Ток потребления процессора пока он не спит (серийный)
    -- fixer * toFloat s * 0.42 / 3600
    -- Ток потребления процессора пока он не спит (опытный)
    toFloat s * 0.7 / 3600


drain_gps : Int -> Float
drain_gps s =
    -- Ток потребления GPS взят с потолка - 34мА
    toFloat s * 27.0 / 3600


drain_accel : Int -> Float
drain_accel s =
    -- В серийной версии будет 26.0мкА
    toFloat s * 0.026 / 3600


drain_gsm_on : Int -> Float
drain_gsm_on s =
    -- Ток потребления GSM взят с потолка (так, чтобы one_session_drain был равен) - 0,3667mAh.
    toFloat s * 0.3573 * 2.0 / 3.0


drain_session : Int -> Float
drain_session s =
    toFloat s * 0.3573 * 1.0 / 3.0


expect_at_sleep : AppState.AppState -> Float -> Int -> String
expect_at_sleep appState capacity sleep =
    let
        sessions =
            24 / (toFloat sleep / 60)

        one_session_drain =
            drain_gsm_on 1
                + drain_gsm 20
                + drain_cpu 20
                + drain_session 1

        -- _ =
        --     Debug.log "one_session_drain" one_session_drain
        drainD =
            capacity
                / fixer
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
                String.fromInt y ++ year_suffix appState y

            else if y > 0 then
                String.fromInt y ++ year_suffix appState y ++ " " ++ month_full appState (String.fromInt <| d // 30)

            else if d > 29 then
                month_full appState (String.fromInt m) ++ " " ++ days_full appState (d - m * 30)

            else
                -- (String.fromInt <| d) ++ "сут"
                days_full appState d
    in
    -- ss ++ " (" ++ String.fromInt drainD ++ "д)"
    ss


expect_at_tracking : AppState.AppState -> Float -> String
expect_at_tracking appState capacity =
    let
        secsInH =
            3600

        -- будем считать 33% времени работы
        drain_each_hour =
            (drain_gsm_on 1
                + drain_session 60
                + drain_gps secsInH
                + drain_gsm secsInH
                + drain_cpu secsInH
            )
                -- 0.8
                * 0.33

        -- _ =
        --     Debug.log "drain_each_hour" drain_each_hour
        drainH =
            capacity / fixer / drain_each_hour |> truncate

        d =
            drainH // 24

        h =
            drainH - d * 24

        m =
            d // 30
    in
    if m > 0 then
        month_full appState (String.fromInt m) ++ " " ++ days_full appState (d - m * 30)

    else if d > 0 then
        days_full appState d ++ " " ++ hours_full appState h
        -- String.fromInt d ++ "сут " ++ String.fromInt h ++ "ч"

    else
        hours_full appState h


year_suffix : AppState.AppState -> Int -> String
year_suffix {t} y =
    t <| case y of
        1 ->
            "dates. год"

        2 ->
            "dates. года"

        3 ->
            "dates. года"

        4 ->
            "dates. года"

        _ ->
            "dates. лет"


month_full : AppState.AppState -> String -> String
month_full {t} m =
    case m of
        "0" ->
            ""

        "1" ->
            m ++ (t "dates. месяц")

        "2" ->
            m ++ (t "dates. месяца")

        "3" ->
            m ++ (t "dates. месяца")

        "4" ->
            m ++ (t "dates. месяца")

        _ ->
            m ++ (t "dates. месяцев")


days_full : AppState.AppState -> Int -> String
days_full ({t} as appState) d =
    let
        sd =
            String.fromInt d
    in
    if d == 0 then
        ""

    else if d == 1 then
        sd ++ (t "dates. день")

    else if d == 2 || d == 3 || d == 4 then
        sd ++ (t "dates. дня")

    else if d > 30 then
        "3" ++ days_full appState (d - 30)

    else if d > 20 then
        "2" ++ days_full appState (d - 20)

    else
        sd ++ (t "dates. дней")


hours_full : AppState.AppState -> Int -> String
hours_full ({t} as appState) h =
    let
        sh =
            String.fromInt h
    in
    if h == 0 then
        ""

    else if h == 1 then
        sh ++ (t "dates. час")

    else if h == 2 || h == 3 || h == 4 then
        sh ++ (t "dates. часа")

    else if h > 20 then
        "2" ++ hours_full appState (h - 20)

    else
        sh ++ (t "dates. часов")
