module Page.System.Logs exposing (init, update, view, Model, Msg(..))

import Components.UI as UI exposing (..)
import Html exposing (Html, div, a)
import Html.Attributes as HA exposing (class, href)
import API.System as System exposing (SystemDocumentInfo, SystemDocumentLog, State, State(..))
import AppState
import Msg as GMsg
import API
import Types.Dt as DT
import Components.DateTime exposing (dateTimeFormat)


type alias Model =
    { sysId : Maybe String
    , expanded : Bool
    }


type Msg
    = OnToday String Int


init : Maybe String -> ( Model, Cmd Msg )
init sysId =
    ( { sysId = sysId
      , expanded = False
      }
    , case sysId of
        Nothing ->
            Cmd.none

        Just s ->
            getLogs s 100000000000
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnToday sid offset ->
            ( model, Cmd.batch [ getLogs sid offset ], Nothing )


getLogs sysId offset =
    API.websocketOut <| System.getLogs sysId offset


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe (List SystemDocumentLog) -> UI Msg
view appState model system logs =
    container <|
        [ header_expander
        , row
            [ iconButton "arrow-left" ("/system/" ++ system.id)
            , stitle system.title
            ]
        , row_item [ text "События" ]
        , row
            [ UI.cmdTextIconButton "sync" "Обновить" (OnToday system.id 100000000000) ]
        ]
            ++ viewLogs appState logs


viewLogs : AppState.AppState -> Maybe (List SystemDocumentLog) -> List (UI Msg)
viewLogs appState mlogs =
    case mlogs of
        Nothing ->
            [ UI.row_item [ text "Не загружено." ] ]

        Just logs ->
            let
                i =
                    \itm ->
                        let
                            dt =
                                (itm.dt |> DT.toPosix |> dateTimeFormat appState.timeZone)
                        in
                            Html.tr [] [ Html.td [] [ text dt ], Html.td [] [ text itm.text ] ]
            in
                [ Html.table [] (logs |> List.map i) ]
