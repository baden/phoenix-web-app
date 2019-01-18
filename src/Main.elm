module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img)
import Html.Attributes exposing (src)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Font as Font


---- MODEL ----


type alias Model =
    { username : String }


init : ( Model, Cmd Msg )
init =
    ( { username = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | OnName String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- let
    --     _ =
    --         Debug.log "Update" ( msg, model )
    -- in
    case msg of
        OnName val ->
            ( { model | username = val }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "static/images/qr_code.png" ] []
        , h1 [] [ Html.text "Приложение в процессе разработки, приходите завтра." ]
        , eel model
        ]


eel model =
    Element.layout []
        (myColOfStuff model)


myColOfStuff : Model -> Element Msg
myColOfStuff model =
    column [ centerX, centerY, spacing 36 ]
        [ myRowOfStuff
        , (Element.text "Вот над этой строкой мы сейчас усердно работаем...")
        , authViev model
        ]


myRowOfStuff : Element Msg
myRowOfStuff =
    row [ width fill, centerY, spacing 30 ]
        [ myElement
        , myElement
        , el [ alignRight ] myElement
        ]


myElement : Element Msg
myElement =
    el
        [ Background.color (rgb255 240 0 245)
        , Font.color (rgb255 255 255 255)
        , Border.rounded 3
        , padding 3
        ]
        (Element.text "+")


authViev : Model -> Element Msg
authViev model =
    column
        [ spacing 20
        , height fill
        , width (fillPortion 50)
        ]
        [ (Element.text "Авторизация")
        , (Input.text []
            { onChange = OnName
            , text = model.username
            , placeholder = Just (Input.placeholder [] (text "username"))
            , label = Input.labelHidden "Solution"
            }
          )
        , Input.button
            [ Background.color blue
            , Font.color white
            , Border.color darkBlue
            , paddingXY 32 16
            , Border.rounded 3
            , width fill
            ]
            { onPress = Nothing
            , label = Element.text <| "Авторизоваться как " ++ model.username
            }
        ]


darkBlue =
    Element.rgb 0 0 0.9


blue =
    Element.rgb 0 0 0.8


white =
    Element.rgb 1 1 1



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
