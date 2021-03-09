module Page.System.Info exposing (init, update, view)

-- import Page.System.Info.СmdPanel1 exposing (cmdPanel)

import API
import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState
import Components.DateTime exposing (dateTimeFormat)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events as HE
import Msg as GMsg
import Page
import Page.System.Info.Battery exposing (chartView)
import Page.System.Info.CmdPanel exposing (..)
import Page.System.Info.Dialogs exposing (..)
import Page.System.Info.Types exposing (..)
import Svg exposing (path, svg, text_)
import Svg.Attributes exposing (d, preserveAspectRatio, strokeDasharray, viewBox, x, y)
import Types.Dt as DT


init : ( Model, Cmd Msg )
init =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , showSleepProlongDialog = False
      , showCommandConfirmDialog = Nothing
      , offId = ""
      , batteryExtendView = BVP1
      , newBatteryCapacity = BC_None

      -- , smartBlock = True
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnSysCmd sysId Off ->
            ( { model | offId = sysId, showConfirmOffDialog = True }, Cmd.none, Nothing )

        OnSysCmdPre sysId state ->
            ( { model | showCommandConfirmDialog = Just state }, Cmd.none, Nothing )

        OnSysCmd sysId state ->
            ( { model | showCommandConfirmDialog = Nothing }, Cmd.batch [ API.websocketOut <| System.setSystemState sysId state ], Nothing )

        OnSysCmdCancel sysId ->
            ( model, Cmd.batch [ API.websocketOut <| System.cancelSystemState sysId ], Nothing )

        -- OnSmartBlockCheck b ->
        --     ( { model | smartBlock = b }, Cmd.none, Nothing )
        OnExtendInfo ->
            ( { model | extendInfo = not model.extendInfo }, Cmd.none, Nothing )

        OnConfirmOff ->
            ( { model | showConfirmOffDialog = False }, Cmd.batch [ API.websocketOut <| System.setSystemState model.offId Off ], Nothing )

        OnCancelOff ->
            ( { model | showConfirmOffDialog = False }, Cmd.none, Nothing )

        OnShowProlongSleepDialog ->
            ( { model | showSleepProlongDialog = True }, Cmd.none, Nothing )

        OnHideProlongSleepDialog ->
            ( { model | showSleepProlongDialog = False }, Cmd.none, Nothing )

        OnHideCmdConfirmDialog ->
            ( { model | showCommandConfirmDialog = Nothing }, Cmd.none, Nothing )

        OnProlongSleep sysId hours ->
            ( { model | showSleepProlongDialog = False }, Cmd.batch [ API.websocketOut <| System.prolongSleep sysId hours ], Nothing )

        OnBatteryClick ->
            case model.batteryExtendView of
                BVP1 ->
                    ( { model | batteryExtendView = BVP2 }, Cmd.none, Nothing )

                BVP2 ->
                    ( { model | batteryExtendView = BVP1 }, Cmd.none, Nothing )

                BVP3 ->
                    ( model, Cmd.none, Nothing )

        OnBatteryMaintance ->
            ( { model | batteryExtendView = BVP3 }, Cmd.none, Nothing )

        OnBatteryMaintanceDone ->
            ( { model | batteryExtendView = BVP1 }, Cmd.none, Nothing )

        -- OnBatteryChange capacity ->
        OnBatteryChange capacity ->
            ( { model | newBatteryCapacity = capacity }, Cmd.none, Nothing )

        OnBatteryCapacityConfirm sysId capacity ->
            let
                cmd =
                    case model.newBatteryCapacity of
                        BC_None ->
                            Cmd.none

                        BC_Change _ ->
                            Cmd.batch [ API.websocketOut <| System.resetBattery sysId capacity ]

                        BC_Capacity _ ->
                            Cmd.batch [ API.websocketOut <| System.setBatteryCapacity sysId capacity ]
            in
            ( { model | newBatteryCapacity = BC_None, batteryExtendView = BVP1 }, cmd, Nothing )

        OnBatteryCapacityCancel ->
            ( { model | newBatteryCapacity = BC_None }, Cmd.none, Nothing )

        OnNoCmd ->
            ( model, Cmd.none, Nothing )


viewWidget : List (Html Msg) -> Html Msg
viewWidget child =
    -- div [ class "row" ]
    --     [ div [ class "viewWidget col s12 m8 offset-m2 xl7 offset-xl2" ] child ]
    div [ class "viewWidget" ] child


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    div [ class "container" ]
        [ div [ class "wrapper-content" ]
            [ div [ class "details-wrapper-bg" ]
                [ div [ class "details-title" ] [ text system.title ]
                , div [ class "details-items" ]
                    [ sysState_of appState system.dynamic
                    , div [ class "details-item" ]
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
                    , div [ class "details-item" ]
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
                    , div [ class "details-item" ]
                        [ div [ class "title" ] [ text <| t "control.Предполагаемое время работы батареи" ]
                        , div [ class "content" ]
                            [ div [ class "content-item" ]
                                [ div [ class "content-item-group" ]
                                    [ div [ class "power-status" ]
                                        [ span [ class "power" ]
                                            [ span [ class "power-top" ] []
                                            , span [ class "power-wr" ]
                                                [ span [ class "power-bg high", attribute "style" "height: 80%" ]
                                                    [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
                                                        [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] [] ]
                                                    ]
                                                ]
                                            ]
                                        , div [ class "power-status-title high" ] [ text "(TDP)85%" ]
                                        ]
                                    , span [ class "details-mode" ]
                                        [ div [ class "wait-mode" ]
                                            [ span [ class "mode-title" ]
                                                [ text <| t "control.Режим"
                                                , text " "
                                                , span [ class "uppercase-txt" ]
                                                    [ text <| t "Ожидание" ]
                                                , text ":"
                                                ]
                                            , span [] [ text "(TDP)8 месяцев 17 дней" ]
                                            ]
                                        , div [ class "search-mode" ]
                                            [ span [ class "mode-title" ]
                                                [ text <| t "control.Режим"
                                                , text " "
                                                , span [ class "uppercase-txt" ]
                                                    [ text <| t "Поиск" ]
                                                , text ":"
                                                ]
                                            , span [] [ text "(TDP)8 месяцев 17 дней" ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "details-item" ]
                        [ div [ class "title" ] [ text <| t "control.SIM-карта" ]
                        , div [ class "content" ]
                            [ div [ class "content-item" ]
                                [ span [ class "icon-sim" ] []
                                , span [ class "name" ] [ text <| t "control.Баланс:" ]
                                , span [ class "text" ] [ text "(TDP)93" ]
                                ]
                            , div [ class "content-item topUpAccount" ]
                                [ div [ class "number-phone accountPhone" ]
                                    [ span [ class "details-icon icon-phone" ] []
                                    , span [ class "text", id "phoneForCopy" ] [ text "(TDP)" ]
                                    ]
                                , div [ class "details-blue-title blue-gradient-text topUpText" ]
                                    [ span [ class "details-icon icon-card" ] []
                                    , span [ class "top-account" ] [ text <| t "control.Пополнить счет" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "details-footer" ]
                    [ button [ class "orange-gradient-text block-engine-btn modal-open cursor-pointer", href "#" ]
                        [ span [ class "icon-block" ] [], text <| t "control.Заблокировать двигатель" ]
                    ]
                ]
            ]
        , div [ class "copiedMess" ]
            [ div [ class "phone-copied-message" ]
                [ text "Номер телефона был скопирован\t\t\t\t" ]
            ]
        ]


sysState_of : AppState.AppState -> Maybe System.Dynamic -> Html Msg
sysState_of ({ t } as appState) maybe_dynamic =
    let
        ( stateText, _ ) =
            case maybe_dynamic of
                Nothing ->
                    ( "Данные о состоянии еще не получены", text "" )

                Just dynamic ->
                    case dynamic.state of
                        Nothing ->
                            ( "идет определение...", text "" )

                        Just Off ->
                            ( "Феникс выключен."
                            , UI.row_item [ text <| "Для включения - откройте крышку Феникса и нажмите кнопку ON/OFF." ]
                            )

                        Just Point ->
                            ( "Идет определение местоположения..."
                            , UI.row_item [ text <| "Это может занять до 15 минут." ]
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
                , span [ class "status" ] [ text <| t "Ожидание" ]
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
-- viewOld : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
-- viewOld appState model system =
--     UI.div_ <|
--         [ header_expander
--         , viewWidget <|
--             viewHeader appState model system
--                 ++ viewInfo appState model system
--                 ++ [ chartView appState model system ]
--                 ++ viewInfoEntended appState model system
--                 ++ [ UI.row [ UI.linkIconTextButton "clone" "Выбрать другой объект" "/" ] ]
--                 ++ prolongSleepDialogView model system.id
--         ]
--             ++ cmdPanel appState system.id system.dynamic
--             ++ viewModalDialogs model
--             ++ confirmDialog model system.id
-- view : AppState.AppState -> Model -> Page.ViewInfo -> Html Msg
-- view appState model pvi =
--     case pvi of
--         Page.VI_System system ->
--             UI.container <|
--                 [ header_expander
--                 , UI.widget <|
--                     (viewHeader appState model system)
--                         ++ (viewInfo appState model system)
--                         ++ (viewInfoEntended appState model system)
--                         ++ [ UI.row [ UI.linkIconTextButton "clone" "Выбрать другой объект" "/" ] ]
--                         ++ (prolongSleepDialogView model system.id)
--                 ]
--                     ++ (viewModalDialogs model)
--
--         _ ->
--             UI.container [ text "404" ]
--
-- viewHeader : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
-- viewHeader appState model system =
--     [ UI.row_item
--         [ text system.title
--         , text " "
--
--         -- , UI.cmdButton "…" (OnTitleChangeStart system.title)
--         , UI.iconButton "cog" ("/system/" ++ system.id ++ "/config")
--
--         -- , UI.cmdIconButton "cog" (OnSysCmd system.id Config)
--         ]
--     ]
-- viewInfo : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
-- viewInfo appState model system =
--     sysState_of appState system.dynamic
--         ++ Dates.nextSession appState system.dynamic
--         ++ Dates.sysPosition appState system.id system.dynamic
--         ++ [ UI.row [ UI.linkIconTextButton "eye" "Cобытия" ("/system/" ++ system.id ++ "/logs") ] ]
-- sysPosition : AppState.AppState -> String -> Maybe System.Dynamic -> List (Html Msg)
-- sysPosition appState sid maybe_dynamic =
--     case maybe_dynamic of
--         Nothing ->
--             []
--
--         Just dynamic ->
--             case ( dynamic.latitude, dynamic.longitude, dynamic.dt ) of
--                 ( Just latitude, Just longitude, Just dt ) ->
--                     [ UI.row_item
--                         [ text <| "Последнее положение определено " ++ (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ++ " "
--                         , UI.button ("/map/" ++ sid) "Смотреть на карте"
--                         ]
--                     ]
--
--                 ( _, _, _ ) ->
--                     [ UI.row_item [ text <| "Положение неизвестно" ] ]
-- curState : String -> Html Msg
-- curState t =
--     UI.row_item
--         [ Html.span
--             [ class "blue-text text-darken-2"
--             , HA.style "font-size" "1.2em"
--             , HA.style "font-weight" "bold"
--             ]
--             [ text t ]
--         ]


viewNextSession : Maybe System.Dynamic -> Html Msg
viewNextSession dynamic =
    text "{DYNAMIC_TBD}"



-- ++ (if model.extendInfo then
--         (viewInfoEntended appState model system)
--     else
--         [ UI.cmdButton "Больше информации…" OnExtendInfo ]
--    )


maybeRow : String -> Maybe a -> (a -> String) -> List (Html Msg)
maybeRow label field foo =
    case field of
        Nothing ->
            []

        Just v ->
            [ UI.row_item [ UI.text <| label ++ ": " ++ foo v ] ]


viewInfoEntended : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewInfoEntended appState ({ extendInfo } as model) system =
    if extendInfo then
        let
            imei =
                system.imei |> Maybe.withDefault "скрыт"

            phone =
                case system.phone of
                    Nothing ->
                        "не задан или скрыт"

                    Just "" ->
                        "не задан или скрыт"

                    Just any_ ->
                        any_
        in
        []
            ++ maybeRow "Модель" system.hwid identity
            ++ maybeRow "Версия ПО" system.swid identity
            ++ maybeRow "IMEI" system.imei identity
            ++ maybeRow "SIM-карта" system.phone identity
            ++ maybeRow "Баланс" system.balance (\{ dt, value } -> String.fromFloat value)
            ++ [ UI.row [ UI.cmdTextIconButton "arrow-up" "Меньше информации" OnExtendInfo ]
               ]

    else
        [ UI.row [ UI.cmdTextIconButton "arrow-down" "Больше информации…" OnExtendInfo ] ]
