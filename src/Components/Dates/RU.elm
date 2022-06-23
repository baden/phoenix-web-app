module Components.Dates.RU exposing (language)

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
            "Январь"

        Feb ->
            "Февраль"

        Mar ->
            "Март"

        Apr ->
            "Апрель"

        May ->
            "Май"

        Jun ->
            "Июнь"

        Jul ->
            "Июль"

        Aug ->
            "Август"

        Sep ->
            "Сентябрь"

        Oct ->
            "Октябрь"

        Nov ->
            "Ноябрь"

        Dec ->
            "Декабрь"



-- monthNameShort : Month -> String
-- monthNameShort month =
--     case month of
--         Jan ->
--             "Янв"
--
--         Feb ->
--             "Фев"
--
--         Mar ->
--             "Март"
--
--         Apr ->
--             "Апр"
--
--         May ->
--             "Май"
--
--         Jun ->
--             "Июн"
--
--         Jul ->
--             "Июл"
--
--         Aug ->
--             "Авг"
--
--         Sep ->
--             "Сен"
--
--         Oct ->
--             "Окт"
--
--         Nov ->
--             "Ноя"
--
--         Dec ->
--             "Дек"


weekdayName : Weekday -> String
weekdayName weekday =
    case weekday of
        Mon ->
            "понедельник"

        Tue ->
            "вторник"

        Wed ->
            "среда"

        Thu ->
            "четверг"

        Fri ->
            "пятница"

        Sat ->
            "суббота"

        Sun ->
            "воскресенье"


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
