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
            [ hint_row "Ошибка загрузки или данные от трекера еще не получены." ]

        Just params ->
            case model.showMasterDialog of
                MasterPage1 ->
                    [ text_row "Период выхода на связь"
                    , text_row <| masterPage1Help model.masterData.masterEcoValue
                    , row [ masterPage1View model.masterData.masterEcoValue ]
                    ]
                        ++ masterFooterFirst

                MasterPage2 ->
                    [ text_row "Время работы в режиме Поиск"
                    , text_row <| masterPage2Help model.masterData.masterTrackValue
                    , row [ masterPage2View model.masterData.masterTrackValue ]
                    ]
                        ++ masterFooterMiddle

                MasterPage3 ->
                    [ text_row "Информирование"
                    , text_row <| masterPage3Help model.masterData.smsPhones
                    , row [ masterPage3View model.masterData.smsPhones model ]
                    ]
                        ++ masterFooterMiddle

                MasterPage4 ->
                    [ text_row "Контроль баланса SIM-карты"
                    , text_row <| masterPage4Help model
                    , row [ masterPage4View model ]
                    ]
                        ++ masterFooterMiddle

                MasterPage5 ->
                    [ text_row "Безопасность"
                    , text_row <| masterPage5Help model.masterData.masterSecurValue
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
    case model.showChanges of
        False ->
            []

        True ->
            changes_table <| changesList model



-- masterPage {Header} -> {Help foo} ->
-- masterPage : String -> String
-- TODO: Fix 'a' type


masterPage1View : MasterDataEco -> Html Msg
masterPage1View selected =
    masterPageForm
        [ radio M_ECO_MAX "Редко" (selected == M_ECO_MAX) OnMasterEco1
        , radio M_ECO_MID "Оптимально" (selected == M_ECO_MID) OnMasterEco1
        , radio M_ECO_MIN "Часто" (selected == M_ECO_MIN) OnMasterEco1
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
        [ radio M_TRACK_MIN "Продолжительно" (selected == M_TRACK_MIN) OnMasterTrack1
        , radio M_TRACK_MID "Оптимально" (selected == M_TRACK_MID) OnMasterTrack1
        , radio M_TRACK_MAX "Минимально" (selected == M_TRACK_MAX) OnMasterTrack1
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


masterPage3View : MasterDataSMS -> Model -> Html Msg
masterPage3View { balance, caseOpen, lowPower, changeMode, moved, onOff } model =
    masterPageForm <|
        [ phoneInput1 1 model.smsPhone1 OnSMSPhone1 ]
            ++ (if model.smsPhone1 == "" then
                    []
                else
                    [ hint_row "События:"
                    , checkboxLazy "Критический остаток средств" balance (\v m -> { m | balance = v }) OnMasterSMSEvent
                    , checkboxLazy "Низкий уровень заряда батареи" lowPower (\v m -> { m | lowPower = v }) OnMasterSMSEvent
                    , checkboxLazy "Изменение режима (Поиск <-> Ожидание)" changeMode (\v m -> { m | changeMode = v }) OnMasterSMSEvent
                    , checkboxLazy "Начало движения (в режиме Поиск)" moved (\v m -> { m | moved = v }) OnMasterSMSEvent
                    , checkboxLazy "Включение и выключение трекера" onOff (\v m -> { m | onOff = v }) OnMasterSMSEvent
                    , checkboxLazy "Вскрытие корпуса" caseOpen (\v m -> { m | caseOpen = v }) OnMasterSMSEvent

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
                        [ hint "Обычно ответ на запрос выглядит примерно так:"
                        , hint_c "Na schetu 454.77 grn. Detalno o bonusah po nomeru *100#"
                        , hint "Если цифра баланса идет не первой в сообщении, то необходимо настротить пропуск (в разработке)"
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
        [ checkbox 1 "Привязать к телефону" s1 OnMasterSecur1
        , phoneInput s1 model.adminPhone OnAdminPhone
        , checkbox 2 "Установить пароль доступа" s2 OnMasterSecur1
        , codeInput s2 model.adminCode OnAdminCode
        ]


masterPage5Help : ( Bool, Bool ) -> String
masterPage5Help _ =
    "Чтобы никто посторонний не смог получить управление вашим устройством, установите дополнительную защиту."
