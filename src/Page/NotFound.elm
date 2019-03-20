module Page.NotFound exposing (view)

import Html exposing (Html)
import Element exposing (..)


view : Html a
view =
    layout []
        (el [] (text "404. Page not found."))
