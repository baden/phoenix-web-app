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
import Page.LinkSys as LinkSys
import API
import API.Account exposing (AccountDocumentInfo)
import API.System exposing (SystemDocumentInfo)
import Dict exposing (Dict)
import Task
import Time


type alias Model =
    { token : Maybe String
    , api_url : Maybe String
    , key : Nav.Key
    , url : Url.Url
    , page : Route.Page
    , timeZone : Time.Zone
    , login : Login.Model
    , linkSys : LinkSys.Model
    , globalMap : GlobalMap.Model
    , account : Maybe AccountDocumentInfo
    , systems : Dict String SystemDocumentInfo
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
    | LinkSysMsg LinkSys.Msg
    | TimeZoneDetected Time.Zone


type alias Flags =
    { token : Maybe String
    , api_url : Maybe String
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( loginModel, _ ) =
            Login.init

        ( globalMapModel, _ ) =
            GlobalMap.init

        ( linkSysModel, _ ) =
            LinkSys.init

        model =
            { token = flags.token
            , api_url = flags.api_url
            , key = key
            , url = url
            , page = Route.Home
            , timeZone = Time.utc
            , login = loginModel
            , linkSys = linkSysModel
            , globalMap = globalMapModel
            , account = Nothing
            , systems = Dict.empty
            }

        ( navedModel, navedCmd ) =
            update (UrlChanged url) model
    in
        ( navedModel
        , Cmd.batch
            [ -- Backend.fetchMe MeFetched
              navedCmd

            -- , API.websocketOpen Config.ws
            , flags.api_url |> Maybe.withDefault Config.ws |> API.websocketOpen
            , Task.perform TimeZoneDetected Time.here
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

        LinkSysMsg linkSysMsg ->
            let
                ( updatedLinkSysModel, upstream ) =
                    LinkSys.update linkSysMsg model.linkSys
            in
                ( { model | linkSys = updatedLinkSysModel }, Cmd.map LinkSysMsg upstream )

        GlobalMapMsg globalMapMsg ->
            let
                ( updatedGlobalMapModel, upstream ) =
                    GlobalMap.update globalMapMsg model.globalMap
            in
                ( { model | globalMap = updatedGlobalMapModel }, Cmd.map GlobalMapMsg upstream )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            case Parser.parse Route.routeParser url of
                -- Just Route.BouncePage ->
                --     ( model, Nav.load (Url.toString url) )
                Just page ->
                    ( { model | page = page }
                        |> computeViewForPage page
                    , Cmd.none
                    )

                Nothing ->
                    -- 404 would be nice
                    ( model, Cmd.none )

        WebsocketIn message ->
            let
                res =
                    API.parsePayload message

                -- API.commandDecoder
            in
                case res of
                    Nothing ->
                        ( model, Cmd.none )

                    Just (API.Token token) ->
                        ( model
                        , Cmd.batch
                            [ saveToken token.value
                            , API.websocketOut <| API.authRequest token.value
                            ]
                        )

                    Just (API.Document (API.AccountDocument document)) ->
                        ( { model | account = Just document }
                        , Cmd.batch
                            [ Nav.pushUrl model.key "/"
                            ]
                        )

                    Just (API.Document (API.SystemDocument document)) ->
                        let
                            _ =
                                Debug.log "System: " document
                        in
                            ( { model | systems = Dict.insert document.id document model.systems }
                            , Cmd.none
                            )

                    Just command ->
                        let
                            _ =
                                Debug.log "???" command
                        in
                            ( model, Cmd.none )

        OpenWebsocket url ->
            ( model, API.websocketOpen url )

        WebsocketOpened _ ->
            let
                authCmd =
                    case model.token of
                        Nothing ->
                            Cmd.none

                        Just token ->
                            API.websocketOut <| API.authRequest token
            in
                ( model
                , Cmd.batch
                    [ authCmd ]
                )

        TimeZoneDetected zone ->
            ( { model | timeZone = zone }, Cmd.none )


computeViewForPage : Route.Page -> Model -> Model
computeViewForPage page model =
    case page of
        Route.LinkSys ->
            { model | linkSys = Tuple.first LinkSys.init }

        _ ->
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
            Home.view model.account model.systems model.timeZone

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

        Route.LinkSys ->
            LinkSys.view model.linkSys |> Html.map LinkSysMsg

        _ ->
            NotFound.view



---- PROGRAM ----


main : Program Flags Model Msg
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


port saveToken : String -> Cmd msg



-- port logger : String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ API.websocketOpened WebsocketOpened, API.websocketIn WebsocketIn ]
