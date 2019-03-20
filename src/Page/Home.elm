module Page.Home exposing (view)

import Html exposing (Html)


-- import Html.Attributes exposing (class, href)

import Element exposing (..)
import Element.Region as Region


-- import Element.Attributes exposing (class)

import Components.UI as UI


view : Html a
view =
    Element.layout [] <|
        column [ centerX, width fill ]
            [ el [ Region.heading 1 ] (text "Феникс")
            , image [] { src = "static/images/qr_code.png", description = "Отсканируйте код на мобильном устройстве" }
            , paragraph [] [ text "Чтобы пользоваться сервисом, вы должны авторизоваться в системе." ]
            , column [ centerX, width fill ]
                [ UI.button "/login" "Авторизация"
                , UI.button "/auth" "Новый пользователь"
                , UI.button "/map" "Карта"
                ]
            , link
                [--class "waves-effect waves-light btn"
                ]
                { url = "/system/FOOBAR"
                , label = Element.text "Информация о трекере"
                }

            -- [ class "waves-effect waves-light btn", href "/system/FOOBAR" ]
            -- [ i [ class "material-icons left" ] [ text "cloud" ]
            -- , text "Информация о трекере"
            -- ]
            ]
