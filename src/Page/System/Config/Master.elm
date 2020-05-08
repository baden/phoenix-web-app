module Page.System.Config.Master exposing (..)

import Page.System.Config.Master.Types exposing (..)
import Page.System.Config.Master.Widget exposing (..)
import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE
import Dict exposing (Dict)
import API.System exposing (SystemDocumentParams)


masterDialogView : Model -> String -> Maybe SystemDocumentParams -> List (UI Msg)
masterDialogView model sysId mparams =
    -- Тут наверное не очень красиво проброшена очередь параметров
    case mparams of
        Nothing ->
            [ row [ UI.text "Ошибка загрузки или данные от трекера еще не получены." ] ]

        Just params ->
            case model.showMasterDialog of
                MasterPage1 ->
                    [ row [ UI.text "Период выхода на связь" ]
                    , row [ UI.text <| masterPage1Help model.masterEcoValue ]
                    , row [ masterPage1View model.masterEcoValue ]
                    ]
                        ++ masterFooterFirst

                MasterPage2 ->
                    [ row [ UI.text "Время работы в режиме Поиск" ]
                    , row [ UI.text <| masterPage2Help model.masterTrackValue ]
                    , row [ masterPage2View model.masterTrackValue ]
                    ]
                        ++ masterFooterMiddle

                MasterPage3 ->
                    [ row [ UI.text "Безопасность" ]
                    , row [ UI.text <| masterPage3Help model.masterSecurValue ]
                    , row [ masterPage3View model.masterSecurValue model ]
                    ]
                        ++ showChanges model sysId
                        ++ masterFooterLast sysId params.queue (changesList model)


ecoToValue : Int -> String
ecoToValue v =
    case v of
        1 ->
            -- Раз в сутки
            "1440"

        2 ->
            -- Каждые 4 часа
            "240"

        _ ->
            -- Каждый час
            "60"


trackToValue : Int -> String
trackToValue v =
    case v of
        1 ->
            -- 12 часов
            "720"

        2 ->
            -- 4 часа
            "240"

        _ ->
            -- 1 час
            "60"


changesList : Model -> Dict String String
changesList model =
    let
        ( s1, s2 ) =
            model.masterSecurValue

        phone =
            case s1 of
                True ->
                    model.adminPhone

                False ->
                    ""

        code =
            case s2 of
                True ->
                    model.adminCode

                False ->
                    ""
    in
        Dict.fromList
            [ ( "sleep", (ecoToValue model.masterEcoValue) )
            , ( "auto.sleep", (trackToValue model.masterTrackValue) )
            , ( "admin", phone )
            , ( "secur.code", code )
            ]


showChanges : Model -> String -> List (UI Msg)
showChanges model sysId =
    let
        -- row ttl val =
        --     [ Html.div [ HA.class "col s6 right-align" ] [ Html.text ttl ]
        --     , Html.div [ HA.class "col s6 left-align" ] [ Html.text val ]
        --     ]
        row ( ttl, val ) =
            Html.tr [] [ Html.td [ HA.class "right-align", HA.style "width" "50%" ] [ Html.text ttl ], Html.td [] [ Html.text val ] ]
    in
        case model.showChanges of
            False ->
                []

            True ->
                [ Html.div [ HA.class "row" ] <|
                    [ Html.div [ HA.class "col s12 m10 offset-m1 l8 offset-l2 xl6 offset-xl3" ]
                        [ Html.text "Следующие параметры будут изменены:"
                        , Html.table []
                            [ Html.tbody [] (changesList model |> Dict.toList |> List.map row)
                            ]
                        ]
                    ]

                -- ++ row "sleep" (ecoToValue model.masterEcoValue)
                -- ++ row "auto.sleep" (trackToValue model.masterTrackValue)
                -- ++ row "admin" model.adminPhone
                -- ++ row "secur.code" model.adminPhone
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
        [ div [ class "col s12 m8 offset-m1 l7 offset-l3 xl7 offset-xl4", HA.style "text-align" "left" ]
            [ form
                [ attribute "action" "#" ]
                [ item_ 1 "Редко" (selected == 1) OnMasterEco1
                , item_ 2 "Оптимально" (selected == 2) OnMasterEco1
                , item_ 3 "Часто" (selected == 3) OnMasterEco1
                ]
            ]
        ]


masterPage1Help : Int -> String
masterPage1Help index =
    case index of
        1 ->
            "Объект будет выходить на связь один раз в сутки. Ожидаемый срок службы батареи - 15 лет."

        2 ->
            "Объект будет выходить на связь каждые 4 часа. Ожидаемый срок службы батареи - 6 лет."

        _ ->
            "Объект будет выходить на связь каждый час. Ожидаемый срок службы батареи - 15 месяцев."


masterPage2View : Int -> Html Msg
masterPage2View selected =
    row <|
        [ div [ class "col s12 m8 offset-m1 l7 offset-l3 xl7 offset-xl4", HA.style "text-align" "left" ]
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
            "Максимальное время работы в режиме Поиск - 12 часов. Ёмкости батареи хватит на 10 активаций режима Поиск."

        2 ->
            "Максимальное время работы в режиме Поиск - 4 часа. Ёмкости батареи хватит на 30 активаций режима Поиск."

        _ ->
            "Максимальное время работы в режиме Поиск - 1 час. Ёмкости батареи хватит на 120 активаций режима Поиск."


masterPage3View : ( Bool, Bool ) -> Model -> Html Msg
masterPage3View ( s1, s2 ) model =
    row <|
        [ div [ class "col s12 m11 offset-m1 l11 offset-l1 xl10 offset-xl2", HA.style "text-align" "left" ]
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
