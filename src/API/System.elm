module API.System
    exposing
        ( SystemDocumentInfo
        , systemDocumentDecoder
        , LastPosition
          -- , SysId
        )

import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


-- type alias SysId =
--     String


type alias SystemDocumentInfo =
    { id : String
    , title : String
    , lastPosition : Maybe LastPosition
    }


systemDocumentDecoder : JD.Decoder SystemDocumentInfo
systemDocumentDecoder =
    JD.succeed SystemDocumentInfo
        |> required "_id" JD.string
        |> required "title" JD.string
        |> optional "last_position" (JD.maybe lastPositionDecoder) Nothing


type alias LastPosition =
    { lat : Float
    , lon : Float
    , dt : Int
    }


lastPositionDecoder : JD.Decoder LastPosition
lastPositionDecoder =
    JD.succeed LastPosition
        |> required "lat" JD.float
        |> required "lon" JD.float
        |> required "dt" JD.int



-- JD.map AccountDocumentInfo
--     (JD.field "realname" JD.string)
