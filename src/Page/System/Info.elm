port module Page.System.Info exposing (init, update, view)

-- import Page.System.Info.СmdPanel1 exposing (cmdPanel)
-- import Page.System.Info.Battery as Battery exposing (chartView)
-- import Page.System.Info.CmdPanel exposing (..)

import API
import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.DateTime exposing (dateTimeFormat)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, classList, href, id)
import Html.Events exposing (onClick)
import Msg as GMsg
import Page
import Page.System.Info.Battery as Battery
import Page.System.Info.Dialogs exposing (..)
import Page.System.Info.Position as Position
import Page.System.Info.Session as Session
import Page.System.Info.SimCard as SimCard
import Page.System.Info.State as State
import Page.System.Info.Types exposing (..)
import Process
import Svg exposing (path, svg, text_)
import Svg.Attributes exposing (d, preserveAspectRatio, strokeDasharray, viewBox, x, y)
import Task
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
      , showPhone = False
      , showCopyPhonePanel = False

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

        OnShowPhone ->
            ( { model | showPhone = True }, Cmd.batch [ Process.sleep 6500 |> Task.perform (\_ -> OnHidePhone) ], Nothing )

        OnHidePhone ->
            ( { model | showPhone = False }, Cmd.none, Nothing )

        OnCopyPhone phone ->
            ( { model | showCopyPhonePanel = True }
            , Cmd.batch
                [ copyToClipboard phone
                , Process.sleep 6500 |> Task.perform (\_ -> OnCopyPhoneDone)
                ]
            , Nothing
            )

        OnCopyPhoneDone ->
            ( { model | showCopyPhonePanel = False }, Cmd.none, Nothing )


viewWidget : List (Html Msg) -> Html Msg
viewWidget child =
    -- div [ class "row" ]
    --     [ div [ class "viewWidget col s12 m8 offset-m2 xl7 offset-xl2" ] child ]
    div [ class "viewWidget" ] child


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    div [ class "container" ] <|
        [ div [ class "wrapper-content" ]
            [ div [ class "details-wrapper-bg" ]
                [ div [ class "details-title" ] [ text system.title ]
                , div [ class "details-items" ]
                    [ State.view appState model system
                    , Session.view appState model system
                    , Position.view appState model system
                    , Battery.view appState model system
                    , SimCard.view appState model system
                    ]
                , div [ class "details-footer" ]
                    [ button [ class "orange-gradient-text block-engine-btn modal-open cursor-pointer", href "#" ]
                        [ span [ class "icon-block" ] [], text <| t "control.Заблокировать двигатель" ]
                    ]
                ]
            ]
        , div [ class "copiedMess", classList [ ( "showAnimate", model.showCopyPhonePanel ) ] ]
            [ div [ class "phone-copied-message" ] [ text <| t "control.Номер телефона был скопирован" ] ]
        ]
            ++ prolongSleepDialogView appState model system.id
            ++ confirmDialogs appState model system.id



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



-- confirmDialogs model system.id


confirmDialogs : AppState -> Model -> String -> List (Html Msg)
confirmDialogs { t, tr } model sysId =
    -- TODO: Вынести в модуль
    let
        pre =
            "При следующем сеансе связи "
    in
    case model.showCommandConfirmDialog of
        Nothing ->
            []

        Just state ->
            [ div [ class "modal-bg show" ]
                [ div [ class "modal-wr" ]
                    [ div [ class "modal-content" ]
                        [ div [ class "modal-close close modal-close-btn", onClick OnHideCmdConfirmDialog ] []
                        , div [ class "modal-title" ] [ text <| t "control.Смена Режима" ]
                        , div [ class "modal-body" ]
                            [ span [ class "modal-text" ]
                                [ text <| tr "control.change_state_dialog" [ ( "date", "(TBD)" ), ( "state", "(TBD)" ) ] ]
                            ]
                        , div [ class "modal-btn-group" ]
                            [ button [ class "btn btn-md btn-secondary modal-close-btn", onClick OnHideCmdConfirmDialog ] [ text <| t "config.Отмена" ]
                            , button [ class "btn btn-md btn-primary" ] [ text <| t "config.Хорошо" ]
                            ]
                        ]
                    ]
                ]
            ]


port copyToClipboard : String -> Cmd msg
