module Page.System.Config.Master exposing (..)

import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE


masterNextPage : MasterPage -> MasterPage
masterNextPage showMasterDialog =
    case showMasterDialog of
        MasterPage1 ->
            MasterPage2

        MasterPage2 ->
            MasterPage3

        MasterPage3 ->
            MasterPage1


masterPrevPage : MasterPage -> MasterPage
masterPrevPage showMasterDialog =
    case showMasterDialog of
        MasterPage3 ->
            MasterPage2

        MasterPage2 ->
            MasterPage1

        MasterPage1 ->
            MasterPage1


masterDialogView : Model -> String -> List (UI Msg)
masterDialogView model sysId =
    case model.showMasterDialog of
        MasterPage1 ->
            [ row [ UI.text "Режим" ]
            , row [ UI.text <| masterPage1Help model.masterEcoValue ]
            , row [ masterPage1View model.masterEcoValue ]
            ]
                ++ masterFooterFirst

        MasterPage2 ->
            [ row [ UI.text "Трекинг" ]
            , row [ UI.text <| masterPage2Help model.masterTrackValue ]
            , row [ masterPage2View model.masterTrackValue ]
            ]
                ++ masterFooterMiddle

        MasterPage3 ->
            [ row [ UI.text "Безопасность" ]
            , row [ UI.text <| masterPage3Help model.masterSecurValue ]
            , row [ masterPage3View model.masterSecurValue model ]
            ]
                ++ masterFooterLast


masterFooterFirst : List (UI Msg)
masterFooterFirst =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "cogs" "Ручное" (OnMasterCustom)
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
    , UI.cmdTextIconButton "confirm" "Применить" (OnConfirmMaster)
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


item1_ : Int -> String -> Bool -> (Int -> Bool -> Msg) -> UI Msg
item1_ index label_ checked_ msg =
    row
        [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ label []
                [ input [ attribute "name" "group1", type_ "checkbox", checked checked_, HE.onCheck (msg index) ] []
                , span [] [ Html.text label_ ]
                ]
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


masterPage3View : ( Bool, Bool ) -> Model -> Html Msg
masterPage3View ( s1, s2 ) model =
    row <|
        [ div [ class "col s12", HA.style "text-align" "left" ]
            [ form [ attribute "action" "#" ] <|
                [ item1_ 1 "Привязать к телефону" s1 OnMasterSecur1 ]
                    ++ [ phoneInput s1 model.adminPhone OnAdminPhone ]
                    ++ [ item1_ 2 "Установить пароль доступа" s2 OnMasterSecur1 ]
                    ++ [ codeInput s2 model.adminCode OnAdminCode ]
            ]
        ]


masterPage3Help : ( Bool, Bool ) -> String
masterPage3Help ( s1, s2 ) =
    case s1 of
        _ ->
            "Чтобы никто посторонний не смог получить управление вашим устройством, установите дополнительную защиту"


phoneInput : Bool -> String -> (String -> cmd) -> Html cmd
phoneInput en code_ cmd_ =
    case en of
        False ->
            row
                [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l3" ] [ Html.text "Управление будет возможно с любого телефона." ] ]

        True ->
            row
                [ Html.div
                    [ class "col s12 m10 offset-m1 l5 offset-l3" ]
                    [ Html.input
                        [ HA.class "sms_code"
                        , HA.type_ "tel"
                        , HA.placeholder "В формате +380..."
                        , HA.value code_
                        , HA.autofocus True
                        , HE.onInput cmd_
                        , HA.pattern "[0-9]{12}"
                        ]
                        []
                    ]
                , Html.div [ class "col s12 m10 offset-m1 l6 offset-l3" ] <|
                    case code_ of
                        "" ->
                            [ Html.text "Управление будет возможно с любого телефона." ]

                        _ ->
                            [ Html.text "Управление будет возможно только с телефона:"
                            , Html.span [ HA.style "font-weight" "bold" ] [ Html.text code_ ]
                            ]
                ]


codeInput : Bool -> String -> (String -> cmd) -> Html cmd
codeInput en code_ cmd_ =
    case en of
        False ->
            row
                [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l3" ]
                    [ Html.text "SMS-команды управления имеют вид: "
                    , Html.span [ HA.style "font-weight" "bold" ] [ Html.text "link" ]
                    ]
                ]

        True ->
            row
                [ Html.div
                    [ class "col s12 m10 offset-m1 l5 offset-l3" ]
                    [ Html.input
                        [ HA.class "sms_code"
                        , HA.placeholder "Только латинские символы или цифры"
                        , HA.value code_
                        , HA.autofocus True
                        , HE.onInput cmd_
                        , HA.pattern "[A-Za-z0-9]{6}"
                        ]
                        []
                    ]
                , Html.div [ class "col s12 m10 offset-m1 l6 offset-l3" ]
                    [ Html.text <| "SMS-команды управления имеют вид: "
                    , Html.span [ HA.style "font-weight" "bold" ] [ Html.text <| code_ ++ " link" ]
                    ]
                ]
