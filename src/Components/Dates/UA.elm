module Components.Dates.UA exposing (language)

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
            "Січень"

        Feb ->
            "Лютий"

        Mar ->
            "Березень"

        Apr ->
            "Квітень"

        May ->
            "Травень"

        Jun ->
            "Червень"

        Jul ->
            "Липень"

        Aug ->
            "Серпень"

        Sep ->
            "Вересень"

        Oct ->
            "Жовтень"

        Nov ->
            "Листопад"

        Dec ->
            "Грудень"


weekdayName : Weekday -> String
weekdayName weekday =
    case weekday of
        Mon ->
            "понеділок"

        Tue ->
            "вівторок"

        Wed ->
            "середа"

        Thu ->
            "четвер"

        Fri ->
            "п'ятниця"

        Sat ->
            "субота"

        Sun ->
            "неділя"


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
            "нд"


dayWithSuffix : Int -> String
dayWithSuffix day =
    String.fromInt day ++ "."
