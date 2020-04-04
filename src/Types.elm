module Types exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Page.Route as Route
import Page.Home as Home
import Page.Login as Login
import Page.LinkSys as LinkSys
import API.Account exposing (AccountDocumentInfo, fixSysListRequest)
import API.System exposing (SystemDocumentInfo, SystemDocumentLog, SystemDocumentParams)
import AppState
import Page.GlobalMap as GlobalMap
import Page.System.Info.Types as SystemInfoTypes
import Dict exposing (Dict)
import Page.System.Config.Types as SystemConfigTypes
import Page.System.Logs as SystemLogs
import Msg as MsgT exposing (..)
import Html exposing (Html)
import Time


type ConnectionState
    = NotConnected
    | Connected


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
    , params : Dict String SystemDocumentParams
    , errorMessage : Maybe String -- Надо бы расширить функцилнал
    , appState : AppState.AppState
    , connectionState : ConnectionState
    , showQrCode : Bool
    }


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


type PageType pageModel pageMsg
    = PT_System (AppState.AppState -> pageModel -> SystemDocumentInfo -> Html pageMsg)
    | PT_SystemParams (AppState.AppState -> pageModel -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html pageMsg)
    | PT_Nodata (pageModel -> Html pageMsg)
    | PT_Full (AppState.AppState -> pageModel -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Html pageMsg)



-- | PT_SysLogs (AppState.AppState -> pageModel -> SystemDocumentInfo -> Maybe (List SystemDocumentLog) -> UI pageMsg)


type PageUpdateType pageModel pageMsg
    = PUT_Private (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg ))
    | PUT_Public (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg, Maybe UpMsg ))


type alias PageRec pageModel pageMsg =
    { get : Model -> pageModel
    , set : pageModel -> Model -> Model

    -- , update : pageMsg -> pageModel -> ( pageModel, Cmd pageMsg, Maybe UpMsg )
    , update : PageUpdateType pageModel pageMsg
    , view : PageType pageModel pageMsg
    , msg : pageMsg -> PageMsg
    }
