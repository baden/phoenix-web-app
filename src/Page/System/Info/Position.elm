module Page.System.Info.Position exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events as HE
import Page.System.Info.Types exposing (..)
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.Положение" ]
        , div [ class "content" ]
            [ div [ class "content-item" ]
                [ span [ class "name" ] [ text <| t "control.Положение определено:" ]
                , span [ class "text" ] [ text "(TDP)14 Июн 18:23" ]
                ]
            , div [ class "content-item content-item-group" ]
                [ a [ class "details-blue-title blue-gradient-text", href "#" ]
                    [ span [ class "details-icon icon-map" ] [], text <| t "control.Показать" ]
                , div [ class "details-blue-title blue-gradient-text" ]
                    [ span [ class "details-icon icon-refresh" ] [], text <| t "control.Обновить" ]
                ]
            ]
        ]
