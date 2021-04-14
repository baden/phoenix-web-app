module Page.GlobalMap exposing (Model, Msg(..), init, setCenter, update, view, viewSystem)

-- import Elm.Kernel.Json

import API
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
import Process
import Task
import Types.Dt as DT


type alias Model =
    { center : LatLng
    , address : Maybe String
    , showAddress : Bool
    , markers : List Marker
    }


init : Maybe String -> Maybe String -> Maybe String -> ( Model, Cmd Msg )
init mSysId mlat mlng =
    ( { center = LatLng (mlat |> mstr2float 48.5013798) (mlng |> mstr2float 34.6234255)
      , address = Nothing
      , showAddress = False
      , markers = []
      }
    , Cmd.batch [ initTask mSysId ]
    )


mstr2float d v =
    v |> Maybe.withDefault "x" |> String.toFloat |> Maybe.withDefault d


getTrack : String -> Int -> Int -> Cmd Msg
getTrack sysId from to =
    API.websocketOut <| System.getTrack sysId from to


type Msg
    = SetCenter LatLng
    | GetAddress LatLng
    | ResponseAddress (Result Http.Error Address)
    | HideAddress
    | CenterChanged LatLng
    | Init String
    | GetTrack String Int Int
    | HideTrack String


initTask : Maybe String -> Cmd Msg
initTask mSysId =
    case mSysId of
        Nothing ->
            -- TDB: Сейчас глобальная карта со всеми системами не реализована
            Cmd.none

        Just sysId ->
            Process.sleep 1000 |> Task.perform (\_ -> Init sysId)


setCenter : LatLng -> Model -> Model
setCenter newPos model =
    { model | center = newPos }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        Init sysId ->
            -- let
            --     _ =
            --         Debug.log "Init map" 0
            -- in
            ( model, Cmd.batch [ API.websocketOut <| System.getHours sysId ], Nothing )

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

        GetTrack sysId from to ->
            -- TODO: Индикатор загрузки трека
            ( model, getTrack sysId from to, Nothing )

        HideTrack sysId ->
            ( model, Cmd.none, Just <| GMsg.HideTrack sysId )

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


encodeTrackPoint : System.TrackPoint -> Encode.Value
encodeTrackPoint =
    Encode.list Encode.float


encodeTrack : System.SystemDocumentTrack -> Encode.Value
encodeTrack { from, to, track } =
    Encode.object
        [ ( "from", Encode.int from )
        , ( "to", Encode.int to )
        , ( "track", Encode.list encodeTrackPoint track )

        -- , ( "track", Encode.list (Encode.list Encode.float track) )
        ]


viewSystem : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe System.SystemDocumentTrack -> Html Msg
viewSystem appState model system mtrack =
    let
        --     center =
        --         case system.dynamic of
        --             Nothing ->
        --                 model.center
        --
        --             Just dynamic ->
        --                 case ( dynamic.latitude, dynamic.longitude ) of
        --                     ( Just latitude, Just longitude ) ->
        --                         LatLng latitude longitude
        --
        --                     _ ->
        --                         model.center
        track =
            mtrack |> Maybe.withDefault (System.SystemDocumentTrack 0 0 [])

        markers =
            case system.dynamic of
                Nothing ->
                    []

                Just dynamic ->
                    case ( dynamic.latitude, dynamic.longitude ) of
                        ( Just latitude, Just longitude ) ->
                            [ Marker (LatLng latitude longitude) "TBD" ]

                        _ ->
                            []
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
        [ --mapAt model.center model.markers
          -- mapAt model.center markers
          Html.node "leaflet-map"
            [ --Html.Attributes.attribute "data-map-center" (latLng2String model.center)
              Html.Attributes.property "center" (encodeLatLng model.center)
            , Html.Attributes.property "markers" (Encode.list encodeMarker markers)
            , Html.Attributes.property "title" (Encode.string system.title)
            , Html.Attributes.property "track" (encodeTrack track)
            , Html.Events.on "centerChanged" <| Decode.map CenterChanged <| Decode.at [ "target", "center" ] <| decodeLatLng
            ]
            []
        , div [ class "map-debug" ]
            [ div [] [ text <| "Position: " ++ String.fromFloat model.center.lat ++ ", " ++ String.fromFloat model.center.lng ]
            , div [ class "map-bottom-control" ]
                [ div [ class "map-bottom-control-btn", onClick (GetTrack system.id 449541 449564) ] [ text "Трек за сегодня" ]
                , div [ class "map-bottom-control-btn", onClick (HideTrack system.id) ] [ text "Скрыть трек" ]
                ]
            ]
        , div [ class "locations" ]
            -- [ span [ class "locations-btn open-locations", onClick (SetCenter 48.4226036 35.0252341) ]
            [ case markers of
                [ { pos } ] ->
                    span [ class "locations-btn open-locations", onClick (GetAddress pos) ] [ span [ class "icon-location" ] [] ]

                _ ->
                    text ""
            , span [ class "tracking" ] [ text "Сегодня" ]
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
