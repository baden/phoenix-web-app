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
    }


type Msg
    = OnCode String
    | StartLink
    | OnHelpPage1
    | OnNext
    | OnPrev


init : ( Model, Cmd Msg )
init =
    ( { code = ""
      , masterPage = 1
      , helpPage1 = False
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


view : Model -> Html Msg
view model =
    let
        masterPage =
            case model.masterPage of
                1 ->
                    [ page_1 model ]

                _ ->
                    [ page_2 model ]
    in
        div [] <|
            [ UI.title_item "Мастер добавления систем"
            ]
                ++ [ UI.master masterPage ]
                ++ [ UI.row [ UI.linkIconTextButton "clone" "Вернуться к списку объектов" "/" ] ]


page_1 : Model -> UI.MasterItem Msg
page_1 model =
    UI.MasterItem "1. Активируйте закладку"
        [ MasterElementText "Убедитесь, что трекер-закладка находится в активном режиме (в режиме трекера)."
        , case model.helpPage1 of
            False ->
                MasterElementCmdButton "Инструкция" OnHelpPage1

            True ->
                MasterElementText "(Доработать!) Тут должна быть инструкция по переводу закладки в активный режим."
        , MasterElementNext OnNext
        ]


page_2 : Model -> UI.MasterItem Msg
page_2 model =
    UI.MasterItem "2. Начните процедуру привязки"
        [ MasterElementText "Отправьте на телефонный номер карточки трекера SMS: link."
        , MasterElementText "В ответ придёт уникальный код, введите код в поле ниже:"
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
