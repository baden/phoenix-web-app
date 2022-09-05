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



-- Не самое элегантное решение


errorMessageString : ApiError -> Maybe String
errorMessageString { resource, code } =
    case ( resource, code ) of
        ( "link_code", "invalid_credentials" ) ->
            Just "errors.Код неверный, уже использован или вышло время действия кода."

        ( "token", "invalid_credentials" ) ->
            Just "errors.Неверное имя пользователя или пароль."

        ( _, _ ) ->
            Nothing



-- payloadDecoder : JD.Decoder APIContent
-- payloadDecoder =
--     (JD.field "cmd" JD.string)
--         |> JD.andThen
--             (\t ->
--                 -- JD.field "data" <|
--                 case t of
--                     "ping" ->
--                         JD.map Ping pingDecoder
