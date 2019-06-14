module API.Account
    exposing
        ( AccountDocumentInfo
        , accountDocumentDecoder
        , fixSysListRequest
        )

import Json.Encode as Encode
import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import API.Document as Document


type alias AccountDocumentInfo =
    { realname : String
    , systems : List String
    }


accountDocumentDecoder : JD.Decoder AccountDocumentInfo
accountDocumentDecoder =
    JD.succeed AccountDocumentInfo
        |> required "realname" JD.string
        |> optional "systems" (JD.list JD.string) []


fixSysListRequest : List String -> Encode.Value
fixSysListRequest syslist =
    Document.updateDocumentRequest "account" <|
        Encode.object
            [ ( "path", Encode.string "systems" )
            , ( "value", Encode.list Encode.string syslist )
            ]



-- JD.map AccountDocumentInfo
--     (JD.field "realname" JD.string)
