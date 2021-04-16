module AppState exposing (..)

-- import Date exposing (Date)

import I18N
import I18Next exposing (Delims(..), Replacements, Translations, initialTranslations, t, tr)
import Task
import Time exposing (Month(..))


type alias AppState =
    { timeZone : Time.Zone -- crrent timeZone

    -- , date : Date -- current DateTime
    , now : Time.Posix -- current Date + Time

    -- , translations : Translations
    , langCode : String
    , themeName : String
    , scaleName : String
    , t : String -> String
    , tr : String -> Replacements -> String
    }


initModel : String -> String -> String -> AppState
initModel lang themeName scaleName =
    { timeZone = Time.utc

    -- , date = Date.fromCalendarDate 2019 Jan 1
    , now = Time.millisToPosix 0

    -- , translations = initialTranslations
    , langCode = lang
    , themeName = themeName
    , scaleName = scaleName
    , t = t (I18N.translations lang)
    , tr = tr (I18N.translations lang) Curly
    }



-- initCmd : (Time.Zone -> msg) -> (Date -> msg) -> List (Cmd msg)


initCmd : (Time.Zone -> msg) -> (Time.Posix -> msg) -> List (Cmd msg)
initCmd timeCmd nowCmd =
    [ Time.here |> Task.perform timeCmd

    -- , Date.today |> Task.perform dateCmd
    , Time.now |> Task.perform nowCmd
    ]


updateTimeZone : Time.Zone -> AppState -> AppState
updateTimeZone zone appState =
    { appState | timeZone = zone }



-- updateDate : Date -> AppState -> AppState
-- updateDate date appState =
--     { appState | date = date }


updateNow : Time.Posix -> AppState -> AppState
updateNow time appState =
    { appState | now = time }
