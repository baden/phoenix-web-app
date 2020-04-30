module Page.System.Config.Types exposing (..)

import Dict exposing (Dict)


-- import API.System as System exposing (SystemDocumentParams)


type ShowState
    = SS_Root
    | SS_Master
    | SS_Custom


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
    , showState : ShowState
    , showMasterDialog : MasterPage
    , masterEcoValue : Int
    , masterTrackValue : Int
    , masterSecurValue : ( Bool, Bool )
    , showChanges : Bool
    , showRemodeDialog : Bool
    , removeId : String
    , adminPhone : String
    , adminCode : String
    , systemId : Maybe String
    , showParamChangeDialog : Maybe ParamChange
    }


type alias ParamChange =
    { name : String
    , value : String
    , sysId : String
    , description : String
    }


type Msg
    = OnTitleChangeStart String
    | OnTitleChange String
    | OnTitleConfirm String String
    | OnTitleCancel
    | OnStartMaster String
    | OnCancelMaster
    | OnMasterEco1 Int Bool
    | OnMasterTrack1 Int Bool
    | OnMasterSecur1 Int Bool
    | OnMasterNext
    | OnMasterPrev
    | OnMasterCustom
    | OnConfirmMaster String
    | OnShowChanges
    | OnNoCmd
    | OnRemove String
    | OnCancelRemove
    | OnConfirmRemove
    | OnAdminPhone String
    | OnAdminCode String
    | OnStartEditParam String String String String
    | OnRestoreParam String (Dict String String) String
    | OnChangeParamValue String
    | OnConfirmParam String (Dict String String) String String
    | OnClearQueue String
    | OnCancelParam



-- type alias Queue =
--     Dict String String
-- | OnShowState ShowState
-- | OnAdminPhoneDone
