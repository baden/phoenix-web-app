module API.System exposing (..)

import API.Document as Document
import API.System.Battery as Battery exposing (Battery)
import Dict exposing (Dict)
import Json.Decode as JD
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode
import Page.System.Config.ParamDesc as ParamDesc
import Types.Dt as DT



-- type alias SysId =
--     String


type alias Balance =
    { dt : DT.Dt
    , value : Float
    }


balanceDecoder : JD.Decoder Balance
balanceDecoder =
    JD.succeed Balance
        |> required "dt" DT.decoder
        |> required "value" JD.float


type alias SystemDocumentInfo =
    { id : String
    , title : String
    , imei : Maybe String
    , phone : Maybe String

    -- , lastPosition : Maybe LastPosition
    -- , lastSession : Maybe LastSession
    , dynamic : Maybe Dynamic
    , balance : Maybe Balance
    , hwid : Maybe String
    , swid : Maybe String
    , battery : Maybe Battery
    , params : SystemParams
    , icon : String
    }


type alias SystemParams =
    { sleep : Maybe Int
    }


systemParamsDecoder : JD.Decoder SystemParams
systemParamsDecoder =
    JD.succeed SystemParams
        |> optional "sleep" (JD.maybe JD.int) Nothing


systemDocumentDecoder : JD.Decoder SystemDocumentInfo
systemDocumentDecoder =
    JD.succeed SystemDocumentInfo
        |> required "id" JD.string
        |> required "title" JD.string
        |> optional "imei" (JD.maybe JD.string) Nothing
        |> optional "phone" (JD.maybe JD.string) Nothing
        -- |> optional "last_position" (JD.maybe lastPositionDecoder) Nothing
        -- |> optional "last_session" (JD.maybe lastSessionDecoder) Nothing
        |> optional "dynamic" (JD.maybe dynamicDecoder) Nothing
        |> optional "balance" (JD.maybe balanceDecoder) Nothing
        |> optional "hwid" (JD.maybe JD.string) Nothing
        |> optional "swid" (JD.maybe JD.string) Nothing
        |> optional "battery" (JD.maybe Battery.batteryDecoder) Nothing
        |> required "params" systemParamsDecoder
        |> required "icon" JD.string


type alias Dynamic =
    { lastping : Maybe DT.Dt
    , method : Maybe String
    , next : Maybe DT.Offset
    , latitude : Maybe Float
    , longitude : Maybe Float
    , dt : Maybe DT.Dt
    , vin : Maybe Float
    , vout : Maybe Float
    , state : Maybe State
    , available : List State
    , waitState : Maybe State
    , autosleep : Maybe DT.Offset

    -- , autosleep : Maybe Int
    }


dynamicDecoder : JD.Decoder Dynamic
dynamicDecoder =
    JD.succeed Dynamic
        |> optional "lastping" (JD.maybe DT.decoder) Nothing
        |> optional "method" (JD.maybe JD.string) Nothing
        |> optional "next_session" (JD.maybe DT.offsetDecoder) Nothing
        |> optional "latitude" (JD.maybe JD.float) Nothing
        |> optional "longitude" (JD.maybe JD.float) Nothing
        |> optional "dt" (JD.maybe DT.decoder) Nothing
        |> optional "vin" (JD.maybe JD.float) Nothing
        |> optional "vout" (JD.maybe JD.float) Nothing
        -- |> optional "state" (JD.maybe sysStateDecoder) Nothing
        |> optional "state" (JD.maybe stateDecoder) Nothing
        -- |> optional "available" statesListDecoder []
        |> optional "available" (JD.list stateDecoder) []
        |> optional "wait_state" (JD.maybe stateDecoder) Nothing
        |> optional "autosleep" (JD.maybe DT.offsetDecoder) Nothing



-- |> optional "autosleep" (JD.maybe JD.int) Nothing
-- type alias LastPosition =
--     { lat : Float
--     , lon : Float
--     , dt : DT.Dt
--     }
--
--
-- lastPositionDecoder : JD.Decoder LastPosition
-- lastPositionDecoder =
--     JD.succeed LastPosition
--         |> required "lat" JD.float
--         |> required "lon" JD.float
--         |> required "dt" DT.decoder
--
--
-- type alias LastSession =
--     { dt : DT.Dt
--     , event : String
--     , next : Maybe DT.Offset
--     }
--
--
-- lastSessionDecoder : JD.Decoder LastSession
-- lastSessionDecoder =
--     JD.succeed LastSession
--         |> required "dt" DT.decoder
--         |> required "event" JD.string
--         |> optional "next" (JD.maybe DT.offsetDecoder) Nothing


type State
    = Tracking
    | Sleep
    | Locked
    | Beacon
    | Hidden
    | Off
    | Config
      -- Дальше не совсем состояния, это скорее команды
    | Point
    | SLock
    | Lock
    | CLock
    | Unlock
    | ProlongSleep Int
      -- Неподдерживаемые приложением команды и состояния
    | Unknown String


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

                    "beacon" ->
                        JD.succeed Beacon

                    "hidden" ->
                        JD.succeed Hidden

                    "off" ->
                        JD.succeed Off

                    "config" ->
                        JD.succeed Config

                    "point" ->
                        JD.succeed Point

                    "slock" ->
                        JD.succeed SLock

                    "lock" ->
                        JD.succeed Lock

                    "unlock" ->
                        JD.succeed Unlock

                    "clock" ->
                        JD.succeed CLock

                    "prolong_4" ->
                        JD.succeed <| ProlongSleep 4

                    "prolong_24" ->
                        JD.succeed <| ProlongSleep 24

                    "prolong_100" ->
                        JD.succeed <| ProlongSleep 100

                    other ->
                        JD.succeed (Unknown other)
            )



-- statesListDecoder : JD.Decoder (List State)
-- statesListDecoder =
--     JD.string
--         |> JD.andThen
--             (\t ->
--                 -- TBD
--                 let
--                     states =
--                         String.foldl
--                             (\c acc ->
--                                 (c |> String.fromChar |> stateFromChar) :: acc
--                             )
--                             []
--                             t
--                 in
--                     JD.succeed states
--             )


stateAsString : State -> String
stateAsString state =
    case state of
        Tracking ->
            "Поиск"

        Sleep ->
            "СОН"

        Locked ->
            "Блокировка"

        Beacon ->
            "СОН"

        Hidden ->
            "Ожидание"

        Off ->
            "Выключен"

        Config ->
            "Конфигурация"

        Point ->
            "Точка"

        SLock ->
            "Интеллектуальная блокировка"

        Lock ->
            "Блокировка"

        CLock ->
            "Отмена блокировки"

        Unlock ->
            "Разблокировка"

        ProlongSleep hours ->
            "Отложить засыпание на " ++ String.fromInt hours ++ " ч"

        Unknown c ->
            "Неизвестно:" ++ c


stateAsCmdString : State -> String
stateAsCmdString state =
    case state of
        Tracking ->
            "ПОИСК"

        Sleep ->
            "УСЫПИТЬ"

        Locked ->
            "ЗАБЛОКИРОВАТЬ"

        Beacon ->
            "УСЫПИТЬ"

        Hidden ->
            "ОЖИДАНИЕ"

        Off ->
            "ВЫКЛЮЧИТЬ"

        Config ->
            "КОНФИГУРАЦИЯ"

        Point ->
            "ПОЛОЖЕНИЕ"

        SLock ->
            "ЗАБЛОКИРОВАТЬ"

        Lock ->
            "ЗАБЛОКИРОВАТЬ"

        CLock ->
            "ОТМ_БЛОКИРОВКИ"

        Unlock ->
            "РАЗБЛОКИРОВАТЬ"

        ProlongSleep hours ->
            "Отложить засыпание на " ++ String.fromInt hours ++ " ч"

        Unknown s ->
            "В разработке..." ++ s


iconForCmdString : State -> String
iconForCmdString state =
    case state of
        Tracking ->
            "search"

        Sleep ->
            "bed"

        Locked ->
            "lock"

        Beacon ->
            "bed"

        Hidden ->
            "bed"

        Off ->
            "power-off"

        Config ->
            "cog"

        Point ->
            "map-marker-alt"

        SLock ->
            "slock"

        Lock ->
            "lock"

        CLock ->
            "clock"

        Unlock ->
            "lock-open"

        ProlongSleep hours ->
            "clock"

        Unknown s ->
            "cog"


type alias SystemDocumentLog =
    { dt : DT.Dt
    , text : String
    }


type alias SystemDocumentParams =
    { id : String -- Дублирующее поле?
    , data : List ( String, SystemDocumentParam )
    , queue : Dict String String
    }


type alias SystemDocumentHour =
    { from : Int
    , to : Int
    , hours : List Int
    }


type alias SystemDocumentTrack =
    { from : Int
    , to : Int
    , track : List TrackPoint
    }


type alias TrackPoint =
    List Float


systemDocumentParamsDecoder : JD.Decoder SystemDocumentParams
systemDocumentParamsDecoder =
    JD.succeed SystemDocumentParams
        |> required "id" JD.string
        -- |> required "data" (JD.keyValuePairs systemDocumentParamDecoder)
        |> required "data" (JD.keyValuePairs systemDocumentParamDecoder |> JD.andThen sortParamList)
        |> required "queue" (JD.dict JD.string)


sortParamList : List ( String, SystemDocumentParam ) -> JD.Decoder (List ( String, SystemDocumentParam ))
sortParamList =
    let
        ffilter : ( String, SystemDocumentParam ) -> Bool
        ffilter =
            \( name, _ ) ->
                ParamDesc.disabled name
    in
    JD.succeed << List.sortBy Tuple.first << List.filter ffilter



-- sortParamList : List ( String, SystemDocumentParam ) -> JD.Decoder (List ( String, SystemDocumentParam ))
-- sortParamList l =
--     l
--         |> List.sortBy Tuple.first
--         |> JD.succeed
-- |> JD.map (List.sortBy Tuple.first >> List.map Tuple.second)


type alias SystemDocumentParam =
    { type_ : String
    , value : String
    , default : String
    }


systemDocumentParamDecoder : JD.Decoder SystemDocumentParam
systemDocumentParamDecoder =
    JD.succeed SystemDocumentParam
        |> required "type" JD.string
        |> required "value" JD.string
        |> required "default" JD.string



-- type alias SystemDocumentLogs =
--     List SystemDocumentLog


systemDocumentLogDecoder : JD.Decoder SystemDocumentLog
systemDocumentLogDecoder =
    JD.succeed SystemDocumentLog
        |> required "dt" DT.decoder
        |> required "text" JD.string


systemDocumentHourDecoder : JD.Decoder SystemDocumentHour
systemDocumentHourDecoder =
    JD.succeed SystemDocumentHour
        |> required "from" JD.int
        |> required "to" JD.int
        |> required "hours" (JD.list JD.int)


systemDocumentTrackDecoder : JD.Decoder SystemDocumentTrack
systemDocumentTrackDecoder =
    JD.succeed SystemDocumentTrack
        |> required "from" JD.int
        |> required "to" JD.int
        |> required "track" (JD.list (JD.list JD.float))



-- systemDocumentLogsDecoder : JD.Decoder SystemDocumentLogs
--     JD.succeed SystemDocumentLogs
-- type alias SysState =
--     { current : State
--     , available : List State
--     }
--
--
--
-- -- type SysState
--
--
-- sysStateDecoder : JD.Decoder SysState
-- sysStateDecoder =
--     JD.succeed SysState
--         |> required "current" stateDecoder
--         |> required "available" (JD.list stateDecoder)
-- JD.map AccountDocumentInfo
--     (JD.field "realname" JD.string)


setSystemTitle : String -> String -> Encode.Value
setSystemTitle sysId newTitle =
    Document.updateDocumentRequest "system" <|
        Encode.object
            [ ( "key", Encode.string sysId )
            , ( "path", Encode.string "title" )
            , ( "value", Encode.string newTitle )
            ]


setSystemIcon : String -> String -> Encode.Value
setSystemIcon sysId newIcon =
    Document.updateDocumentRequest "system" <|
        Encode.object
            [ ( "key", Encode.string sysId )
            , ( "path", Encode.string "icon" )
            , ( "value", Encode.string newIcon )
            ]


setBatteryCapacity : String -> String -> Encode.Value
setBatteryCapacity sysId capacity =
    Document.updateDocumentRequest "system" <|
        Encode.object
            [ ( "key", Encode.string sysId )
            , ( "path", Encode.string "battery.init_capacity" )
            , ( "value", Encode.float <| Maybe.withDefault 5800 (String.toFloat capacity) )
            ]


resetBattery : String -> String -> Encode.Value
resetBattery sysId capacity =
    Encode.object
        [ ( "cmd", Encode.string "system_reset_battery" )
        , ( "id", Encode.string sysId )
        , ( "value", Encode.float <| Maybe.withDefault 5800 (String.toFloat capacity) )
        ]


setSystemState : String -> State -> Encode.Value
setSystemState sysId newState =
    -- "cmd" : "system_mode",
    -- "id" : "$SYS_ID1",
    -- "mode" : "main",
    -- "value" : "force"
    Encode.object
        [ ( "cmd", Encode.string "system_state" )
        , ( "id", Encode.string sysId )
        , ( "value"
          , Encode.string <|
                case newState of
                    Tracking ->
                        "tracking"

                    Sleep ->
                        "sleep"

                    Locked ->
                        "locked"

                    Beacon ->
                        "beacon"

                    Hidden ->
                        "hidden"

                    Off ->
                        "off"

                    Config ->
                        "config"

                    Point ->
                        "point"

                    SLock ->
                        "slock"

                    Lock ->
                        "lock"

                    CLock ->
                        "clock"

                    Unlock ->
                        "unlock"

                    ProlongSleep hours ->
                        "prolong_" ++ String.fromInt hours

                    Unknown c ->
                        c
          )
        ]


cancelSystemState : String -> Encode.Value
cancelSystemState sysId =
    Encode.object
        [ ( "cmd", Encode.string "system_state" )
        , ( "id", Encode.string sysId )
        , ( "value", Encode.string "" )
        ]


prolongSleep : String -> Int -> Encode.Value
prolongSleep sysId hours =
    setSystemState sysId (ProlongSleep hours)


getLogs : String -> Int -> Encode.Value
getLogs sysId offset =
    Encode.object
        [ ( "cmd", Encode.string "system_logs" )
        , ( "id", Encode.string sysId )
        , ( "skip", Encode.int offset )
        , ( "count", Encode.int 20 )
        ]


getParams : String -> Encode.Value
getParams sysId =
    Encode.object
        [ ( "cmd", Encode.string "system_params" )
        , ( "id", Encode.string sysId )
        ]


paramQueue : String -> Dict String String -> Encode.Value
paramQueue sysId queue =
    Encode.object
        [ ( "cmd", Encode.string "params_queue" )
        , ( "id", Encode.string sysId )
        , ( "value", Encode.dict identity Encode.string queue )
        ]



--     Document.updateDocumentRequest "system" <|
--         Encode.object
--             [ ( "key", Encode.string sysId )
--             , ( "path", Encode.string "title" )
--             , ( "value", Encode.string newTitle )
--             ]


getTrack : String -> Int -> Int -> Encode.Value
getTrack sysId from to =
    Encode.object
        [ ( "cmd", Encode.string "system_track" )
        , ( "id", Encode.string sysId )
        , ( "from", Encode.int from )
        , ( "to", Encode.int to )
        ]


getHours : String -> Encode.Value
getHours sysId =
    Encode.object
        [ ( "cmd", Encode.string "system_hours" )
        , ( "id", Encode.string sysId )
        , ( "from", Encode.int 0 )
        , ( "to", Encode.int 10000000 )
        ]
