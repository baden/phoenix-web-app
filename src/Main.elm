port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser as Parser
import Page
import Page.Route as Route
import Html exposing (Html)
import Html.Attributes as HA
import Json.Encode as Encode
import Components.ChartSvg as ChartSvg
import Page.Home as Home
import Page.Login as Login
import Page.System.Info as SystemInfo
import Page.System.Info.Types as SystemInfoTypes
import Page.System.Config as SystemConfig
import Page.System.Logs as SystemLogs
import Page.System.Config.Types as SystemConfigTypes
import Page.NotFound as NotFound
import Page.GlobalMap as GlobalMap
import Page.LinkSys as LinkSys
import API
import API.Account exposing (AccountDocumentInfo, fixSysListRequest)
import API.System exposing (SystemDocumentInfo, SystemDocumentLog)
import API.Error exposing (errorMessageString)
import Dict exposing (Dict)
import Task
import Time
import Msg exposing (..)


-- exposing (Month(..))

import Msg as MsgT
import List.Extra as ListExtra
import Components.UI as UI


-- import Date exposing (Date, Interval(..), Unit(..))

import AppState


type alias Model =
    { token : Maybe String
    , api_url : String
    , key : Nav.Key
    , url : Url.Url
    , page : Route.Page
    , home : Home.Model
    , login : Login.Model
    , linkSys : LinkSys.Model
    , info : SystemInfoTypes.Model
    , systemConfig : SystemConfigTypes.Model
    , systemLogs : SystemLogs.Model
    , globalMap : GlobalMap.Model
    , account : Maybe AccountDocumentInfo
    , systems : Dict String SystemDocumentInfo
    , logs : Dict String (List SystemDocumentLog)
    , errorMessage : Maybe String -- Надо бы расширить функцилнал
    , appState : AppState.AppState
    , connectionState : ConnectionState
    , showQrCode : Bool
    }


type ConnectionState
    = NotConnected
    | Connected


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | WebsocketIn String
    | OpenWebsocket String
    | WebsocketOpened Bool
      -- | HomeMsg Home.Msg
      -- | LoginMsg Login.Msg
      -- | SystemInfoMsg SystemInfoTypes.Msg
      -- | GlobalMapMsg GlobalMap.Msg
      -- | LinkSysMsg LinkSys.Msg
    | OnCloseModal
    | TimeZoneDetected Time.Zone
    | ReceiveNow Time.Posix
    | ShowQrCode
    | HideQrCode
    | OnPageMsg PageMsg



-- | PageMsg Page Msg


type PageMsg
    = HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | SystemInfoMsg SystemInfoTypes.Msg
    | SystemConfigMsg SystemConfigTypes.Msg
    | SystemLogsMsg SystemLogs.Msg
    | GlobalMapMsg GlobalMap.Msg
    | LinkSysMsg LinkSys.Msg


type alias Flags =
    { token : Maybe String
    , api_url : String
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

        ( systemConfigModel, _ ) =
            SystemConfig.init

        ( systemLogsModel, _ ) =
            SystemLogs.init

        model =
            { token = flags.token
            , api_url = flags.api_url
            , key = key
            , url = url
            , page = Route.Home
            , home = homeModel
            , login = loginModel
            , linkSys = linkSysModel
            , info = infoModel
            , systemConfig = systemConfigModel
            , systemLogs = systemLogsModel
            , globalMap = globalMapModel
            , account = Nothing
            , systems = Dict.empty
            , logs = Dict.empty
            , errorMessage = Nothing
            , appState = AppState.initModel
            , connectionState = NotConnected
            , showQrCode = False
            }

        ( navedModel, navedCmd ) =
            update (UrlChanged url) model
    in
        ( navedModel
        , Cmd.batch <|
            [ -- Backend.fetchMe MeFetched
              navedCmd

            -- , API.websocketOpen Config.ws
            -- , flags.api_url |> Maybe.withDefault Config.ws |> API.websocketOpen
            , API.websocketOpen flags.api_url

            -- , Task.perform TimeZoneDetected Time.here
            -- , Date.today |> Task.perform ReceiveDate
            ]
                ++ (AppState.initCmd TimeZoneDetected ReceiveNow)
        )


upmessageUpdate : Maybe MsgT.UpMsg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
upmessageUpdate msg ( model, cmd ) =
    case msg of
        Nothing ->
            ( model, cmd )

        Just (MsgT.RemoveSystemFromList sid) ->
            case model.account of
                Nothing ->
                    ( model, cmd )

                Just account ->
                    let
                        newSysList =
                            account.systems |> ListExtra.remove sid

                        -- newSysList =
                        --     account.systems |> ListExtra.removeAt index
                    in
                        ( model, Cmd.batch [ cmd, API.websocketOut <| fixSysListRequest newSysList ] )



-- ( model, Cmd.none )
-- updatePage :


type alias PageRec pageModel pageMsg =
    { get : Model -> pageModel
    , set : pageModel -> Model -> Model
    , update : pageMsg -> pageModel -> ( pageModel, Cmd pageMsg, Maybe UpMsg )
    , view : AppState.AppState -> pageModel -> SystemDocumentInfo -> Html pageMsg

    -- , view : AppState.AppState -> pageModel -> Page.ViewInfo -> Html pageMsg
    , msg : pageMsg -> PageMsg
    }


systemInfoRec : PageRec SystemInfoTypes.Model SystemInfoTypes.Msg
systemInfoRec =
    { get = .info
    , set = \newModel model -> { model | info = newModel }
    , update = SystemInfo.update
    , view = SystemInfo.view
    , msg = SystemInfoMsg
    }


systemConfigRec : PageRec SystemConfigTypes.Model SystemConfigTypes.Msg
systemConfigRec =
    { get = .systemConfig
    , set = \newModel model -> { model | systemConfig = newModel }
    , update = SystemConfig.update
    , view = SystemConfig.view
    , msg = SystemConfigMsg
    }



-- systemLogsRec : PageRec SystemLogs.Model SystemLogs.Msg
-- systemLogsRec =
--     { get = .systemLogs
--     , set = \newModel model -> { model | systemLogs = newModel }
--     , update = SystemLogs.update
--     , view = SystemLogs.view
--     , msg = SystemLogsMsg
--     }


systemOnMapRec : PageRec GlobalMap.Model GlobalMap.Msg
systemOnMapRec =
    { get = .globalMap
    , set = \newModel model -> { model | globalMap = newModel }
    , update = GlobalMap.update
    , view = GlobalMap.viewSystem
    , msg = GlobalMapMsg
    }


updatePage : PageMsg -> Model -> ( Model, Cmd Msg )
updatePage pageMsg model =
    case pageMsg of
        HomeMsg homeMsg ->
            let
                ( updatedHomeModel, upstream, upmessage ) =
                    Home.update homeMsg model.home
            in
                -- TODO: Move to UP
                ( { model | home = updatedHomeModel }, Cmd.map (HomeMsg >> OnPageMsg) upstream )
                    |> upmessageUpdate upmessage

        LoginMsg loginMsg ->
            let
                ( updatedLoginModel, upstream ) =
                    Login.update loginMsg model.login
            in
                ( { model | login = updatedLoginModel }, Cmd.map (LoginMsg >> OnPageMsg) upstream )

        LinkSysMsg linkSysMsg ->
            let
                ( updatedLinkSysModel, upstream ) =
                    LinkSys.update linkSysMsg model.linkSys
            in
                ( { model | linkSys = updatedLinkSysModel }, Cmd.map (LinkSysMsg >> OnPageMsg) upstream )

        GlobalMapMsg globalMapMsg ->
            updateOverRec globalMapMsg systemOnMapRec model

        SystemInfoMsg globalInfoMsg ->
            updateOverRec globalInfoMsg systemInfoRec model

        SystemConfigMsg msg ->
            updateOverRec msg systemConfigRec model

        SystemLogsMsg msg ->
            let
                ( updatedModel, upstream, upmessage ) =
                    SystemLogs.update msg (model.systemLogs)
            in
                ( ({ model | systemLogs = updatedModel }), Cmd.map (SystemLogsMsg >> OnPageMsg) upstream )
                    |> upmessageUpdate upmessage



--     updateOverRec msg systemLogsRec model


updateOverRec msg rec model =
    let
        ( updatedModel, upstream, upmessage ) =
            rec.update msg (rec.get model)
    in
        ( (rec.set updatedModel model), Cmd.map (rec.msg >> OnPageMsg) upstream )
            |> upmessageUpdate upmessage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnPageMsg pageMsg ->
            updatePage pageMsg model

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
            let
                setModel4Page page oldModel =
                    { oldModel | page = page } |> computeViewForPage page

                -- _ =
                --     Debug.log "UrlChanged" url
            in
                case Parser.parse Route.routeParser url of
                    Just page ->
                        ( setModel4Page page model, Cmd.none )

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

                    Just (API.Document _ (API.AccountDocument document)) ->
                        let
                            -- _ =
                            --     Debug.log "Account" ( model.page, document )
                            leaveIfmember sid =
                                if document.systems |> List.member sid then
                                    Cmd.none
                                else
                                    Cmd.batch [ Nav.pushUrl model.key "/" ]

                            next =
                                case model.page of
                                    Route.Login ->
                                        Cmd.batch [ Nav.pushUrl model.key "/" ]

                                    Route.LinkSys ->
                                        Cmd.batch [ Nav.pushUrl model.key "/" ]

                                    Route.SystemConfig sid ->
                                        leaveIfmember sid

                                    Route.SystemInfo sid ->
                                        leaveIfmember sid

                                    Route.SystemOnMap sid ->
                                        leaveIfmember sid

                                    _ ->
                                        Cmd.none
                        in
                            ( { model | account = Just document }
                            , next
                            )

                    Just (API.Document sysId (API.SystemDocument document)) ->
                        ( { model | systems = Dict.insert sysId document model.systems }
                        , Cmd.none
                        )

                    Just (API.Document sysId (API.SystemDocumentDynamic document)) ->
                        case Dict.get sysId model.systems of
                            Nothing ->
                                ( model, Cmd.none )

                            Just system ->
                                let
                                    new_system =
                                        { system | dynamic = Just document }
                                in
                                    ( { model | systems = Dict.insert sysId new_system model.systems }, Cmd.none )

                    Just (API.Document sysId (API.SystemLogsDocument document)) ->
                        -- let
                        --     _ =
                        --         Debug.log "logs" document
                        -- in
                        ( { model | logs = Dict.insert sysId document model.logs }
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
                        -- let
                        --     _ =
                        --         Debug.log "???" command
                        -- in
                        ( model, Cmd.none )

        OpenWebsocket url ->
            ( model, API.websocketOpen url )

        WebsocketOpened False ->
            ( { model | connectionState = NotConnected }, Cmd.none )

        WebsocketOpened True ->
            let
                authCmd =
                    case model.token of
                        Nothing ->
                            Cmd.none

                        Just token ->
                            API.websocketOut <| API.authRequest token
            in
                ( { model | connectionState = Connected }
                , Cmd.batch
                    [ authCmd ]
                )

        OnCloseModal ->
            ( { model | errorMessage = Nothing }, Cmd.none )

        TimeZoneDetected zone ->
            ( { model | appState = model.appState |> AppState.updateTimeZone zone }, Cmd.none )

        ReceiveNow time ->
            ( { model | appState = model.appState |> AppState.updateNow time }, Cmd.none )

        ShowQrCode ->
            ( { model | showQrCode = not model.showQrCode }, Cmd.none )

        HideQrCode ->
            ( { model | showQrCode = False }, Cmd.none )


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

        connection =
            case model.connectionState of
                Connected ->
                    []

                NotConnected ->
                    UI.connectionWidwet
    in
        { title = "Fenix App"
        , body = (viewHeader model) ++ [ viewPage model ] ++ modal ++ connection
        }


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        Route.Home ->
            Home.view model.appState model.home model.account model.systems |> Html.map (HomeMsg >> OnPageMsg)

        Route.Login ->
            Login.loginView model.login |> Html.map (LoginMsg >> OnPageMsg)

        Route.Auth ->
            Login.authView model.login |> Html.map (LoginMsg >> OnPageMsg)

        Route.SystemInfo sysId ->
            view4SystemRec sysId model systemInfoRec

        Route.SystemConfig sysId ->
            view4SystemRec sysId model systemConfigRec

        Route.SystemLogs sysId ->
            case Dict.get sysId model.systems of
                Nothing ->
                    Html.div []
                        [ Html.text "Ошибка! Система не существует или у вас недостаточно прав для просмотра."
                        , Html.a [ HA.class "btn", HA.href "/" ] [ Html.text "Вернуться на главную" ]
                        ]

                Just system ->
                    let
                        logs =
                            Dict.get sysId model.logs
                    in
                        SystemLogs.view model.appState model.systemLogs system logs |> Html.map (SystemLogsMsg >> OnPageMsg)

        Route.GlobalMap ->
            GlobalMap.view

        Route.SystemOnMap sysId ->
            view4SystemRec sysId model systemOnMapRec

        Route.LinkSys ->
            LinkSys.view model.linkSys |> Html.map (LinkSysMsg >> OnPageMsg)

        _ ->
            NotFound.view


view4SystemRec : String -> Model -> PageRec smodel smsg -> Html Msg
view4SystemRec sysId model ir =
    view4System sysId model (ir.view model.appState (ir.get model) >> Html.map (ir.msg >> OnPageMsg))


view4System : String -> Model -> (SystemDocumentInfo -> Html Msg) -> Html Msg
view4System sysId model pageView =
    case Dict.get sysId model.systems of
        Nothing ->
            Html.div []
                [ Html.text "Ошибка! Система не существует или у вас недостаточно прав для просмотра."
                , Html.a [ HA.class "btn", HA.href "/" ] [ Html.text "Вернуться на главную" ]
                ]

        Just system ->
            pageView system



-- SystemInfo.view model.appState model.info system |> Html.map SystemInfoMsg


viewHeader : Model -> List (Html Msg)
viewHeader model =
    case model.page of
        Route.Home ->
            UI.header model.showQrCode ShowQrCode HideQrCode

        _ ->
            []



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
    Sub.batch
        [ API.websocketOpened WebsocketOpened
        , API.websocketIn WebsocketIn
        , Time.every (1000.0) ReceiveNow
        ]
