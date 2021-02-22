module Components.UI.Theme exposing (..)

-- import Dict exposing (Dict)

import AssocList as Dict exposing (Dict)


type ThemeID
    = ThemeID String


type alias Theme =
    { selectedTheme : ThemeID
    }


type alias ThemeItem =
    { name : String
    , class_name : String
    }


type alias ThemeItems =
    Dict ThemeID ThemeItem


defaultThemes : Dict ThemeID ThemeItem
defaultThemes =
    Dict.fromList
        [ ( ThemeID "dark", ThemeItem "dark" "dark" )
        , ( ThemeID "light", ThemeItem "light" "light" )
        ]
