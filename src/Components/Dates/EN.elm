module Components.Dates.EN exposing (language)

import DateFormat.Language exposing (Language)
import Time exposing (Month(..), Weekday(..))


-- import DateFormat exposing (Weekday)
-- import Date exposing (Date, Language, Month, Weekday, formatWithLanguage)
-- import Time exposing (Month(..), Weekday(..))


language : Language
language =
    Language
        monthName
        -- monthNameShort
        (monthName >> String.left 3)
        weekdayName
        weekdayNameShort
        (\_ -> "")
        (\_ -> "")


monthName : Month -> String
monthName month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "Augest"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"


weekdayName : Weekday -> String
weekdayName weekday =
    case weekday of
        Mon ->
            "monday"

        Tue ->
            "вторник"

        Wed ->
            "среда"

        Thu ->
            "четверг"

        Fri ->
            "friday"

        Sat ->
            "sat"

        Sun ->
            "sunday"


weekdayNameShort : Weekday -> String
weekdayNameShort weekday =
    case weekday of
        Mon ->
            "пн"

        Tue ->
            "вт"

        Wed ->
            "ср"

        Thu ->
            "чт"

        Fri ->
            "пт"

        Sat ->
            "сб"

        Sun ->
            "вс"


dayWithSuffix : Int -> String
dayWithSuffix day =
    String.fromInt day ++ "."
