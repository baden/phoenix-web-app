module Page.System.Info.Dialogs
    exposing
        ( titleChangeDialogView
        , prolongSleepDialogView
        , viewModalDialogs
        )

import Page.System.Info.Types exposing (Model, Msg, Msg(..))
import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.UI as UI


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


prolongSleepDialogView : Model -> String -> List (Html Msg)
prolongSleepDialogView model sysId =
    if model.showSleepProlongDialog then
        [ UI.modal
            "Не спать!"
            [ UI.ModalText "Продлить работу в режиме Трекер"
            , UI.ModalHtml <| UI.cmdButton "На 2 часа" (OnProlongSleep sysId 2)
            , UI.ModalHtml <| UI.cmdButton "На 12 часов" (OnProlongSleep sysId 12)
            , UI.ModalHtml <| UI.cmdButton "На сутки" (OnProlongSleep sysId 24)
            ]
            [ UI.cmdButton "Отменить" (OnHideProlongSleepDialog)
            ]
        , UI.modal_overlay OnHideProlongSleepDialog
        ]
    else
        []


viewModalDialogs : Model -> List (Html Msg)
viewModalDialogs model =
    if model.showConfirmOffDialog then
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
