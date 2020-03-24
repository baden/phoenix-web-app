module Page.System.Config.Dialogs exposing (..)

import Page.System.Config.Types exposing (Model, Msg, Msg(..))
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE


titleChangeDialogView : Model -> String -> List (UI Msg)
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


masterDialogView : Model -> String -> List (UI Msg)
masterDialogView model sysId =
    if model.showMasterDialog then
        [ UI.modal
            "Режим"
            [ UI.ModalText <| masterPage1Help model.masterEcoValue
            , UI.ModalHtml <| masterPage1View model.masterEcoValue
            ]
            [ UI.cmdButton "Назад" (OnCancelMaster)
            , UI.cmdButton "Далее" (OnCancelMaster)
            ]
        , UI.modal_overlay OnCancelMaster
        ]
    else
        []


masterPage1View : Int -> Html Msg
masterPage1View selected =
    let
        item index label_ checked_ =
            p []
                [ label []
                    [ input [ attribute "name" "group1", type_ "radio", checked checked_, HE.onCheck (OnMasterEco1 index) ] []
                    , span [] [ Html.text label_ ]
                    ]
                ]
    in
        UI.row <|
            [ div [ class "col s12 m8 offset-m1 xl7 offset-xl1", HA.style "text-align" "left" ]
                [ form
                    [ attribute "action" "#" ]
                    [ item 1 "Очень экономно" (selected == 1)
                    , item 2 "Средне экономно" (selected == 2)
                    , item 3 "Не экономно" (selected == 3)
                    ]
                ]
            ]


masterPage1Help : Int -> String
masterPage1Help index =
    case index of
        1 ->
            "Объект будет выходить на связь раз в сутки. Ожидаемый срок службы - более 10ти лет."

        2 ->
            "Объект будет выходить на связь четыре раза в сутки. Ожидаемый срок службы - около 4-х лет."

        _ ->
            "Объект будет выходить на связь каждый час. Ожидаемый срок службы - около 2-х лет."
