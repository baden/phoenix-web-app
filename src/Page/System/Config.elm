module Page.System.Config exposing (init, update, view)

import Page.System.Config.Types exposing (Model, Msg, Msg(..))
import Page.System.Config.Dialogs exposing (..)
import AppState
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import Components.UI as UI exposing (..)
import API


init : ( Model, Cmd Msg )
init =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , offId = ""
      , showTitleChangeDialog = False
      , newTitle = ""
      , showMasterDialog = False
      , masterEcoValue = 1
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        OnStartMaster ->
            ( { model | showMasterDialog = True }, Cmd.none )

        OnCancelMaster ->
            ( { model | showMasterDialog = False }, Cmd.none )

        OnMasterEco1 val _ ->
            ( { model | masterEcoValue = val }, Cmd.none )

        OnNoCmd ->
            ( model, Cmd.none )


view : AppState.AppState -> Model -> SystemDocumentInfo -> UI Msg
view appState model system =
    container <|
        [ row
            [ iconButton "arrow-left" ("/system/" ++ system.id)
            , stitle system.title
            , UI.cmdIconButton "edit" (OnTitleChangeStart system.title)
            ]
        , row [ cmdTextIconButton "edit" "Изменить название" (OnTitleChangeStart system.title) ]
        , row [ cmdTextIconButton "cogs" "Конфигурация" OnStartMaster ]
        , row [ linkIconTextButton "clone" "Выбрать другой объект" "/" ]
        , row [ linkIconTextButton "plus-square" "Добавить объект" "/linksys" ]
        , row [ cmdTextIconButton "trash" "Удалить" (OnTitleChangeStart system.title) ]
        ]
            ++ (titleChangeDialogView model system.id)
            ++ (masterDialogView model system.id)



-- Html.div []
--     [ Html.text "Страница конфигурации для системы "
--     , Html.span [ HA.class "blue-text text-darken-2" ] [ Html.text system.title ]
--     , Html.text " находится в разработке..."
--     ]
