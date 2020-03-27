module Page.System.Config exposing (init, update, view)

import Page.System.Config.Types exposing (..)
import Page.System.Config.Dialogs exposing (..)
import AppState
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import Components.UI as UI exposing (..)
import API
import Msg as GMsg


init : ( Model, Cmd Msg )
init =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , offId = ""
      , showTitleChangeDialog = False
      , newTitle = ""
      , showMasterDialog = Nothing
      , masterEcoValue = 1
      , masterTrackValue = 2
      , showRemodeDialog = False
      , removeId = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnTitleChangeStart oldTitle ->
            ( { model | showTitleChangeDialog = True, newTitle = oldTitle }, Cmd.none, Nothing )

        OnTitleChange enteredTitle ->
            ( { model | newTitle = enteredTitle }, Cmd.none, Nothing )

        OnTitleConfirm sysId newTitle ->
            let
                cmd =
                    API.websocketOut <|
                        System.setSystemTitle sysId newTitle
            in
                ( { model | showTitleChangeDialog = False }, Cmd.batch [ cmd ], Nothing )

        OnTitleCancel ->
            ( { model | showTitleChangeDialog = False }, Cmd.none, Nothing )

        OnStartMaster ->
            ( { model | showMasterDialog = Just MasterPage1 }, Cmd.none, Nothing )

        OnCancelMaster ->
            ( { model | showMasterDialog = Nothing }, Cmd.none, Nothing )

        OnMasterEco1 val _ ->
            ( { model | masterEcoValue = val }, Cmd.none, Nothing )

        OnMasterTrack1 val _ ->
            ( { model | masterTrackValue = val }, Cmd.none, Nothing )

        OnMasterNext ->
            ( { model | showMasterDialog = (masterNextPage model.showMasterDialog) }, Cmd.none, Nothing )

        OnMasterPrev ->
            ( { model | showMasterDialog = (masterPrevPage model.showMasterDialog) }, Cmd.none, Nothing )

        OnRemove sid ->
            ( { model | showRemodeDialog = True, removeId = sid }, Cmd.none, Nothing )

        OnCancelRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Nothing )

        OnConfirmRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Just (GMsg.RemoveSystemFromList model.removeId) )

        OnNoCmd ->
            ( model, Cmd.none, Nothing )


view : AppState.AppState -> Model -> SystemDocumentInfo -> UI Msg
view appState model system =
    container <|
        [ header_expander
        , row
            [ iconButton "arrow-left" ("/system/" ++ system.id)
            , stitle system.title
            , UI.cmdIconButton "edit" (OnTitleChangeStart system.title)
            ]
        , row [ cmdTextIconButton "edit" "Изменить название" (OnTitleChangeStart system.title) ]
        , row [ cmdTextIconButton "cogs" "Конфигурация" OnStartMaster ]
        , row [ linkIconTextButton "clone" "Выбрать другой объект" "/" ]
        , row [ linkIconTextButton "plus-square" "Добавить объект" "/linksys" ]
        , row [ cmdTextIconButton "trash" "Удалить" (OnRemove system.id) ]
        ]
            ++ (titleChangeDialogView model system.id)
            ++ (masterDialogView model system.id)
            ++ (viewRemoveWidget model)



-- Html.div []
--     [ Html.text "Страница конфигурации для системы "
--     , Html.span [ HA.class "blue-text text-darken-2" ] [ Html.text system.title ]
--     , Html.text " находится в разработке..."
--     ]
