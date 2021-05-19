module API.GPS exposing (..)

-- import Bytes exposing (Bytes, Endianness(..))
-- import Bytes.Decode as Decode exposing (Decoder, andThen, unsignedInt16, unsignedInt32, unsignedInt8)

import API.System exposing (SystemDocumentTrack, TrackPoint)
import Http
import Json.Decode as JD exposing (Decoder, int, list, map, oneOf, string)
import Json.Decode.Pipeline exposing (required)


type
    Msg
    -- = GotData (Result Http.Error (List TrackPoint))
    = GotHours (Result Http.Error HoursResp)



-- = GotData (Result Http.Error SystemDocumentTrack)
-- type alias Data =
--     { fsourse : Int
--     , sats : Int
--     , dt : Int
--     , latLng : LatLng
--     , speed : Float
--     , dir : Int
--     }


type alias HoursResp =
    { system : String
    , from : Int
    , to : Int
    , hours : List Int
    }


decodeHoursResp : Decoder HoursResp
decodeHoursResp =
    JD.succeed HoursResp
        |> required "system" string
        |> required "from" toInt
        |> required "to" toInt
        |> required "hours" (list int)


toInt : Decoder Int
toInt =
    oneOf
        [ int
        , map (String.toInt >> Maybe.withDefault 0) string
        ]


getHours : String -> Cmd Msg
getHours sysId =
    Http.riskyRequest
        { method = "GET"
        , headers = [ Http.header "Accept" "application/json" ]
        , url = "http://pil.fx.navi.cc/1.0/geos/" ++ sysId ++ "/hours?from=0&rand=1963672576&to=1000000&access_token=fenix_wip_token"
        , body = Http.emptyBody
        , expect = Http.expectJson GotHours decodeHoursResp
        , timeout = Nothing
        , tracker = Nothing
        }



-- getBinTrack : Int -> Int -> Cmd Msg
-- getBinTrack from to =
--     let
--         e =
--             -- Http.expectBytes GotData listDataDecoder
--             Http.expectBytesResponse GotData listBinaryDataDecoder
--     in
--     Http.riskyRequest
--         { method = "GET"
--         , headers = [ Http.header "Accept" "application/octet-stream" ]
--
--         -- , url = "http://pil.fx.navi.cc/1.0/geos/ODY3NTU2MDQ2MTkxOTE1?from=450045&to=450188&access_token=FpMdTdRtpNwFTv08pMt25WPZvbwbusTR"
--         -- , url = "http://pil.fx.navi.cc/1.0/geos/ODY3NTU2MDQ2MTkxOTE1?from=450045&to=450065&access_token=FpMdTdRtpNwFTv08pMt25WPZvbwbusTR"
--         , url = "http://pil.fx.navi.cc/1.0/geos/ODY3NTU2MDQ2MTkxOTE1?from=450045&to=450065&access_token=fenix_wip_token"
--         , body = Http.emptyBody
--         , expect = e
--         , timeout = Nothing
--         , tracker = Nothing
--         }
--
--
-- listBinaryDataDecoder : Http.Response Bytes.Bytes -> Result Http.Error (List TrackPoint)
-- listBinaryDataDecoder response =
--     case response of
--         Http.BadUrl_ u ->
--             Err (Http.BadUrl u)
--
--         Http.Timeout_ ->
--             Err Http.Timeout
--
--         Http.NetworkError_ ->
--             Err Http.NetworkError
--
--         Http.BadStatus_ metadata _ ->
--             Err (Http.BadStatus metadata.statusCode)
--
--         Http.GoodStatus_ meta body ->
--             -- Ok (Blob (Dict.get "content-type" meta.headers |> Maybe.withDefault "") body)
--             let
--                 _ =
--                     Debug.log "Good status" ( meta, Bytes.width body )
--             in
--             Ok <| newDataDecoder body
--
--
-- newDataDecoder : Bytes -> List TrackPoint
-- newDataDecoder body =
--     let
--         body_size =
--             Bytes.width body
--
--         _ =
--             Debug.log "Try to decode" body_size
--     in
--     Decode.decode (listDataDecoder body_size) body
--         |> Maybe.withDefault []
--
--
--
-- -- |> Cmd.map APIGpsMsg
-- -- Пока выделим только часть полей
-- -- type alias State =
-- --     ( Int, List Data )
--
--
-- listDataDecoder : Int -> Decoder (List TrackPoint)
-- listDataDecoder body_size =
--     let
--         step ( n, acc ) =
--             -- let
--             --     _ =
--             --         Debug.log "step" ( n, List.length acc )
--             -- in
--             if n <= 0 then
--                 Decode.succeed <|
--                     Decode.Done (List.reverse acc)
--
--             else
--                 dataDecoder
--                     |> Decode.map
--                         (\v ->
--                             Decode.Loop ( n - 32, v :: acc )
--                         )
--     in
--     Decode.loop ( body_size, [] ) step
--
--
--
-- -- listDataStep : State -> Decoder (Decode.Step State Data)
-- -- listDataStep ( n, xs ) =
-- --     Decode.succeed (Decode.Done xs)
--
--
-- dataDecoder : Decoder TrackPoint
-- dataDecoder =
--     unsignedInt16 LE
--         |> andThen
--             (\header ->
--                 if header == 0xF5FF then
--                     decodeBody
--
--                 else
--                     let
--                         _ =
--                             Debug.log "decode fail" header
--                     in
--                     Decode.fail
--              -- Decode.succeed (Data 0 0 0.0 0.0)
--             )
--
--
-- andMap : Decoder a -> Decoder (a -> b) -> Decoder b
-- andMap aDecoder fnDecoder =
--     -- Идея взята отсюда: https://github.com/TSFoster/elm-bytes-extra/blob/1.3.0/src/Bytes/Decode/Extra.elm
--     -- Если только ради одной функции, может и не стоит подключать всю библиотеку
--     Decode.map2 (<|) fnDecoder aDecoder
--
--
-- unsignedInt32LE =
--     unsignedInt32 LE
--
--
-- decodeLatLng : Decoder Float
-- decodeLatLng =
--     unsignedInt32 LE |> andThen (\i -> Decode.succeed <| toFloat i / 600000.0)
--
--
-- decodeBody : Decoder TrackPoint
-- decodeBody =
--     -- Decode.succeed TrackPoint
--     Decode.succeed
--         (\fsource _ dt lan lng _ ->
--             TrackPoint fsource dt lan lng
--         )
--         -- fsourse
--         |> andMap unsignedInt8
--         -- sats
--         |> andMap unsignedInt8
--         -- dt
--         |> andMap unsignedInt32LE
--         -- lat
--         |> andMap decodeLatLng
--         -- lng
--         |> andMap decodeLatLng
--         -- skip rest bytes
--         |> andMap (Decode.bytes 16)
--
--
--
-- -- Выглядит это конечно монструозно
-- -- decodeBody0 : Decoder TrackPoint
-- -- decodeBody0 =
-- --     unsignedInt8
-- --         |> andThen
-- --             (\fsource ->
-- --                 unsignedInt8
-- --                     |> andThen
-- --                         (\sats ->
-- --                             unsignedInt32 LE
-- --                                 |> andThen
-- --                                     (\dt ->
-- --                                         decodeLatLon
-- --                                             |> andThen
-- --                                                 (\latLng ->
-- --                                                     unsignedInt16 LE
-- --                                                         |> andThen
-- --                                                             (\speed ->
-- --                                                                 unsignedInt16 LE
-- --                                                                     |> andThen
-- --                                                                         -- Not used now
-- --                                                                         (\alt ->
-- --                                                                             unsignedInt8
-- --                                                                                 |> andThen
-- --                                                                                     (\dir ->
-- --                                                                                         Decode.bytes 11
-- --                                                                                             |> andThen
-- --                                                                                                 (\rest ->
-- --                                                                                                     -- Decode.succeed (Data fsource sats dt latLng (toFloat speed * 1.852 / 100.0) (dir * 2))
-- --                                                                                                     Decode.succeed (TrackPoint dt latLng.lat latLng.lng)
-- --                                                                                                 )
-- --                                                                                     )
-- --                                                                         )
-- --                                                             )
-- --                                                 )
-- --                                     )
-- --                         )
-- --             )
-- -- (Decode.float32 BE)
-- -- (Decode.float32 BE)
-- -- type alias LatLng =
-- --     { lat : Float
-- --     , lng : Float
-- --     }
-- --
-- --
-- -- decodeLatLon : Decoder LatLng
-- -- decodeLatLon =
-- --     -- unsignedInt32 LE
-- --     --     |> andThen
-- --     --         (\lat ->
-- --     --             unsignedInt32 LE
-- --     --                 |> andThen
-- --     --                     (\lng ->
-- --     --                         Decode.succeed <| LatLng (toFloat lat / 600000) (toFloat lng / 600000)
-- --     --                     )
-- --     --         )
-- --     Decode.map2 iLatLng
-- --         (unsignedInt32 LE)
-- --         (unsignedInt32 LE)
-- --
-- --
-- -- iLatLng : Int -> Int -> LatLng
-- -- iLatLng lat lng =
-- --     LatLng (toFloat lat / 600000) (toFloat lng / 600000)
