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
                    , row [ UI.text <| masterPage1Help model.masterData.masterEcoValue ]
                    , row [ masterPage1View model.masterData.masterEcoValue ]
                    ]
                        ++ masterFooterFirst

                MasterPage2 ->
                    [ row [ UI.text "Время работы в режиме Поиск" ]
                    , row [ UI.text <| masterPage2Help model.masterData.masterTrackValue ]
                    , row [ masterPage2View model.masterData.masterTrackValue ]
                    ]
                        ++ masterFooterMiddle

                MasterPage3 ->
                    [ row [ UI.text "Информирование" ]
                    , row [ UI.text <| masterPage3Help model.masterData.smsPhones ]
                    , row [ masterPage3View model.masterData.smsPhones model ]
                    ]
                        ++ masterFooterMiddle

                MasterPage4 ->
                    [ row [ UI.text "Контроль баланса SIM-карты" ]
                    , row [ UI.text <| masterPage4Help model ]
                    , row [ masterPage4View model ]
                    ]
                        ++ masterFooterMiddle

                MasterPage5 ->
                    [ row [ UI.text "Безопасность" ]
                    , row [ UI.text <| masterPage5Help model.masterData.masterSecurValue ]
                    , row [ masterPage5View model.masterData.masterSecurValue model ]
                    ]
                        ++ showChanges model sysId
                        ++ masterFooterLast sysId params.queue (changesList model)


changesList : Model -> Dict String String
changesList ({ masterData } as model) =
    let
        ( s1, s2 ) =
            masterData.masterSecurValue

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

        sp f =
            if f then
                "1"
            else
                "0"
    in
        Dict.fromList <|
            [ ( "sleep", (ecoToValue masterData.masterEcoValue) )
            , ( "auto.sleep", (trackToValue masterData.masterTrackValue) )
            , ( "admin", phone )
            , ( "secur.code", code )
            , ( "alarm1", model.smsPhone1 )
            , ( "balance.ussd", model.ussdPhone )
            ]
                ++ (if model.smsPhone1 /= "" then
                        [ ( "alarm.balance", sp masterData.smsPhones.balance )
                        , ( "alarm.case", sp masterData.smsPhones.caseOpen )
                        , ( "alarm.low", sp masterData.smsPhones.lowPower )
                        , ( "alarm.mode", sp masterData.smsPhones.changeMode )
                        , ( "alarm.on", sp masterData.smsPhones.onOff )
                        , ( "alarm.off", sp masterData.smsPhones.onOff )

                        -- , ( "alarm.delay", sp masterData.smsPhones.gsm )
                        -- , ( "alarm.stealth", sp masterData.smsPhones.gsm )
                        , ( "alarm.gps", sp masterData.smsPhones.moved )
                        ]
                    else
                        [ ( "alarm.balance", "0" )
                        , ( "alarm.case", "0" )
                        , ( "alarm.low", "0" )
                        , ( "alarm.mode", "0" )
                        , ( "alarm.on", "0" )
                        , ( "alarm.off", "0" )

                        -- , ( "alarm.delay", "0" )
                        -- , ( "alarm.stealth", "0" )
                        , ( "alarm.gps", "0" )
                        ]
                   )


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


item_ : mt -> String -> Bool -> (mt -> Bool -> Msg) -> UI Msg
item_ index label_ checked_ msg =
    p []
        [ label []
            [ input [ attribute "name" "group1", type_ "radio", checked checked_, HE.onCheck (msg index) ] []
            , span [] [ Html.text label_ ]
            ]
        ]



-- TODO: Fix 'a' type


item1_ : mt -> String -> Bool -> (mt -> Bool -> Msg) -> UI Msg
item1_ index label_ checked_ msg =
    row
        [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ label []
                [ input [ attribute "name" "group1", type_ "checkbox", checked checked_, HE.onCheck (msg index) ] []
                , span [] [ Html.text label_ ]
                ]
            ]
        ]


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


masterPage1View : MasterDataEco -> Html Msg
masterPage1View selected =
    masterPageForm
        [ item_ M_ECO_MAX "Редко" (selected == M_ECO_MAX) OnMasterEco1
        , item_ M_ECO_MID "Оптимально" (selected == M_ECO_MID) OnMasterEco1
        , item_ M_ECO_MIN "Часто" (selected == M_ECO_MIN) OnMasterEco1
        ]


masterPage1Help : MasterDataEco -> String
masterPage1Help index =
    case index of
        M_ECO_MAX ->
            "Объект будет выходить на связь один раз в сутки. Ожидаемый срок службы батареи - 15 лет."

        M_ECO_MID ->
            "Объект будет выходить на связь каждые 4 часа. Ожидаемый срок службы батареи - 6 лет."

        M_ECO_MIN ->
            "Объект будет выходить на связь каждый час. Ожидаемый срок службы батареи - 15 месяцев."


masterPage2View : MasterDataTrack -> Html Msg
masterPage2View selected =
    masterPageForm
        [ item_ M_TRACK_MIN "Продолжительно" (selected == M_TRACK_MIN) OnMasterTrack1
        , item_ M_TRACK_MID "Оптимально" (selected == M_TRACK_MID) OnMasterTrack1
        , item_ M_TRACK_MAX "Минимально" (selected == M_TRACK_MAX) OnMasterTrack1
        ]


masterPage2Help : MasterDataTrack -> String
masterPage2Help index =
    case index of
        M_TRACK_MIN ->
            "Максимальное время работы в режиме Поиск - 12 часов. Ёмкости батареи хватит на 10 активаций режима Поиск."

        M_TRACK_MID ->
            "Максимальное время работы в режиме Поиск - 4 часа. Ёмкости батареи хватит на 30 активаций режима Поиск."

        M_TRACK_MAX ->
            "Максимальное время работы в режиме Поиск - 1 час. Ёмкости батареи хватит на 120 активаций режима Поиск."


item2_ : String -> Bool -> (Bool -> MasterDataSMS -> MasterDataSMS) -> ((Bool -> MasterDataSMS -> MasterDataSMS) -> Bool -> Msg) -> UI Msg
item2_ label_ checked_ updater msg =
    row
        [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l2" ]
            [ label []
                [ input [ attribute "name" "group1", type_ "checkbox", checked checked_, HE.onCheck (msg updater) ] []
                , span [] [ Html.text label_ ]
                ]
            ]
        ]


masterPage3View : MasterDataSMS -> Model -> Html Msg
masterPage3View { balance, caseOpen, lowPower, changeMode, moved, onOff } model =
    masterPageForm <|
        [ phoneInput1 1 model.smsPhone1 OnSMSPhone1 ]
            ++ (if model.smsPhone1 == "" then
                    []
                else
                    [ row [ Html.div [ class "col" ] [ UI.text "На какие события реагировать:" ] ]
                    , item2_ "Критический остаток средств" balance (\v m -> { m | balance = v }) OnMasterSMSEvent
                    , item2_ "Низкий уровень заряда батареи" lowPower (\v m -> { m | lowPower = v }) OnMasterSMSEvent
                    , item2_ "Изменение режима (Поиск <-> Ожидание)" changeMode (\v m -> { m | changeMode = v }) OnMasterSMSEvent
                    , item2_ "Начало движения (в режиме Поиск)" moved (\v m -> { m | moved = v }) OnMasterSMSEvent
                    , item2_ "Включение и выключение трекера кнопкой на плате или через WEB-сервис" onOff (\v m -> { m | onOff = v }) OnMasterSMSEvent
                    , item2_ "Вскрытие корпуса" caseOpen (\v m -> { m | caseOpen = v }) OnMasterSMSEvent

                    -- , item2_ "Включение и выключение GSM-модуля" gsm (\v m -> { m | gsm = v }) OnMasterSMSEvent
                    ]
               )



-- , item1_ 2 "Вскрытие корпуса" True OnMasterSecur1
-- , codeInput s2 model.adminCode OnAdminCode


masterPage3Help : MasterDataSMS -> String
masterPage3Help _ =
    "Когда происходят определенные события, трекер может отправлять SMS-уведомление на заданный телефонный номер."


masterPage4View : Model -> Html Msg
masterPage4View model =
    masterPageForm <|
        [ phoneInput2 1 model.ussdPhone OnUSSDPhone ]
            ++ (if model.ussdPhone == "" then
                    []
                else
                    [ row
                        [ Html.div [ class "col s12" ] [ Html.text "Обычно ответ на запрос выглядит примерно так:" ]
                        , Html.div [ class "col s10 offset-s1 m4 offset-m3 lime", HA.style "margin-top" "20px", HA.style "margin-bottom" "20px" ] [ Html.text "Na schetu 454.77 grn. Detalno o bonusah po nomeru *100#" ]
                        , Html.div [ class "col s12" ] [ Html.text "Если цифра баланса идет не первой в сообщении, то необходимо настротить пропуск (в разработке)" ]
                        ]

                    -- , item2_ "Включение и выключение GSM-модуля" gsm (\v m -> { m | gsm = v }) OnMasterSMSEvent
                    ]
               )


masterPage4Help : Model -> String
masterPage4Help _ =
    "Чтобы трекер мог контроллировать баланс SIM-карты, необходимо настроить процедуру проверки."
        ++ " Если вы используете SIM-карту оператора Киевстар, то вам не понадобится менять настройки, просто нажмите кнопку Далее."


masterPage5View : ( Bool, Bool ) -> Model -> Html Msg
masterPage5View ( s1, s2 ) model =
    masterPageForm
        [ item1_ 1 "Привязать к телефону" s1 OnMasterSecur1
        , phoneInput s1 model.adminPhone OnAdminPhone
        , item1_ 2 "Установить пароль доступа" s2 OnMasterSecur1
        , codeInput s2 model.adminCode OnAdminCode
        ]


masterPage5Help : ( Bool, Bool ) -> String
masterPage5Help _ =
    "Чтобы никто посторонний не смог получить управление вашим устройством, установите дополнительную защиту."


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
            [ Html.text "Запрос для проверки баланса:"
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
