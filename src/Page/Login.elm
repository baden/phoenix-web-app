module Page.Login exposing (Model, Msg(..), init, update, view)

import Element exposing (..)
import Element.Input as Input
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border


type alias Model =
    { username : String
    }


type Msg
    = OnName String


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnName val ->
            ( { model | username = val }, Cmd.none )


view : Model -> Element Msg
view model =
    column
        [ spacing 20
        , height fill
        , width (fillPortion 50)
        ]
        [ (Element.text "Авторизация")
        , (Input.text []
            { onChange = OnName
            , text = model.username
            , placeholder = Just (Input.placeholder [] (text "username"))
            , label = Input.labelHidden "Solution"
            }
          )
        , Input.button
            [ Background.color blue
            , Font.color white
            , Border.color darkBlue
            , paddingXY 32 16
            , Border.rounded 3
            , width fill
            ]
            { onPress = Nothing
            , label = Element.text <| "Авторизоваться как " ++ model.username
            }
        ]



-- Private


blue =
    Element.rgb 0 0 0.8


white =
    Element.rgb 1 1 1


darkBlue =
    Element.rgb 0 0 0.9
