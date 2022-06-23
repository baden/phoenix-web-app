module Page.System.Config.Battery exposing (..)

-- import Page.System.Info.Types exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo, SystemDocumentParams)
import API.System.Battery as Battery exposing (Battery)
import AppState exposing (AppState)
import Components.Dates exposing (dateFormatFull)
import Components.UI.Battery exposing (powerLevelClass)
import Html exposing (Html, a, br, button, div, input, label, span, text)
import Html.Attributes as HA exposing (attribute, class, href, name, type_, value)
import Html.Events exposing (onClick)
import Page.System.Config.Types exposing (BatteryChange(..), Model, Msg(..))
import Round
import Svg exposing (Svg, path, svg)
import Svg.Attributes exposing (d, viewBox)
import Time
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe SystemDocumentParams -> Html Msg
view ({ t } as appState) model system mparams =
    let
        sleep =
            case system.params.sleep of
                Nothing ->
                    120

                -- Значение по умолчанию
                Just sleepValue ->
                    sleepValue
    in
    div [ class "wrapper-content wrapper-page" ]
        [ div [ class "details-wrapper-bg" ] <|
            case system.battery of
                Nothing ->
                    [ text <| t "control.Информация будет доступна после выхода Феникса на связь." ]

                Just battery ->
                    let
                        used =
                            Battery.calculation battery.counters lifetime

                        percentage =
                            100 * (battery.init_capacity - used) / battery.init_capacity

                        colour =
                            if percentage > 66 then
                                "green"

                            else if percentage > 33 then
                                "yellow"

                            else
                                "red"

                        lifetime =
                            (appState.now |> Time.posixToMillis) // 1000 - (battery.init_dt |> DT.toInt)

                        capacity =
                            battery.init_capacity - used
                    in
                    [ div [ class "details-header" ] [ div [ class "details-title" ] [ text <| t "config.Обслуживание батареи" ] ]
                    , div [ class "details-items" ]
                        [ div [ class "details-item" ]
                            [ div [ class "title" ] [ text <| t "config.Предполагаемое время", br [] [], text <| t "config.работы батареи" ]
                            , div [ class "setting-item-wr" ]
                                [ div [ class "content-item-group" ]
                                    [ batteryWidget percentage
                                    , span [ class "details-mode" ]
                                        [ waitModeTime appState (Battery.expect_at_sleep appState capacity sleep)
                                        , trackerModeTime appState (Battery.expect_at_tracking appState capacity)
                                        ]
                                    ]
                                ]
                            ]
                        , div [ class "details-item" ]
                            [ div [ class "title" ] [ text <| t "config.Статистика работы", text ":" ]
                            , div [ class "setting-item-wr" ]
                                [ div [ class "setting-item" ]
                                    [ startCapacity appState (String.fromFloat battery.init_capacity)
                                    , beginAt appState (battery.init_dt |> DT.toPosix |> dateFormatFull appState.langCode appState.timeZone)

                                    -- , totalTime appState "(TBD)673 ч 9 мин"
                                    , usedBattery appState (Round.round 1 used)
                                    ]
                                ]
                            ]
                        ]
                    , footer appState battery
                    ]
        ]


waitModeTime { t } value =
    div [ class "wait-mode" ]
        [ span [ class "mode-title" ] [ text <| t "Режим", text " ", span [ class "uppercase-txt" ] [ text <| t "Ожидание" ], text ":" ]
        , span [] [ text value ]
        ]


trackerModeTime { t } value =
    div [ class "search-mode" ]
        [ span [ class "mode-title" ] [ text <| t "Режим", text " ", span [ class "uppercase-txt" ] [ text <| t "Поиск" ], text ": " ]
        , span [] [ text value ]
        ]


startCapacity { t } value =
    div [ class "content-item" ]
        [ span [ class "name" ] [ text <| t "config.Начальная емкость батареи", text ":" ]
        , span [ class "text" ] [ text value, text " mAh" ]
        ]


beginAt { t } value =
    div [ class "content-item" ]
        [ span [ class "name" ] [ text <| t "config.Начало эксплуатации", text ":" ]
        , span [ class "text" ] [ text value ]
        ]


totalTime { t } value =
    div [ class "content-item" ]
        [ span [ class "name" ] [ text <| t "config.Общее время эксплуатации", text ":" ]
        , span [ class "text" ] [ text value ]
        ]


usedBattery { t } value =
    div [ class "content-item" ]
        [ span [ class "name" ] [ text <| t "config.Израсходовано энергии батареи", text ":" ]
        , span [ class "text" ] [ text value, text " mAh" ]
        ]


footer { t } battery =
    div [ class "details-footer setting-footer" ]
        [ button [ class "orange-gradient-text cursor-pointer details-footer-btn modal-change-battery-btn", onClick (OnBatteryChange <| BC_Change "5800") ]
            [ span [ class "image icon-battery orange-gradient-text" ] [], text <| t "config.Замена батареи" ]
        , button [ class "blue-text cursor-pointer details-footer-btn modal-change-capacity-btn", onClick (OnBatteryChange <| BC_Capacity <| String.fromFloat battery.init_capacity) ]
            [ span [ class "image icon-change_battery" ] [], text <| t "config.Изменить начальную емкость" ]
        ]


batteryWidget percentage =
    let
        colour =
            powerLevelClass percentage

        p_as_text =
            (percentage |> Round.round 1) ++ "%"

        -- TDP
        -- div [ class "power-status" ]
        --     [ span [ class "power" ]
        --         [ span [ class "power-top" ] []
        --         , span [ class "power-wr" ]
        --             [ span [ class "power-bg high", attribute "style" "height: 80%" ]
        --                 [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
        --                     [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] []
        --                     ]
        --                 ]
        --             ]
        --         ]
        --     , div [ class "power-status-title high" ] [ text "(TBD)85%" ]
        --     ]
    in
    div [ class "power-status" ]
        [ span [ class "power" ]
            [ span [ class "power-top" ] []
            , span [ class "power-wr" ]
                [ span [ class "power-bg", class colour, attribute "style" ("height: " ++ height percentage) ]
                    [ svg [ attribute "preserveAspectRatio" "xMinYMin meet", viewBox "0 0 500 500" ]
                        [ path [ d "M0, 100 C150, 200 350, 0 500, 100 L500, 00 L0, 0 Z", attribute "style" "stroke:none; fill: #323343;" ] [] ]
                    ]
                ]
            ]
        , div [ class "power-status-title", class colour ] [ text p_as_text ]
        ]



-- icon4Fenix : String -> String
-- icon4Fenix


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
