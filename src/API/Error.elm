module API.Error exposing (..)

import Json.Decode as JD exposing (Decoder, Value, string, value)


type alias ApiError =
    { resource : String
    , code : String
    }


errorDecoder : JD.Decoder ApiError
errorDecoder =
    JD.map2 ApiError
        (JD.field "resource" JD.string)
        (JD.field "code" JD.string)



-- payloadDecoder : JD.Decoder APIContent
-- payloadDecoder =
--     (JD.field "cmd" JD.string)
--         |> JD.andThen
--             (\t ->
--                 -- JD.field "data" <|
--                 case t of
--                     "ping" ->
--                         JD.map Ping pingDecoder
