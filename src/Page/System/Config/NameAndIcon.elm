module Page.System.Config.NameAndIcon exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo, SystemDocumentParams)
import AppState exposing (AppState)
import Html exposing (Html, a, button, div, input, label, span, text)
import Html.Attributes as HA exposing (attribute, class, name, type_, value)
import Html.Events exposing (onClick)
import Page.System.Config.Types exposing (Model, Msg(..))



-- (OnTitleChangeStart system.title)


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html Msg
view ({ t } as appState) model system mparams =
    div [ class "details-wrapper-bg" ]
        [ div [ class "details-header" ] [ div [ class "details-title" ] [ text <| t "config.Иконка и название" ] ]
        , div [ class "details-items" ]
            [ div [ class "details-item" ]
                [ div [ class "title" ] [ text <| t "config.Название Феникса" ]
                , div [ class "setting-item-wr" ]
                    [ div [ class "setting-item" ]
                        [ div [ class "setting-item-header" ]
                            [ span [ class "name" ] [ text system.title ]
                            , button [ class "setting-edit btn-change-name", onClick (OnTitleChangeStart system.title) ] [ span [ class "icon-edit" ] [] ]
                            ]
                        ]
                    ]
                ]
            , div [ class "details-item" ]
                [ div [ class "title" ] [ text <| t "config.Иконка Феникса" ]
                , div [ class "setting-item-wr" ]
                    [ div [ class "setting-item" ]
                        [ div [ class "setting-item-header" ]
                            [ span [ class "setting-selected-icon btn-select-icon", onClick (OnIconChangeStart system.icon) ]
                                [ span [ class <| "icon-" ++ system.icon ++ " image" ] []
                                , span [ class <| "icon-" ++ system.icon ++ "_icon image-logo" ] []
                                ]
                            , button [ class "setting-edit btn-select-icon", onClick (OnIconChangeStart system.icon) ] [ span [ class "icon-edit" ] [] ]
                            ]
                        ]
                    ]
                ]
            ]
        ]



-- icon4Fenix : String -> String
-- icon4Fenix
