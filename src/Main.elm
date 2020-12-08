port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Types exposing (Model, ConnectionState(..), Msg(..), Flags, PageMsg(..))
import Types.Page exposing (PageRec, PageType(..), PageUpdateType(..), updateOverRec, upmessageUpdate)
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
import API.System exposing (SystemDocumentInfo, SystemDocumentLog, SystemDocumentParams)
import API.Error exposing (errorMessageString)
import Dict exposing (Dict)
import Task
import Time
import Msg as MsgT exposing (..)
import List.Extra as ListExtra
import Components.UI as UI
import AppState


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
            SystemConfig.init Nothing

        ( systemLogsModel, _ ) =
            SystemLogs.init Nothing

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
            , params = Dict.empty
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



-- ( model, Cmd.none )
-- updatePage :


systemInfoRec : PageRec SystemInfoTypes.Model SystemInfoTypes.Msg Model Msg
systemInfoRec =
    { get = .info
    , set = \newModel model -> { model | info = newModel }
    , update = PUT_Public SystemInfo.update
    , view = PT_System SystemInfo.view
    , msg = SystemInfoMsg >> OnPageMsg
    }


systemConfigRec : PageRec SystemConfigTypes.Model SystemConfigTypes.Msg Model Msg
systemConfigRec =
    { get = .systemConfig
    , set = \newModel model -> { model | systemConfig = newModel }
    , update = PUT_Public SystemConfig.update
    , view = PT_SystemParams SystemConfig.view

    -- , view = PT_System SystemConfig.view
    , msg = SystemConfigMsg >> OnPageMsg
    }



-- systemLogsRec : PageRec SystemLogs.Model SystemLogs.Msg Model Msg
-- systemLogsRec =
--     { get = .systemLogs
--     , set = \newModel model -> { model | systemLogs = newModel }
--     , update = PUT_Public SystemLogs.update
--     , view = PT_SystemParams SystemLogs.view
--
--     -- , view = PT_System SystemConfig.view
--     , msg = SystemLogsMsg >> OnPageMsg
--     }


linkSysRec : PageRec LinkSys.Model LinkSys.Msg Model Msg
linkSysRec =
    { get = .linkSys
    , set = \newModel model -> { model | linkSys = newModel }
    , update = PUT_Private LinkSys.update
    , view = PT_Nodata LinkSys.view
    , msg = LinkSysMsg >> OnPageMsg
    }


homeRec : PageRec Home.Model Home.Msg Model Msg
homeRec =
    { get = .home
    , set = \newModel model -> { model | home = newModel }
    , update = PUT_Public Home.update
    , view = PT_Full Home.view
    , msg = HomeMsg >> OnPageMsg
    }


loginRec : PageRec Login.Model Login.Msg Model Msg
loginRec =
    { get = .login
    , set = \newModel model -> { model | login = newModel }
    , update = PUT_Private Login.update
    , view = PT_Nodata Login.loginView
    , msg = LoginMsg >> OnPageMsg
    }


authRec : PageRec Login.Model Login.Msg Model Msg
authRec =
    { loginRec | view = PT_Nodata Login.authView }



-- { get = .login
-- , set = \newModel model -> { model | login = newModel }
-- , update = loginRec.update
-- , view = PT_Nodata Login.authView
-- , msg = loginRec.msg
-- }
-- systemLogsRec : PageRec SystemLogs.Model SystemLogs.Msg
-- systemLogsRec =
--     { get = .systemLogs
--     , set = \newModel model -> { model | systemLogs = newModel }
--     , update = SystemLogs.update
--     , view = SystemLogs.view
--     , msg = SystemLogsMsg
--     }


systemOnMapRec : PageRec GlobalMap.Model GlobalMap.Msg Model Msg
systemOnMapRec =
    { get = .globalMap
    , set = \newModel model -> { model | globalMap = newModel }
    , update = PUT_Public GlobalMap.update
    , view = PT_System GlobalMap.viewSystem
    , msg = GlobalMapMsg >> OnPageMsg
    }


updatePage : PageMsg -> Model -> ( Model, Cmd Msg )
updatePage pageMsg model =
    case pageMsg of
        HomeMsg homeMsg ->
            updateOverRec homeMsg homeRec model

        LoginMsg loginMsg ->
            -- TODO: Тут на самом деле и loginRec и authRec
            updateOverRec loginMsg loginRec model

        LinkSysMsg smsg ->
            updateOverRec smsg linkSysRec model

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



-- upmessageUpdate : Maybe UpMsg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
-- upmessageUpdate msg ( model, cmd ) =
--     case msg of
--         Nothing ->
--             ( model, cmd )
--
--         Just (MsgT.RemoveSystemFromList sid) ->
--             case model.account of
--                 Nothing ->
--                     ( model, cmd )
--
--                 Just account ->
--                     let
--                         newSysList =
--                             account.systems |> ListExtra.remove sid
--                     in
--                         ( model, Cmd.batch [ cmd, API.websocketOut <| fixSysListRequest newSysList ] )


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
            case Parser.parse Route.routeParser url of
                Just page ->
                    let
                        updateModel =
                            { model | page = page }
                    in
                        computeViewForPage page updateModel

                -- ( setModel4Page page model, Cmd.none )
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

                    Just (API.Document sysId (API.SystemParamsDocument document)) ->
                        -- let
                        --     _ =
                        --         Debug.log "params" document
                        -- in
                        ( { model | params = Dict.insert sysId document model.params }
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


computeViewForPage : Route.Page -> Model -> ( Model, Cmd Msg )
computeViewForPage page model =
    case page of
        Route.LinkSys ->
            let
                ( init_model, init_cmd ) =
                    LinkSys.init
            in
                ( { model | linkSys = init_model }, Cmd.none )

        Route.SystemConfig s ->
            let
                --TOTO: systemConfigRec.init
                ( init_model, init_cmd ) =
                    SystemConfig.init (Just s)
            in
                ( { model | systemConfig = init_model }, Cmd.map (SystemConfigMsg >> OnPageMsg) init_cmd )

        Route.SystemLogs s ->
            let
                --TOTO: systemConfigRec.init
                ( init_model, init_cmd ) =
                    SystemLogs.init (Just s)
            in
                ( { model | systemLogs = init_model }, Cmd.map (SystemLogsMsg >> OnPageMsg) init_cmd )

        _ ->
            ( model, Cmd.none )



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



-- TODO: Тут бы провести глобальную унификацию!


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        Route.Home ->
            view4SystemRec "" model homeRec

        -- Home.view model.appState model.home model.account model.systems |> Html.map (HomeMsg >> OnPageMsg)
        Route.Login ->
            view4SystemRec "" model loginRec

        -- Login.loginView model.login |> Html.map (LoginMsg >> OnPageMsg)
        Route.Auth ->
            view4SystemRec "" model authRec

        -- Login.authView model.login |> Html.map (LoginMsg >> OnPageMsg)
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
            view4SystemRec "" model linkSysRec

        -- Route.LinkSys ->
        --     LinkSys.view model.linkSys |> Html.map (LinkSysMsg >> OnPageMsg)
        _ ->
            NotFound.view


view4SystemRec : String -> Model -> PageRec smodel smsg Model Msg -> Html Msg
view4SystemRec sysId model ir =
    case ir.view of
        PT_System v ->
            view4System sysId model (v model.appState (ir.get model) >> Html.map ir.msg)

        PT_SystemParams v ->
            case Dict.get sysId model.systems of
                Nothing ->
                    (Html.div [] [ Html.text "Error" ]) |> Html.map ir.msg

                Just system ->
                    (v model.appState (ir.get model) system (model.params |> Dict.get sysId)) |> Html.map ir.msg

        -- view4SystemParams sysId model (v model.appState (ir.get model) >> Html.map (ir.msg >> OnPageMsg))
        PT_Nodata v ->
            v (ir.get model) |> Html.map ir.msg

        PT_Full v ->
            v model.appState (ir.get model) model.account model.systems |> Html.map ir.msg


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


view4SystemParams : String -> Model -> (SystemDocumentInfo -> Maybe SystemDocumentParams -> Html Msg) -> Html Msg
view4SystemParams sysId model pageView =
    case Dict.get sysId model.systems of
        Nothing ->
            Html.div []
                [ Html.text "Ошибка! Система не существует или у вас недостаточно прав для просмотра."
                , Html.a [ HA.class "btn", HA.href "/" ] [ Html.text "Вернуться на главную" ]
                ]

        Just system ->
            pageView system Nothing



--(model.params |> Dict.get sysId)
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
