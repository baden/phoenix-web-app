module Page.System.Info.State exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events exposing (onClick)
import Page.System.Info.Types exposing (..)
import Page.System.Info.UI as InfoUI
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    let
        ( stateText, controlWidgets ) =
            case system.dynamic of
                Nothing ->
                    ( "Данные о состоянии еще не получены", [] )

                Just dynamic ->
                    case dynamic.state of
                        Nothing ->
                            ( "идет определение...", [] )

                        Just Off ->
                            ( "Феникс выключен."
                            , [ text <| "Для включения - откройте крышку Феникса и нажмите кнопку ON/OFF." ]
                            )

                        Just Point ->
                            ( "Идет определение местоположения..."
                            , [ text <| "Это может занять до 15 минут." ]
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
                            , [ expectSleepIn appState dynamic prolongCmd
                              , startNewState appState "Ожидание" system.id System.Hidden dynamic
                              ]
                            )

                        -- Just Tracking ->
                        -- ++ prolongCmd
                        Just Hidden ->
                            ( System.stateAsString Hidden, [ startNewState appState "Поиск" system.id System.Tracking dynamic ] )

                        Just state ->
                            -- [ UI.row_item [ text <| "Текущий режим: " ++ (System.stateAsString state) ] ]
                            ( System.stateAsString state, [] )
    in
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.Текущий режим" ]
        , div [ class "content" ] <|
            [ div [ class "content-item fenix-status fenix-big-status" ]
                [ span [ class "status-big-icon wait-status status-icon" ] []
                , span [ class "status" ] [ text <| t <| "control." ++ stateText ]
                , span [ class "icon sleep" ] []
                ]

            -- div [ class "details-blue-title blue-gradient-text" ]
            --     [ span [ class "details-icon icon-search" ] []
            --     , text <| t "control.Включить режим Поиск"
            --     ]
            ]
                ++ controlWidgets
        ]


stateView =
    div [ class "details-changed-mode" ]
        [ div [ class "details-revert-mode" ]
            [ span []
                [ text "При следующем сеансе связи,  Феникс будет переведён в режим ПОИСК" ]
            ]
        , div [ class "details-blue-title red-text" ] [ text "Отмена" ]
        ]



-- sysState_ofOld : AppState.AppState -> Maybe System.Dynamic -> List (Html Msg)
-- sysState_ofOld appState maybe_dynamic =
--     case maybe_dynamic of
--         Nothing ->
--             [ UI.row_item [ text <| "Данные о состоянии еще не получены" ] ]
--
--         Just dynamic ->
--             case dynamic.state of
--                 Nothing ->
--                     [ curState "Текущий режим: идет определение.." ]
--
--                 Just Off ->
--                     [ curState "Феникс выключен."
--                     , UI.row_item [ text <| "Для включения - откройте крышку Феникса и нажмите кнопку ON/OFF." ]
--                     ]
--
--                 Just Point ->
--                     [ curState "Идет определение местоположения..."
--                     , UI.row_item [ text <| "Это может занять до 15 минут." ]
--                     ]
--
--                 Just Tracking ->
--                     let
--                         -- autosleep =
--                         --     dynamic.autosleep |> Maybe.withDefault 0 |> String.fromInt
--                         last_session =
--                             case dynamic.lastping of
--                                 Nothing ->
--                                     DT.fromInt 0
--
--                                 Just lastping ->
--                                     lastping
--
--                         -- autosleepText =
--                         --     DT.addSecs last_session (DT.fromMinutes (Maybe.withDefault 0 dynamic.autosleep)) |> DT.toPosix |> dateTimeFormat appState.timeZone
--                         prolongCmd =
--                             case dynamic.waitState of
--                                 Nothing ->
--                                     -- [ Html.div [ HA.class "row" ] [ UI.cmdButton "Отложить" OnShowProlongSleepDialog ] ]
--                                     [ Html.div [ HA.class "col s12 l3" ] [ UI.cmdButton "Отложить" OnShowProlongSleepDialog ] ]
--
--                                 _ ->
--                                     []
--                     in
--                     [ curState "Текущий режим: Поиск" ]
--                         ++ Dates.expectSleepIn appState dynamic prolongCmd
--
--                 -- ++ prolongCmd
--                 Just state ->
--                     -- [ UI.row_item [ text <| "Текущий режим: " ++ (System.stateAsString state) ] ]
--                     [ curState <| "Текущий режим: " ++ System.stateAsString state ]


expectSleepIn : AppState.AppState -> System.Dynamic -> List (Html msg) -> Html Msg
expectSleepIn ({ t } as appState) dynamic prolongCmd =
    let
        now =
            appState.now

        last_session =
            case dynamic.lastping of
                Nothing ->
                    DT.fromInt 0

                Just lastping ->
                    lastping

        autosleep =
            case dynamic.autosleep of
                Nothing ->
                    "-"

                -- Just (DT.fromMinutes 6000) ->
                --     -- offset
                --     "никогда"
                Just offset ->
                    -- offset
                    if offset == DT.fromMinutes 6000 then
                        "никогда"

                    else
                        DT.addSecs last_session offset |> DT.toPosix |> Dates.dateTimeFormat tz

        tz =
            appState.timeZone
    in
    -- Html.div [ HA.class "row sessions" ]
    --     ([ Html.div [ HA.class "col s8 l6" ] [ text "Переход в режим Ожидание:" ]
    --      , Html.div [ HA.class "col s4 l3" ] [ text <| autosleep ]
    --      ]
    --         ++ prolongCmd
    --     )
    div [ class "content-item" ]
        [ div [ class "details-changed-mode" ]
            [ div [ class "details-revert-mode" ]
                [ span []
                    [ text <| t "control.Переход в режим"
                    , text " "
                    , span [ class "uppercase-txt mode" ] [ text <| t "control.Ожидание" ]
                    , text ":"
                    ]
                , span [ class "date" ] [ text autosleep ]
                ]
            , InfoUI.disabledOnWait appState <|
                div [ class "details-blue-title blue-gradient-text modal-open", InfoUI.disabledOnWaitClass dynamic, onClick OnShowProlongSleepDialog ]
                    [ text <| t "control.Продлить режим"
                    , span [ class "uppercase-txt mode" ] [ text "Поиск" ]
                    ]
            ]
        ]



-- OnSysCmdPre sysId i


startNewState : AppState.AppState -> String -> String -> System.State -> System.Dynamic -> Html Msg
startNewState ({ t } as appState) state sysId i dynamic =
    div [ class "content-item" ]
        [ InfoUI.disabledOnWait appState <|
            div [ class "details-blue-title blue-gradient-text", InfoUI.disabledOnWaitClass dynamic, onClick (OnSysCmdPre sysId i) ]
                [ span [ class "details-icon icon-search" ] []
                , text <| t "control.Включить режим"
                , text " "
                , text <| t <| "control." ++ state
                ]
        ]
