port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Config
import Url
import Html exposing (Html, div, h1, img, a)
import Html.Attributes exposing (src, style, class, href)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Font as Font
import Json.Encode as Encode
import Components.ChartSvg as ChartSvg
import Page.Login as Login


---- MODEL ----


type Route
    = Home
    | Login
    | SignUp
    | Contracts
    | Contract Int
    | Profile String


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , currentView : Route
    , login : Login.Model
    }



-- type alias Model =
--     { username : String }
---- UPDATE ----


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | WebsocketIn String
    | OpenWebsocket String
    | WebsocketOpened Bool
    | LoginMgs Login.Msg



-- init : ( Model, Cmd Msg )
-- init =
--     ( { username = "" }
--     , Cmd.batch [ websocketOpen Config.ws ]
--     )


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( loginModel, _ ) =
            Login.init
    in
        ( Model key url Home loginModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- let
    --     _ =
    --         Debug.log "Update" ( msg, model )
    -- in
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LoginMgs loginMsg ->
            let
                ( updatedLoginModel, upstream ) =
                    Login.update loginMsg model.login
            in
                ( { model | login = updatedLoginModel }, Cmd.map LoginMgs upstream )

        LinkClicked urlRequest ->
            let
                _ =
                    Debug.log "LinkClicked" urlRequest
            in
                case urlRequest of
                    Browser.Internal url ->
                        ( model, Nav.pushUrl model.key (Url.toString url) )

                    Browser.External href ->
                        ( model, Nav.load href )

        UrlChanged url ->
            let
                _ =
                    Debug.log "UrlChanged" url
            in
                ( { model | url = url, currentView = Login }
                , Cmd.none
                )

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
-- view : Model -> Html Msg


view : Model -> Browser.Document Msg
view model =
    { title = "Charity Code - Helping Nonprofits find the development help they need!"
    , body =
        [ div []
            [ div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
            , div [ class "control" ]
                [ img [ src "static/images/qr_code.png" ] []
                , a [ href "/auth" ] []
                , h1 [] [ Html.text "Приложение в процессе разработки, приходите завтра." ]
                , eel model
                ]
            ]
        ]
    }


eel model =
    Element.layout []
        (myColOfStuff model)


myColOfStuff : Model -> Element Msg
myColOfStuff model =
    column [ centerX, centerY, spacing 36 ]
        [ myRowOfStuff
        , (Element.text "Вот над этой строкой мы сейчас усердно работаем...")
        , ChartSvg.chartView "Батарея" 80.0
        , Login.view model.login |> Element.map LoginMgs
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



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- Browser.element
--     { view = view
--     , init = \_ -> init
--     , update = update
--     , subscriptions = subscriptions
--     }


port websocketOpen : String -> Cmd msg


port websocketOpened : (Bool -> msg) -> Sub msg


port websocketIn : (String -> msg) -> Sub msg


port websocketOut : Encode.Value -> Cmd msg


port mapInit : String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ websocketOpened WebsocketOpened, websocketIn WebsocketIn ]
