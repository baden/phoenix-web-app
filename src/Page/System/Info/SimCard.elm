module Page.System.Info.SimCard exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, classList, href, id)
import Html.Events exposing (onClick)
import Page.System.Info.Types exposing (..)
import Time
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) { showPhone } system =
    let
        phoneClick =
            case system.phone of
                Nothing ->
                    -- TODO: Редактирование номера телефона
                    OnNoCmd

                Just phone ->
                    OnCopyPhone phone
    in
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.SIM-карта" ]
        , div [ class "content" ]
            [ div [ class "content-item" ]
                [ span [ class "icon-sim" ] []
                , span [ class "name" ] [ text <| t "control.Баланс:" ]
                , span [ class "text" ]
                    [ case system.balance of
                        Nothing ->
                            text <| t "control.Данные еще не получены"

                        Just { dt, value } ->
                            text <| String.fromFloat value
                    ]
                ]
            , div [ class "content-item topUpAccount", onClick OnShowPhone ]
                -- number-phone accountPhone showAnimate
                [ div [ class "number-phone accountPhone", classList [ ( "showAnimate", showPhone ) ], onClick phoneClick ]
                    [ span [ class "details-icon icon-phone" ] []
                    , span [ class "text", id "phoneForCopy" ] [
                        text <| Maybe.withDefault (Maybe.withDefault (t "config.Не указан") system.phone ) <| system.phoneManual
                        ]
                    ]
                , div [ class "details-blue-title blue-gradient-text topUpText", classList [ ( "hidden", showPhone ) ] ]
                    [ span [ class "details-icon icon-card" ] []
                    , span [ class "top-account" ] [ text <| t "control.Пополнить счет" ]
                    ]
                ]
            ]
        ]
