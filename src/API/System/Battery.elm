module API.System.Battery exposing (..)

import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Types.Dt as DT


-- init_capacity: 5800
-- init_dt: 1587726596
-- last_update: 1587728224
-- counters:
-- -- accel: 462
-- -- gps: 392
-- -- gsm: 484
-- -- gsm_on: 3
-- -- sessions: 0


type alias Battery =
    { init_capacity : Float
    , init_dt : DT.Dt
    , last_update : DT.Dt
    , counters : Counters
    }


type alias Counters =
    { gsm : Int
    , gps : Int
    , accel : Int
    , gsm_on : Int
    , sessions : Int
    }


batteryDecoder : JD.Decoder Battery
batteryDecoder =
    JD.succeed Battery
        |> required "init_capacity" JD.float
        |> required "init_dt" DT.decoder
        |> required "last_update" DT.decoder
        |> required "counters" counterDecoder


counterDecoder : JD.Decoder Counters
counterDecoder =
    JD.succeed Counters
        |> required "gsm" JD.int
        |> required "gps" JD.int
        |> required "accel" JD.int
        |> required "gsm_on" JD.int
        |> required "sessions" JD.int
