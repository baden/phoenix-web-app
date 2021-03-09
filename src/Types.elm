module Types exposing (..)

-- import Msg as MsgT exposing (..)
-- import Page.Home as Home

import API.Account exposing (AccountDocumentInfo, fixSysListRequest)
import API.System exposing (SystemDocumentInfo, SystemDocumentLog, SystemDocumentParams)
import AppState
import Browser
import Browser.Navigation as Nav
import Components.UI.Menu as Menu
import Dict exposing (Dict)
import Html exposing (Html)
import Page.GlobalMap as GlobalMap
import Page.Home.Types as Home
import Page.LinkSys as LinkSys
import Page.Login as Login
import Page.Route as Route
import Page.System.Config.Types as SystemConfigTypes
import Page.System.Info.Types as SystemInfoTypes
import Page.System.Logs as SystemLogs
import Time
import Url


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
    , menuModel : Menu.Model
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
    | OnCloseModal
    | TimeZoneDetected Time.Zone
    | ReceiveNow Time.Posix
    | ShowQrCode
    | HideQrCode
    | OnPageMsg PageMsg
    | BodyClick



-- | PageMsg Page Msg


type PageMsg
    = HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | SystemInfoMsg SystemInfoTypes.Msg
    | SystemConfigMsg SystemConfigTypes.Msg
    | SystemLogsMsg SystemLogs.Msg
    | GlobalMapMsg GlobalMap.Msg
    | LinkSysMsg LinkSys.Msg
    | MenuMsg Menu.Msg


type alias Flags =
    { token : Maybe String
    , api_url : String
    , language : String
    , theme : String
    }
