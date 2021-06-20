module Page.System.Info.UI exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events exposing (onClick)


disabledOnWait dynamic { t } child =
    case dynamic.waitState of
        Nothing ->
            child

        Just _ ->
            div [ class "tooltip" ]
                [ div [ class "tooltip-wr" ]
                    [ div [ class "tooltip-content tooltip-content-big" ]
                        [ text <| t "control.Вы сможете нажать эту кнопку после того как Феникc исполнит команды которые ждут выполнения" ]
                    ]
                , div [ class "tooltip-title" ] [ child ]
                ]


disabledOnWaitClass dynamic =
    class <|
        case dynamic.waitState of
            Nothing ->
                ""

            Just _ ->
                "btn-disabled-opacity"
