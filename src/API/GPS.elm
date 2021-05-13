module API.GPS exposing (..)

import Bytes exposing (Endianness(..))
import Bytes.Decode as Decode exposing (Decoder)
import Http


type Msg
    = GotData (Result Http.Error Data)


type alias Data =
    { lat : Float
    , lon : Float
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
        , url = "http://pil.fx.navi.cc/1.0/geos/ODY3NTU2MDQ2MTkxOTE1?from=450045&to=450188&access_token=UJs7TyiOEp83x48EAhzlKMoxZdYnhUZQ"
        , body = Http.emptyBody
        , expect = e
        , timeout = Nothing
        , tracker = Nothing
        }



-- |> Cmd.map APIGpsMsg


dataDecoder : Decoder Data
dataDecoder =
    Decode.map2 Data
        (Decode.float32 BE)
        (Decode.float32 BE)
