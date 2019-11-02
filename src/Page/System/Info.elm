module Page.System.Info exposing (init, update, view, Model, Msg(..))

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI
import Components.Dates as Dates
import API
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import AppState


type alias Model =
    { showTitleChangeDialog : Bool
    , newTitle : String
    , extendInfo : Bool
    , showConfirmOffDialog : Bool
    , offId : String
    }


type Msg
    = OnSysCmd String System.State
    | OnSysCmdCancel String
    | OnTitleChangeStart String
    | OnTitleChange String
    | OnTitleConfirm String String
    | OnTitleCancel
    | OnExtendInfo
    | OnConfirmOff
    | OnCancelOff


init : ( Model, Cmd Msg )
init =
    ( { showTitleChangeDialog = False
      , newTitle = ""
      , extendInfo = False
      , showConfirmOffDialog = False
      , offId = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnSysCmd sysId Off ->
            ( { model | offId = sysId, showConfirmOffDialog = True }, Cmd.none )

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

        OnExtendInfo ->
            ( { model | extendInfo = not model.extendInfo }, Cmd.none )

        OnConfirmOff ->
            ( { model | showConfirmOffDialog = False }, Cmd.batch [ API.websocketOut <| System.setSystemState model.offId Off ] )

        OnCancelOff ->
            ( { model | showConfirmOffDialog = False }, Cmd.none )


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view appState model system =
    div [ class "container" ] <|
        [ div [ class "row" ]
            [ div [ class "col s12 m8 offset-m2 xl7 offset-xl2" ] <|
                [ UI.row_item
                    [ text system.title
                    , UI.cmdButton "…" (OnTitleChangeStart system.title)
                    ]
                ]
                    ++ (viewInfo appState model system)
                    ++ (if model.extendInfo then
                            (viewInfoEntended appState model system)
                        else
                            [ UI.cmdButton "Больше информации…" OnExtendInfo ]
                       )
                    ++ [ -- , div [] [ text <| "Id:" ++ system.id ]
                         UI.button ("/map/" ++ system.id) "Смотреть на карте"
                       , UI.row_item [ UI.button "/" "На главную" ]
                       ]
                    ++ (titleChangeDialogView model system.id)
            ]
        ]
            ++ (if model.showConfirmOffDialog then
                    [ UI.modal
                        "Выключение"
                        [ UI.ModalText "Предупреждение! Это действие необратимо."
                        , UI.ModalText "Включить трекер можно будет только нажатием кнопки на плате прибора."
                        , UI.ModalText "Вы действительно хотите выключить трекер?"
                        ]
                        [ UI.cmdButton "Да" (OnConfirmOff)
                        , UI.cmdButton "Нет" (OnCancelOff)
                        ]
                    , UI.modal_overlay OnCancelOff
                    ]
                else
                    []
               )


viewInfo : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewInfo appState model system =
    [ UI.row_item [ ChartSvg.chartView "Батарея" 80 ]
    ]
        ++ (sysState_of system.dynamic)
        ++ [ UI.row_item (cmdPanel system.id system.dynamic)
           , UI.row_item (Dates.nextSession appState system.dynamic)
           ]


sysState_of : Maybe System.Dynamic -> List (Html Msg)
sysState_of maybe_dynamic =
    case maybe_dynamic of
        Nothing ->
            [ UI.row_item [ text <| "Данные о состоянии еще не получены" ] ]

        Just dynamic ->
            case dynamic.state of
                Nothing ->
                    [ UI.row_item [ text <| "Состояние: -" ] ]

                Just Off ->
                    [ UI.row_item [ text <| "Трекер выключен." ]
                    , UI.row_item [ text <| "Для включения трекера, нажмите кнопку на плате прибора." ]
                    ]

                Just state ->
                    [ UI.row_item [ text <| "Состояние: " ++ (System.stateAsString state) ] ]


viewNextSession : Maybe System.Dynamic -> Html Msg
viewNextSession dynamic =
    text "{DYNAMIC_TBD}"


viewInfoEntended : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewInfoEntended appState model system =
    let
        imei =
            system.imei |> Maybe.withDefault "скрыт"

        phone =
            case system.phone of
                Nothing ->
                    "не задан или скрыт"

                Just "" ->
                    "не задан или скрыт"

                Just any_ ->
                    any_
    in
        [ UI.row_item [ text <| "IMEI: " ++ imei ]
        , UI.row_item [ text <| "Номер телефона: " ++ phone ]
        , UI.cmdButton "Меньше информации" OnExtendInfo
        ]


cmdPanel : String -> Maybe System.Dynamic -> List (Html Msg)
cmdPanel sysId maybe_dynamic =
    case maybe_dynamic of
        Nothing ->
            []

        Just dynamic ->
            case dynamic.waitState of
                Nothing ->
                    case dynamic.state of
                        Nothing ->
                            []

                        Just state ->
                            let
                                b =
                                    \i -> UI.cmdButton (System.stateAsCmdString i) (OnSysCmd sysId i)
                            in
                                dynamic.available
                                    |> List.map b

                Just Point ->
                    [ text <| "При следуюем сеансе связи, будет определено текущее местоположение системы"
                    , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                    ]

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
