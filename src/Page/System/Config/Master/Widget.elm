module Page.System.Config.Master.Widget exposing (..)

import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Dict exposing (Dict)


-- Deprecated

import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE


masterPageForm : List (Html Msg) -> Html Msg
masterPageForm c =
    row <|
        -- [ div [ class "col s12 m8 offset-m1 l7 offset-l3 xl7 offset-xl4", HA.style "text-align" "left" ]
        [ div [ class "col s12 m11 offset-m1 l11 offset-l1 xl10 offset-xl2", HA.style "text-align" "left" ]
            [ form
                [ attribute "action" "#" ]
                c
            ]
        ]


masterFooterFirst : List (UI Msg)
masterFooterFirst =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "cogs" "Подробно" (OnMasterCustom)
    , UI.cmdTextIconButton "arrow-right" "Далее" (OnMasterNext)
    ]


masterFooterMiddle : List (UI Msg)
masterFooterMiddle =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "arrow-left" "Назад" (OnMasterPrev)
    , UI.cmdTextIconButton "arrow-right" "Далее" (OnMasterNext)
    ]


masterFooterLast : String -> Dict String String -> Dict String String -> List (UI Msg)
masterFooterLast sysId customQueue masterQueue =
    let
        mixedQueue =
            Dict.union masterQueue customQueue
    in
        [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
        , UI.cmdTextIconButton "arrow-left" "Назад" (OnMasterPrev)
        , UI.cmdTextIconButton "thumbs-up" "Применить" (OnConfirmMaster sysId mixedQueue)
        , UI.cmdIconButton "question-circle" (OnShowChanges)
        ]


radio : mt -> String -> Bool -> (mt -> Bool -> Msg) -> UI Msg
radio index label_ checked_ msg =
    p []
        [ label []
            [ input [ attribute "name" "group1", type_ "radio", checked checked_, HE.onCheck (msg index) ] []
            , span [] [ Html.text label_ ]
            ]
        ]


checkbox : mt -> String -> Bool -> (mt -> Bool -> Msg) -> UI Msg
checkbox index label_ checked_ msg =
    row
        [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ label []
                [ input [ attribute "name" "group1", type_ "checkbox", checked checked_, HE.onCheck (msg index) ] []
                , span [] [ Html.text label_ ]
                ]
            ]
        ]



-- item2_ : String -> Bool -> (Bool -> MasterDataSMS -> MasterDataSMS) -> ((Bool -> MasterDataSMS -> MasterDataSMS) -> Bool -> Msg) -> UI Msg


checkboxLazy : String -> Bool -> (Bool -> mt -> mt) -> ((Bool -> mt -> mt) -> Bool -> Msg) -> UI Msg
checkboxLazy label_ checked_ updater msg =
    row
        [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ label []
                [ input [ attribute "name" "group1", type_ "checkbox", checked checked_, HE.onCheck (msg updater) ] []
                , span [] [ Html.text label_ ]
                ]
            ]
        ]


phoneInput : Bool -> String -> (String -> cmd) -> Html cmd
phoneInput en code_ cmd_ =
    case en of
        False ->
            row
                [ Html.div [ class "col s12 m11 offset-m1 l9 offset-l3" ] [ Html.text "Управление будет возможно с любого телефона." ] ]

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
                , Html.div [ class "col s12 m11 offset-m1 l9 offset-l3" ] <|
                    case code_ of
                        "" ->
                            [ Html.text "Управление будет возможно с любого телефона." ]

                        _ ->
                            [ Html.text "Управление будет возможно только с телефона:"
                            , Html.span [ HA.style "font-weight" "bold" ] [ Html.text code_ ]
                            ]
                ]


phoneInput1 : Int -> String -> (String -> cmd) -> Html cmd
phoneInput1 index code_ cmd_ =
    row
        [ Html.div
            [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ Html.text "Укажите номер телефона:"
            , Html.div [ class "input-field inline" ]
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
            ]
        ]


phoneInput2 : Int -> String -> (String -> cmd) -> Html cmd
phoneInput2 index code_ cmd_ =
    row
        [ Html.div
            [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ Html.text "USSD-запрос баланса SIM-карты:"
            , Html.div [ class "input-field inline" ]
                [ Html.input
                    [ HA.class "sms_code"
                    , HA.type_ "tel"
                    , HA.placeholder "В формате *XXX#"
                    , HA.value code_
                    , HA.autofocus True
                    , HE.onInput cmd_
                    , HA.pattern "[0-9*#]{12}"
                    ]
                    []
                ]
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


hint : String -> Html cmd
hint s =
    Html.div [ class "col s12" ] [ Html.text s ]


hint_c : String -> Html cmd
hint_c s =
    Html.div [ class "col s10 offset-s1 m4 offset-m3 lime", HA.style "margin-top" "20px", HA.style "margin-bottom" "20px" ] [ Html.text s ]


hint_row : String -> Html cmd
hint_row s =
    row [ Html.div [ class "col" ] [ UI.text s ] ]


text_row : String -> Html msg
text_row s =
    row [ UI.text s ]


changes_table : Dict String String -> List (UI msg)
changes_table dict =
    let
        row ( ttl, val ) =
            Html.tr [] [ Html.td [ HA.class "right-align", HA.style "width" "50%" ] [ Html.text ttl ], Html.td [] [ Html.text val ] ]
    in
        [ Html.div [ HA.class "row" ] <|
            [ Html.div [ HA.class "col s12 m10 offset-m1 l8 offset-l2 xl6 offset-xl3" ]
                [ Html.text "Следующие параметры будут изменены:"
                , Html.table []
                    [ Html.tbody [] (dict |> Dict.toList |> List.map row)
                    ]
                ]
            ]

        -- ++ row "sleep" (ecoToValue model.masterEcoValue)
        -- ++ row "auto.sleep" (trackToValue model.masterTrackValue)
        -- ++ row "admin" model.adminPhone
        -- ++ row "secur.code" model.adminPhone
        ]
