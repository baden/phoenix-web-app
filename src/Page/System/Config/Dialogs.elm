module Page.System.Config.Dialogs exposing (..)

import API.System as System exposing (SystemDocumentInfo, SystemDocumentParams)
import AppState exposing (AppState)
import Components.UI as UI exposing (UI)
import Dict exposing (Dict)
import Html exposing (Html, a, button, div, form, input, label, p, span, text)
import Html.Attributes as HA exposing (attribute, checked, class, classList, href, type_, value)
import Html.Events as HE exposing (onClick, onInput)
import Page.System.Config.Types exposing (..)


titleChangeDialogView : AppState -> Model -> String -> List (UI Msg)
titleChangeDialogView { t } model sysId =
    if model.showTitleChangeDialog then
        [ -- UI.modal
          --     "Название"
          --     [ UI.ModalText "Отображаемое имя системы:"
          --     , UI.ModalHtml <| UI.formInput "Имя" model.newTitle OnTitleChange
          --     ]
          --     [ UI.cmdButton "Применить" (OnTitleConfirm sysId model.newTitle)
          --     , UI.cmdButton "Отменить" OnTitleCancel
          --     ]
          -- , UI.modal_overlay OnTitleCancel
          div [ class "modal-bg modal-change-name show" ]
            [ div [ class "modal-wr" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-close close modal-close-btn", onClick OnTitleCancel ] []
                    , div [ class "modal-title" ] [ text <| t "config.Название Феникса" ]
                    , div [ class "modal-body" ]
                        [ span [ class "modal-text" ] [ text <| t "config.Ведите новое либо измените старое название" ]
                        , div [ class "input-st modal-input" ]
                            [ span [ class "input-sm-label" ] [ text <| t "config.Введите название" ]
                            , input [ attribute "autocomplete" "off", value model.newTitle, onInput OnTitleChange ] []
                            ]
                        ]
                    , div [ class "modal-btn-group" ]
                        [ button [ class "btn btn-md btn-secondary modal-close-btn", onClick OnTitleCancel ] [ text <| t "config.Отмена" ]
                        , button [ class "btn btn-md btn-primary", onClick (OnTitleConfirm sysId model.newTitle) ] [ text <| t "config.Сохранить" ]
                        ]
                    ]
                ]
            ]
        ]

    else
        []


iconChangeDialogView : AppState -> Model -> String -> List (UI Msg)
iconChangeDialogView { t } model sysId =
    if model.showIconChangeDialog then
        let
            icon isActive v =
                div [ class "config-select-item select-icon-item", classList [ ( "active", model.newIcon == v ) ], onClick (OnIconChange v) ]
                    [ div [ class "select-icon-content" ]
                        [ span [ class <| "icon-" ++ v ++ " image-big" ] []
                        , span [ class <| "icon-" ++ v ++ "_icon image-logo" ] []
                        ]
                    ]
        in
        [ div [ class "modal-bg modal-select-icon show" ]
            [ div [ class "modal-wr" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-close close modal-close-btn", onClick OnIconCancel ] []
                    , div [ class "modal-title" ] [ text <| t "config.Иконка Феникса" ]
                    , div [ class "modal-body" ]
                        [ span [ class "modal-text" ] [ text <| t "config.Выберите подходящую иконку для вашего феникса" ]
                        , div [ class "select-icon-wr" ]
                            [ icon True "car"
                            , icon False "truck"
                            , icon False "taxi"
                            , icon False "emergency"
                            , icon False "fire_engine"
                            , icon False "wagon"
                            , icon False "dump_truck"
                            , icon False "concrete_mixer"
                            , icon False "bus"
                            ]
                        ]
                    , div [ class "modal-btn-group" ]
                        [ button [ class "btn btn-md btn-secondary modal-close-btn", onClick OnIconCancel ] [ text <| t "config.Отмена" ]
                        , button [ class "btn btn-md btn-primary", onClick (OnIconConfirm sysId model.newIcon) ] [ text <| t "config.Сохранить" ]
                        ]
                    ]
                ]
            ]
        ]

    else
        []


viewRemoveWidget : AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewRemoveWidget { t, tr } model system =
    if model.showRemodeDialog then
        -- [ UI.modal
        --     "Удаление"
        --     [ UI.ModalText "Вы уверены что хотите удалить систему из списка наблюдения?"
        --     , UI.ModalText "Напоминаю, что вы не можете просто добавить систему в список наблюдения, необходимо проделать определенную процедуру."
        --     ]
        --     [ UI.cmdButton "Да" OnConfirmRemove
        --     , UI.cmdButton "Нет" OnCancelRemove
        --     ]
        -- , UI.modal_overlay OnCancelRemove
        -- ]
        [ div [ class "modal-bg show" ]
            [ div [ class "modal-wr" ]
                [ div [ class "modal-content modal-sm" ]
                    [ div [ class "modal-close close modal-close-btn", onClick OnCancelRemove ] []
                    , div [ class "modal-title modal-title-sm" ] [ text <| t "config.Удалить Феникс?" ]
                    , div [ class "modal-body" ]
                        [ span [ class "modal-text" ] [ text <| tr "config.remove_fx" [ ( "title", system.title ) ] ] ]
                    , div [ class "modal-btn-group" ]
                        [ button [ class "btn btn-md btn-secondary modal-close-btn", onClick OnCancelRemove ] [ text <| t "config.Нет" ]
                        , button [ class "btn btn-md btn-cancel", onClick OnConfirmRemove ] [ text <| t "config.Да, удалить" ]
                        ]
                    ]
                ]
            ]
        ]

    else
        []


paramChangeDialogView : Model -> Maybe SystemDocumentParams -> List (UI Msg)
paramChangeDialogView model mparams =
    let
        oldQueue =
            case mparams of
                Nothing ->
                    Dict.empty

                Just { queue } ->
                    queue
    in
    case model.showParamChangeDialog of
        Nothing ->
            []

        Just { sysId, name, value, description } ->
            [ UI.modal
                name
                [ UI.ModalText description
                , UI.ModalHtml <| UI.formInput "" value OnChangeParamValue
                ]
                [ UI.cmdButton "Применить" (OnConfirmParam sysId oldQueue name value)
                , UI.cmdButton "Отменить" OnCancelParam
                ]
            , UI.modal_overlay OnTitleCancel
            ]
