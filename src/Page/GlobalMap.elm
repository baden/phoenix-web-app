module Page.GlobalMap exposing (Model, Msg(..), init, setCenter, update, view, viewSystem)

import API.Geo as Geo exposing (Address)
import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState
import Components.DateTime exposing (dateTimeFormat)
import Components.UI as UI
import Html exposing (Html, a, div, h1, img)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Html.Lazy exposing (lazy, lazy2)
import Http
import Json.Encode as Encode
import Msg as GMsg
import Types.Dt as DT


type alias Model =
    { center : ( Float, Float )
    , address : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { center = ( 48.5013798, 34.6234255 )
      , address = Nothing
      }
    , Cmd.none
    )


type Msg
    = SetCenter Float Float
    | GetAddress Float Float
    | ResponseAddress (Result Http.Error Address)


setCenter : ( Float, Float ) -> Model -> Model
setCenter newPos model =
    { model | center = newPos }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        SetCenter x y ->
            ( { model | center = ( x, y ) }, Cmd.none, Nothing )

        GetAddress lat lon ->
            ( model, Geo.getAddress ( lat, lon ) ResponseAddress, Nothing )

        ResponseAddress (Ok address) ->
            ( { model | address = Just <| Geo.addressToString address }, Cmd.none, Nothing )

        ResponseAddress (Err _) ->
            ( model, Cmd.none, Nothing )


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
    String.fromFloat lat ++ "," ++ String.fromFloat lng



-- encodeFloats : List Float -> Encode.Value
-- encodeFloats list =
--     Encode.list (List.map Encode.float list)


encodeLatLong : Float -> Float -> Encode.Value
encodeLatLong lat lon =
    Encode.list Encode.float [ lat, lon ]


viewSystem : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
viewSystem appState model system =
    let
        ( lat, lon ) =
            case system.dynamic of
                Nothing ->
                    model.center

                Just dynamic ->
                    case ( dynamic.latitude, dynamic.longitude ) of
                        ( Just latitude, Just longitude ) ->
                            ( latitude, longitude )

                        _ ->
                            model.center
    in
    div []
        [ --div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
          lazy2 mapAt lat lon
        , div [ class "control" ]
            [ -- , div [] [ Html.text <| "Центр: " ++ (String.fromFloat lat) ++ ", " ++ (String.fromFloat lon) ]
              -- , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.4226036 35.0252341) ]
              --     [ Html.text "На высоковольтную" ]
              -- , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.5013798 34.6234255) ]
              --     [ Html.text "Домой" ]
              div []
                [ Html.text system.title
                , div [] (sysPosition appState system.id system.dynamic model.address)
                ]
            , UI.linkIconTextButton "gamepad" "Управление" ("/system/" ++ system.id)
            , UI.linkIconTextButton "clone" "Выбрать объект" "/"
            ]
        ]


sysPosition : AppState.AppState -> String -> Maybe System.Dynamic -> Maybe String -> List (Html Msg)
sysPosition appState sid maybe_dynamic maddress =
    case maybe_dynamic of
        Nothing ->
            []

        Just dynamic ->
            case ( dynamic.latitude, dynamic.longitude, dynamic.dt ) of
                ( Just latitude, Just longitude, Just dt ) ->
                    [ UI.row_item
                        [ Html.text <| "Последнее положение определено " ++ (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ++ " "

                        -- , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter latitude longitude) ] [ Html.text "Центровать" ]
                        , Html.button [ class "btn blue-btn", onClick (GetAddress latitude longitude) ] [ Html.text "?" ]
                        ]
                    , case maddress of
                        Nothing ->
                            Html.text ""

                        Just address ->
                            UI.row_item [ Html.text address ]
                    ]

                ( _, _, _ ) ->
                    [ UI.row_item [ Html.text <| "Положение неизвестно" ] ]


mapAt : Float -> Float -> Html Msg
mapAt lat lon =
    Html.node "leaflet-map"
        [ --Html.Attributes.attribute "data-map-center" (latLng2String model.center)
          Html.Attributes.property "center" (encodeLatLong lat lon)
        ]
        []
