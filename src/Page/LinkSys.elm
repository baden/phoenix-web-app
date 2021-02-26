module Page.LinkSys exposing (..)

import API
import AppState exposing (AppState)
import Components.UI as UI exposing (UI)
import Html exposing (Html, br, button, div, form, img, input, label, li, ol, span, text)
import Html.Attributes as HA exposing (action, alt, attribute, class, name, pattern, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput)
import Regex
import String


type alias Model =
    { code : String
    , masterPage : Int
    , helpPage1 : Bool
    , showLedHelpDialog : Bool
    }


type Msg
    = OnCode String
    | StartLink
    | OnHelpPage1
    | OnNext
    | OnPrev
    | OnPage Int
    | OnLedHelp
    | OnLedHelpCancel


init : ( Model, Cmd Msg )
init =
    ( { code = ""
      , masterPage = 1
      , helpPage1 = False
      , showLedHelpDialog = False
      }
    , Cmd.none
    )


splitAtCouple : Int -> String -> ( String, String )
splitAtCouple pos str =
    ( String.left pos str, String.dropLeft pos str )


splitEvery pos str =
    if String.length str > pos then
        let
            ( head, tail ) =
                splitAtCouple pos str
        in
        head :: splitEvery pos tail

    else
        [ str ]


putDashEvery : Int -> String -> String
putDashEvery len str =
    str
        |> splitEvery len
        |> String.join "-"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCode newCode ->
            let
                cd =
                    newCode
                        |> Regex.replace
                            (Maybe.withDefault Regex.never (Regex.fromString "[\\W\\s\\._\\-]+"))
                            (\i -> "")
            in
            ( { model | code = putDashEvery 2 cd }, Cmd.none )

        StartLink ->
            ( model
            , Cmd.batch
                [ API.websocketOut <|
                    API.linkSysRequest model.code
                ]
            )

        OnHelpPage1 ->
            ( { model | helpPage1 = True }, Cmd.none )

        OnNext ->
            ( { model | masterPage = model.masterPage + 1 }, Cmd.none )

        OnPrev ->
            ( { model | masterPage = model.masterPage - 1 }, Cmd.none )

        OnPage page ->
            ( { model | masterPage = page }, Cmd.none )

        OnLedHelp ->
            ( { model | showLedHelpDialog = True }, Cmd.none )

        OnLedHelpCancel ->
            ( { model | showLedHelpDialog = False }, Cmd.none )


type alias Page =
    { title : String
    , list : List String
    , form : Html Msg
    , buttons : List (Html Msg)
    }



-- TODO: Make this defs static


page1 : AppState -> Model -> Page
page1 { t } model =
    Page
        "Подготовка SIM-карты"
        [ "Установите SIM-карту в мобильный телефон."
        , "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора."
        , "Убедитесь в том, что PIN-код при включении телефона выключен."
        , "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора."
        , "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту."
        ]
        (text "")
        [ button [ class "btn btn-md btn-primary btn-next", onClick OnNext ] [ text <| t "master.Далeе" ]
        ]


page2 : AppState -> Model -> Page
page2 { t } model =
    Page
        "Установка подготовленной SIM-карты в Феникс"
        [ "Выкрутите 4 винта и снимите крышку корпуса."
        , "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает."
        , "Установите подготовленную SIM-карту в Феникс."
        ]
        (div []
            [ div [ class "binding-executors" ]
                [ span [] [ text <| t "master.В случае необходимости произведите привязку экзекуторов." ]
                , span [ class "orange-gradient-text binding-title", onClick (OnPage 3) ] [ text <| t "master.Привязать экзекутор" ]
                ]
            , span [ class "checkmark-wrap checkmark-executors" ]
                [ label [ class "checkboxContainer" ] [ input [ name "", type_ "checkbox", value "" ] [], span [ class "checkmark" ] [] ]
                , span [ class "checkmark-text" ] [ text <| t "master.Экзекутор в наличии" ]
                ]
            ]
        )
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnPrev ] [ text <| t "master.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick (OnPage 4) ] [ text <| t "master.Далeе" ]
        ]


page3 : AppState -> Model -> Page
page3 { t } model =
    Page
        "Привязка экзекуторов и активация Феникса"
        [ "Исходное состояние: Феникс – выключен."
        , "Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания."
        , "Нажмите и удерживайте 3 секунды кнопку Фениска – загорится светодиод."
        , "Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки."
        , "Закройте крышку корпуса Фениска и закрутите 4 винта."
        ]
        (text "")
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnPrev ] [ text <| t "master.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick (OnPage 5) ] [ text <| t "master.Далeе" ]
        ]


page_3 =
    page_4


page_4 : Model -> UI.MasterItem Msg
page_4 model =
    UI.MasterItem "Активация Феникса"
        [ UI.MasterElementText "Нажмите кнопку ON-OFF Феникса – светодиодный индикатор подтвердит включение."
        , UI.MasterElementText "Закройте крышку корпуса Феникса и закрутите 4 винта."
        , UI.MasterElementPrev (OnPage 2)
        , UI.MasterElementCmdButton "LED" OnLedHelp
        , UI.MasterElementNext OnNext
        ]


page4 : AppState -> Model -> Page
page4 { t } model =
    Page
        "Активация Феникса"
        [ "Нажмите кнопку Феникса – светодиодный индикатор подтвердит включение."
        , "Закройте крышку корпуса Феникса и закрутите 4 винта."
        ]
        (text "")
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick (OnPage 2) ] [ text <| t "master.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick OnNext ] [ text <| t "master.Далeе" ]
        ]


page_5 : Model -> UI.MasterItem Msg
page_5 model =
    UI.MasterItem "Добавление Феникса в наблюдение"
        [ UI.MasterElementText "Отправьте на телефонный номер SIM-карты Феникса SMS: link"
        , UI.MasterElementText "В ответ придёт уникальный код – введите его в поле ниже:"
        , UI.MasterElementSMSLink
        , UI.MasterElementTextField model.code OnCode StartLink
        , UI.MasterElementPrev OnPrev
        ]


page5 : AppState -> Model -> Page
page5 { t } model =
    Page
        "Добавление Феникса в наблюдение"
        [ "Отправьте на телефонный номер SIM-карты Феникса SMS: link"
        , "В ответ придёт уникальный код – введите его в поле ниже:"
        ]
        (form [ action "" ]
            [ div [ class "form-list" ]
                [ div [ class "input-st" ]
                    [ input [ attribute "autocomplete" "off", attribute "required" "", type_ "text", value model.code, onInput OnCode ] []
                    , label [ class "input-label" ] [ text <| t "master.Введите уникальный код из SMS" ]
                    ]
                ]
            ]
        )
        [ button [ class "btn btn-md btn-secondary btn-prev", onClick OnPrev ] [ text <| t "master.Назад" ]
        , button [ class "btn btn-md btn-primary btn-next", onClick StartLink ] [ text <| t "master.Подтвердить" ]
        ]


view : AppState -> Model -> Html Msg
view ({ t } as appState) model =
    let
        page =
            case model.masterPage of
                1 ->
                    page1 appState model

                2 ->
                    page2 appState model

                3 ->
                    page3 appState model

                4 ->
                    page4 appState model

                _ ->
                    page5 appState model
    in
    div [ class "container" ]
        [ div [ class "wrapper-content" ]
            [ div [ class "wrapper-bg" ]
                [ Html.a [ HA.href "/", class "close closeAddFenix" ] []
                , div [ class "title-sm-gr" ] [ text <| t "master.Мастер добавления Феникса" ]

                --
                , div [ class "title-st" ] [ text <| t <| "master." ++ page.title ]
                , page.list |> List.map (\e -> li [] [ text <| t ("master." ++ e) ]) |> ol [ class "list-numbered list" ]
                , page.form
                , div [ HA.classList [ ( "wrapper-content-btn", True ), ( "btn-group", List.length page.buttons > 1 ) ] ] page.buttons
                , button [ class "led-indicator-wr modal-open", onClick OnLedHelp ]
                    [ span [] [ text <| t "master.Свериться с" ]
                    , span [ class "led-title orange-gradient-text" ] [ img [ alt "led", src "images/led.svg" ] [], text "LED" ]
                    , span [] [ text <| t "master.индикатором" ]
                    ]
                ]
            ]
        ]


viewOld : AppState -> Model -> Html Msg
viewOld { t } model =
    let
        masterPage =
            case model.masterPage of
                1 ->
                    [ page_1 model ]

                2 ->
                    [ page_2 model ]

                3 ->
                    [ page_3 model ]

                4 ->
                    [ page_4 model ]

                _ ->
                    [ page_5 model ]
    in
    -- TODO: Remove one level. Transfer to List?
    div []
        [ UI.appHeader ""
        , div [ class "content-wr list-wr" ] <|
            [ UI.title_item "Мастер добавления Феникса"
            ]
                ++ [ UI.master masterPage ]
                -- ++ [ UI.row_item [ UI.linkIconTextButton "clone" "Вернуться к списку Фениксов" "/" ] ]
                ++ [ UI.grayLinkButton "Отменить добавление" "/" ]
                ++ ledHelpDialogView model.showLedHelpDialog
        ]


page_1 : Model -> UI.MasterItem Msg
page_1 model =
    UI.MasterItem "Подготовка SIM-карты"
        [ UI.MasterElementText "Установите SIM-карту в мобильный телефон."
        , UI.MasterElementText "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора."
        , UI.MasterElementText "Убедитесь в том, что PIN-код при включении телефона выключен."
        , UI.MasterElementText "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора."
        , UI.MasterElementText "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту."
        , UI.MasterElementCmdButton "LED" OnLedHelp
        , UI.MasterElementNext OnNext
        ]


page_2 : Model -> UI.MasterItem Msg
page_2 model =
    UI.MasterItem "Установка подготовленной SIM-карты в Феникс"
        [ UI.MasterElementText "Выкрутите 4 винта и снимите крышку корпуса."
        , UI.MasterElementText "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает."
        , UI.MasterElementText "Установите подготовленную SIM-карту в Феникс."
        , UI.MasterElementText "В случае необходимости произведите привязку экзекуторов."
        , UI.MasterElementPrev OnPrev
        , UI.MasterElementCmdButton "LED" OnLedHelp
        , UI.MasterElementCmdButton "Привязать экзекуторы" (OnPage 3)
        , UI.MasterElementNext (OnPage 4)

        -- , MasterElementCmdButton "" (OnPage 3)
        -- , MasterElementNext OnNext
        ]


page_alt_1 : Model -> UI.MasterItem Msg
page_alt_1 model =
    UI.MasterItem "1. Укажите телефонный номер карточки системы"
        [ UI.MasterElementText "Данный способ регистрации менее защищенный, так как идет передача номера карточки."
        , UI.MasterElementText "Данный способ регистрации пока на стадии разработки..."

        -- , UI.smsCodeInput model.code OnCode StartLink
        ]


ledHelpDialogView : Bool -> List (UI Msg)
ledHelpDialogView s =
    if s then
        [ UI.modal
            "Светодиодный индикатор"
            [ UI.ModalIconText "images/gifs/LedOff.gif" "Не горит и не мигает – Феникс выключен"
            , UI.ModalIconText "images/gifs/led_fast_flash.gif" "Серия частых вспышек – включение Феникса"
            , UI.ModalIconText "images/gifs/led_slow_flash.gif" "Редкие одиночные вспышки – режим Поиск"
            , UI.ModalIconText "images/gifs/led_slow2_flash.gif" "Редкие двойные вспышки – зарегистрированы спутники"
            , UI.ModalIconText "images/gifs/led_long_flash.gif" "Серия нечастых вспышек – выключение Феникса"
            , UI.ModalIconText "images/gifs/led_5sec_flash.gif" "Загорается на 5 секунд – привязка экзекуторов"
            ]
            [ UI.cmdButton "Закрыть" OnLedHelpCancel
            ]
        , UI.modal_overlay OnLedHelpCancel
        ]

    else
        []
