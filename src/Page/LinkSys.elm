module Page.LinkSys exposing (..)

import API
import AppState exposing (AppState)
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text)
import Html.Attributes as HA exposing (class, pattern, placeholder, value)
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


view : AppState -> Model -> Html Msg
view { t } model =
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
        [ MasterElementText "Установите SIM-карту в мобильный телефон."
        , MasterElementText "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора."
        , MasterElementText "Убедитесь в том, что PIN-код при включении телефона выключен."
        , MasterElementText "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора."
        , MasterElementText "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту."
        , MasterElementCmdButton "LED" OnLedHelp
        , MasterElementNext OnNext
        ]


page_2 : Model -> UI.MasterItem Msg
page_2 model =
    UI.MasterItem "Установка подготовленной SIM-карты в Феникс"
        [ MasterElementText "Выкрутите 4 винта и снимите крышку корпуса."
        , MasterElementText "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает."
        , MasterElementText "Установите подготовленную SIM-карту в Феникс."
        , MasterElementText "В случае необходимости произведите привязку экзекуторов."
        , MasterElementPrev OnPrev
        , MasterElementCmdButton "LED" OnLedHelp
        , MasterElementCmdButton "Привязать экзекуторы" (OnPage 3)
        , MasterElementNext (OnPage 4)

        -- , MasterElementCmdButton "" (OnPage 3)
        -- , MasterElementNext OnNext
        ]


page_3 : Model -> UI.MasterItem Msg
page_3 model =
    UI.MasterItem "Привязка экзекуторов и активация Феникса"
        [ MasterElementText "Исходное состояние: Феникс – выключен."
        , MasterElementText "Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания."
        , MasterElementText "Нажмите и удерживайте 3 секунды кнопку ON-OFF Фениска – загорится светодиод."
        , MasterElementText "Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки."
        , MasterElementText "Закройте крышку корпуса Фениска и закрутите 4 винта."
        , MasterElementPrev OnPrev
        , MasterElementCmdButton "LED" OnLedHelp
        , MasterElementNext (OnPage 5)
        ]


page_4 : Model -> UI.MasterItem Msg
page_4 model =
    UI.MasterItem "Активация Феникса"
        [ MasterElementText "Нажмите кнопку ON-OFF Феникса – светодиодный индикатор подтвердит включение."
        , MasterElementText "Закройте крышку корпуса Феникса и закрутите 4 винта."
        , MasterElementPrev (OnPage 2)
        , MasterElementCmdButton "LED" OnLedHelp
        , MasterElementNext OnNext
        ]


page_5 : Model -> UI.MasterItem Msg
page_5 model =
    UI.MasterItem "Добавление Феникса в наблюдение"
        [ MasterElementText "Отправьте на телефонный номер SIM-карты Феникса SMS: link"
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
