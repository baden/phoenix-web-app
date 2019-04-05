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
import API


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Route.Page
    , login : Login.Model
    , globalMap : GlobalMap.Model
    }


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | WebsocketIn String
    | OpenWebsocket String
    | WebsocketOpened Bool
    | LoginMsg Login.Msg
    | GlobalMapMsg GlobalMap.Msg


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( loginModel, _ ) =
            Login.init

        ( globalMapModel, _ ) =
            GlobalMap.init

        model =
            { key = key
            , url = url
            , page = Route.Home
            , login = loginModel
            , globalMap = globalMapModel
            }

        ( navedModel, navedCmd ) =
            update (UrlChanged url) model
    in
        ( navedModel
        , Cmd.batch
            [ -- Backend.fetchMe MeFetched
              navedCmd
            , API.websocketOpen Config.ws
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LoginMsg loginMsg ->
            let
                ( updatedLoginModel, upstream ) =
                    Login.update loginMsg model.login
            in
                ( { model | login = updatedLoginModel }, Cmd.map LoginMsg upstream )

        GlobalMapMsg globalMapMsg ->
            let
                ( updatedGlobalMapModel, upstream ) =
                    GlobalMap.update globalMapMsg model.globalMap
            in
                ( { model | globalMap = updatedGlobalMapModel }, Cmd.map GlobalMapMsg upstream )

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
            ( model, API.websocketOpen url )

        WebsocketOpened _ ->
            ( model
            , Cmd.batch
                [ API.websocketOut <|
                    API.authRequest "$TOKEN(TBD)"
                ]
            )


computeViewForPage : Model -> Model
computeViewForPage model =
    model



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
            Login.loginView model.login |> Html.map LoginMsg

        Route.Auth ->
            Login.authView model.login |> Html.map LoginMsg

        Route.SystemInfo id ->
            SystemInfo.view id

        Route.GlobalMap ->
            GlobalMap.view

        Route.SystemOnMap id_ ->
            GlobalMap.viewSystem model.globalMap |> Html.map GlobalMapMsg

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


port mapInit : String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ API.websocketOpened WebsocketOpened, API.websocketIn WebsocketIn ]
