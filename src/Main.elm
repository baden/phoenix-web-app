port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Config
import Url
import Url.Parser as Parser
import Page.Route as Route
import Html exposing (Html)
import Json.Encode as Encode
import Components.ChartSvg as ChartSvg
import Page.Home as Home
import Page.Login as Login
import Page.System.Info as SystemInfo
import Page.NotFound as NotFound
import Page.GlobalMap as GlobalMap


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Route.Page
    , login : Login.Model
    }


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

        model =
            { key = key
            , url = url
            , page = Route.Home
            , login = loginModel
            }

        ( navedModel, navedCmd ) =
            update (UrlChanged url) model
    in
        ( navedModel
        , Cmd.batch
            [ -- Backend.fetchMe MeFetched
              navedCmd
            , websocketOpen Config.ws
            ]
        )


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
            -- let
            --     _ =
            --         Debug.log "LinkClicked" urlRequest
            -- in
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            -- let
            --     _ =
            --         Debug.log "UrlChanged" url
            -- in
            case Parser.parse Route.routeParser url of
                -- Just Route.BouncePage ->
                --     ( model, Nav.load (Url.toString url) )
                Just page ->
                    ( { model | page = page }
                        |> computeViewForPage
                    , Cmd.none
                    )

                Nothing ->
                    -- 404 would be nice
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


computeViewForPage : Model -> Model
computeViewForPage model =
    model


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
    { title = "Fenix App"
    , body = [ viewPage model ]
    }


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        Route.Home ->
            Home.view

        Route.Login ->
            Login.loginView model.login |> Html.map LoginMgs

        Route.Auth ->
            Login.authView model.login |> Html.map LoginMgs

        Route.SystemInfo id ->
            SystemInfo.view id

        Route.GlobalMap ->
            GlobalMap.view

        _ ->
            NotFound.view



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


port websocketOpen : String -> Cmd msg


port websocketOpened : (Bool -> msg) -> Sub msg


port websocketIn : (String -> msg) -> Sub msg


port websocketOut : Encode.Value -> Cmd msg


port mapInit : String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ websocketOpened WebsocketOpened, websocketIn WebsocketIn ]
