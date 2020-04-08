module Page.LinkSys exposing (..)

import Components.UI as UI exposing (..)
import Html exposing (Html, div, text)
import Html.Attributes as HA exposing (class, placeholder, value, pattern)
import Html.Events exposing (onInput, onClick)
import API
import String
import Regex


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


view : Model -> Html Msg
view model =
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
        div [ class "container" ] <|
            [ UI.title_item "Мастер добавления трекеров"
            ]
                ++ [ UI.master masterPage ]
                ++ [ UI.row_item [ UI.linkIconTextButton "clone" "Вернуться к списку объектов" "/" ] ]
                ++ (ledHelpDialogView model.showLedHelpDialog)


page_1 : Model -> UI.MasterItem Msg
page_1 model =
    UI.MasterItem "Подготовка SIM-карты"
        [ MasterElementText "1. Установите SIM-карту в мобильный телефон."
        , MasterElementText "2. Активируйте SIM-карту в соответствии с инструкциями GSM-оператора."
        , MasterElementText "3. Убедитесь в том, что PIN-код при включении телефона выключен."
        , MasterElementText "4. В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора."
        , MasterElementText "5. Выключите мобильный телефон и извлеките из него подготовленную SIM-карту."
        , MasterElementCmdButton "L" OnLedHelp
        , MasterElementNext OnNext
        ]


page_2 : Model -> UI.MasterItem Msg
page_2 model =
    UI.MasterItem "Установка подготовленной SIM-карты в трекер"
        [ MasterElementText "1. Выкрутите 4 винта и снимите крышку корпуса."
        , MasterElementText "2. Убедитесь в том, что трекер выключен – светодиодный индикатор не горит и не мигает."
        , MasterElementText "3. Установите подготовленную SIM-карту в трекер."
        , MasterElementText "4. В случае необходимости произведите привязку экзекуторов."
        , MasterElementPrev OnPrev
        , MasterElementCmdButton "L" OnLedHelp
        , MasterElementCmdButton "Привязать экзекуторы" (OnPage 3)
        , MasterElementCmdButton "Далее" (OnPage 4)

        -- , MasterElementCmdButton "" (OnPage 3)
        -- , MasterElementNext OnNext
        ]


page_3 : Model -> UI.MasterItem Msg
page_3 model =
    UI.MasterItem "Привязка экзекуторов и активация трекера-закладки"
        [ MasterElementText "1. Исходное состояние: трекер – выключен."
        , MasterElementText "2. Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания."
        , MasterElementText "3. Нажмите и удерживайте 3 секунды кнопку ON-OFF трекера – загорится светодиод."
        , MasterElementText "4. Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки."
        , MasterElementText "5. Закройте крышку корпуса трекера и закрутите 4 винта."
        , MasterElementPrev OnPrev
        , MasterElementCmdButton "L" OnLedHelp
        , MasterElementCmdButton "Далее" (OnPage 5)
        ]


page_4 : Model -> UI.MasterItem Msg
page_4 model =
    UI.MasterItem "Активация трекера-закладки"
        [ MasterElementText "1. Нажмите кнопку ON-OFF трекера – светодиодный индикатор подтвердит включение."
        , MasterElementText "2. Закройте крышку корпуса трекера и закрутите 4 винта."
        , MasterElementCmdButton "Назад" (OnPage 2)
        , MasterElementCmdButton "L" OnLedHelp
        , MasterElementNext OnNext
        ]


page_5 : Model -> UI.MasterItem Msg
page_5 model =
    UI.MasterItem "Добавление трекера-закладки в наблюдение"
        [ MasterElementText "1. Отправьте на телефонный номер SIM-карты трекера SMS: link."
        , MasterElementText "В ответ придёт уникальный код – введите его в поле ниже:"
        , MasterElementSMSLink
        , MasterElementTextField model.code OnCode StartLink
        , MasterElementPrev OnPrev
        ]


page_alt_1 : Model -> UI.MasterItem Msg
page_alt_1 model =
    UI.MasterItem "1. Укажите телефонный номер карточки системы"
        [ MasterElementText "Данный способ регистрации менее защищенный, так как идет передача номера карточки."
        , MasterElementText "Данный способ регистрации пока на стадии разработки..."

        -- , UI.smsCodeInput model.code OnCode StartLink
        ]


ledHelpDialogView : Bool -> List (UI Msg)
ledHelpDialogView s =
    if s then
        [ UI.modal
            "Светодиодный индикатор"
            [ UI.ModalIconText "images/gifs/LedOff.png" "Не горит и не мигает – трекер выключен"
            , UI.ModalIconText "images/gifs/led_fast_flash.gif" "Серия частых вспышек – включение трекера"
            , UI.ModalIconText "images/gifs/led_slow_flash.gif" "Редкие одиночные вспышки – режим трекера"
            , UI.ModalIconText "images/gifs/led_slow2_flash.gif" "Редкие двойные вспышки – зарегистрированы спутники"
            , UI.ModalIconText "images/gifs/led_long_flash.gif" "Серия нечастых вспышек – выключение трекера"
            , UI.ModalIconText "images/gifs/led_5sec_flash.gif" "Загорается на 5 секунд – привязка экзекуторов"
            ]
            [ UI.cmdButton "Закрыть" (OnLedHelpCancel)
            ]
        , UI.modal_overlay OnLedHelpCancel
        ]
    else
        []
