module Page.GlobalMap exposing (view)

import Html exposing (Html, div, img, a, h1)
import Html.Attributes exposing (class, src, href)
import Json.Encode as Encode


view : Html a
view =
    div []
        [ div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
        , div [ class "control" ]
            [ a [ href "/login" ] [ Html.text "Выйти" ]

            -- , eel model
            ]
        ]
