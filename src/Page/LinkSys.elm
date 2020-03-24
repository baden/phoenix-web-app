module Page.LinkSys exposing (..)

import Components.UI as UI
import Html exposing (Html, div, text)
import Html.Attributes as HA exposing (class, placeholder, value, pattern)
import Html.Events exposing (onInput, onClick)
import API
import String
import Regex


type alias Model =
    { code : String
    , alt : Bool
    }


type Msg
    = OnCode String
    | StartLink
    | AltMode


init : ( Model, Cmd Msg )
init =
    ( Model "" False, Cmd.none )


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

        AltMode ->
            ( { model | alt = not model.alt }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        master =
            case model.alt of
                False ->
                    [ UI.master
                        [ page_1
                        , page_2
                        ]
                    , div [ class "row nodesktop" ]
                        [ div [ class "col s4 offset-s4" ]
                            [ UI.smsLink "" "link" ]
                        ]
                    ]

                True ->
                    [ UI.master
                        [ page_alt_1 model
                        ]
                    , div [ class "row nodesktop" ]
                        [ div [ class "col s4 offset-s4" ]
                            [ UI.smsLink "" "link" ]
                        ]
                    ]
    in
        div [] <|
            [ UI.title_item "Мастер добавления систем"
            ]
                ++ master
                ++ [ UI.smsCodeInput model.code OnCode StartLink
                   , UI.row [ UI.cmdButton "Альтернативный способ" AltMode ]
                   , UI.row [ UI.linkIconTextButton "clone" "Вернуться к списку объектов" "/" ]
                   ]


page_1 : UI.MasterItem
page_1 =
    UI.MasterItem "1. Активируйте закладку"
        [ "Убедитесь, что трекер-закладка находится в активном режиме (в режиме трекера)."
        , "(Доработать!) Инструкция по переводу закладки в активный режим."
        ]


page_2 : UI.MasterItem
page_2 =
    UI.MasterItem "2. Начните процедуру привязки"
        [ "Отправьте на телефонный номер карточки трекера SMS: link."
        , "В ответ придёт уникальный код, введите код в поле ниже."
        ]


page_alt_1 : Model -> UI.MasterItem
page_alt_1 model =
    UI.MasterItem "1. Укажите телефонный номер карточки системы"
        [ "Данный способ регистрации менее защищенный, так как идет передача номера карточки."
        , "Данный способ регистрации пока на стадии разработки..."

        -- , UI.smsCodeInput model.code OnCode StartLink
        ]
