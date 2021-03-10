module Page.System.Info.State exposing (..)

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
    let
        ( stateText, _ ) =
            case system.dynamic of
                Nothing ->
                    ( "Данные о состоянии еще не получены", text "" )

                Just dynamic ->
                    case dynamic.state of
                        Nothing ->
                            ( "идет определение...", text "" )

                        Just Off ->
                            ( "Феникс выключен."
                            , text <| "Для включения - откройте крышку Феникса и нажмите кнопку ON/OFF."
                            )

                        Just Point ->
                            ( "Идет определение местоположения..."
                            , text <| "Это может занять до 15 минут."
                            )

                        Just Tracking ->
                            let
                                -- autosleep =
                                --     dynamic.autosleep |> Maybe.withDefault 0 |> String.fromInt
                                last_session =
                                    case dynamic.lastping of
                                        Nothing ->
                                            DT.fromInt 0

                                        Just lastping ->
                                            lastping

                                -- autosleepText =
                                --     DT.addSecs last_session (DT.fromMinutes (Maybe.withDefault 0 dynamic.autosleep)) |> DT.toPosix |> dateTimeFormat appState.timeZone
                                prolongCmd =
                                    case dynamic.waitState of
                                        Nothing ->
                                            -- [ Html.div [ HA.class "row" ] [ UI.cmdButton "Отложить" OnShowProlongSleepDialog ] ]
                                            [ Html.div [ HA.class "col s12 l3" ] [ UI.cmdButton "Отложить" OnShowProlongSleepDialog ] ]

                                        _ ->
                                            []
                            in
                            ( "Поиск"
                            , Dates.expectSleepIn appState dynamic prolongCmd
                            )

                        -- ++ prolongCmd
                        Just state ->
                            -- [ UI.row_item [ text <| "Текущий режим: " ++ (System.stateAsString state) ] ]
                            ( System.stateAsString state, text "" )
    in
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.Текущий режим" ]
        , div [ class "content" ]
            [ div [ class "content-item fenix-status fenix-big-status" ]
                [ span [ class "status-big-icon wait-status status-icon" ] []
                , span [ class "status" ] [ text <| t stateText ]
                , span [ class "icon sleep" ] []
                ]
            , div [ class "content-item" ]
                [ div [ class "details-blue-title blue-gradient-text" ]
                    [ span [ class "details-icon icon-search" ] []
                    , text <| t "control.Включить режим Поиск"
                    ]
                ]
            ]
        ]


stateView =
    div [ class "details-changed-mode" ]
        [ div [ class "details-revert-mode" ]
            [ span []
                [ text "При следующем сеансе связи,  Феникс будет переведён в режим ПОИСК" ]
            ]
        , div [ class "details-blue-title red-text" ] [ text "Отмена" ]
        ]
