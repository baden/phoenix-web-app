module Msg exposing (..)

import Components.UI.Menu as Menu


type UpMsg
    = RemoveSystemFromList String
    | MenuMsg Menu.MenuMsg
    | HideTrack String
