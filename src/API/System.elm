module API.System
    exposing
        ( SystemDocumentInfo
        , systemDocumentDecoder
        , LastPosition
        , SysState
        , State
          -- , SysId
        , stateAsString
        , stateAsCmdString
        )

import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


-- type alias SysId =
--     String


type alias SystemDocumentInfo =
    { id : String
    , title : String
    , lastPosition : Maybe LastPosition
    , state : Maybe SysState
    }


systemDocumentDecoder : JD.Decoder SystemDocumentInfo
systemDocumentDecoder =
    JD.succeed SystemDocumentInfo
        |> required "_id" JD.string
        |> required "title" JD.string
        |> optional "last_position" (JD.maybe lastPositionDecoder) Nothing
        |> optional "state" (JD.maybe sysStateDecoder) Nothing


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


type State
    = Tracking
    | Sleep
    | Locked
    | Unknown


stateDecoder : JD.Decoder State
stateDecoder =
    JD.string
        |> JD.andThen
            (\t ->
                case t of
                    "tracking" ->
                        JD.succeed Tracking

                    "sleep" ->
                        JD.succeed Sleep

                    "locked" ->
                        JD.succeed Locked

                    _ ->
                        JD.succeed Unknown
            )


stateAsString : State -> String
stateAsString state =
    case state of
        Tracking ->
            "Слежение"

        Sleep ->
            "Сон"

        Locked ->
            "Блокировка"

        Unknown ->
            "Неизвестно"


stateAsCmdString : State -> String
stateAsCmdString state =
    case state of
        Tracking ->
            "Отследить"

        Sleep ->
            "Усыпить"

        Locked ->
            "Заблокировать"

        Unknown ->
            "В разработке..."


type alias SysState =
    { current : State
    , available : List State
    }


sysStateDecoder : JD.Decoder SysState
sysStateDecoder =
    JD.succeed SysState
        |> required "current" stateDecoder
        |> required "available" (JD.list stateDecoder)



-- JD.map AccountDocumentInfo
--     (JD.field "realname" JD.string)
