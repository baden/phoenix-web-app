module Components.Dates exposing (..)

import Html exposing (Html, div, text, a)
import Components.UI as UI
import API.System as System
import AppState
import DateFormat
import Time exposing (Zone, Posix)


-- import Date


nextSession : AppState.AppState -> Maybe System.LastSession -> List (Html msg)
nextSession appState maybeLastSession =
    case maybeLastSession of
        Nothing ->
            [ text "TBD" ]

        Just lastSession ->
            let
                offset =
                    lastSession.next |> Maybe.withDefault 0

                tz =
                    appState.timeZone

                _ =
                    Debug.log "lastSession" lastSession
            in
                [ text <|
                    "Следующий сеанс связи примерно через "
                        ++ (offset |> String.fromInt)
                        ++ " минут"
                , div [] [ text <| "Текущее дата-время: " ++ (appState.now |> dateTimeFormat tz) ]
                , div [] [ text <| "Дата последнего сеанса: " ++ (lastSession.dt |> dtToPosix |> dateTimeFormat tz) ]
                , div [] [ text <| "Ожидаемая дата следующего сеанса: " ++ (lastSession.dt + offset * 60 |> dtToPosix |> dateTimeFormat tz) ]
                ]


dtToPosix : Int -> Posix
dtToPosix dt =
    dt * 1000 |> Time.millisToPosix


dateTimeFormat : Zone -> Posix -> String
dateTimeFormat zone time =
    (dateFormat zone time) ++ " " ++ (timeFormat zone time)


dateFormat : Zone -> Posix -> String
dateFormat =
    DateFormat.format
        [ DateFormat.dayOfMonthNumber
        , divToken
        , DateFormat.monthNameAbbreviated
        , divToken
        , DateFormat.yearNumber
        ]


timeFormat : Zone -> Posix -> String
timeFormat =
    DateFormat.format
        [ DateFormat.hourMilitaryFixed
        , colonToken
        , DateFormat.minuteFixed
        , colonToken
        , DateFormat.secondFixed
        ]


colonToken : DateFormat.Token
colonToken =
    DateFormat.text ":"


spaceToken : DateFormat.Token
spaceToken =
    DateFormat.text " "


divToken : DateFormat.Token
divToken =
    DateFormat.text "/"
