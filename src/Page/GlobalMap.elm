module Page.GlobalMap exposing (view, viewSystem)

import Html exposing (Html, div, img, a, h1)
import Html.Attributes exposing (class, src, href)
import Json.Encode as Encode


view : Html a
view =
    div []
        [ Html.node "leaflet-map" [] []
        , div [ class "control" ]
            [ a [ href "/login" ] [ Html.text "Выйти" ]

            -- , eel model
            ]
        ]


viewSystem : String -> Html a
viewSystem _ =
    div []
        [ --div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
          Html.node "leaflet-map" [] []
        , div [ class "control" ]
            [ a [ href "/login" ] [ Html.text "Выйти" ]

            -- , eel model
            ]
        ]
