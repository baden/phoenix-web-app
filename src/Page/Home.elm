module Page.Home exposing (view)

import Html exposing (Html, h1, text, i, p, a, button)
import Html.Attributes exposing (src, href, class)
import API
import API.Account exposing (AccountDocumentInfo)
import API.System exposing (SystemDocumentInfo)
import Dict exposing (Dict)
import Time


-- import Date
-- import Element exposing (..)
-- import Element.Region as Region
-- import Element.Attributes exposing (class)

import Components.UI as UI


smsLink : String -> String -> Html a
smsLink phone body =
    Html.a [ href <| "sms:" ++ phone ++ "?body=" ++ body ] [ text "Отправить SMS" ]


view : Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> Html a
view acc systems timeZone =
    UI.column12
        [ h1 [] [ text "Феникс" ]
        , Html.img [ src "static/images/fx.navi.cc.png", class "nomobile" ] []
        , auth_info acc systems timeZone
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


auth_info : Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> Html a
auth_info macc systems timeZone =
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
                    , systemList acc.systems systems timeZone
                    , p [] [ a [ href "/linksys" ] [ text "Добавить систему в список наблюдения" ] ]
                    ]
            )
        ]


systemList : List String -> Dict String SystemDocumentInfo -> Time.Zone -> Html a
systemList sysIds systems timeZone =
    Html.div [ class "row" ] (sysIds |> List.map (systemItem systems timeZone))


systemItem : Dict String SystemDocumentInfo -> Time.Zone -> String -> Html a
systemItem systems timeZone sysId =
    let
        card =
            case Dict.get sysId systems of
                Nothing ->
                    [ Html.p [] [ text "Данные по трекеру еще не получены" ] ]

                Just system ->
                    [ Html.div [ class "row" ]
                        [ Html.div [ class "col s2" ] [ text "ID:" ]
                        , Html.div [ class "col s10" ] [ text sysId ]
                        ]
                    , Html.div [ class "row" ]
                        [ Html.div [ class "col s2" ] [ text "Название:" ]
                        , Html.div [ class "col s10" ] [ text system.title ]
                        ]
                    , Html.div [ class "row" ]
                        [ Html.div [ class "col s2" ] [ text "Последная известная позиция:" ]
                        , Html.div [ class "col s10" ]
                            [ case system.lastPosition of
                                Nothing ->
                                    (text "неизвестно")

                                Just lastPosition ->
                                    (text <|
                                        (String.fromFloat lastPosition.lat)
                                            ++ ", "
                                            ++ (String.fromFloat lastPosition.lon)
                                            ++ "@"
                                            ++ (lastPosition.dt * 1000 |> Time.millisToPosix |> dateTimeFormat timeZone)
                                    )
                            ]
                        ]
                    ]
    in
        Html.div [ class "col s12 m4 l2" ]
            [ Html.div [ class "z-depth-2 shadow-demo" ] card ]


dateTimeFormat : Time.Zone -> Time.Posix -> String
dateTimeFormat timeZone time =
    let
        year =
            Time.toYear timeZone time |> String.fromInt

        month =
            Time.toMonth timeZone time |> toNumMonth

        day =
            Time.toDay timeZone time |> String.fromInt |> String.padLeft 2 '0'

        hour =
            Time.toHour timeZone time |> String.fromInt |> String.padLeft 2 '0'

        minute =
            Time.toMinute timeZone time |> String.fromInt |> String.padLeft 2 '0'

        second =
            Time.toSecond timeZone time |> String.fromInt |> String.padLeft 2 '0'
    in
        day ++ "/" ++ month ++ "/" ++ year ++ " " ++ hour ++ ":" ++ minute ++ ":" ++ second


toNumMonth : Time.Month -> String
toNumMonth month =
    case month of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"



-- <div class="row">
--           <div class="col s12 m4 l2">
--             <p class="z-depth-0 shadow-demo"></p>
--           </div>
--           <div class="col s12 m4 l2">
--             <p class="z-depth-1 shadow-demo"></p>
--           </div>
--           <div class="col s12 m4 l2">
--             <p class="z-depth-2 shadow-demo"></p>
--           </div>
--           <div class="col s12 m4 l2">
--             <p class="z-depth-3 shadow-demo"></p>
--           </div>
--           <div class="col s12 m4 l2">
--             <p class="z-depth-4 shadow-demo"></p>
--           </div>
--           <div class="col s12 m4 l2">
--             <p class="z-depth-5 shadow-demo"></p>
--           </div>
--         </div>
--
