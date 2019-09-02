module Components.Dates exposing (..)

import Html exposing (Html, div, text, a)
import Components.UI as UI
import API.System as System
import AppState
import DateFormat
import Time exposing (Zone, Posix)
import Types.Dt as DT


-- import Date


nextSession : AppState.AppState -> Maybe System.LastSession -> List (Html msg)
nextSession appState maybeLastSession =
    case maybeLastSession of
        Nothing ->
            [ text "TBD" ]

        Just lastSession ->
            let
                now =
                    appState.now

                last_session =
                    lastSession.dt

                tz =
                    appState.timeZone
            in
                [ --text <|
                  --     "Следующий сеанс связи примерно через "
                  --         ++ (offset |> String.fromInt)
                  --         ++ " минут"
                  -- div [] [ text <| "Текущее дата-время: " ++ (now |> dateTimeFormat tz) ]
                  Html.table []
                    [ Html.tr []
                        [ Html.td [] [ text "Дата последнего сеанса: " ]
                        , Html.td [] [ text <| (last_session |> DT.toPosix |> dateTimeFormat tz) ]
                        ]
                    , Html.tr []
                        [ Html.td [] [ text "Ожидаемая дата следующего сеанса: " ]
                        , Html.td []
                            [ text <| nextSessionText last_session lastSession.next tz ]
                        ]
                    ]
                ]


nextSessionText : DT.Dt -> Maybe DT.Offset -> Zone -> String
nextSessionText last_session next_session tz =
    case next_session of
        Nothing ->
            "неизвестно"

        Just offset ->
            DT.addSecs last_session offset |> DT.toPosix |> dateTimeFormat tz


humanOffsetP : Int -> Int -> String
humanOffsetP before current =
    " (" ++ (humanOffset before current) ++ ")"


humanOffset : Int -> Int -> String
humanOffset before current =
    let
        -- _ =
        --     Debug.log "offset" offset
        offset =
            before - current

        inRange a b x =
            if (x >= a) && (x <= b) then
                True
            else
                False
    in
        if (inRange -40 40 offset) then
            "только что"
        else if (inRange -100 -40 offset) then
            "около минуты назад"
        else if offset < -100 then
            "давно"
        else
            "неизвестно"


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
