module Page.System.Config.Types exposing (..)


type MasterPage
    = MasterPage1
    | MasterPage2
    | MasterPage3


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , offId : String
    , showTitleChangeDialog : Bool
    , newTitle : String
    , showMasterDialog : Maybe MasterPage
    , masterEcoValue : Int
    , masterTrackValue : Int
    }


type Msg
    = OnTitleChangeStart String
    | OnTitleChange String
    | OnTitleConfirm String String
    | OnTitleCancel
    | OnStartMaster
    | OnCancelMaster
    | OnMasterEco1 Int Bool
    | OnMasterTrack1 Int Bool
    | OnMasterNext
    | OnMasterPrev
    | OnNoCmd
