port module Main exposing (..)

import Browser
import Config
import Html exposing (Html, div, h1, img)
import Html.Attributes exposing (src, style, class)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Font as Font
import Json.Encode as Encode
import Components.ChartSvg as ChartSvg


---- MODEL ----


type alias Model =
    { username : String }


init : ( Model, Cmd Msg )
init =
    ( { username = "" }
    , Cmd.batch [ websocketOpen Config.ws ]
    )



---- UPDATE ----


type Msg
    = NoOp
    | OnName String
    | WebsocketIn String
    | OpenWebsocket String
    | WebsocketOpened Bool


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

        WebsocketIn message ->
            let
                _ =
                    Debug.log "WebsocketIn" message
            in
                ( model, Cmd.none )

        OpenWebsocket url ->
            ( model, websocketOpen url )

        WebsocketOpened _ ->
            -- let
            --     -- ( request, listener ) =
            --     --     sendTicket model.websocketTicket
            -- in
            -- sendMessage model request listener
            ( model
            , Cmd.batch
                [ websocketOut <|
                    makeRequest 1 "foo"
                ]
            )


makeRequest : Int -> String -> Encode.Value
makeRequest id method =
    Encode.object
        [ ( "jsonrpc", Encode.string "2.0" )
        , ( "method", Encode.string method )
        , ( "id", Encode.int id )
        ]



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string model.username) ] []
        , div [ class "control" ]
            [ img [ src "static/images/qr_code.png" ] []
            , h1 [] [ Html.text "Приложение в процессе разработки, приходите завтра." ]
            , eel model
            ]
        ]


eel model =
    Element.layout []
        (myColOfStuff model)


myColOfStuff : Model -> Element Msg
myColOfStuff model =
    column [ centerX, centerY, spacing 36 ]
        [ myRowOfStuff
        , (Element.text "Вот над этой строкой мы сейчас усердно работаем...")
        , ChartSvg.chartView "Батарея" 80.0
        , authView model
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


authView : Model -> Element Msg
authView model =
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
        , subscriptions = subscriptions
        }


port websocketOpen : String -> Cmd msg


port websocketOpened : (Bool -> msg) -> Sub msg


port websocketIn : (String -> msg) -> Sub msg


port websocketOut : Encode.Value -> Cmd msg


port mapInit : String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ websocketOpened WebsocketOpened, websocketIn WebsocketIn ]
