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
    , masterSecurValue : ( Bool, Bool )
    , showRemodeDialog : Bool
    , removeId : String
    , adminPhone : String
    , adminCode : String
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
    | OnMasterSecur1 Int Bool
    | OnMasterNext
    | OnMasterPrev
    | OnNoCmd
    | OnRemove String
    | OnCancelRemove
    | OnConfirmRemove
    | OnAdminPhone String
    | OnAdminCode String



-- | OnAdminPhoneDone
