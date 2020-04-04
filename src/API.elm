port module API exposing (..)

import API.Account as Account
import API.System as System
import API.Error as Error
import Json.Encode as Encode
import Json.Decode as JD exposing (Decoder, Value, string, value)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


type APIContent
    = Ping PingInfo
    | Token TokenInfo
    | Document String DocumentInfo
    | Error Error.ApiError


type alias PingInfo =
    { timestamp : Int
    }


type alias TokenInfo =
    { value : String
    }


type DocumentInfo
    = AccountDocument Account.AccountDocumentInfo
    | SystemDocument System.SystemDocumentInfo
    | SystemDocumentDynamic System.Dynamic
    | SystemLogsDocument (List System.SystemDocumentLog)
    | SystemParamsDocument System.SystemDocumentParams


parsePayload : String -> Maybe APIContent
parsePayload payload =
    case JD.decodeString payloadDecoder payload of
        Ok content ->
            Just content

        Err error ->
            Nothing


payloadDecoder : JD.Decoder APIContent
payloadDecoder =
    (JD.field "cmd" JD.string)
        |> JD.andThen
            (\t ->
                -- JD.field "data" <|
                case t of
                    "ping" ->
                        JD.map Ping pingDecoder

                    "error" ->
                        JD.map Error Error.errorDecoder

                    "token" ->
                        JD.map Token tokenDecoder

                    "document" ->
                        JD.map2 Document
                            (JD.field "key" JD.string)
                            documentDecoder

                    _ ->
                        JD.fail ("unexpected message " ++ t)
            )


pingDecoder : JD.Decoder PingInfo
pingDecoder =
    JD.map PingInfo
        (JD.field "timestamp" JD.int)


tokenDecoder : JD.Decoder TokenInfo
tokenDecoder =
    JD.map TokenInfo
        (JD.field "value" JD.string)


documentDecoder : JD.Decoder DocumentInfo
documentDecoder =
    (JD.field "collection" JD.string)
        |> JD.andThen
            (\c ->
                JD.field "value" <|
                    case c of
                        "account" ->
                            JD.map AccountDocument Account.accountDocumentDecoder

                        "system" ->
                            JD.map SystemDocument System.systemDocumentDecoder

                        "system.dynamic" ->
                            JD.map SystemDocumentDynamic
                                System.dynamicDecoder

                        "system_logs" ->
                            JD.map SystemLogsDocument (JD.list System.systemDocumentLogDecoder)

                        "system_params" ->
                            JD.map SystemParamsDocument System.systemDocumentParamsDecoder

                        _ ->
                            JD.fail ("unexpected document " ++ c)
            )



-- TODO: Нужно как-то понять как декодировать документ и поле key.
-- https://github.com/NOLAnuffsaid/elm-quotes/blob/313d3de5236084edb1316e6baaffeefdef296f24/elm-stuff/packages/bendyworks/elm-action-cable/1.0.0/src/ActionCable/Decoder.elm


documentIs : String -> JD.Decoder String
documentIs documentName =
    let
        typeDecoder s =
            if s == documentName then
                JD.succeed documentName
            else
                JD.fail ""
    in
        JD.andThen
            typeDecoder
            JD.string



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


linkSysRequest : String -> Encode.Value
linkSysRequest code =
    Encode.object
        [ ( "cmd", Encode.string "link" )
        , ( "code", Encode.string code )
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
