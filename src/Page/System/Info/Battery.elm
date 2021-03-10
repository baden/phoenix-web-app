module Page.System.Info.Battery exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events as HE
import Page.System.Info.Types exposing (..)
import Svg exposing (path, svg, text_)
import Svg.Attributes exposing (d, preserveAspectRatio, strokeDasharray, viewBox, x, y)
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.Предполагаемое время работы батареи" ]
        , div [ class "content" ]
            [ div [ class "content-item" ]
                [ div [ class "content-item-group" ]
                    [ div [ class "power-status" ]
                        [ span [ class "power" ]
                            [ span [ class "power-top" ] []
                            , span [ class "power-wr" ]
                                [ span [ class "power-bg high", attribute "style" "height: 80%" ]
                                    [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
                                        [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] [] ]
                                    ]
                                ]
                            ]
                        , div [ class "power-status-title high" ] [ text "(TDP)85%" ]
                        ]
                    , span [ class "details-mode" ]
                        [ div [ class "wait-mode" ]
                            [ span [ class "mode-title" ]
                                [ text <| t "control.Режим"
                                , text " "
                                , span [ class "uppercase-txt" ]
                                    [ text <| t "Ожидание" ]
                                , text ":"
                                ]
                            , span [] [ text "(TDP)8 месяцев 17 дней" ]
                            ]
                        , div [ class "search-mode" ]
                            [ span [ class "mode-title" ]
                                [ text <| t "control.Режим"
                                , text " "
                                , span [ class "uppercase-txt" ]
                                    [ text <| t "Поиск" ]
                                , text ":"
                                ]
                            , span [] [ text "(TDP)8 месяцев 17 дней" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
