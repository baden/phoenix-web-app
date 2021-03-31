module Page.GlobalMap exposing (Model, Msg(..), init, setCenter, update, view, viewSystem)

import API.Geo as Geo exposing (Address)
import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState
import Components.DateTime exposing (dateTimeFormat)
import Components.UI as UI
import Html exposing (Html, a, div, h1, img, span, text)
import Html.Attributes exposing (class, classList, href, src)
import Html.Events exposing (onClick)
import Html.Lazy exposing (lazy, lazy2)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Msg as GMsg
import Page.Map.Types exposing (..)
import Types.Dt as DT


type alias Model =
    { center : LatLng
    , address : Maybe String
    , showAddress : Bool
    , markers : List Marker
    }


init : ( Model, Cmd Msg )
init =
    ( { center = LatLng 48.5013798 34.6234255
      , address = Nothing
      , showAddress = False
      , markers = []
      }
    , Cmd.none
    )


type Msg
    = SetCenter LatLng
    | GetAddress LatLng
    | ResponseAddress (Result Http.Error Address)
    | HideAddress
    | CenterChanged LatLng


setCenter : LatLng -> Model -> Model
setCenter newPos model =
    { model | center = newPos }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        SetCenter newPos ->
            ( { model | center = newPos }, Cmd.none, Nothing )

        GetAddress { lat, lng } ->
            ( { model
                | showAddress = True
                , center = LatLng lat lng
                , markers = [ Marker (LatLng lat lng) "TBD" ]
              }
            , Geo.getAddress ( lat, lng ) ResponseAddress
            , Nothing
            )

        ResponseAddress (Ok address) ->
            ( { model | address = Just <| Geo.addressToString address }, Cmd.none, Nothing )

        ResponseAddress (Err _) ->
            ( model, Cmd.none, Nothing )

        HideAddress ->
            ( { model | showAddress = False }, Cmd.none, Nothing )

        CenterChanged newPos ->
            ( { model | center = newPos }, Cmd.none, Nothing )


view : Html a
view =
    div []
        [ Html.node "leaflet-map" [] []
        , div [ class "control" ]
            [ a [ href "/" ] [ Html.text "На гравную" ]
            ]
        ]


latLng2String : LatLng -> String
latLng2String { lat, lng } =
    String.fromFloat lat ++ "," ++ String.fromFloat lng



-- encodeFloats : List Float -> Encode.Value
-- encodeFloats list =
--     Encode.list (List.map Encode.float list)


viewSystem : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
viewSystem appState model system =
    let
        center =
            case system.dynamic of
                Nothing ->
                    model.center

                Just dynamic ->
                    case ( dynamic.latitude, dynamic.longitude ) of
                        ( Just latitude, Just longitude ) ->
                            LatLng latitude longitude

                        _ ->
                            model.center
    in
    -- div []
    -- [ --div [ class "leaflet-map", Html.Attributes.property "center" (Encode.string "35.0, 48.0") ] []
    -- lazy2 mapAt lat lon
    -- , div [ class "control" ]
    -- [ -- , div [] [ Html.text <| "Центр: " ++ (String.fromFloat lat) ++ ", " ++ (String.fromFloat lon) ]
    -- -- , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.4226036 35.0252341) ]
    -- --     [ Html.text "На высоковольтную" ]
    -- -- , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter 48.5013798 34.6234255) ]
    -- --     [ Html.text "Домой" ]
    -- div []
    -- [ Html.text system.title
    -- , div [] (sysPosition appState system.id system.dynamic model.address)
    -- ]
    -- , UI.linkIconTextButton "gamepad" "Управление" ("/system/" ++ system.id)
    -- , UI.linkIconTextButton "clone" "Выбрать объект" "/"
    -- ]
    -- ]
    div [ class "container-map" ]
        -- [ lazy mapAt center
        [ mapAt model.center model.markers
        , div [ class "map-debug" ] [ text <| "Position: " ++ String.fromFloat model.center.lat ++ ", " ++ String.fromFloat model.center.lng ]
        , div [ class "locations" ]
            -- [ span [ class "locations-btn open-locations", onClick (SetCenter 48.4226036 35.0252341) ]
            [ span [ class "locations-btn open-locations", onClick (GetAddress center) ]
                [ span [ class "icon-location" ] [] ]
            , div [ class "locations-wr", classList [ ( "show", model.showAddress ) ] ]
                [ div [ class "locations-notifications" ]
                    [ span [ class "image icon-location" ] []
                    , span [ class "content" ]
                        [ span [ class "title" ] <| sysPosition appState system.id system.dynamic model.address

                        -- , span [ class "text" ]
                        --     [ text "Положение определено:"
                        --     , span [ class "date" ] [ text "14 Июн 18:22" ]
                        --     ]
                        ]
                    , span [ class "locations-notifications-close close-locations", onClick HideAddress ] []
                    ]
                ]
            ]
        ]


mapAt : LatLng -> List Marker -> Html Msg
mapAt center markers =
    Html.node "leaflet-map"
        [ --Html.Attributes.attribute "data-map-center" (latLng2String model.center)
          Html.Attributes.property "center" (encodeLatLng center)
        , Html.Attributes.property "markers" (Encode.list encodeMarker markers)
        , Html.Events.on "centerChanged" <| Decode.map CenterChanged <| Decode.at [ "target", "center" ] <| decodeLatLng
        ]
        []


sysPosition : AppState.AppState -> String -> Maybe System.Dynamic -> Maybe String -> List (Html Msg)
sysPosition appState sid maybe_dynamic maddress =
    case maybe_dynamic of
        Nothing ->
            [ Html.text <| "Данные от трекера еще не получены" ]

        Just dynamic ->
            case ( dynamic.latitude, dynamic.longitude, dynamic.dt ) of
                ( Just latitude, Just longitude, Just dt ) ->
                    [ UI.row_item
                        [ Html.text <| "Последнее положение определено " ++ (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ++ " "

                        -- , Html.button [ class "waves-effect waves-light btn", onClick (SetCenter latitude longitude) ] [ Html.text "Центровать" ]
                        ]
                    , case maddress of
                        Nothing ->
                            Html.text ""

                        Just address ->
                            UI.row_item [ Html.text address ]
                    ]

                ( _, _, _ ) ->
                    [ UI.row_item [ Html.text <| "Положение неизвестно" ] ]
