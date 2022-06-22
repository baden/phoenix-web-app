module Page.System.Logs exposing (Model, Msg(..), init, update, view)

import API
import API.System as System exposing (State(..), SystemDocumentInfo, SystemDocumentLog)
import AppState
import Components.DateTime exposing (dateFormat, timeFormat)
import Components.UI as UI
import Html exposing (Html, a, button, div, li, span, text, ul)
import Html.Attributes as HA exposing (class, href, id)
import Html.Events as HE exposing (onClick)
import Json.Encode as Encode
import Msg as GMsg
import Regex
import Types.Dt as DT


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


userReplace : String -> (Regex.Match -> String) -> String -> String
userReplace userRegex replacer string =
    case Regex.fromString userRegex of
        Nothing ->
            string

        Just regex ->
            Regex.replace regex replacer string


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe (List SystemDocumentLog) -> Html Msg
view ({ t } as appState) model system mlogs =
    let
        logsBody =
            case mlogs of
                Nothing ->
                    [ li [] [ text <| t "logs.Не загружено. Нажимте кнопку Обновить." ] ]

                Just logs ->
                    let
                        logLine itm =
                            let
                                date =
                                    itm.dt |> DT.toPosix |> dateFormat appState.timeZone

                                time =
                                    itm.dt |> DT.toPosix |> timeFormat appState.timeZone
                            in
                            li []
                                [ span [ class "action-date" ]
                                    [ span [] [ text date ], span [] [ text time ] ]

                                -- , span [ HA.property "innerHTML" (Encode.string itm.text) ] []
                                , text <| t <|
                                    ("logs." ++ userReplace "<[^>]*>" (\_ -> "") itm.text)
                                ]
                    in
                    logs
                        |> List.map logLine
    in
    div [ class "container" ]
        [ div [ class "wrapper-content" ]
            [ div [ class "details-wrapper-bg scroll-wr" ]
                [ div [ class "details-header" ]
                    [ div [ class "details-title" ] [ text <| t "menu.События" ]
                    , button [ class "revert-btn", onClick (OnToday system.id 100000000000) ] [ span [ class "icon-revert" ] [] ]
                    ]
                , ul [ class "list action-list", id "scroll-wr" ] logsBody
                ]
            ]
        ]



-- viewOld : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe (List SystemDocumentLog) -> Html Msg
-- viewOld appState model system logs =
--     UI.div_ <|
--         [ UI.header_expander
--         , UI.row
--             [ UI.iconButton "arrow-left" ("/system/" ++ system.id)
--             , stitle system.title
--             ]
--         , UI.row_item [ text "События" ]
--         , row
--             [ UI.cmdTextIconButton "sync" "Обновить" (OnToday system.id 100000000000) ]
--         ]
--             ++ viewLogs appState logs
-- viewLogs : AppState.AppState -> Maybe (List SystemDocumentLog) -> List (Html Msg)
-- viewLogs appState mlogs =
--     case mlogs of
--         Nothing ->
--             [ UI.row_item [ text "Не загружено. Нажимте кнопку Обновить." ] ]
--
--         Just logs ->
--             let
--                 i =
--                     \itm ->
--                         let
--                             dt =
--                                 itm.dt |> DT.toPosix |> dateTimeFormat appState.timeZone
--                         in
--                         -- Html.tr [] [ Html.td [] [ text dt ], Html.td [] [ text itm.text ] ]
--                         -- Html.tr [] [ Html.td [] [ text dt ], Html.td [] [ Html.node "baden-log-line" [ HA.property "data-html" (Encode.string itm.text) ] [] ] ]
--                         Html.tr [ class "log-line" ] [ Html.td [] [ text dt ], Html.td [] [ Html.node "baden-log-line" [ HA.attribute "data-html" itm.text ] [] ] ]
--
--                 -- Html.tr [] [ Html.td [] [ text dt ], Html.td [ HA.property "innerHTML" (Encode.string itm.text) ] [] ]
--             in
--             [ Html.table [] (logs |> List.map i) ]
