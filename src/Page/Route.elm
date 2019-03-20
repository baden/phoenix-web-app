module Page.Route exposing (routeParser, Page(..))

import Url.Parser as Parser exposing (Parser, oneOf, s, string, map, top, (</>))


type Page
    = Home
    | User
    | GlobalMap
    | Config
    | SystemInfo String
    | SystemConfig String
    | BouncePage


routeParser : Parser (Page -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Home (s "home")
        , map User (s "user")
        , map GlobalMap (s "map")
        , map Config (s "config")
        , map SystemInfo (s "system" </> string)
        , map SystemConfig (s "system" </> string </> s "config")
        , map BouncePage (s "auth")
        , map BouncePage (s "logout")
        ]
