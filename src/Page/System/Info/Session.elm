module Page.System.Info.Session exposing (..)

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
        [ div [ class "title" ] [ text <| t "control.Связь" ]
        , div [ class "content" ]
            [ div [ class "content-item" ]
                [ span [ class "name" ] [ text <| t "control.Последний сеанс связи:" ]
                , span [ class "text" ] [ text "(TDP)23 Июн 18:17" ]
                ]
            , div [ class "content-item" ]
                [ span [ class "name" ] [ text <| t "control.Следующий сеанс связи:" ]
                , span [ class "text" ] [ text "(TDP)23 Июн 18:47" ]
                ]
            ]
        ]
