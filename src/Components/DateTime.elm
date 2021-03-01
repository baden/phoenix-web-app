module Components.DateTime exposing (..)

import Time


dateFormat : Time.Zone -> Time.Posix -> String
dateFormat timeZone time =
    let
        -- year =
        --     Time.toYear timeZone time |> String.fromInt
        month =
            Time.toMonth timeZone time |> toNumMonth

        day =
            Time.toDay timeZone time |> String.fromInt |> String.padLeft 2 '0'
    in
    day ++ "/" ++ month


timeFormat : Time.Zone -> Time.Posix -> String
timeFormat timeZone time =
    let
        hour =
            Time.toHour timeZone time |> String.fromInt |> String.padLeft 2 '0'

        minute =
            Time.toMinute timeZone time |> String.fromInt |> String.padLeft 2 '0'
    in
    hour ++ ":" ++ minute


dateTimeFormat : Time.Zone -> Time.Posix -> String
dateTimeFormat timeZone time =
    dateFormat timeZone time ++ " " ++ timeFormat timeZone time



-- let
--     -- year =
--     --     Time.toYear timeZone time |> String.fromInt
--     month =
--         Time.toMonth timeZone time |> toNumMonth
--
--     day =
--         Time.toDay timeZone time |> String.fromInt |> String.padLeft 2 '0'
--
--     hour =
--         Time.toHour timeZone time |> String.fromInt |> String.padLeft 2 '0'
--
--     minute =
--         Time.toMinute timeZone time |> String.fromInt |> String.padLeft 2 '0'
--
--     -- second =
--     --     Time.toSecond timeZone time |> String.fromInt |> String.padLeft 2 '0'
-- in
-- -- day ++ "/" ++ month ++ "/" ++ year ++ " " ++ hour ++ ":" ++ minute ++ ":" ++ second
-- day ++ "/" ++ month ++ " " ++ hour ++ ":" ++ minute


toNumMonth : Time.Month -> String
toNumMonth month =
    case month of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"
