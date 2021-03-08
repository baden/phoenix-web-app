module Page.System.Config.Battery exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo, SystemDocumentParams)
import AppState exposing (AppState)
import Html exposing (Html, a, br, button, div, input, label, span, text)
import Html.Attributes as HA exposing (attribute, class, href, name, type_, value)
import Html.Events exposing (onClick)
import Page.System.Config.Types exposing (Model, Msg(..))
import Svg exposing (Svg, path, svg)
import Svg.Attributes exposing (d, viewBox)


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html Msg
view ({ t } as appState) model system mparams =
    div [ class "wrapper-content wrapper-page" ]
        [ div [ class "details-wrapper-bg" ]
            [ div [ class "details-header" ] [ div [ class "details-title" ] [ text <| t "config.Обслуживание батареи" ] ]
            , div [ class "details-items" ]
                [ div [ class "details-item" ]
                    [ div [ class "title" ] [ text <| t "config.Предполагаемое время", br [] [], text <| t "config.работы батареи" ]
                    , div [ class "setting-item-wr" ]
                        [ div [ class "content-item-group" ]
                            [ div [ class "power-status" ]
                                [ span [ class "power" ]
                                    [ span [ class "power-top" ] []
                                    , span [ class "power-wr" ]
                                        [ span [ class "power-bg high", attribute "style" "height: 80%" ]
                                            [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
                                                [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
                                                ]
                                            ]
                                        ]
                                    ]
                                , div [ class "power-status-title high" ] [ text "(TBD)85%" ]
                                ]
                            , span [ class "details-mode" ]
                                [ div [ class "wait-mode" ]
                                    [ span [ class "mode-title" ] [ text <| t "Режим", text " ", span [ class "uppercase-txt" ] [ text <| t "Ожидание" ], text ":" ]
                                    , span [] [ text "(TBD)8 месяцев 17 дней" ]
                                    ]
                                , div [ class "search-mode" ]
                                    [ span [ class "mode-title" ] [ text <| t "Режим", text " ", span [ class "uppercase-txt" ] [ text <| t "Поиск" ], text ":" ]
                                    , span [] [ text "(TBD)8 месяцев 17 дней" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "details-item" ]
                    [ div [ class "title" ] [ text <| t "config.Статистика работы", text ":" ]
                    , div [ class "setting-item-wr" ]
                        [ div [ class "setting-item" ]
                            [ div [ class "content-item" ]
                                [ span [ class "name" ] [ text <| t "config.Начальная емкость батареи", text ":" ]
                                , span [ class "text" ] [ text "(TBD)4800мАч" ]
                                ]
                            , div [ class "content-item" ]
                                [ span [ class "name" ] [ text <| t "config.Начало эксплуатации", text ":" ]
                                , span [ class "text" ] [ text "(TBD)18 Янв 2021" ]
                                ]
                            , div [ class "content-item" ]
                                [ span [ class "name" ] [ text <| t "config.Общее время эксплуатации", text ":" ]
                                , span [ class "text" ] [ text "(TBD)673 ч 9 мин" ]
                                ]
                            , div [ class "content-item" ]
                                [ span [ class "name" ] [ text <| t "config.Израсходовано энергии батареи", text ":" ]
                                , span [ class "text" ] [ text "(TBD)620.1 мАч" ]
                                ]
                            ]
                        ]
                    ]
                ]
            , div [ class "details-footer setting-footer" ]
                [ a [ class "orange-gradient-text cursor-pointer details-footer-btn modal-change-battery-btn", href "#" ]
                    [ span [ class "image icon-battery orange-gradient-text" ] []
                    , text <| t "config.Замена батареи"
                    ]
                , a [ class "blue-text cursor-pointer details-footer-btn modal-change-capacity-btn", href "#" ]
                    [ span [ class "image icon-change_battery" ] []
                    , text <| t "config.Изменить начальную емкость"
                    ]
                ]
            ]
        ]



-- icon4Fenix : String -> String
-- icon4Fenix
