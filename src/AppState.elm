module AppState exposing (..)

-- import Date exposing (Date)

import Time exposing (Month(..))
import Task


type alias AppState =
    { timeZone : Time.Zone -- crrent timeZone

    -- , date : Date -- current DateTime
    , now : Time.Posix -- current Date + Time
    }


initModel : AppState
initModel =
    { timeZone = Time.utc

    -- , date = Date.fromCalendarDate 2019 Jan 1
    , now = Time.millisToPosix 0
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
