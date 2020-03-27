module Page.System.Config.Dialogs exposing (..)

import Page.System.Config.Types exposing (..)
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


viewRemoveWidget : Model -> List (Html Msg)
viewRemoveWidget model =
    if model.showRemodeDialog then
        [ UI.modal
            "Удаление"
            [ UI.ModalText "Вы уверены что хотите удалить систему из списка наблюдения?"
            , UI.ModalText "Напоминаю, что вы не можете просто добавить систему в список наблюдения, необходимо проделать определенную процедуру."
            ]
            [ UI.cmdButton "Да" (OnConfirmRemove)
            , UI.cmdButton "Нет" (OnCancelRemove)
            ]
        , UI.modal_overlay OnCancelRemove
        ]
    else
        []


masterNextPage : Maybe MasterPage -> Maybe MasterPage
masterNextPage showMasterDialog =
    case showMasterDialog of
        Nothing ->
            Nothing

        Just MasterPage1 ->
            Just MasterPage2

        Just MasterPage2 ->
            Just MasterPage3

        Just MasterPage3 ->
            Just MasterPage1


masterPrevPage : Maybe MasterPage -> Maybe MasterPage
masterPrevPage showMasterDialog =
    case showMasterDialog of
        Nothing ->
            Nothing

        Just MasterPage3 ->
            Just MasterPage2

        Just MasterPage2 ->
            Just MasterPage1

        Just MasterPage1 ->
            Just MasterPage1


masterDialogView : Model -> String -> List (UI Msg)
masterDialogView model sysId =
    case model.showMasterDialog of
        Nothing ->
            []

        Just MasterPage1 ->
            [ UI.modal
                "Режим"
                [ UI.ModalText <| masterPage1Help model.masterEcoValue
                , UI.ModalHtml <| masterPage1View model.masterEcoValue
                ]
                masterFooterFirst
            , UI.modal_overlay OnCancelMaster
            ]

        Just MasterPage2 ->
            [ UI.modal
                "Трекинг"
                [ UI.ModalText <| masterPage2Help model.masterTrackValue
                , UI.ModalHtml <| masterPage2View model.masterTrackValue
                ]
                masterFooterLast
            , UI.modal_overlay OnCancelMaster
            ]

        Just MasterPage3 ->
            [ UI.modal
                "SMS оповещения"
                [ UI.ModalText <| masterPage1Help model.masterEcoValue
                , UI.ModalHtml <| masterPage1View model.masterEcoValue
                ]
                masterFooterLast
            , UI.modal_overlay OnCancelMaster
            ]


masterFooterFirst : List (UI Msg)
masterFooterFirst =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "arrow-right" "Далее" (OnMasterNext)
    ]


masterFooterMiddle : List (UI Msg)
masterFooterMiddle =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "arrow-left" "Назад" (OnMasterPrev)
    , UI.cmdTextIconButton "arrow-right" "Далее" (OnMasterNext)
    ]


masterFooterLast : List (UI Msg)
masterFooterLast =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "arrow-left" "Назад" (OnMasterPrev)
    , UI.cmdTextIconButton "confirm" "Применить" (OnCancelMaster)
    ]



-- masterPage {Header} -> {Help foo} ->
-- masterPage : String -> String


item_ : Int -> String -> Bool -> (Int -> Bool -> Msg) -> UI Msg
item_ index label_ checked_ msg =
    p []
        [ label []
            [ input [ attribute "name" "group1", type_ "radio", checked checked_, HE.onCheck (msg index) ] []
            , span [] [ Html.text label_ ]
            ]
        ]


masterPage1View : Int -> Html Msg
masterPage1View selected =
    row <|
        [ div [ class "col s12 m8 offset-m1 xl7 offset-xl1", HA.style "text-align" "left" ]
            [ form
                [ attribute "action" "#" ]
                [ item_ 1 "Очень экономно" (selected == 1) OnMasterEco1
                , item_ 2 "Средне экономно" (selected == 2) OnMasterEco1
                , item_ 3 "Не экономно" (selected == 3) OnMasterEco1
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


masterPage2View : Int -> Html Msg
masterPage2View selected =
    row <|
        [ div [ class "col s12 m8 offset-m1 xl7 offset-xl1", HA.style "text-align" "left" ]
            [ form
                [ attribute "action" "#" ]
                [ item_ 1 "Продолжительно" (selected == 1) OnMasterTrack1
                , item_ 2 "Оптимально" (selected == 2) OnMasterTrack1
                , item_ 3 "Минимально" (selected == 3) OnMasterTrack1
                ]
            ]
        ]


masterPage2Help : Int -> String
masterPage2Help index =
    case index of
        1 ->
            "Объект будет сутки работать в режиме Трекинга, потом перейдет в режим Сон. Заряда хватит на 5 активаций режима Трекинг."

        2 ->
            "Объект будет 4 часа работать в режиме Трекинга, потом перейдет в режим Сон. Заряда хватит на 20 активаций режима Трекинг."

        _ ->
            "Объект будет 1 час работать в режиме Трекинга, потом перейдет в режим Сон. Заряда хватит на 50 активаций режима Трекинг."
