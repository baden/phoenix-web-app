module Page.System.Config exposing (init, update, view)

import API
import API.System as System exposing (State(..), SystemDocumentInfo, SystemDocumentParams)
import AppState
import Components.UI as UI exposing (..)
import Dict exposing (Dict)
import Html exposing (Html, a, div, input, label, span)
import Html.Attributes as HA exposing (attribute, class, name, type_, value)
import Html.Events as HE
import Msg as GMsg
import Page.System.Config.Battery as Battery
import Page.System.Config.Custom exposing (..)
import Page.System.Config.Details as Details
import Page.System.Config.Dialogs as Dialogs exposing (..)
import Page.System.Config.Master exposing (..)
import Page.System.Config.Master.Types exposing (..)
import Page.System.Config.NameAndIcon as NameAndIcon
import Page.System.Config.Types exposing (..)


init : Maybe String -> ( Model, Cmd Msg )
init sysId =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , offId = ""
      , showTitleChangeDialog = False
      , newTitle = ""
      , showIconChangeDialog = False
      , newIcon = ""
      , showState = SS_Root
      , showMasterDialog = MasterPage1
      , masterData = initMasterData

      -- , masterEcoValue = 2
      -- , masterTrackValue = 2
      -- , masterSecurValue = ( False, False )
      , showChanges = False
      , showRemodeDialog = False
      , removeId = ""
      , smsPhone1 = ""
      , ussdPhone = "*111#"
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

        OnIconChangeStart oldIcon ->
            ( { model | showIconChangeDialog = True, newIcon = oldIcon }, Cmd.none, Nothing )

        OnIconConfirm sysId newIcon ->
            ( { model | showIconChangeDialog = False }, Cmd.batch [ API.websocketOut <| System.setSystemIcon sysId newIcon ], Nothing )

        OnIconCancel ->
            ( { model | showIconChangeDialog = False }, Cmd.none, Nothing )

        OnIconChange selectedIcon ->
            ( { model | newIcon = selectedIcon }, Cmd.none, Nothing )

        -- TODO: Move all Master updates to .Master.Types or elsewhere
        OnMasterEco1 val ->
            ( { model | masterData = setMasterDataEco val model.masterData }, Cmd.none, Nothing )

        OnMasterTrack1 val ->
            ( { model | masterData = setMasterDataTrack val model.masterData }, Cmd.none, Nothing )

        OnMasterSecur1 val s ->
            ( { model | masterData = setMasterDataSecur val s model.masterData }, Cmd.none, Nothing )

        OnMasterSMSEvent updater s ->
            ( { model | masterData = setMasterDataSmsEvent updater s model.masterData }, Cmd.none, Nothing )

        OnMasterNext ->
            ( { model | showMasterDialog = masterNextPage model.showMasterDialog }, Cmd.none, Nothing )

        OnMasterPrev ->
            ( { model | showMasterDialog = masterPrevPage model.showMasterDialog }, Cmd.none, Nothing )

        OnRemove sid ->
            ( { model | showRemodeDialog = True, removeId = sid }, Cmd.none, Nothing )

        OnCancelRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Nothing )

        OnConfirmRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Just (GMsg.RemoveSystemFromList model.removeId) )

        OnSMSPhone1 s ->
            ( { model | smsPhone1 = s }, Cmd.none, Nothing )

        OnUSSDPhone s ->
            ( { model | ussdPhone = s }, Cmd.none, Nothing )

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
            --
            -- TODO: Временно отключено применение настроек (для отладки)
            --
            -- ( { model | showState = SS_Congrat }, Cmd.none, Nothing )
            ( { model | showState = SS_Congrat }, paramsSetQueue sysId queue, Nothing )

        OnOpenDetails s ->
            ( { model | showState = SS_Details }, Cmd.none, Nothing )

        OnOpenNameAndIcon s ->
            ( { model | showState = SS_NameAndIcon }, Cmd.none, Nothing )

        OnOpenBattery s ->
            ( { model | showState = SS_Battery }, Cmd.none, Nothing )

        OnShowChanges ->
            ( { model | showChanges = not model.showChanges }, Cmd.none, Nothing )

        OnMasterCustom s ->
            -- ( { model | showState = SS_Custom, showQueue = False }, Cmd.none, Nothing )
            ( { model | showState = SS_Custom, showQueue = False }, loadParams s, Nothing )

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
    -- UI.div_ <|
    Html.div [ class "container" ] <|
        [ Html.div [ class "wrapper-content wrapper-page" ]
            [ viewContainer appState model system mparams
            ]
        ]
            ++ titleChangeDialogView appState model system.id
            ++ iconChangeDialogView appState model system.id
            ++ viewRemoveWidget appState model system
            ++ Dialogs.paramChangeDialogView appState model mparams


viewContainer : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html Msg
viewContainer ({ t } as appState) model system mparams =
    case model.showState of
        SS_Root ->
            Html.div [ class "wrapper-bg" ]
                [ row [ cmdTextIconButton "edit" (t "menu.Иконка и название Феникса") (OnOpenNameAndIcon system.id) ]
                , row [ cmdTextIconButton "cogs" "Мастер Конфигурации (TBD)" (OnStartMaster system.id) ]
                , row [ cmdTextIconButton "cogs" (t "menu.Расширенные настройки") (OnMasterCustom system.id) ]
                , row [ cmdTextIconButton "cogs" (t "menu.Обслуживание батареи") (OnOpenBattery system.id) ]
                , row [ cmdTextIconButton "cogs" (t "menu.Детали о Фениксе") (OnOpenDetails system.id) ]

                -- , row [ cmdTextIconButton "trash" "Удалить" (OnRemove system.id) ]
                ]

        SS_Master ->
            Html.div [ class "wrapper-bg" ] <| masterDialogView appState model system.id mparams

        SS_Custom ->
            Html.div [ class "wrapper-bg" ] <| configCustomView appState model system.id mparams

        SS_Congrat ->
            Html.div [ class "wrapper-bg" ]
                [ Html.div [ HA.class "config-img" ] [ Html.img [ HA.alt "", HA.src "/images/setting_done.svg" ] [] ]
                , Html.div [ HA.class "title-st" ]
                    [ Html.text <| t "config.Поздравляем!"
                    , Html.br [] []
                    , Html.text <| t "config.Основные настройки применены"
                    ]
                , Html.a [ HA.class "btn btn-md btn-primary btn-next mt-40", HA.href <| "/system/" ++ system.id ] [ Html.text <| t "config.Перейти к Фениксу" ]
                ]

        SS_Details ->
            Details.view appState model system mparams

        SS_NameAndIcon ->
            NameAndIcon.view appState model system mparams

        SS_Battery ->
            Battery.view appState model system mparams



-- Html.div []
--     [ Html.text "Страница конфигурации для системы "
--     , Html.span [ HA.class "blue-text text-darken-2" ] [ Html.text system.title ]
--     , Html.text " находится в разработке..."
--     ]
