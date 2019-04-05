module Page.Home exposing (view)

import Html exposing (Html, h1, text, i, p, a, button)
import Html.Attributes exposing (src, href, class)


-- import Element exposing (..)
-- import Element.Region as Region
-- import Element.Attributes exposing (class)

import Components.UI as UI


view : Html a
view =
    UI.column12
        [ h1 [] [ text "Феникс" ]
        , i [ src "static/images/qr_code.png" ] []
        , p [] [ text "Чтобы пользоваться сервисом, вы должны авторизоваться в системе." ]
        , UI.button "/login" "Авторизация"
        , UI.button "/map" "Карта"
        , a
            [ class "waves-effect waves-light btn"
            , href "/system/FOOBAR"
            ]
            [ text "Информация о трекере" ]
        , button [ class "waves-effect waves-light btn" ]
            [ text "Просто кнопка" ]

        -- [ class "waves-effect waves-light btn", href "/system/FOOBAR" ]
        -- [ i [ class "material-icons left" ] [ text "cloud" ]
        -- , text "Информация о трекере"
        -- ]
        ]
