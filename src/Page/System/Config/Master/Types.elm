module Page.System.Config.Master.Types exposing (..)


type MasterPage
    = MasterPage1
    | MasterPage2
    | MasterPage3


type alias MasterData =
    { masterEcoValue : Int
    , masterTrackValue : Int
    , masterSecurValue : ( Bool, Bool )
    }


type MasterDataEco
    = M_ECO


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
