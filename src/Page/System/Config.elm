module Page.System.Config exposing (init, update, view)

import Page.System.Config.Types exposing (..)
import Page.System.Config.Dialogs as Dialogs exposing (..)
import Page.System.Config.Master exposing (..)
import Page.System.Config.Master.Types exposing (..)
import Page.System.Config.Custom exposing (..)
import AppState
import API.System as System exposing (SystemDocumentInfo, State, State(..), SystemDocumentParams)
import Components.UI as UI exposing (..)
import API
import Msg as GMsg
import Dict exposing (Dict)


init : Maybe String -> ( Model, Cmd Msg )
init sysId =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , offId = ""
      , showTitleChangeDialog = False
      , newTitle = ""
      , showState = SS_Root
      , showMasterDialog = MasterPage1
      , masterEcoValue = 2
      , masterTrackValue = 2
      , masterSecurValue = ( False, False )
      , showChanges = False
      , showRemodeDialog = False
      , removeId = ""
      , adminPhone = ""
      , adminCode = ""
      , systemId = sysId
      , showParamChangeDialog = Nothing
      , showQueue = False
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

        OnMasterEco1 val _ ->
            ( { model | masterEcoValue = val }, Cmd.none, Nothing )

        OnMasterTrack1 val _ ->
            ( { model | masterTrackValue = val }, Cmd.none, Nothing )

        OnMasterSecur1 val s ->
            let
                ( s1, s2 ) =
                    model.masterSecurValue
            in
                case val of
                    1 ->
                        ( { model | masterSecurValue = ( s, s2 ) }, Cmd.none, Nothing )

                    _ ->
                        ( { model | masterSecurValue = ( s1, s ) }, Cmd.none, Nothing )

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

        OnAdminPhone s ->
            ( { model | adminPhone = s }, Cmd.none, Nothing )

        OnAdminCode s ->
            ( { model | adminCode = s }, Cmd.none, Nothing )

        -- OnShowState s ->
        --     ( { model | showState = s }, Cmd.none, Nothing )
        OnStartMaster s ->
            ( { model | showState = SS_Master, showMasterDialog = MasterPage1, showChanges = False }, loadParams s, Nothing )

        OnCancelMaster ->
            ( { model | showState = SS_Root }, Cmd.none, Nothing )

        OnConfirmMaster sysId queue ->
            -- paramsSetQueue : String -> Dict String String -> Cmd Msg
            -- ( { model | showState = SS_Root }, paramsSetQueue sysId (changesList model), Nothing )
            ( { model | showState = SS_Root }, paramsSetQueue sysId queue, Nothing )

        OnShowChanges ->
            ( { model | showChanges = not model.showChanges }, Cmd.none, Nothing )

        OnMasterCustom ->
            ( { model | showState = SS_Custom, showQueue = False }, Cmd.none, Nothing )

        OnStartEditParam sysId name value description ->
            let
                showParamChangeDialog =
                    { name = name
                    , value = value
                    , sysId = sysId
                    , description = description
                    }
            in
                ( { model | showParamChangeDialog = Just showParamChangeDialog }, Cmd.none, Nothing )

        OnRestoreParam sysId queue name ->
            let
                -- queue = model.
                newQueue =
                    Dict.remove name queue
            in
                ( model, paramsSetQueue sysId newQueue, Nothing )

        OnChangeParamValue value ->
            case model.showParamChangeDialog of
                Nothing ->
                    ( model, Cmd.none, Nothing )

                Just showParamChangeDialog ->
                    let
                        newShowParamChangeDialog =
                            { showParamChangeDialog | value = value }
                    in
                        ( { model | showParamChangeDialog = Just newShowParamChangeDialog }, Cmd.none, Nothing )

        OnConfirmParam sysId oldQueue name value ->
            let
                newQueue =
                    Dict.insert name value oldQueue
            in
                ( { model | showParamChangeDialog = Nothing }, paramsSetQueue sysId newQueue, Nothing )

        OnClearQueue sysId ->
            ( { model | showParamChangeDialog = Nothing, showQueue = False }, paramsSetQueue sysId Dict.empty, Nothing )

        OnShowQueue ->
            ( { model | showQueue = not model.showQueue }, Cmd.none, Nothing )

        OnCancelParam ->
            ( { model | showParamChangeDialog = Nothing }, Cmd.none, Nothing )

        OnNoCmd ->
            ( model, Cmd.none, Nothing )


loadParams : String -> Cmd Msg
loadParams sysId =
    API.websocketOut <| System.getParams sysId


paramsSetQueue : String -> Dict String String -> Cmd Msg
paramsSetQueue sysId newQueue =
    API.websocketOut <| System.paramQueue sysId newQueue



-- view : AppState.AppState -> Model -> SystemDocumentInfo -> UI Msg


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> UI Msg
view appState model system mparams =
    container <|
        [ header_expander
        , row
            [ iconButton "arrow-left" ("/system/" ++ system.id)
            , stitle system.title
            , UI.cmdIconButton "edit" (OnTitleChangeStart system.title)
            ]
        ]
            ++ (viewContainer appState model system mparams)
            -- ++ (viewContainer appState model system Nothing)
            ++ (titleChangeDialogView model system.id)
            ++ (viewRemoveWidget model)
            ++ (Dialogs.paramChangeDialogView model mparams)


viewContainer : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> List (UI Msg)
viewContainer appState model system mparams =
    case model.showState of
        SS_Root ->
            [ --  row [ cmdTextIconButton "edit" "Изменить название" (OnTitleChangeStart system.title) ]
              row [ cmdTextIconButton "cogs" "Конфигурация" (OnStartMaster system.id) ]
            , row [ linkIconTextButton "clone" "Выбрать другой объект" "/" ]
            , row [ linkIconTextButton "plus-square" "Добавить объект" "/linksys" ]
            , row [ cmdTextIconButton "trash" "Удалить" (OnRemove system.id) ]
            ]

        SS_Master ->
            masterDialogView model system.id mparams

        SS_Custom ->
            configCustomView model system.id mparams



-- Html.div []
--     [ Html.text "Страница конфигурации для системы "
--     , Html.span [ HA.class "blue-text text-darken-2" ] [ Html.text system.title ]
--     , Html.text " находится в разработке..."
--     ]
