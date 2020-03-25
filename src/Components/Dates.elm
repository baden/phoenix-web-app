module Components.Dates exposing (..)

import Html exposing (Html, div, text, a)
import Html.Attributes as HA
import Components.UI as UI
import API.System as System
import AppState
import DateFormat
import Time exposing (Zone, Posix)
import Types.Dt as DT


-- import Date


nextSession : AppState.AppState -> Maybe System.Dynamic -> List (Html msg)
nextSession appState maybeSystemDynamic =
    case maybeSystemDynamic of
        Nothing ->
            [ text "Информация будет доступна после выхода трекера на связь." ]

        Just dynamic ->
            let
                now =
                    appState.now

                last_session =
                    case dynamic.lastping of
                        Nothing ->
                            DT.fromInt 0

                        Just lastping ->
                            lastping

                tz =
                    appState.timeZone

                nextSessionTextRow =
                    case dynamic.state of
                        Just System.Off ->
                            []

                        _ ->
                            [ Html.div [ HA.class "row" ]
                                [ Html.div [ HA.class "col s6" ] [ text "Следующий сеанс связи: " ]
                                , Html.div [ HA.class "col s6" ] [ text <| nextSessionText last_session dynamic.next tz ]
                                ]
                            ]
            in
                [ Html.div [ HA.class "row" ]
                    [ Html.div [ HA.class "col s6" ] [ Html.text "Последний сеанс связи: " ]
                    , Html.div [ HA.class "col s6" ] [ Html.text <| (last_session |> DT.toPosix |> dateTimeFormat tz) ]
                    ]
                ]
                    ++ nextSessionTextRow


expectSleepIn : AppState.AppState -> System.Dynamic -> List (Html msg)
expectSleepIn appState dynamic =
    let
        now =
            appState.now

        last_session =
            case dynamic.lastping of
                Nothing ->
                    DT.fromInt 0

                Just lastping ->
                    lastping

        autosleep =
            case dynamic.autosleep of
                Nothing ->
                    "-"

                Just offset ->
                    -- offset
                    DT.addSecs last_session offset |> DT.toPosix |> dateTimeFormat tz

        tz =
            appState.timeZone
    in
        [ Html.table []
            [ Html.tr []
                [ Html.td [] [ text "Трекер уснет: " ]
                , Html.td [] [ text <| (autosleep) ]
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


sysPosition : AppState.AppState -> String -> Maybe System.Dynamic -> List (Html msg)
sysPosition appState sid maybe_dynamic =
    case maybe_dynamic of
        Nothing ->
            []

        Just dynamic ->
            case ( dynamic.latitude, dynamic.longitude, dynamic.dt ) of
                ( Just latitude, Just longitude, Just dt ) ->
                    [ Html.div [ HA.class "row" ]
                        [ --text <| "Последнее положение определено: " ++ (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ++ " "
                          Html.div [ HA.class "col s6" ] [ text "Последнее положение определено:" ]
                        , Html.div [ HA.class "col s6" ] [ text <| (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ]
                        , Html.div [ HA.class "col s12" ] [ UI.linkIconTextButton "map" "Смотреть на карте" ("/map/" ++ sid) ]
                        ]
                    ]

                ( _, _, _ ) ->
                    [ UI.row_item [ text <| "Положение неизвестно" ] ]


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
