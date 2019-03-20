module Components.UI exposing (button, formHeader, formInput, formPassword, formButton)

import Html exposing (Html, h1, div, a, text, i)
import Html.Attributes exposing (class, href)
import Element exposing (..)
import Element.Region as Region
import Element.Font as Font
import Element.Input as Input
import Element.Background as Background
import Element.Border as Border


-- type Styles
--     = None
--
--
-- stylesheet : StyleSheet Styles variation
-- stylesheet =
--     Style.stylesheet
--         [ style None [] ]


addClass name =
    htmlAttribute (Html.Attributes.class name)


button : String -> String -> Element a
button url label =
    Element.html
        (a [ class "waves-effect waves-light btn", href url ]
            [ Html.div [] [ Html.text label ] ]
        )



-- Element.link
--     -- url
--     [ addClass "waves-effect waves-light btn", centerX ]
--     { url = url
--     , label = Element.text label
--     }
-- Element.html <|
--     Html.a
--         [ class "btn-floating pulse", href url ]
--         [ Html.i [ class "material-icons" ] [ Html.text "menu" ]
--         ]


formHeader : String -> Element m
formHeader title =
    el
        [ Region.heading 1
        , width fill

        -- , centerX
        -- , alignLeft
        , Font.size 36
        , mouseOver
            [ Font.color (rgba 0.3 0.4 0.6 0.5) ]
        , padding 12
        ]
        (Element.text title)


formInput : String -> String -> (String -> msg) -> Element msg
formInput title input update =
    Input.text [ Input.focusedOnLoad ]
        { onChange = update
        , text = input
        , placeholder = Just (Input.placeholder [] (Element.text title))
        , label = Input.labelHidden title
        }


formPassword : String -> String -> (String -> msg) -> Element msg
formPassword title input update =
    Input.currentPassword []
        { onChange = update
        , text = input
        , placeholder = Just (Input.placeholder [] (Element.text title))
        , label = Input.labelHidden title
        , show = False
        }


formButton : String -> Maybe String -> Maybe msg -> Element msg
formButton title enabled update =
    case enabled of
        Nothing ->
            (Input.button
                [ Background.color blue
                , Font.color white
                , Border.color darkBlue
                , paddingXY 32 16
                , Border.rounded 3
                , width (fill |> maximum 400)
                ]
                { onPress = update
                , label = Element.text <| title
                }
            )

        Just text_ ->
            (Element.text text_)


blue =
    Element.rgb 0 0 0.8


white =
    Element.rgb 1 1 1


darkBlue =
    Element.rgb 0 0 0.9
