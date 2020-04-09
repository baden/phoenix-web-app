module Page.System.Info exposing (init, update, view)

import Page
import Html exposing (Html, div, a)
import Html.Attributes as HA exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI exposing (..)
import Components.Dates as Dates
import API
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import AppState
import Components.DateTime exposing (dateTimeFormat)
import Types.Dt as DT
import Page.System.Info.Types exposing (Model, Msg, Msg(..))
import Page.System.Info.Dialogs exposing (..)
import Msg as GMsg


init : ( Model, Cmd Msg )
init =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , showSleepProlongDialog = False
      , offId = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnSysCmd sysId Off ->
            ( { model | offId = sysId, showConfirmOffDialog = True }, Cmd.none, Nothing )

        OnSysCmd sysId state ->
            ( model, Cmd.batch [ API.websocketOut <| System.setSystemState sysId state ], Nothing )

        OnSysCmdCancel sysId ->
            ( model, Cmd.batch [ API.websocketOut <| System.cancelSystemState sysId ], Nothing )

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

        OnProlongSleep sysId hours ->
            ( { model | showSleepProlongDialog = False }, Cmd.batch [ API.websocketOut <| System.prolongSleep sysId hours ], Nothing )

        OnNoCmd ->
            ( model, Cmd.none, Nothing )


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view appState model system =
    UI.container <|
        [ header_expander
        , UI.widget <|
            (viewHeader appState model system)
                ++ (viewInfo appState model system)
                ++ (viewInfoEntended appState model system)
                ++ [ UI.row [ UI.linkIconTextButton "clone" "Выбрать другой объект" "/" ] ]
                ++ (prolongSleepDialogView model system.id)
        ]
            ++ (viewModalDialogs model)



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


viewHeader : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewHeader appState model system =
    [ UI.row_item
        [ text system.title
        , text " "

        -- , UI.cmdButton "…" (OnTitleChangeStart system.title)
        , UI.iconButton "cog" ("/system/" ++ system.id ++ "/config")

        -- , UI.cmdIconButton "cog" (OnSysCmd system.id Config)
        ]
    ]


viewInfo : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewInfo appState model system =
    (sysState_of appState system.dynamic)
        ++ (cmdPanel system.id system.dynamic)
        ++ (Dates.nextSession appState system.dynamic)
        ++ (Dates.sysPosition appState system.id system.dynamic)
        ++ [ UI.row [ UI.linkIconTextButton "eye" "Cобытия" ("/system/" ++ system.id ++ "/logs") ] ]



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


sysState_of : AppState.AppState -> Maybe System.Dynamic -> List (Html Msg)
sysState_of appState maybe_dynamic =
    case maybe_dynamic of
        Nothing ->
            [ UI.row_item [ text <| "Данные о состоянии еще не получены" ] ]

        Just dynamic ->
            case dynamic.state of
                Nothing ->
                    [ UI.row_item [ text <| "Состояние: -" ] ]

                Just Off ->
                    [ UI.row_item [ text <| "Трекер выключен." ]
                    , UI.row_item [ text <| "Для включения трекера, нажмите кнопку на плате прибора." ]
                    ]

                Just Point ->
                    [ UI.row_item [ text <| "Идет определение местоположения..." ]
                    , UI.row_item [ text <| "Это может занять до 15 минут." ]
                    ]

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
                                    [ Html.div [ HA.class "row" ] [ UI.cmdButton "Отложить засыпание" OnShowProlongSleepDialog ] ]

                                _ ->
                                    []
                    in
                        [ UI.row_item [ text <| "Трекер под наблюдением." ]
                        ]
                            ++ (Dates.expectSleepIn appState dynamic)
                            ++ prolongCmd

                Just state ->
                    [ UI.row_item [ text <| "Состояние: " ++ (System.stateAsString state) ] ]


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
            [ UI.row_item [ text <| label ++ ": " ++ (foo v) ] ]


viewInfoEntended : AppState.AppState -> Model -> SystemDocumentInfo -> List (Html Msg)
viewInfoEntended appState model system =
    if model.extendInfo then
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
            [ chartView model ]
                ++ (maybeRow "Плата" system.hwid identity)
                ++ (maybeRow "Версия" system.swid identity)
                ++ (maybeRow "IMEI" system.imei identity)
                ++ (maybeRow "Номер телефона" system.phone identity)
                ++ (maybeRow "Баланс" system.balance (\{ dt, value } -> String.fromFloat value))
                ++ [ UI.row [ UI.cmdTextIconButton "arrow-up" "Меньше информации" OnExtendInfo ]
                   ]
    else
        [ UI.row [ UI.cmdTextIconButton "arrow-down" "Больше информации…" OnExtendInfo ] ]


chartView : Model -> Html Msg
chartView _ =
    Html.div [ HA.class "row", HA.style "margin-bottom" "0" ]
        [ Html.div [ HA.class "col s12 m6 l4 right-align" ] [ ChartSvg.chartView "Батарея" 80 ]
        , Html.div [ HA.class "col s12 m6 l8 left-align" ]
            [ Html.p [] [ Html.text "Ожидаемое время работы:" ]
            , Html.p [] [ Html.text "В режиме ожидания: около 2 лет" ]
            , Html.p [] [ Html.text "В режиме слежения: около 2 суток" ]
            ]
        ]


cmdPanel : String -> Maybe System.Dynamic -> List (Html Msg)
cmdPanel sysId maybe_dynamic =
    case maybe_dynamic of
        Nothing ->
            []

        Just dynamic ->
            case dynamic.waitState of
                Nothing ->
                    case dynamic.state of
                        Nothing ->
                            []

                        Just Config ->
                            cmdPanelConfig sysId

                        Just state ->
                            let
                                b =
                                    \i ->
                                        Html.div [ HA.class "col s12 m6 l3 xl3" ]
                                            [ UI.cmdButton (System.stateAsCmdString i) (OnSysCmd sysId i) ]
                            in
                                [ Html.div [ HA.class "row" ] (dynamic.available |> List.map b) ]

                Just Point ->
                    [ text <| "При следуюем сеансе связи, будет определено текущее местоположение системы"
                    , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                    ]

                Just (ProlongSleep duration) ->
                    [ text <| "При следуюем сеансе связи, будет продлена работа прибора в режиме Трекер на " ++ (String.fromInt duration) ++ "ч."
                    , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                    ]

                Just wState ->
                    [ text <| "При следуюем сеансе связи, система будет переведена в режим: " ++ (System.stateAsString wState)
                    , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                    ]


cmdPanelConfig : String -> List (Html Msg)
cmdPanelConfig sysId =
    [ UI.text <| "В разработке..."
    ]
