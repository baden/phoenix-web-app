port module API
    exposing
        ( registerUserRequest
        , websocketOpen
        , websocketOut
        , websocketOpened
        , websocketIn
        , authRequest
        )

import Json.Encode as Encode


authRequest : String -> Encode.Value
authRequest token =
    commonRequest "login"
        [ ( "token", Encode.string token )
        ]



-- registerUser =
--     websocketOut <|
--         makeRequest 1 "foo"


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
