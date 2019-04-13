module API.Account
    exposing
        ( AccountDocumentInfo
        , accountDocumentDecoder
        )

import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


type alias AccountDocumentInfo =
    { realname : String
    , systems : List String
    }


accountDocumentDecoder : JD.Decoder AccountDocumentInfo
accountDocumentDecoder =
    JD.succeed AccountDocumentInfo
        |> required "realname" JD.string
        |> optional "systems" (JD.list JD.string) []



-- JD.map AccountDocumentInfo
--     (JD.field "realname" JD.string)
