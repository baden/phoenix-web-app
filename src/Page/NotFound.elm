module Page.NotFound exposing (view)

import Html exposing (Html, div, text)


view : Html a
view =
    div []
        [ text "404. Page not found." ]
