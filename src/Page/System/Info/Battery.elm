module Page.System.Info.Battery exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import API.System.Battery as Battery exposing (Battery)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Components.UI.Battery exposing (powerLevelClass)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events as HE
import Page.System.Info.Types exposing (..)
import Round
import Svg exposing (path, svg, text_)
import Svg.Attributes exposing (d, preserveAspectRatio, strokeDasharray, viewBox, x, y)
import Time
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.Предполагаемое время работы батареи" ]
        , div [ class "content" ]
            [ div [ class "content-item" ]
                [ div [ class "content-item-group" ] <|
                    case system.battery of
                        Nothing ->
                            [ text <| t "control.Информация будет доступна после выхода Феникса на связь." ]

                        Just battery ->
                            let
                                hiddenMode =
                                    div [ class "wait-mode" ]
                                        [ span [ class "mode-title" ]
                                            [ text <| t "control.Режим", text " ", span [ class "uppercase-txt" ] [ text <| t "Ожидание" ], text ": " ]
                                        , span [] [ text (Battery.expect_at_sleep capacity sleep) ]
                                        ]

                                trackingMode =
                                    div [ class "search-mode" ]
                                        [ span [ class "mode-title" ]
                                            [ text <| t "control.Режим", text " ", span [ class "uppercase-txt" ] [ text <| t "Поиск" ], text ": " ]
                                        , span [] [ text (Battery.expect_at_tracking capacity) ]
                                        ]

                                lifetime =
                                    (appState.now |> Time.posixToMillis) // 1000 - (battery.init_dt |> DT.toInt)

                                used =
                                    Battery.calculation battery.counters lifetime

                                percentage =
                                    100 * (battery.init_capacity - used) / battery.init_capacity

                                p_as_text =
                                    (percentage |> Round.round 1) ++ "%"

                                colour =
                                    powerLevelClass percentage

                                sleep =
                                    case system.params.sleep of
                                        Nothing ->
                                            120

                                        -- Значение по умолчанию
                                        Just sleepValue ->
                                            sleepValue

                                capacity =
                                    battery.init_capacity - used
                            in
                            [ div [ class "power-status" ]
                                [ span [ class "power" ]
                                    [ span [ class "power-top" ] []
                                    , span [ class "power-wr" ]
                                        [ span [ class "power-bg", class colour, attribute "style" ("height: " ++ height percentage) ]
                                            [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
                                                [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] [] ]
                                            ]
                                        ]
                                    ]
                                , div [ class "power-status-title", class colour ] [ text p_as_text ]
                                ]
                            , span [ class "details-mode" ] <|
                                case system.dynamic of
                                    Nothing ->
                                        [ hiddenMode, trackingMode ]

                                    Just dynamic ->
                                        if dynamic.state == Just System.Tracking then
                                            [ trackingMode, hiddenMode ]

                                        else
                                            [ hiddenMode, trackingMode ]
                            ]
                ]
            ]
        ]


height : Float -> String
height percentage =
    -- Из дизайна:
    -- 100 -> 80%
    -- 85 -> 90%
    -- 50 -> 70%
    -- 15 -> 30%
    -- Примерно можно так:
    -- 100 -> 110
    -- 0 -> 9
    ((percentage + 9) |> Round.round 0) ++ "%"
