module Page.Home exposing (view)

import Html exposing (Html, h1, div, a, text)
import Html.Attributes exposing (class, href)


view : List (Html a)
view =
    [ div []
        [ h1 [] [ text "Феникс" ]
        , a [ class "button", href "/auth" ] [ text "Авторизация" ]
        , a [ class "button", href "/system/FOOBAR" ] [ text "Информация о трекере" ]
        ]
    ]
