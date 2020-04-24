module Components.ChartSvg exposing (chartSvg)

import Html exposing (Html)
import Html.Attributes as HA
import Svg exposing (svg, path, text_)
import Svg.Attributes exposing (viewBox, class, d, strokeDasharray, x, y)


-- chartView : String -> Float -> Html a
-- chartView title percentage =
--     chartSvg percentage


chartSvg : Float -> String -> String -> Html a
chartSvg percentage ptext colour =
    let
        -- В теории этого никогда не будет. Информация о батарее должна подтягиваться после первого же включения.
        progressBar =
            if percentage > 0 then
                [ path
                    [ class <| "circle " ++ colour
                    , d <| circlePath 18 18 15
                    , strokeDasharray <| (String.fromFloat percentage) ++ ", 100"
                    ]
                    []
                ]
            else
                []
    in
        Html.div
            [ HA.class "single-chart" ]
            [ svg
                [ class "circular-chart chart_green", viewBox "0 0 36 36" ]
              <|
                [ path
                    [ class "circle-bg", d <| circlePath 18 18 15 ]
                    []
                , text_
                    [ class "percentage", x "18", y "25.35" ]
                    [ Svg.text ptext ]
                ]
                    ++ progressBar
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
