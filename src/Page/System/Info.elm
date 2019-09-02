module Page.System.Info exposing (init, update, view, Model, Msg(..))

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI
import Components.Dates as Dates
import API
import API.System as System exposing (SystemDocumentInfo, SysState, State)
import AppState


type alias Model =
    { showTitleChangeDialog : Bool
    , newTitle : String
    }


type Msg
    = OnSysCmd String System.State
    | OnSysCmdCancel String
    | OnTitleChangeStart String
    | OnTitleChange String
    | OnTitleConfirm String String
    | OnTitleCancel


init : ( Model, Cmd Msg )
init =
    ( { showTitleChangeDialog = False
      , newTitle = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnSysCmd sysId state ->
            -- let
            --     _ =
            --         Debug.log "Make new state:" state
            -- in
            ( model, Cmd.batch [ API.websocketOut <| System.setSystemState sysId state ] )

        OnSysCmdCancel sysId ->
            ( model, Cmd.batch [ API.websocketOut <| System.cancelSystemState sysId ] )

        OnTitleChangeStart oldTitle ->
            ( { model | showTitleChangeDialog = True, newTitle = oldTitle }, Cmd.none )

        OnTitleChange enteredTitle ->
            ( { model | newTitle = enteredTitle }, Cmd.none )

        OnTitleConfirm sysId newTitle ->
            let
                cmd =
                    API.websocketOut <|
                        System.setSystemTitle sysId newTitle
            in
                ( { model | showTitleChangeDialog = False }, Cmd.batch [ cmd ] )

        OnTitleCancel ->
            ( { model | showTitleChangeDialog = False }, Cmd.none )


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view appState model system =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col s12 m8 offset-m2 xl7 offset-xl2" ] <|
                [ UI.row_item
                    [ text system.title
                    , UI.cmdButton "…" (OnTitleChangeStart system.title)
                    ]

                -- , div [] [ text <| "Id:" ++ system.id ]
                , UI.row_item [ ChartSvg.chartView "Батарея" 80 ]
                , UI.row_item [ text <| "Состояние: " ++ (sysState_of system.state) ]
                , UI.row_item (cmdPanel system.id system.state system.waitState)
                , UI.row_item (Dates.nextSession appState system.lastSession)
                , UI.button ("/map/" ++ system.id) "Смотреть на карте"
                , UI.row_item [ UI.button "/" "На главную" ]
                ]
                    ++ (titleChangeDialogView model system.id)
            ]
        ]


sysState_of : Maybe SysState -> String
sysState_of sysState =
    case sysState of
        Nothing ->
            "-"

        Just state ->
            (System.stateAsString state.current)


cmdPanel : String -> Maybe SysState -> Maybe State -> List (Html Msg)
cmdPanel sysId sysState waitState =
    case waitState of
        Nothing ->
            case sysState of
                Nothing ->
                    []

                Just state ->
                    let
                        b =
                            \i -> UI.cmdButton (System.stateAsCmdString i) (OnSysCmd sysId i)
                    in
                        state.available
                            |> List.map b

        Just wState ->
            [ text <| "При следуюем сеансе связи, система будет переведена в режим: " ++ (System.stateAsString wState)
            , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
            ]


titleChangeDialogView : Model -> String -> List (Html Msg)
titleChangeDialogView model sysId =
    if model.showTitleChangeDialog then
        [ UI.modal
            "Название"
            [ UI.ModalText "Отображаемое имя системы:"
            , UI.ModalHtml <| UI.formInput "Имя" model.newTitle OnTitleChange
            ]
            [ UI.cmdButton "Применить" (OnTitleConfirm sysId model.newTitle)
            , UI.cmdButton "Отменить" (OnTitleCancel)
            ]
        , UI.modal_overlay OnTitleCancel
        ]
    else
        []
