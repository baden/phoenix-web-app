module Page.System.Config.Master exposing (..)

-- exposing (..)

import API.System exposing (SystemDocumentParams)
import AppState exposing (AppState)
import Components.UI as UI
import Dict exposing (Dict)
import Html exposing (Html, a, button, div, form, input, label, p, span, text)
import Html.Attributes as HA exposing (attribute, checked, class, classList, href, id, type_, value)
import Html.Events as HE exposing (onClick)
import Page.System.Config.Master.Types exposing (..)
import Page.System.Config.Master.Widget exposing (..)
import Page.System.Config.Types exposing (..)


masterDialogView : AppState -> Model -> String -> Maybe SystemDocumentParams -> List (Html Msg)
masterDialogView ({ t } as appState) model sysId mparams =
    case mparams of
        Nothing ->
            [ hint_row "Ошибка загрузки или данные от Феникса еще не получены." ]

        Just params ->
            let
                p =
                    case model.showMasterDialog of
                        MasterPage1 ->
                            masterDialogView1 appState model sysId params

                        MasterPage2 ->
                            masterDialogView2 appState model sysId params

                        MasterPage3 ->
                            masterDialogView3 appState model sysId params

                        MasterPage4 ->
                            masterDialogView4 appState model sysId params

                        MasterPage5 ->
                            masterDialogView5 appState model sysId params
            in
            [ div [ class "title-sm-gr" ] [ text <| t "config.Основные настройки феникса" ]
            , progressBar <| masterPageNumber model.showMasterDialog
            ]
                ++ p


progressBar : Int -> Html Msg
progressBar progress =
    let
        classed pos =
            classList [ ( "progress-item", True ), ( "active", progress == pos ), ( "done", progress > pos ) ]
    in
    div [ class "progress" ]
        [ div [ classed 1 ] [ span [ class "circle" ] [ span [ class "progress-icon icon-clock" ] [] ] ]
        , div [ classed 2 ] [ span [ class "circle" ] [ span [ class "progress-icon icon-magnifier" ] [] ] ]
        , div [ classed 3 ] [ span [ class "circle" ] [ span [ class "progress-icon icon-phone" ] [] ] ]
        , div [ classed 4 ] [ span [ class "circle" ] [ span [ class "progress-icon icon-sim_logo" ] [] ] ]
        , div [ classed 5 ] [ span [ class "circle" ] [ span [ class "progress-icon icon-done" ] [] ] ]
        ]


masterDialogView1 : AppState -> Model -> String -> SystemDocumentParams -> List (Html Msg)
masterDialogView1 { t } model sysId params =
    let
        ev : MasterDataEco
        ev =
            model.masterData.masterEcoValue

        it : MasterDataEco -> List (Html Msg) -> Html Msg
        it v =
            div [ classList [ ( "config-select-item", True ), ( "active", ev == v ) ], onClick (OnMasterEco1 v) ]
    in
    [ div [ class "title-st" ] [ text <| t "config.Период выхода на связь" ]
    , div [ class "config-select" ]
        [ it M_ECO_MAX
            [ div [ class "config-select-content" ]
                [ span [ class "item-title" ] [ text <| t "config.Редко" ]
                , span [ class "item-text" ] [ text <| t "config.Феникс будет выходить на связь один раз в сутки." ]
                , span [ class "item-text" ] [ text <| t "config.Ожидаемый срок службы батареи - 15 лет." ]
                ]
            ]
        , it M_ECO_MID
            [ div [ class "config-select-content" ]
                [ span [ class "item-title" ] [ text <| t "config.Оптимально" ]
                , span [ class "item-text" ] [ text <| t "config.Феникс будет выходить на связь каждые 6 часов." ]
                , span [ class "item-text" ] [ text <| t "config.Ожидаемый срок службы батареи - 6 лет." ]
                ]
            ]
        , it M_ECO_MIN
            [ div [ class "config-select-content" ]
                [ span [ class "item-title" ] [ text <| t "config.Часто" ]
                , span [ class "item-text" ] [ text <| t "config.Феникс будет выходить на связь каждые 2 часа." ]
                , span [ class "item-text" ] [ text <| t "config.Ожидаемый срок службы батареи - 2 года." ]
                ]
            ]
        ]
    , button [ class "btn btn-md btn-primary btn-next mt-40", onClick OnMasterNext ] [ text <| t "config.Далее" ]
    ]


masterDialogView2 : AppState -> Model -> String -> SystemDocumentParams -> List (Html Msg)
masterDialogView2 { t } model sysId params =
    let
        ev : MasterDataTrack
        ev =
            model.masterData.masterTrackValue

        it : MasterDataTrack -> List (Html Msg) -> Html Msg
        it v =
            div [ classList [ ( "config-select-item", True ), ( "active", ev == v ) ], onClick (OnMasterTrack1 v) ]
    in
    [ div [ class "title-st" ] [ text <| t "config.Время работы в режиме Поиск" ]
    , div [ class "config-select" ]
        [ it M_TRACK_MIN
            [ div [ class "config-select-content" ]
                [ span [ class "item-title" ] [ text <| t "config.Продолжительно" ]
                , span [ class "item-text" ] [ text <| t "config.Максимальное время работы в режиме Поиск - 12 часов." ]
                , span [ class "item-text" ] [ text <| t "config.Ёмкости батареи хватит на 15 активаций режима Поиск." ]
                ]
            ]
        , it M_TRACK_MID
            [ div [ class "config-select-content" ]
                [ span [ class "item-title" ] [ text <| t "config.Оптимально" ]
                , span [ class "item-text" ] [ text <| t "config.Максимальное время работы в режиме Поиск - 6 часов." ]
                , span [ class "item-text" ] [ text <| t "config.Ёмкости батареи хватит на 30 активаций режима Поиск." ]
                ]
            ]
        , it M_TRACK_MAX
            [ div [ class "config-select-content" ]
                [ span [ class "item-title" ] [ text <| t "config.Минимально" ]
                , span [ class "item-text" ] [ text <| t "config.Максимальное время работы в режиме Поиск - 1 час." ]
                , span [ class "item-text" ] [ text <| t "config.Ёмкости батареи хватит на 100 активаций режима Поиск." ]
                ]
            ]
        ]
    , div [ class "wrapper-content-btn btn-group" ]
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnMasterPrev ] [ text <| t "config.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick OnMasterNext ] [ text <| t "config.Далее" ]
        ]
    ]


masterDialogView3 : AppState -> Model -> String -> SystemDocumentParams -> List (Html Msg)
masterDialogView3 { t } model sysId params =
    let
        phone =
            model.smsPhone1

        { balance, lowPower, changeMode, moved, caseOpen, onOff } =
            model.masterData.smsPhones

        toggler ttl v u =
            div [ class "toggler" ]
                [ span [ class "toggler-title" ] [ text <| t <| "config." ++ ttl ]
                , label [ class "toggler-wr" ] [ input [ checked v, type_ "checkbox", HE.onCheck (OnMasterSMSEvent u) ] [], span [ class "toggler-icon" ] [] ]
                ]
    in
    [ div [ class "title-st" ] [ text <| t "config.Информирование" ]
    , div [ class "page-subtext" ] [ text <| t "config.Когда происходят определенные события, Феникс может отправлять SMS на заданный номер" ]
    , div [ class "config-sm-title" ] [ text <| t "config.Укажите номер телефона" ]
    , div [ class "config-set-phone input-st" ] [ span [ class "phone-prefix" ] [ text "+380" ], input [ attribute "autocomplete" "off", value model.smsPhone1, HE.onInput OnSMSPhone1 ] [] ]
    , div [ class "config-sm-title" ] [ text <| t "config.Выберите события" ]
    , div [ class "toggler-list" ]
        [ toggler "Критический остаток средств" balance (\v m -> { m | balance = v })
        , toggler "Низкий уровень заряда батареи" lowPower (\v m -> { m | lowPower = v })
        , toggler "Изменение режима (Поиск <-> Ожидание)" changeMode (\v m -> { m | changeMode = v })
        , toggler "Начало движения (в режиме Поиск)" moved (\v m -> { m | moved = v })
        , toggler "Включение и выключение Феникса" onOff (\v m -> { m | onOff = v })
        , toggler "Вскрытие корпуса" caseOpen (\v m -> { m | caseOpen = v })
        ]
    , div [ class "wrapper-content-btn btn-group" ]
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnMasterPrev ] [ text <| t "config.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick OnMasterNext ] [ text <| t "config.Далее" ]
        ]
    ]


masterDialogView4 : AppState -> Model -> String -> SystemDocumentParams -> List (Html Msg)
masterDialogView4 { t } model sysId params =
    [ div [ class "title-st" ] [ text <| t "config.Контроль баланса SIM-карты" ]
    , div [ class "config-sm-title config-ussd-title" ] [ text <| t "config.USSD-запрос баланса SIM-карты" ]
    , div [ class "config-set-ussd input-st" ] [ input [ attribute "autocomplete" "off", value model.ussdPhone, HE.onInput OnUSSDPhone ] [] ]
    , div [ class "wrapper-content-btn btn-group" ]
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnMasterPrev ] [ text <| t "config.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick OnMasterNext ] [ text <| t "config.Далее" ]
        ]
    ]


masterDialogView5 : AppState -> Model -> String -> SystemDocumentParams -> List (Html Msg)
masterDialogView5 { t } model sysId params =
    let
        ( s1, s2 ) =
            model.masterData.masterSecurValue

        phoneHelp =
            if s1 && (model.adminPhone /= "") then
                span [ class "page-subtext" ] [ text <| t "config.Управление возможно только с телефона:", div [] [ text "+380 ", span [ id "phoneText" ] [ text model.adminPhone ] ] ]

            else
                span [ class "page-subtext" ] [ text <| t "config.По умолчанию управление возможно с любого телефона." ]

        smsHelp =
            if s2 && (model.adminCode /= "") then
                span [ class "page-subtext" ] [ text <| t "config.SMS-коды управления имеют вид:", span [ id "passwordText" ] [ text model.adminCode ], text " link" ]

            else
                span [ class "page-subtext" ] [ text <| t "config.SMS-коды управления имеют вид:", span [ id "passwordText" ] [], text "link" ]

        mixedQueue =
            Dict.union (changesList model) params.queue
    in
    [ div [ class "title-st" ] [ text <| t "config.Безопасность" ]
    , div [ class "security-wr" ]
        [ span [ class "page-subtext" ] [ text <| t "config.Чтобы никто посторонний не смог получить управление Вашим Фениксом, вы можете привязать управление к конкретному телефону и установить свой код доступа." ]
        , phoneHelp
        , smsHelp
        , div [ class "config-security-item" ]
            [ div [ class "toggler toggler-show-data" ]
                [ span [ class "toggler-title" ] [ text <| t "config.Привязать к телефону" ]
                , label [ class "toggler-wr" ] [ input [ id "bindingPhone", type_ "checkbox", checked s1, HE.onCheck (OnMasterSecur1 1) ] [], span [ class "toggler-icon" ] [] ]
                ]
            , div [ class "config-set-phone input-st", classList [ ( "bindingPhoneShowed", not s1 ) ] ]
                [ span [ class "phone-prefix" ] [ text "+380" ]
                , input [ attribute "autocomplete" "off", id "bindingPhoneText", attribute "maxlength" "9", value model.adminPhone, HE.onInput OnAdminPhone ] []
                ]
            ]
        , div [ class "config-security-item" ]
            [ div [ class "toggler toggler-show-data" ]
                [ span [ class "toggler-title" ] [ text <| t "config.Установить пароль доступа" ]
                , label [ class "toggler-wr" ] [ input [ id "setPassword", type_ "checkbox", checked s2, HE.onCheck (OnMasterSecur1 2) ] [], span [ class "toggler-icon" ] [] ]
                ]
            , div [ class "input-st", classList [ ( "setPasswordShowed", not s2 ) ] ]
                [ span [ class "input-sm-label" ] [ text <| t "config.Вводите только латинские буквы и цифры" ]
                , input [ attribute "autocomplete" "off", id "setPasswordText", value model.adminCode, HE.onInput OnAdminCode ] []
                ]
            ]
        ]
    , div [ class "wrapper-content-btn btn-group" ]
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnMasterPrev ] [ text <| t "config.Назад" ]
        , span [ class "text", onClick OnShowChanges ] [ text "(?)" ]

        -- , button [ class "btn btn-md btn-primary btn-next", onClick (OnConfirmMaster sysId mixedQueue) ] [ text "Применить" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick (OnConfirmMaster sysId mixedQueue) ] [ text <| t "config.Применить" ]

        -- , masterFooterLast sysId params.queue (changesList model)
        ]
    ]
        ++ showChanges model sysId


masterFooterLast : String -> Dict String String -> Dict String String -> List (Html Msg)
masterFooterLast sysId customQueue masterQueue =
    let
        mixedQueue =
            Dict.union masterQueue customQueue
    in
    [ UI.cmdTextIconButton "thumbs-up" "Применить" (OnConfirmMaster sysId mixedQueue)
    ]



-- masterDialogViewOld : Model -> String -> Maybe SystemDocumentParams -> List (Html Msg)
-- masterDialogViewOld model sysId mparams =
--     -- Тут наверное не очень красиво проброшена очередь параметров
--     case mparams of
--         Nothing ->
--             [ hint_row "Ошибка загрузки или данные от Феникса еще не получены." ]
--
--         Just params ->
--             case model.showMasterDialog of
--                 MasterPage1 ->
--                     [ text_row "Период выхода на связь"
--                     , text_row <| masterPage1Help model.masterData.masterEcoValue
--                     , UI.row [ masterPage1View model.masterData.masterEcoValue ]
--                     ]
--                         ++ masterFooterFirst
--
--                 MasterPage2 ->
--                     [ text_row "Время работы в режиме Поиск"
--                     , text_row <| masterPage2Help model.masterData.masterTrackValue
--                     , UI.row [ masterPage2View model.masterData.masterTrackValue ]
--                     ]
--                         ++ masterFooterMiddle
--
--                 MasterPage3 ->
--                     [ text_row "Информирование"
--                     , text_row <| masterPage3Help model.masterData.smsPhones
--                     , UI.row [ masterPage3View model.masterData.smsPhones model ]
--                     ]
--                         ++ masterFooterMiddle
--
--                 MasterPage4 ->
--                     [ text_row "Контроль баланса SIM-карты"
--                     , text_row <| masterPage4Help model
--                     , UI.row [ masterPage4View model ]
--                     ]
--                         ++ masterFooterMiddle
--
--                 MasterPage5 ->
--                     [ text_row "Безопасность"
--                     , text_row <| masterPage5Help model.masterData.masterSecurValue
--                     , UI.row [ masterPage5View model.masterData.masterSecurValue model ]
--                     ]
--                         ++ showChanges model sysId
--                         ++ masterFooterLast sysId params.queue (changesList model)


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
        [ ( "sleep", ecoToValue masterData.masterEcoValue )
        , ( "auto.sleep", trackToValue masterData.masterTrackValue )
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


showChanges : Model -> String -> List (Html Msg)
showChanges model sysId =
    case model.showChanges of
        False ->
            []

        True ->
            changes_table <| changesList model



-- masterPage {Header} -> {Help foo} ->
-- masterPage : String -> String
-- TODO: Fix 'a' type
-- masterPage1View : MasterDataEco -> Html Msg
-- masterPage1View selected =
--     masterPageForm
--         [ radio M_ECO_MAX "Редко" (selected == M_ECO_MAX) OnMasterEco1
--         , radio M_ECO_MID "Оптимально" (selected == M_ECO_MID) OnMasterEco1
--         , radio M_ECO_MIN "Часто" (selected == M_ECO_MIN) OnMasterEco1
--         ]
-- masterPage1Help : MasterDataEco -> String
-- masterPage1Help index =
--     case index of
--         M_ECO_MAX ->
--             "Феникс будет выходить на связь один раз в сутки. Ожидаемый срок службы батареи - 15 лет."
--
--         M_ECO_MID ->
--             "Феникс будет выходить на связь каждые 4 часа. Ожидаемый срок службы батареи - 6 лет."
--
--         M_ECO_MIN ->
--             "Феникс будет выходить на связь каждые 2 часа. Ожидаемый срок службы батареи - 3 года."
-- masterPage2View : MasterDataTrack -> Html Msg
-- masterPage2View selected =
--     masterPageForm
--         [ radio M_TRACK_MIN "Продолжительно" (selected == M_TRACK_MIN) OnMasterTrack1
--         , radio M_TRACK_MID "Оптимально" (selected == M_TRACK_MID) OnMasterTrack1
--         , radio M_TRACK_MAX "Минимально" (selected == M_TRACK_MAX) OnMasterTrack1
--         ]
--
--
-- masterPage2Help : MasterDataTrack -> String
-- masterPage2Help index =
--     case index of
--         M_TRACK_MIN ->
--             "Максимальное время работы в режиме Поиск - 12 часов. Ёмкости батареи хватит на 10 активаций режима Поиск."
--
--         M_TRACK_MID ->
--             "Максимальное время работы в режиме Поиск - 4 часа. Ёмкости батареи хватит на 30 активаций режима Поиск."
--
--         M_TRACK_MAX ->
--             "Максимальное время работы в режиме Поиск - 1 час. Ёмкости батареи хватит на 120 активаций режима Поиск."
--
--
-- masterPage3View : MasterDataSMS -> Model -> Html Msg
-- masterPage3View { balance, caseOpen, lowPower, changeMode, moved, onOff } model =
--     masterPageForm <|
--         [ phoneInput1 1 model.smsPhone1 OnSMSPhone1 ]
--             ++ (if model.smsPhone1 == "" then
--                     []
--
--                 else
--                     [ hint_row "События:"
--                     , checkboxLazy "Критический остаток средств" balance (\v m -> { m | balance = v }) OnMasterSMSEvent
--                     , checkboxLazy "Низкий уровень заряда батареи" lowPower (\v m -> { m | lowPower = v }) OnMasterSMSEvent
--                     , checkboxLazy "Изменение режима (Поиск <-> Ожидание)" changeMode (\v m -> { m | changeMode = v }) OnMasterSMSEvent
--                     , checkboxLazy "Начало движения (в режиме Поиск)" moved (\v m -> { m | moved = v }) OnMasterSMSEvent
--                     , checkboxLazy "Включение и выключение Феникса" onOff (\v m -> { m | onOff = v }) OnMasterSMSEvent
--                     , checkboxLazy "Вскрытие корпуса" caseOpen (\v m -> { m | caseOpen = v }) OnMasterSMSEvent
--
--                     -- , item2_ "Включение и выключение GSM-модуля" gsm (\v m -> { m | gsm = v }) OnMasterSMSEvent
--                     ]
--                )
-- , item1_ 2 "Вскрытие корпуса" True OnMasterSecur1
-- , codeInput s2 model.adminCode OnAdminCode
-- masterPage3Help : MasterDataSMS -> String
-- masterPage3Help _ =
--     "Когда происходят определенные события, Феникс может отправлять SMS на заданный номер:"
--
--
-- masterPage4View : Model -> Html Msg
-- masterPage4View model =
--     masterPageForm <|
--         [ phoneInput2 1 model.ussdPhone OnUSSDPhone ]
-- ++ (if model.ussdPhone == "" then
--         []
--     else
--         [ row
--             [ hint "Обычно ответ на запрос выглядит примерно так:"
--             , hint_c "Na schetu 454.77 grn. Detalno o bonusah po nomeru *100#"
--             , hint "Если цифра баланса идет не первой в сообщении, то необходимо настротить пропуск (в разработке)"
--             ]
--
--         -- , item2_ "Включение и выключение GSM-модуля" gsm (\v m -> { m | gsm = v }) OnMasterSMSEvent
--         ]
--    )
-- masterPage4Help : Model -> String
-- masterPage4Help _ =
--     -- "Чтобы Феникс мог контроллировать баланс SIM-карты, необходимо настроить процедуру проверки."
--     --     ++ " Если вы используете SIM-карту оператора Киевстар, то вам не понадобится менять настройки, просто нажмите кнопку Далее."
--     ""
-- masterPage5View : ( Bool, Bool ) -> Model -> Html Msg
-- masterPage5View ( s1, s2 ) model =
--     masterPageForm
--         [ checkbox 1 "Привязать к телефону" s1 OnMasterSecur1
--         , phoneInput s1 model.adminPhone OnAdminPhone
--         , checkbox 2 "Установить пароль доступа" s2 OnMasterSecur1
--         , codeInput s2 model.adminCode OnAdminCode
--         ]
--
--
-- masterPage5Help : ( Bool, Bool ) -> String
-- masterPage5Help _ =
--     "Чтобы никто посторонний не смог получить управление Вашим Фенисксом, установите дополнительную защиту:"
