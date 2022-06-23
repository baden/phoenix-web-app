module Page.Home.List exposing (..)

import API.System as System exposing (SystemDocumentInfo)
import API.System.Battery as Battery exposing (Battery)
import AppState exposing (AppState)
import Components.UI as UI
import Components.UI.Battery exposing (powerLevelClass)
import Dict exposing (Dict)
import Html exposing (Html, a, button, div, img, li, span, text, ul)
import Html.Attributes as HA exposing (alt, attribute, class, classList, href, id, src, style)
import Html.Events as HE exposing (onClick)
import Page.Home.Types exposing (Model, Msg(..))
import Round
import Svg exposing (path, svg, text_)
import Svg.Attributes exposing (d, preserveAspectRatio, strokeDasharray, viewBox, x, y)
import Time
import Types.Dt as DT


card : SystemDocumentInfo -> AppState -> List (Html Msg)
card system ({ t } as appState) =
    [ span [ class <| "icon-" ++ system.icon ++ " fenix-type" ] []
    , div [ class "fenix-header" ]
        [ div [ class "fenix-status" ]
            [ status_icon system.dynamic
            , span [ class "status" ] [ text <| t <| sysState_of system.dynamic ]
            , stateIcon appState system.dynamic
            ]
        , a [ href <| "/system/" ++ system.id ++ "/config", class "fenix-set-btn" ] []
        ]
    , div [ class "fenix-body" ]
        [ span [ class "fenix-title" ] [ text system.title ]
        , smallPowerWidget appState system.battery system.params.sleep system.dynamic
        ]
    , div [ class "fenix-footer" ]
        [ a [ href <| "/map/" ++ system.id, class "btn btn-md btn-secondary open-maps" ] [ text <| t "list.На карте" ]
        , a [ href <| "/system/" ++ system.id, class "btn btn-md btn-primary" ] [ text <| t "list.Управление" ]
        ]
    ]


addCard : AppState -> Html Msg
addCard { t } =
    div [ class "fenix fenix-bg fenix-add" ]
        [ div [ class "fenix-header" ] []
        , div [ class "fenix-body" ]
            [ div [ class "fenix-add-text" ]
                [ text <| t "list.Добавьте ещё один Феникс"
                , Html.br [] []
                , text <| t "list.в список наблюдения"
                ]
            , a [ href "/linksys", class "btn btn-primary btn-lg btn-add" ] [ text <| t "list.Добавить" ]
            ]
        ]



-- Private


systemList : List String -> Dict String SystemDocumentInfo -> AppState -> Html Msg
systemList sysIds systems ({ timeZone } as appState) =
    UI.systemList <|
        (sysIds
            |> List.indexedMap (systemItem systems appState)
        )
            ++ [ addCard appState ]


systemItem : Dict String SystemDocumentInfo -> AppState -> Int -> String -> Html Msg
systemItem systems appState index sysId =
    let
        -- title =
        --     [ UI.info_2_10 "Index:" (String.fromInt index)
        --     , UI.info_2_10 "ID:" sysId
        --     ]
        maybe_system =
            Dict.get sysId systems

        header =
            case maybe_system of
                Nothing ->
                    []

                Just system ->
                    [ UI.cardHeader (sysState_of system.dynamic) ("/system/" ++ sysId ++ "/config") ]

        body =
            case maybe_system of
                Nothing ->
                    [ UI.row_item [ UI.text "Данные по объекту еще не получены или недостаточно прав для доступа" ] ]

                Just system ->
                    -- [ UI.cardBody
                    --     [ UI.cardTitle system.title
                    --     , UI.cardPwrPanel
                    --     ]
                    -- ]
                    card system appState

        footer =
            -- [ UI.row_item <|
            --     [ UI.linkIconTextButton "gamepad" "Управление" ("/system/" ++ sysId)
            --     , UI.linkIconTextButton "cog" "Настройка" ("/system/" ++ sysId ++ "/config")
            --     ]
            --         ++ ifPosition maybe_system
            --
            -- -- ++ [ UI.cmdTextIconButton "trash" "Удалить" (OnRemove index)]
            -- ]
            [ UI.cardFooter ("/system/" ++ sysId) (ifPosition maybe_system) ]
    in
    -- UI.card (title ++ body ++ footer)
    -- UI.card <| header ++ body ++ footer
    div [ class "fenix fenix-bg" ]
        body


curState : String -> Html Msg
curState t =
    UI.row_item
        [ Html.span
            [ HA.class "blue-text text-darken-2"
            , HA.style "font-size" "1.2em"
            , HA.style "font-weight" "bold"
            ]
            [ Html.text t ]
        ]


ifPosition : Maybe SystemDocumentInfo -> Maybe String
ifPosition maybe_system =
    case maybe_system of
        Nothing ->
            Nothing

        Just system ->
            case system.dynamic of
                Nothing ->
                    Nothing

                Just dynamic ->
                    case ( dynamic.latitude, dynamic.longitude ) of
                        ( Just _, Just _ ) ->
                            Just ("/map/" ++ system.id)

                        _ ->
                            Nothing


sysState_of : Maybe System.Dynamic -> String
sysState_of dynamic =
    case dynamic of
        Nothing ->
            "-"

        Just d ->
            case d.state of
                Nothing ->
                    "-"

                Just state ->
                    System.stateAsString state


position_of : Maybe System.Dynamic -> Time.Zone -> String
position_of maybe_system_dynamic timeZone =
    case maybe_system_dynamic of
        Nothing ->
            "неизвестно"

        Just dynamic ->
            maybeLatLong dynamic.latitude dynamic.longitude


maybeLatLong : Maybe Float -> Maybe Float -> String
maybeLatLong mlatitude mlongitude =
    case ( mlatitude, mlongitude ) of
        -- ( Nothing, _ ) ->
        --     "данные не получены"
        --
        -- ( _, Nothing ) ->
        --     "данные не получены"
        ( Just latitude, Just longitude ) ->
            (String.fromFloat latitude
                ++ ", "
                ++ String.fromFloat longitude
             -- ++ "@"
             -- ++ (dtFormat lastPosition.dt timeZone)
            )

        ( _, _ ) ->
            "данные не получены"


systemListTitle : String -> Html a
systemListTitle ttl_ =
    div [ class "title-st" ] [ text ttl_ ]


status_icon : Maybe System.Dynamic -> Html Msg
status_icon mdynamic =
    let
        icon =
            case mdynamic of
                Nothing ->
                    ""

                Just d ->
                    case d.state of
                        Nothing ->
                            ""

                        Just state ->
                            case state of
                                System.Tracking ->
                                    "search-status"

                                System.Sleep ->
                                    "wait-status"

                                System.Locked ->
                                    "Блокировка"

                                System.Beacon ->
                                    "wait-status"

                                System.Hidden ->
                                    "wait-status"

                                System.Off ->
                                    "off-status"

                                System.Config ->
                                    "config-status"

                                System.Point ->
                                    "point-status"

                                System.SLock ->
                                    "lock-status"

                                System.Lock ->
                                    "lock-status"

                                System.CLock ->
                                    "lock-status"

                                System.Unlock ->
                                    "unlock-status"

                                System.ProlongSleep hours ->
                                    "prolong-status"

                                System.Unknown c ->
                                    "unknown-status"
    in
    span [ class "status-icon", class icon ] []


stateIcon : AppState -> Maybe System.Dynamic -> Html Msg
stateIcon { t } mdynamic =
    let
        ( title_, icon ) =
            case mdynamic of
                Nothing ->
                    ( "Состояние еще неизвестно", "sleep" )

                Just d ->
                    case d.state of
                        Nothing ->
                            ( "Состояние еще неизвестно", "sleep" )

                        Just System.Tracking ->
                            ( "Авто в движении", "green-car" )

                        _ ->
                            ( "Авто в спящем состоянии", "sleep" )

        -- ("Нет сигнала", "chair")
        -- ("Авто не движется", "stop")
        -- ("Авто в движении", "green-car")
    in
    div [ class "tooltip" ]
        [ div [ class "tooltip-wr" ] [ div [ class "tooltip-content" ] [ text title_ ] ]
        , div [ class "tooltip-title" ] [ span [ class "icon", class icon ] [] ]
        ]



-- powerStatus100 : Html Msg
-- powerStatus100 =
--     div [ class "power-status" ]
--         [ span [ class "power" ]
--             [ span [ class "power-top" ] []
--             , span [ class "power-wr" ]
--                 [ span [ class "power-bg full", attribute "style" "height: 80%" ]
--                     [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
--                         [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
--                         ]
--                     ]
--                 ]
--             ]
--         , div [ class "power-status-title full" ] [ text "100%" ]
--         ]
-- powerStatus85 =
--     div [ class "power-status" ]
--         [ span [ class "power" ]
--             [ span [ class "power-top" ] []
--             , span [ class "power-wr" ]
--                 [ span [ class "power-bg high", attribute "style" "height: 90%" ]
--                     [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
--                         [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
--                         ]
--                     ]
--                 ]
--             ]
--         , div [ class "power-status-title high" ] [ text "85%" ]
--         ]
-- powerStatus50 =
--     div [ class "power-status" ]
--         [ span [ class "power" ]
--             [ span [ class "power-top" ] []
--             , span [ class "power-wr" ]
--                 [ span [ class "power-bg medium", attribute "style" "height: 70%" ]
--                     [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
--                         [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
--                         ]
--                     ]
--                 ]
--             ]
--         , div [ class "power-status-title medium" ] [ text "50%" ]
--         ]
-- powerStatus15 =
--     div [ class "power-status" ]
--         [ span [ class "power" ]
--             [ span [ class "power-top" ] []
--             , span [ class "power-wr" ]
--                 [ span [ class "power-bg low", attribute "style" "height: 30%" ]
--                     [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
--                         [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
--                         ]
--                     ]
--                 ]
--             ]
--         , div [ class "power-status-title low" ] [ text "15%" ]
--         ]


smallPowerWidget : AppState -> Maybe Battery -> Maybe Int -> Maybe System.Dynamic -> Html Msg
smallPowerWidget appState mbattery msleep mdynamic =
    case mbattery of
        Nothing ->
            text "Unknown"

        Just battery ->
            let
                lifetime =
                    (appState.now |> Time.posixToMillis) // 1000 - (battery.init_dt |> DT.toInt)

                used =
                    Battery.calculation battery.counters lifetime

                percentage =
                    100 * (battery.init_capacity - used) / battery.init_capacity

                p_as_text =
                    (percentage |> Round.round 1) ++ "%"

                colour =
                    powerLevelClass percentage

                sleep =
                    case msleep of
                        Nothing ->
                            120

                        -- Значение по умолчанию
                        Just sleepValue ->
                            sleepValue
            in
            div [ class "fenix-power-wr" ] <|
                [ div [ class "power-status" ]
                    [ span [ class "power" ]
                        [ span [ class "power-top" ] []
                        , span [ class "power-wr" ]
                            [ span [ class "power-bg", class colour, attribute "style" ("height: " ++ height percentage) ]
                                [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
                                    [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "power-status-title", class colour ] [ text p_as_text ]
                    ]
                ]
                    ++ batText appState battery used sleep mdynamic


batText : AppState -> Battery -> Float -> Int -> Maybe System.Dynamic -> List (Html Msg)
batText ({ t } as appState) battery used sleep mdynamic =
    let
        capacity =
            battery.init_capacity - used

        trackingMode =
            case mdynamic of
                Nothing ->
                    False

                Just s ->
                    case s.state of
                        Just System.Tracking ->
                            True

                        _ ->
                            False
    in
    [ span [ class "text" ] <|
        case trackingMode of
            True ->
                [ span [ class "title" ] [ text <| t "list.Режим Поиск:" ]
                , span [] [ text (Battery.expect_at_tracking appState capacity) ]
                ]

            False ->
                [ span [ class "title" ] [ text <| t "list.Режим Ожидание:" ]
                , span [] [ text (Battery.expect_at_sleep appState capacity sleep) ]
                ]
    ]


height : Float -> String
height percentage =
    -- Из дизайна:
    -- 100 -> 80%
    -- 85 -> 90%
    -- 50 -> 70%
    -- 15 -> 30%
    -- Примерно можно так:
    -- 100 -> 110
    -- 0 -> 9
    ((percentage + 9) |> Round.round 0) ++ "%"
