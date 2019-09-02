module Types.Dt exposing (Dt)

import Json.Decode as JD


type Dt
    = Dt Int


dtDecoder : JD.Decoder Dt
dtDecoder =
    JD.int
        |> JD.andThen
            (\t -> JD.succeed <| Dt t)
