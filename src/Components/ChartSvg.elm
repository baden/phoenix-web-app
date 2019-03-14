module Components.ChartSvg exposing (chartView)

import Html
import Html.Attributes
import Element exposing (..)
import Svg
import Svg.Attributes


chartView : String -> Float -> Element.Element a
chartView title percentage =
    Element.column
        [ centerX, height (fill |> minimum 200) ]
        [ html <| chartSvg percentage
        , row [ centerX ]
            [ Element.html <| Html.i [ Html.Attributes.class "fas fa-battery-full" ] []
            , Element.text <| " " ++ title
            ]
        ]


chartSvg : Float -> Html.Html a
chartSvg percentage =
    Html.div
        [ Html.Attributes.class "flex-wrapper" ]
        [ Html.div
            [ Html.Attributes.class "single-chart" ]
            [ Svg.svg
                [ Svg.Attributes.class "circular-chart green"
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
                    , Svg.Attributes.y "21.35"
                    ]
                    [ Svg.text "80%" ]
                ]
            ]
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
