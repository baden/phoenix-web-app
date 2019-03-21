module Page.GlobalMap exposing (Model, Msg(..), init, update, view, viewSystem)

import Html exposing (Html, div, img, a, h1)
import Html.Attributes exposing (class, src, href)
import Html.Events exposing (onClick)
import Json.Encode as Encode


type alias Model =
    { center : ( Float, Float )
    }


init : ( Model, Cmd Msg )
init =
    ( { center = ( 48.5013798, 34.6234255 )
      }
    , Cmd.none
    )


type Msg
    = SetCenter Float Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetCenter x y ->
            ( { model | center = ( x, y ) }, Cmd.none )


view : Html a
view =
    div []
        [ Html.node "leaflet-map" [] []
        , div [ class "control" ]
            [ a [ href "/login" ] [ Html.text "Выйти" ]
            ]
        ]


latLng2String : ( Float, Float ) -> String
latLng2String ( lat, lng ) =
    (String.fromFloat lat) ++ "," ++ (String.fromFloat lng)


viewSystem : Model -> Html Msg
viewSystem model =
    div []
        [ --div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
          Html.node "leaflet-map"
            [ Html.Attributes.attribute "data-map-center" (latLng2String model.center)
            ]
            []
        , div [ class "control" ]
            [ a [ href "/login" ] [ Html.text "Выйти" ]
            , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.4226036 35.0252341) ]
                [ Html.text "На высоковольтную" ]
            , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.5013798 34.6234255) ]
                [ Html.text "Домой" ]
            ]
        ]
