module Page.System.Config.Details exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo, SystemDocumentParams)
import AppState exposing (AppState)
import Html exposing (Html, a, div, input, label, span, text)
import Html.Attributes as HA exposing (attribute, class, name, type_, value)
import Html.Events as HE
import Page.System.Config.Types exposing (..)


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html Msg
view ({ t } as appState) model system mparams =
    let
        maybeRow : String -> Maybe String -> (String -> String) -> Html Msg
        maybeRow label field foo =
            case field of
                Nothing ->
                    text ""

                Just v ->
                    div [ class "content-item" ]
                        [ span [ class "name" ] [ text <| t <| "config." ++ label, text ":" ]
                        , span [ class "text" ] [ text v ]
                        ]

        maybeRowEditable : String -> Maybe String -> (String -> String) -> Html Msg
        maybeRowEditable label field foo =
            div [ class "content-item setting-det-phone" ]
                [ span [ class "name" ] [ text <| t <| "config." ++ label, text ":" ]
                , span [ class "text" ] [ text <| Maybe.withDefault (t "config.Не указан") <| field ]
                , Html.button [ class "setting-edit details-edit-btn openModalPhone", HE.onClick <| OnEditPhone <| Maybe.withDefault "" <| system.phone ] [ span [ class "icon-edit" ] [] ]
                ]
    in
    Html.div [ class "details-wrapper-bg" ]
        [ div [ class "details-header" ]
            [ div [ class "details-title" ] [ text <| t "config.Детали о Фениксе" ] ]
        , div [ class "details-items" ]
            [ div [ class "details-item" ]
                [ div [ class "setting-item" ]
                    [ maybeRow "Модель" system.hwid identity
                    , maybeRow "Версия ПО" system.swid identity
                    , maybeRow "IMEI" system.imei identity
                    , maybeRowEditable "SIM-карта" system.phone identity
                    , div [ class "content-item" ]
                        [ span [ class "checkmark-wrap setting-executors" ]
                            [ label [ class "checkboxContainer" ]
                                [ input [ attribute "checked" "", name "", type_ "checkbox", HA.checked system.executor, HE.onCheck (OnExecutor system.id) ] [], span [ class "checkmark" ] [] ]
                            , span [ class "checkmark-text" ] [ text <| t "config.Экзекутор в наличии" ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "details-footer setting-footer" ]
            [ Html.button [ HA.href "#", attribute "role" "button", class "red-text cursor-pointer details-footer-btn modal-open", HE.onClick (OnRemove system.id) ]
                [ span [ class "icon-remove" ] [], text <| t "config.Удалить Феникс" ]
            ]
        ]
