module Page.System.Info exposing (view)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI


view : String -> Html a
view id =
    div []
        [ div [] [ text "Информация о системе" ]
        , div [] [ text <| "Id:" ++ id ]
        , div [] [ ChartSvg.chartView "Батарея" 80 ]
        , div [] [ text "Следующий сеанс связи через 04:25" ]
        , UI.button ("/map/" ++ id) "Посмотреть последнее положение на карте"
        , a [ class "button", href "/" ] [ text "На главную" ]
        ]
