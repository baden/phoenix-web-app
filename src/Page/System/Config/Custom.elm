module Page.System.Config.Custom exposing (configCustomView)

import API.System exposing (SystemDocumentParams)
import AppState exposing (AppState)
import Components.UI as UI exposing (UI, cmdIconButton, cmdIconButtonR, row)
import Dict exposing (Dict)
import Html exposing (Html, a, button, div, form, img, input, label, p, span, text)
import Html.Attributes as HA exposing (alt, attribute, checked, class, href, id, src, type_)
import Html.Events exposing (onClick)
import Page.System.Config.ParamDesc as ParamDesc
import Page.System.Config.Types exposing (..)


configCustomView : AppState -> Model -> String -> Maybe SystemDocumentParams -> List (UI Msg)
configCustomView ({ t } as appState) model sysId sysparams =
    case sysparams of
        Nothing ->
            [ row [ UI.text <| t "config.error_custom" ] ]
                ++ footer appState sysId Dict.empty

        Just params ->
            [ div [ class "details-header" ]
                [ div [ class "details-title" ] [ text <| t "menu.Расширенные настройки" ] ]
            , div [ class "details-items general-setting-wr scroll scroll-height" ] <|
                [ div [ class "warning" ]
                    [ div [ class "warning-content" ]
                        [ span [ class "warning-title" ] [ img [ alt "", src "/images/warning.svg" ] [], text <| t "config.Предупреждение!" ]
                        , span [ class "warning-text" ] [ text <| t "config.warning_custom" ]
                        ]
                    ]
                ]
                    ++ paramsWidget appState sysId params model.showQueue
            ]
                ++ footer appState sysId params.queue


footer : AppState -> String -> Dict String String -> List (UI Msg)
footer { t } sysId queue =
    case Dict.isEmpty queue of
        True ->
            []

        False ->
            -- [ Html.div [ HA.class "row param_row_filler" ] []
            -- , Html.div [ HA.class "params_footer right-align" ]
            --     [ Html.div [ HA.class "container" ]
            --         [ UI.cmdTextIconButtonR "trash" "Отменить внесенные изменения" (OnClearQueue sysId)
            --         , UI.cmdIconButton "question-circle" OnShowQueue
            --         ]
            --     ]
            -- ]
            [ div [ class "details-footer setting-footer" ]
                [ button [ href "#", class "red-text cursor-pointer details-footer-btn modal-open-cancel", onClick (OnClearQueue sysId) ]
                    [ span [ class "icon-remove" ] []
                    , span [] [ text <| t "config.Отменить", text " ", span [ class "mob-hidde" ] [ text <| t "config.изменения" ] ]
                    ]

                -- , a [ href "#", attribute "role" "button", class "blue-text cursor-pointer details-footer-btn modal-open-changes", UI.onLinkClick OnShowQueue ]
                , button [ href "#", attribute "role" "button", class "blue-text cursor-pointer details-footer-btn modal-open-changes", onClick OnShowQueue ]
                    [ span [ class "icon-eye_active" ] []
                    , span [] [ text <| t "config.Показать", text " ", span [ class "mob-hidde" ] [ text <| t "config.изменения" ] ]
                    ]
                ]
            ]


paramsWidget : AppState -> String -> SystemDocumentParams -> Bool -> List (UI Msg)
paramsWidget { t } sysId params showQueue =
    let
        prow queue ( name, { type_, value, default } ) =
            let
                valueField =
                    case Dict.get name queue of
                        Nothing ->
                            --     [ Html.span [ HA.class "params params_default" ] [ Html.text value ]
                            --     , cmdIconButton "edit" (OnStartEditParam sysId name value (ParamDesc.description name))
                            --     ]
                            [ div [ class "setting-item" ]
                                [ div [ class "setting-item-header" ]
                                    [ span [ class "name" ] [ text value ]
                                    , button [ class "setting-edit open-modal-axelerometr", onClick (OnStartEditParam sysId name value (ParamDesc.description name)) ] [ span [ class "icon-edit" ] [] ]
                                    ]
                                ]
                            ]

                        Just expect ->
                            -- [ Html.span [ HA.class "params params_waited" ]
                            --     [ Html.text value
                            --     , Html.i [ HA.class "fas fa-arrow-right", HA.style "margin" "0 5px 0 5px" ] []
                            --     , Html.text expect
                            --     ]
                            -- , cmdIconButtonR "trash-restore" (OnRestoreParam sysId queue name)
                            -- ]
                            [ div [ class "setting-item setting-changed" ]
                                [ div [ class "setting-item-header" ]
                                    [ span [ class "name" ]
                                        [ span [] [ text value ]
                                        , span [ class "setting-changed-data orange-gradient-text" ]
                                            [ span [ class "icon-arrow_next" ] []
                                            , span [] [ text expect ]
                                            ]
                                        ]
                                    , div [ class "details-btn-title red-text modal-open-cancel", onClick (OnRestoreParam sysId queue name) ]
                                        [ text <| t "config.Отмена" ]
                                    ]
                                ]
                            ]
            in
            div [ class "details-item" ]
                [ div [ class "title" ] [ text <| t <| "params." ++ name ]
                , div [ class "setting-item-wr" ] valueField
                ]

        -- Html.div [ HA.class "row param_row valign-wrapper" ]
        --     [ Html.div [ HA.class "col s8 m9 left-align" ]
        --         [ Html.div [ HA.class "name" ] [ Html.text name ]
        --         , Html.text (ParamDesc.description name)
        --         ]
        --     , Html.div [ HA.class "col s4 m3 right-align" ] valueField
        --     ]
        data =
            case showQueue of
                False ->
                    params.data

                True ->
                    params.data
                        |> List.filter (\( name, _ ) -> Dict.member name params.queue)
    in
    data
        |> List.map (prow params.queue)
