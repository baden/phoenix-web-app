module API.GPS exposing (..)

import Bytes exposing (Endianness(..))
import Bytes.Decode as Decode exposing (Decoder, andThen, unsignedInt16, unsignedInt32, unsignedInt8)
import Http


type Msg
    = GotData (Result Http.Error Data)


type alias Data =
    { fsourse : Int
    , sats : Int
    , dt : Int
    , latLng : LatLng
    , speed : Float
    , dir : Int
    }


getBinTrack : Int -> Int -> Cmd Msg
getBinTrack from to =
    let
        e =
            -- Decode.expectBytes GPSGotData gpsDecoder
            Http.expectBytes GotData dataDecoder
    in
    Http.riskyRequest
        { method = "GET"
        , headers = [ Http.header "Accept" "application/octet-stream" ]
        , url = "http://pil.fx.navi.cc/1.0/geos/ODY3NTU2MDQ2MTkxOTE1?from=450045&to=450188&access_token=6sAYC4AZ6Hnlawd1fwskF135X9PG7sGV"
        , body = Http.emptyBody
        , expect = e
        , timeout = Nothing
        , tracker = Nothing
        }



-- |> Cmd.map APIGpsMsg
-- Пока выделим только часть полей


dataDecoder : Decoder Data
dataDecoder =
    unsignedInt16 LE
        |> andThen
            (\header ->
                let
                    _ =
                        Debug.log "Decode" header
                in
                if header == 0xF5FF then
                    decodeBody

                else
                    Decode.fail
             -- Decode.succeed (Data 0 0 0.0 0.0)
            )



-- Выглядит это конечно монструозно


decodeBody : Decoder Data
decodeBody =
    unsignedInt8
        |> andThen
            (\fsource ->
                unsignedInt8
                    |> andThen
                        (\sats ->
                            unsignedInt32 LE
                                |> andThen
                                    (\dt ->
                                        decodeLatLon
                                            |> andThen
                                                (\latLng ->
                                                    unsignedInt16 LE
                                                        |> andThen
                                                            (\speed ->
                                                                unsignedInt16 LE
                                                                    |> andThen
                                                                        -- Not used now
                                                                        (\alt ->
                                                                            unsignedInt8
                                                                                |> andThen
                                                                                    (\dir ->
                                                                                        Decode.bytes 11
                                                                                            |> andThen
                                                                                                (\rest ->
                                                                                                    Decode.succeed (Data fsource sats dt latLng (toFloat speed * 1.852 / 100.0) (dir * 2))
                                                                                                )
                                                                                    )
                                                                        )
                                                            )
                                                )
                                    )
                        )
            )



-- (Decode.float32 BE)
-- (Decode.float32 BE)


type alias LatLng =
    { lat : Float
    , lng : Float
    }


decodeLatLon : Decoder LatLng
decodeLatLon =
    -- unsignedInt32 LE
    --     |> andThen
    --         (\lat ->
    --             unsignedInt32 LE
    --                 |> andThen
    --                     (\lng ->
    --                         Decode.succeed <| LatLng (toFloat lat / 600000) (toFloat lng / 600000)
    --                     )
    --         )
    Decode.map2 iLatLng
        (unsignedInt32 LE)
        (unsignedInt32 LE)


iLatLng : Int -> Int -> LatLng
iLatLng lat lng =
    LatLng (toFloat lat / 600000) (toFloat lng / 600000)
