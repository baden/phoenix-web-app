port module API exposing (..)

-- ( websocketOpen
-- , websocketOut
-- , websocketOpened
-- , websocketIn
-- , authUserRequest
-- , registerUserRequest
-- , authRequest
-- , parsePayload
-- )

import Json.Encode as Encode
import Json.Decode as JD exposing (Decoder, Value, string, value)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


-- type alias Command =
--     { cmd : String
--     , data : JD.Value
--     }
-- type CommandValue
--     = CommandPing
--     | CommandError
--
--
-- type Resource
--     = Token
--     | Account


type APIContent
    = Ping PingInfo
    | Token TokenInfo
    | Document DocumentInfo
    | Error ApiError


type alias PingInfo =
    { timestamp : Int
    }


type alias ApiError =
    { resource : String
    , code : String
    }


type alias TokenInfo =
    { value : String
    }


type DocumentInfo
    = AccountDocument AccountDocumentInfo


type alias AccountDocumentInfo =
    { realname : String
    }


parsePayload : String -> Maybe APIContent
parsePayload payload =
    case JD.decodeString payloadDecoder payload of
        Ok content ->
            Just content

        Err error ->
            let
                _ =
                    Debug.log "Err Error" error
            in
                Nothing


payloadDecoder : JD.Decoder APIContent
payloadDecoder =
    (JD.field "cmd" JD.string)
        |> JD.andThen
            (\t ->
                let
                    _ =
                        Debug.log "cmd" t
                in
                    -- JD.field "data" <|
                    case t of
                        "ping" ->
                            JD.map Ping pingDecoder

                        "error" ->
                            JD.map Error errorDecoder

                        "token" ->
                            JD.map Token tokenDecoder

                        "document" ->
                            JD.map Document documentDecoder

                        _ ->
                            let
                                _ =
                                    Debug.log "" ("unexpected message " ++ t)
                            in
                                JD.fail ("unexpected message " ++ t)
            )


pingDecoder : JD.Decoder PingInfo
pingDecoder =
    JD.map PingInfo
        (JD.field "timestamp" JD.int)


errorDecoder : JD.Decoder ApiError
errorDecoder =
    JD.map2 ApiError
        (JD.field "resource" JD.string)
        (JD.field "code" JD.string)


tokenDecoder : JD.Decoder TokenInfo
tokenDecoder =
    JD.map TokenInfo
        (JD.field "value" JD.string)


documentDecoder : JD.Decoder DocumentInfo
documentDecoder =
    (JD.field "collection" JD.string)
        |> JD.andThen
            (\c ->
                let
                    _ =
                        Debug.log "collection" c
                in
                    JD.field "value" <|
                        case c of
                            "account" ->
                                JD.map AccountDocument accountDocumentDecoder

                            _ ->
                                let
                                    _ =
                                        Debug.log "" ("unexpected document " ++ c)
                                in
                                    JD.fail ("unexpected document " ++ c)
            )


accountDocumentDecoder : JD.Decoder AccountDocumentInfo
accountDocumentDecoder =
    JD.map AccountDocumentInfo
        (JD.field "realname" JD.string)



-- commandDecoder : Decoder Command
-- commandDecoder =
--     JD.succeed Command
--         |> required "cmd" (JD.map commandMap string)
--         |> required "data" value


authRequest : String -> Encode.Value
authRequest token =
    Encode.object
        [ ( "cmd", Encode.string "login" )
        , ( "token", Encode.string token )
        ]



-- registerUser =
--     websocketOut <|
--         makeRequest 1 "foo"


authUserRequest : String -> String -> Encode.Value
authUserRequest username password_hash =
    commonRequest "auth"
        [ ( "username", Encode.string username )
        , ( "password", Encode.string password_hash )
        ]


registerUserRequest : String -> String -> Encode.Value
registerUserRequest username password_hash =
    commonRequest "register"
        [ ( "username", Encode.string username )
        , ( "password", Encode.string password_hash )
        ]


commonRequest : String -> List ( String, Encode.Value ) -> Encode.Value
commonRequest cmd data =
    Encode.object
        [ ( "cmd", Encode.string cmd )
        , ( "data", Encode.object data )
        ]


port websocketOpen : String -> Cmd msg


port websocketOpened : (Bool -> msg) -> Sub msg


port websocketIn : (String -> msg) -> Sub msg


port websocketOut : Encode.Value -> Cmd msg
