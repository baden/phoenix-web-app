module Page.Properties exposing (..)

import Html exposing (Html)


type alias Model =
    {}


type Msg
    = NoOp


view : Model -> Html Msg
view model =
    Html.text "В разработке..."
