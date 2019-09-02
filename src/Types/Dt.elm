module Types.Dt exposing (Dt, toInt, fromInt, toPosix, fromPosix, decoder, addSecs)

import Json.Decode as JD
import Time


type Dt
    = Dt Int


toInt : Dt -> Int
toInt (Dt v) =
    v


fromInt : Int -> Dt
fromInt i =
    Dt i


toPosix : Dt -> Time.Posix
toPosix (Dt dt) =
    dt * 1000 |> Time.millisToPosix


fromPosix : Time.Posix -> Dt
fromPosix posix =
    posix |> Time.posixToMillis |> millisToSesc |> Dt


millisToSesc : Int -> Int
millisToSesc a =
    a // 1000


decoder : JD.Decoder Dt
decoder =
    JD.int
        |> JD.andThen
            (\t -> JD.succeed <| Dt t)


addSecs : Dt -> Dt -> Dt
addSecs (Dt a) (Dt b) =
    Dt (a + b * 60)
