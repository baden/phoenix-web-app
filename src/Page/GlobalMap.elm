module Page.GlobalMap exposing (Model, Msg(..), init, setCenter, update, view, viewSystem)

-- import Elm.Kernel.Json

import API
import API.GPS as GPS
import API.Geo as Geo exposing (Address)
import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState
import Components.DateTime exposing (dateTimeFormat)
import Components.UI as UI
import Components.UI.Calendar as Calendar
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
import Time
import Types.Dt as DT
import Url.Builder as UB


type alias Model =
    { center : LatLng
    , address : Maybe String
    , showAddress : Bool
    , markers : List Marker

    -- , track : List System.TrackPoint
    -- Теперь это просто день, строкой
    -- , track : String
    -- Мне не нравится что тут часы а не дни. Как-то бы это преобразовать на этапе загрузки
    -- , hours : List Int
    , calendar : Calendar.Model
    }


init : Maybe String -> Maybe String -> Maybe String -> Maybe String -> ( Model, Cmd Msg )
init mSysId mlat mlng mday =
    -- let
    --     _ =
    --         Debug.log "Map init" ( mSysId, ( mlat, mlng ), mday )
    -- in
    ( { center = LatLng (mlat |> mstr2float 48.5013798) (mlng |> mstr2float 34.6234255)
    -- ( { center = LatLng (mlat |> mstr2float 0.0) (mlng |> mstr2float 0.0)
      , address = Nothing
      , showAddress = False
      , markers = []

      -- , track = mday |> Maybe.withDefault ""
      -- , hours = []
      , calendar = Calendar.init mSysId
      }
    , Cmd.batch [ initTask mSysId ]
    )


initTask : Maybe String -> Cmd Msg
initTask mSysId =
    case mSysId of
        Nothing ->
            -- TDB: Сейчас глобальная карта со всеми системами не реализована
            Cmd.none

        Just sysId ->
            Process.sleep 1000 |> Task.perform (\_ -> Init sysId)


mstr2float d v =
    v |> Maybe.withDefault "x" |> String.toFloat |> Maybe.withDefault d



-- getTrack : String -> Int -> Int -> Cmd Msg
-- getTrack sysId from to =
--     -- API.websocketOut <| System.getTrack sysId from to
--     -- GPS.getBinTrack from to |> Cmd.map GetBinTrack
--     TrackRec sysId


type Msg
    = SetCenter LatLng
    | GetAddress LatLng
    | ResponseAddress (Result Http.Error Address)
    | HideAddress
    | CenterChanged LatLng
    | Init String
      -- | GetTrack String String
      -- | HideTrack String
    | GPSMsg GPS.Msg
    | CalendarMsg Calendar.Msg


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
            -- ( model, Cmd.batch [ API.websocketOut <| System.getHours sysId ], Nothing )
            ( model, Cmd.batch [ GPS.getHours sysId |> Cmd.map GPSMsg ], Nothing )

        SetCenter newPos ->
            ( { model | center = newPos }, Cmd.none, Nothing )

        GetAddress { lat, lng } ->
            ( { model
                | showAddress = True
                , center = LatLng lat lng
                , markers = [ Marker (LatLng lat lng) "???" "car" ]
              }
            , Geo.getAddress ( lat, lng ) ResponseAddress
            , Nothing
            )

        -- GetTrack sysId day ->
        --     -- TODO: Индикатор загрузки трека
        --     ( { model | track = day }, Cmd.none, Nothing )
        -- HideTrack sysId ->
        --     -- ( model, Cmd.none, Just <| GMsg.HideTrack sysId )
        --     ( { model | track = "" }, Cmd.none, Just <| GMsg.HideTrack sysId )
        ResponseAddress (Ok address) ->
            ( { model | address = Just <| Geo.addressToString address }, Cmd.none, Nothing )

        ResponseAddress (Err _) ->
            ( model, Cmd.none, Nothing )

        HideAddress ->
            ( { model | showAddress = False }, Cmd.none, Nothing )

        CenterChanged newPos ->
            ( { model | center = newPos }, Cmd.none, Nothing )

        GPSMsg (GPS.GotHours (Ok d)) ->
            let
                -- _ =
                --     Debug.log "GotHours (TODO: как-то нужно преобразовать в дни)" d
                cmodel =
                    model.calendar |> Calendar.update (Calendar.LoadHours d.hours) |> Tuple.first
            in
            -- ( { model | track = d }, Cmd.none, Nothing )
            ( { model | calendar = cmodel }, Cmd.none, Nothing )

        GPSMsg (GPS.GotHours (Err _)) ->
            -- let
            --     _ =
            --         Debug.log "Error GetBinTrack" 0
            -- in
            ( model, Cmd.none, Nothing )

        CalendarMsg sub_msg ->
            let
                ( cmodel, cmsg ) =
                    model.calendar |> Calendar.update sub_msg
            in
            -- Может и не самое элегантное решение
            case sub_msg of
                -- Calendar.LoadTrack day_string ->
                --     -- let
                --     --     _ =
                --     --         Debug.log "LoadTrack" day_string
                --     -- in
                --     -- GetTrack
                --     ( { model | calendar = cmodel, track = day_string }, cmsg |> Cmd.map CalendarMsg, Nothing )
                _ ->
                    ( { model | calendar = cmodel }, cmsg |> Cmd.map CalendarMsg, Nothing )


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
-- type alias TrackRec =
--     { sysId : String
--
--     -- , from : Int
--     , day : String
--     }


encodeTrack : String -> String -> Encode.Value
encodeTrack sysId day =
    -- encodeTrack { from, to, track } =
    Encode.object
        [ ( "sysId", Encode.string sysId )
        , ( "day", Encode.string day )
        ]



-- Encode.list System.encodeTrackPoint track


viewSystem : AppState.AppState -> Model -> SystemDocumentInfo -> Maybe String -> Html Msg
viewSystem appState model system mday =
    let
        markers =
            case system.dynamic of
                Nothing ->
                    []

                Just dynamic ->
                    case ( dynamic.latitude, dynamic.longitude ) of
                        ( Just latitude, Just longitude ) ->
                            [ Marker (LatLng latitude longitude) system.title system.icon ]

                        _ ->
                            []

        -- _ =
        --     Debug.log "map:view day" mday
    in
    div [ class "container-map" ]
        [ Html.node "leaflet-map"
            [ --Html.Attributes.attribute "data-map-center" (latLng2String model.center)
              Html.Attributes.property "center" (encodeLatLng model.center)
            , Html.Attributes.property "markers" (Encode.list encodeMarker markers)
            , Html.Attributes.property "title" (Encode.string system.title)
            , Html.Attributes.property "track" (encodeTrack system.id (mday |> Maybe.withDefault ""))
            , Html.Events.on "centerChanged" <| Decode.map CenterChanged <| Decode.at [ "target", "center" ] <| decodeLatLng
            ]
            []
        , --div [] [ text <| "Position: " ++ String.fromFloat model.center.lat ++ ", " ++ String.fromFloat model.center.lng ]
          div [ class "map-bottom-control" ]
            [ -- div [ class "map-bottom-control-btn", onClick (GetTrack system.id "10/05/2021") ] [ text "Трек за сегодня" ]
              -- [ div [ class "map-bottom-control-btn", onClick (GetTrack system.id 450045 450188) ] [ text "Трек за сегодня" ]
              -- div [ class "map-bottom-control-btn" ] [ Calendar.view appState model.calendar |> Html.map CalendarMsg ]
              Calendar.view appState system.id mday model.calendar |> Html.map CalendarMsg

            -- , div [ class "map-debug" ] [ text "Центр: " ]
            -- , div [ class "map-bottom-control-btn", onClick (HideTrack system.id) ] [ text "X" ]
            -- , div [] [ a [ href <| UB.absolute [ "map", system.id ] [] ] [ text "Тест роутинга пустой карты" ] ]
            -- , div [] [ a [ href <| UB.absolute [ "map", system.id ] [ UB.string "day" "08/05/2021" ] ] [ text "Тест роутинга карты с днем" ] ]
            ]
        , div [ class "locations" ]
            -- [ span [ class "locations-btn open-locations", onClick (SetCenter 48.4226036 35.0252341) ]
            [ case markers of
                [ { pos } ] ->
                    span [ class "locations-btn open-locations", onClick (GetAddress pos) ] [ span [ class "icon-location" ] [] ]

                _ ->
                    text ""

            -- , span [ class "tracking" ] [ text "Сегодня" ]
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
                        [ Html.text <| (appState.t "map.Последнее положение определено ") ++ (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ++ " "

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
