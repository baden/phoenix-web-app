module Page.System.Info exposing (init, update, view, Model, Msg(..))

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI
import API
import API.System as System exposing (SystemDocumentInfo, SysState)


type alias Model =
    { showTitleChangeDialog : Bool
    , newTitle : String
    }


type Msg
    = OnSysCmd System.State
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
        OnSysCmd state ->
            let
                _ =
                    Debug.log "Make new state:" state
            in
                ( model, Cmd.none )

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


view : Model -> SystemDocumentInfo -> Html Msg
view model system =
    div [] <|
        [ UI.row_item
            [ text system.title
            , UI.cmdButton "…" (OnTitleChangeStart system.title)
            ]

        -- , div [] [ text <| "Id:" ++ system.id ]
        , UI.row_item [ ChartSvg.chartView "Батарея" 80 ]
        , UI.row_item [ text <| "Состояние: " ++ (sysState_of system.state) ]
        , UI.row_item (cmdPanel system.state)
        , UI.row_item [ text "Следующий сеанс связи через 04:25" ]
        , UI.button ("/map/" ++ system.id) "Смотреть на карте"
        , UI.row_item [ UI.button "/" "На главную" ]
        ]
            ++ (titleChangeDialogView model system.id)


sysState_of : Maybe SysState -> String
sysState_of sysState =
    case sysState of
        Nothing ->
            "-"

        Just state ->
            (System.stateAsString state.current)


cmdPanel : Maybe SysState -> List (Html Msg)
cmdPanel sysState =
    case sysState of
        Nothing ->
            []

        Just state ->
            let
                b =
                    \i -> UI.cmdButton (System.stateAsCmdString i) (OnSysCmd i)
            in
                state.available
                    |> List.map b


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
