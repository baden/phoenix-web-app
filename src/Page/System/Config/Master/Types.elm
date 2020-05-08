module Page.System.Config.Master.Types exposing (..)


type MasterPage
    = MasterPage1
    | MasterPage2
    | MasterPage3


type alias MasterData =
    { masterEcoValue : MasterDataEco
    , masterTrackValue : MasterDataTrack
    , masterSecurValue : ( Bool, Bool )
    }


type MasterDataEco
    = M_ECO_MAX
    | M_ECO_MID
    | M_ECO_MIN


type MasterDataTrack
    = M_TRACK_MIN
    | M_TRACK_MID
    | M_TRACK_MAX


initMasterData : MasterData
initMasterData =
    { masterEcoValue = M_ECO_MID
    , masterTrackValue = M_TRACK_MID
    , masterSecurValue = ( False, False )
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
            MasterPage1


masterPrevPage : MasterPage -> MasterPage
masterPrevPage showMasterDialog =
    case showMasterDialog of
        MasterPage3 ->
            MasterPage2

        MasterPage2 ->
            MasterPage1

        MasterPage1 ->
            MasterPage1
