module Components.ChartSvg exposing (chartView)

import Html exposing (..)
import Html.Attributes as HA
import Svg
import Svg.Attributes


chartView : String -> Float -> Html a
chartView title percentage =
    chartSvg percentage


chartSvg : Float -> Html a
chartSvg percentage =
    Html.div
        [ HA.class "single-chart" ]
        [ Svg.svg
            [ Svg.Attributes.class "circular-chart chart_green"
            , Svg.Attributes.viewBox "0 0 36 36"
            ]
            [ Svg.path
                [ Svg.Attributes.class "circle-bg"
                , Svg.Attributes.d <| circlePath 18 18 15
                ]
                []
            , Svg.path
                [ Svg.Attributes.class "circle"
                , Svg.Attributes.d <| circlePath 18 18 15
                , Svg.Attributes.strokeDasharray <| (String.fromFloat percentage) ++ ", 100"
                ]
                []
            , Svg.text_
                [ Svg.Attributes.class "percentage"
                , Svg.Attributes.x "18"
                , Svg.Attributes.y "25.35"
                ]
                [ Svg.text "80%" ]
            ]
        , Html.div [ HA.class "title" ] [ Html.i [ HA.class "fas fa-battery-full" ] [] ]
        ]


circlePath : Float -> Float -> Float -> String
circlePath cx cy r =
    "M "
        ++ (String.fromFloat cx)
        ++ " "
        ++ (String.fromFloat <| cy - r)
        ++ " a "
        ++ (String.fromFloat r)
        ++ " "
        ++ (String.fromFloat r)
        ++ " 0 0 1 0 "
        ++ (String.fromFloat <| r * 2)
        ++ "   a "
        ++ (String.fromFloat r)
        ++ " "
        ++ (String.fromFloat r)
        ++ " 0 0 1 0 "
        ++ (String.fromFloat <| r * -2)
