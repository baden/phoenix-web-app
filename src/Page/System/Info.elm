module Page.System.Info exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)


view : String -> List (Html a)
view id =
    [ div []
        [ div [] [ text "Информация о системе" ]
        , div [] [ text <| "Id:" ++ id ]
        , a [ class "button", href "/" ] [ text "На главную" ]
        ]
    ]
