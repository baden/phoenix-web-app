module Page.System.Info exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI
import API.System exposing (SystemDocumentInfo, SysState)


view : SystemDocumentInfo -> Html a
view system =
    div []
        [ div [] [ text "Информация о системе" ]
        , div [] [ text <| "Id:" ++ system.id ]
        , div [] [ ChartSvg.chartView "Батарея" 80 ]
        , div [] [ text <| "Состояние: " ++ (sysState_of system.state) ]
        , div [] [ text <| "Доступные состояния: " ++ (sysAvailable_of system.state) ]
        , div [] [ text "Следующий сеанс связи через 04:25" ]
        , UI.button ("/map/" ++ system.id) "Посмотреть последнее положение на карте"
        , a [ class "button", href "/" ] [ text "На главную" ]
        ]


sysState_of : Maybe SysState -> String
sysState_of sysState =
    case sysState of
        Nothing ->
            "-"

        Just state ->
            (state.current)


sysAvailable_of : Maybe SysState -> String
sysAvailable_of sysState =
    case sysState of
        Nothing ->
            "-"

        Just state ->
            state.available
                |> List.foldl (\i acc -> i ++ "," ++ acc) ""
