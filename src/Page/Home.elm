module Page.Home exposing (view)

import Html exposing (Html, h1, text, i, p, a, button)
import Html.Attributes exposing (src, href, class)
import API
import API.Account exposing (AccountDocumentInfo)


-- import Element exposing (..)
-- import Element.Region as Region
-- import Element.Attributes exposing (class)

import Components.UI as UI


smsLink : String -> String -> Html a
smsLink phone body =
    Html.a [ href <| "sms:" ++ phone ++ "?body=" ++ body ] [ text "Отправить SMS" ]


view : Maybe AccountDocumentInfo -> Html a
view acc =
    UI.column12
        [ h1 [] [ text "Феникс" ]
        , i [ src "static/images/qr_code.png" ] []
        , auth_info acc
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



-- <div class="card-panel">
--     <span class="blue-text text-darken-2">This is a card panel with dark blue text</span>
--   </div>


auth_info : Maybe AccountDocumentInfo -> Html a
auth_info macc =
    Html.div [ class "card-panel" ]
        [ Html.span [ class "blue-text text-darken-2" ]
            (case macc of
                Nothing ->
                    [ text "Чтобы пользоваться сервисом, вы должны "
                    , a [ href "/login" ] [ text "авторизоваться" ]
                    , text " в системе."
                    , Html.div [ class "row" ]
                        [ Html.div [ class "col s4 offset-s4" ]
                            [ smsLink "+380677700200" "link" ]
                        ]
                    ]

                Just acc ->
                    [ p [] [ text <| "Вы авторизованы как " ++ acc.realname ]
                    , p [] [ text <| "У вас в списке наблюдения " ++ (String.fromInt <| List.length acc.systems) ++ " систем" ]
                    , p [] [ a [ href "/linksys" ] [ text "Добавить систему в список наблюдения" ] ]
                    ]
            )
        ]
