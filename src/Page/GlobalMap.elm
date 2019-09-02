module Page.GlobalMap exposing (Model, Msg(..), init, update, view, viewSystem)

import Html exposing (Html, div, img, a, h1)
import Html.Lazy exposing (lazy, lazy2)
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
    let
        _ =
            Debug.log "GlobalMap update" ( msg, model )
    in
        case msg of
            SetCenter x y ->
                ( { model | center = ( x, y ) }, Cmd.none )


view : Html a
view =
    div []
        [ Html.node "leaflet-map" [] []
        , div [ class "control" ]
            [ a [ href "/" ] [ Html.text "На гравную" ]
            ]
        ]


latLng2String : ( Float, Float ) -> String
latLng2String ( lat, lng ) =
    (String.fromFloat lat) ++ "," ++ (String.fromFloat lng)



-- encodeFloats : List Float -> Encode.Value
-- encodeFloats list =
--     Encode.list (List.map Encode.float list)


encodeLatLong : Float -> Float -> Encode.Value
encodeLatLong lat lon =
    Encode.list Encode.float [ lat, lon ]


viewSystem : Model -> Html Msg
viewSystem model =
    let
        ( lat, lon ) =
            model.center

        _ =
            Debug.log "viewSystem" model
    in
        div []
            [ --div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
              lazy2 mapAt lat lon
            , div [ class "control" ]
                [ a [ href "/" ] [ Html.text "На главную" ]
                , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.4226036 35.0252341) ]
                    [ Html.text "На высоковольтную" ]
                , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.5013798 34.6234255) ]
                    [ Html.text "Домой" ]
                ]
            ]


mapAt : Float -> Float -> Html Msg
mapAt lat lon =
    Html.node "leaflet-map"
        [ --Html.Attributes.attribute "data-map-center" (latLng2String model.center)
          Html.Attributes.property "center" (encodeLatLong lat lon)
        ]
        []
