module Page.System.Config.Master.Types exposing (..)


type MasterPage
    = MasterPage1
    | MasterPage2
    | MasterPage3
    | MasterPage4
    | MasterPage5


type alias MasterData =
    { masterEcoValue : MasterDataEco
    , masterTrackValue : MasterDataTrack
    , masterSecurValue : ( Bool, Bool )
    , smsPhones : MasterDataSMS
    }


type MasterDataEco
    = M_ECO_MAX
    | M_ECO_MID
    | M_ECO_MIN


type MasterDataTrack
    = M_TRACK_MIN
    | M_TRACK_MID
    | M_TRACK_MAX



-- alarm.case Вскрытие корпуса
-- alarm.low Низкий уровень заряда
-- alarm.mode Изменение режима (Поиск, Ожидание, Включение, Выключение)
-- alarm.delay? alarm.stealth? Включение и выключение GSM-модуля
-- alarm.gps Начало движения (в режиме Поиск)
-- type MasterDataPhoneIndex
--     = MD_Phone_None
--     | MD_Phone_1
--     | MD_Phone_2


type alias MasterDataSMS =
    { balance : Bool
    , lowPower : Bool
    , changeMode : Bool
    , moved : Bool
    , caseOpen : Bool
    , onOff : Bool

    -- , gsm : Bool
    }


initMasterData : MasterData
initMasterData =
    { masterEcoValue = M_ECO_MID
    , masterTrackValue = M_TRACK_MID
    , masterSecurValue = ( False, False )
    , smsPhones =
        { balance = False
        , lowPower = False
        , changeMode = False
        , moved = False
        , caseOpen = False
        , onOff = False

        -- , gsm = False
        }
    }


setMasterDataEco : MasterDataEco -> MasterData -> MasterData
setMasterDataEco v m =
    { m | masterEcoValue = v }


setMasterDataTrack : MasterDataTrack -> MasterData -> MasterData
setMasterDataTrack v m =
    { m | masterTrackValue = v }


setMasterDataSecur : Int -> Bool -> MasterData -> MasterData
setMasterDataSecur val s m =
    let
        ( s1, s2 ) =
            m.masterSecurValue
    in
        case val of
            1 ->
                { m | masterSecurValue = ( s, s2 ) }

            _ ->
                { m | masterSecurValue = ( s1, s ) }


setMasterDataSmsEvent updater s m =
    { m | smsPhones = updater s m.smsPhones }


ecoToValue : MasterDataEco -> String
ecoToValue v =
    case v of
        M_ECO_MAX ->
            -- Раз в сутки
            "1440"

        M_ECO_MID ->
            -- Каждые 4 часа
            "240"

        M_ECO_MIN ->
            -- Каждый час
            "60"


trackToValue : MasterDataTrack -> String
trackToValue v =
    case v of
        M_TRACK_MIN ->
            -- 12 часов
            "720"

        M_TRACK_MID ->
            -- 4 часа
            "240"

        M_TRACK_MAX ->
            -- 1 час
            "60"


masterNextPage : MasterPage -> MasterPage
masterNextPage showMasterDialog =
    case showMasterDialog of
        MasterPage1 ->
            MasterPage2

        MasterPage2 ->
            MasterPage3

        MasterPage3 ->
            MasterPage4

        MasterPage4 ->
            MasterPage5

        MasterPage5 ->
            MasterPage1


masterPrevPage : MasterPage -> MasterPage
masterPrevPage showMasterDialog =
    case showMasterDialog of
        MasterPage5 ->
            MasterPage4

        MasterPage4 ->
            MasterPage3

        MasterPage3 ->
            MasterPage2

        MasterPage2 ->
            MasterPage1

        MasterPage1 ->
            MasterPage1
