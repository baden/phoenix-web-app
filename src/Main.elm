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
import API.Account exposing (AccountDocumentInfo, fixSysListRequest)
import API.System exposing (SystemDocumentInfo)
import API.Error exposing (errorMessageString)
import Dict exposing (Dict)
import Task
import Time
import Msg as MsgT
import List.Extra as ListExtra
import Components.UI as UI


type alias Model =
    { token : Maybe String
    , api_url : Maybe String
    , key : Nav.Key
    , url : Url.Url
    , page : Route.Page
    , timeZone : Time.Zone
    , home : Home.Model
    , login : Login.Model
    , linkSys : LinkSys.Model
    , info : SystemInfo.Model
    , globalMap : GlobalMap.Model
    , account : Maybe AccountDocumentInfo
    , systems : Dict String SystemDocumentInfo
    , errorMessage : Maybe String -- Надо бы расширить функцилнал
    }


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | WebsocketIn String
    | OpenWebsocket String
    | WebsocketOpened Bool
    | HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | SystemInfoMsg SystemInfo.Msg
    | GlobalMapMsg GlobalMap.Msg
    | LinkSysMsg LinkSys.Msg
    | TimeZoneDetected Time.Zone
    | OnCloseModal


type alias Flags =
    { token : Maybe String
    , api_url : Maybe String
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( homeModel, _ ) =
            Home.init

        ( loginModel, _ ) =
            Login.init

        ( globalMapModel, _ ) =
            GlobalMap.init

        ( linkSysModel, _ ) =
            LinkSys.init

        ( infoModel, _ ) =
            SystemInfo.init

        model =
            { token = flags.token
            , api_url = flags.api_url
            , key = key
            , url = url
            , page = Route.Home
            , timeZone = Time.utc
            , home = homeModel
            , login = loginModel
            , linkSys = linkSysModel
            , info = infoModel
            , globalMap = globalMapModel
            , account = Nothing
            , systems = Dict.empty
            , errorMessage = Nothing
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


upmessageUpdate : Maybe MsgT.UpMsg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
upmessageUpdate msg ( model, cmd ) =
    case msg of
        Nothing ->
            ( model, Cmd.none )

        Just (MsgT.RemoveSystemFromList index) ->
            case model.account of
                Nothing ->
                    ( model, Cmd.none )

                Just account ->
                    let
                        newSysList =
                            account.systems |> ListExtra.removeAt index
                    in
                        ( model, Cmd.batch [ API.websocketOut <| fixSysListRequest newSysList ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        HomeMsg homeMsg ->
            let
                ( updatedHomeModel, upstream, upmessage ) =
                    Home.update homeMsg model.home
            in
                -- TODO: Move to UP
                ( { model | home = updatedHomeModel }, Cmd.map HomeMsg upstream )
                    |> upmessageUpdate upmessage

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

        SystemInfoMsg globalInfoMsg ->
            let
                ( updatedInfoModel, upstream ) =
                    SystemInfo.update globalInfoMsg model.info
            in
                ( { model | info = updatedInfoModel }, Cmd.map SystemInfoMsg upstream )

        LinkClicked urlRequest ->
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
                        let
                            _ =
                                Debug.log "Account" ( model.page, document )

                            next =
                                case model.page of
                                    Route.Login ->
                                        Cmd.batch [ Nav.pushUrl model.key "/" ]

                                    _ ->
                                        Cmd.none
                        in
                            ( { model | account = Just document }
                            , next
                            )

                    Just (API.Document (API.SystemDocument document)) ->
                        ( { model | systems = Dict.insert document.id document model.systems }
                        , Cmd.none
                        )

                    Just (API.Error error) ->
                        case errorMessageString error of
                            Nothing ->
                                ( model, Cmd.none )

                            Just astext ->
                                -- Не самое элегантное решение
                                ( { model | errorMessage = Just astext }, Cmd.none )

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

        OnCloseModal ->
            ( { model | errorMessage = Nothing }, Cmd.none )


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
    let
        modal =
            case model.errorMessage of
                Nothing ->
                    []

                Just errorText ->
                    [ UI.modal
                        "Ошибка"
                        [ UI.ModalText errorText
                        ]
                        [ UI.cmdButton "Закрыть" (OnCloseModal)
                        ]
                    , UI.modal_overlay OnCloseModal
                    ]
    in
        { title = "Fenix App"
        , body = [ viewPage model ] ++ modal
        }


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        Route.Home ->
            Home.view model.home model.account model.systems model.timeZone |> Html.map HomeMsg

        Route.Login ->
            Login.loginView model.login |> Html.map LoginMsg

        Route.Auth ->
            Login.authView model.login |> Html.map LoginMsg

        Route.SystemInfo sysId ->
            case Dict.get sysId model.systems of
                Nothing ->
                    Html.div [] [ Html.text "Ошибка! Система не существует или у вас недостаточно прав для просмотра." ]

                Just system ->
                    SystemInfo.view model.info system |> Html.map SystemInfoMsg

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
