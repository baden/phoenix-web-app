module Page.Route exposing (Page(..), PageBase(..), routeParser)

import Url.Parser as Parser exposing ((</>), (<?>), Parser, map, oneOf, s, string, top)
import Url.Parser.Query as Query


type alias SysId =
    String


type Page
    = Home
    | Auth
    | Login
    | User
    | Properties
    | GlobalMap
    | SystemOnMap SysId (Maybe String) (Maybe String) (Maybe String)
    | Config
    | SystemInfo String
    | SystemConfig String
    | SystemLogs String
    | BouncePage
    | LinkSys


type PageBase
    = HomeBase
    | MapBase
    | SystemInfoBase
    | SystemLogsBase
    | SystemConfigBase


routeParser : Parser (Page -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Home (s "home")
        , map User (s "user")
        , map Properties (s "properties")
        , map GlobalMap (s "map")
        , map SystemOnMap (s "map" </> string <?> Query.string "lat" <?> Query.string "lng" <?> Query.string "day")
        , map Config (s "config")
        , map SystemInfo (s "system" </> string)
        , map SystemConfig (s "system" </> string </> s "config")
        , map SystemLogs (s "system" </> string </> s "logs")
        , map Auth (s "auth")
        , map Login (s "login")
        , map BouncePage (s "logout")
        , map LinkSys (s "linksys")
        ]
