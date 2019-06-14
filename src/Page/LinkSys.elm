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
    }


type Msg
    = OnCode String
    | StartLink


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


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


smsLink : String -> String -> Html a
smsLink phone body =
    Html.a [ HA.href <| "sms:" ++ phone ++ "?body=" ++ body ] [ text "Отправить SMS" ]


view : Model -> Html Msg
view model =
    div []
        [ Html.h4 [] [ text "Мастер добавления систем" ]
        , UI.master
            [ page_1
            , page_2
            ]
        , div [ class "row nodesktop" ]
            [ div [ class "col s4 offset-s4" ]
                [ smsLink "" "link" ]
            ]
        , div [ class "row" ]
            [ div [ class "col s6 offset-s3 m4 offset-m4 l2 offset-l5" ]
                [ Html.input
                    [ class "sms_code"
                    , placeholder "Введите код из SMS"
                    , value model.code
                    , onInput OnCode
                    , pattern "[A-Za-z0-9]{3}"
                    ]
                    []
                , Html.button
                    [ class "waves-effect waves-light btn"
                    , onClick StartLink
                    ]
                    [ text <| "Добавить" ]
                ]
            ]
        ]


page_1 : UI.MasterItem
page_1 =
    UI.MasterItem "1. Активируйте закладку"
        [ "Убедитесь, что трекер-закладка находится в активном режиме (в режиме трекера)."
        , "(Доработать!) Инструкция по переводу закладки в активный режим"
        ]


page_2 : UI.MasterItem
page_2 =
    UI.MasterItem "2. Начните процедуру привязки"
        [ "Отправьте на телефонный номер карточки трекера SMS: link."
        , "В ответ придёт уникальный код, введите код в окне ниже."
        ]



-- { text = "Убедитесь, что трекер-закладка находится в активном режиме (в режиме трекера)."
-- , content = div [] [ text "TBD" ]
-- }
-- div []
--     [ Html.h5 [] [ text "1" ]
--     , Html.p [] [ text "Убедитесь, что трекер-закладка находится в активном режиме (в режиме трекера)." ]
--     , Html.p [] [ text "(Доработать!) Инструкция по переводу закладки в активный режим" ]
--     ]
