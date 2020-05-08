module Page.System.Config.Types exposing (..)

import Dict exposing (Dict)
import Page.System.Config.Master.Types exposing (..)


-- import API.System as System exposing (SystemDocumentParams)


type ShowState
    = SS_Root
    | SS_Master
    | SS_Custom


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , offId : String
    , showTitleChangeDialog : Bool
    , newTitle : String
    , showState : ShowState
    , showMasterDialog : MasterPage

    -- , masterEcoValue : Int
    -- , masterTrackValue : Int
    -- , masterSecurValue : ( Bool, Bool )
    , masterData : MasterData
    , showChanges : Bool
    , showRemodeDialog : Bool
    , removeId : String
    , smsPhone1 : String
    , ussdPhone : String
    , adminPhone : String
    , adminCode : String
    , systemId : Maybe String
    , showParamChangeDialog : Maybe ParamChange
    , showQueue : Bool
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
    | OnMasterEco1 MasterDataEco Bool
    | OnMasterTrack1 MasterDataTrack Bool
    | OnMasterSecur1 Int Bool
    | OnMasterSMSEvent (Bool -> MasterDataSMS -> MasterDataSMS) Bool
    | OnMasterNext
    | OnMasterPrev
    | OnMasterCustom
    | OnConfirmMaster String (Dict String String)
    | OnShowChanges
    | OnNoCmd
    | OnRemove String
    | OnCancelRemove
    | OnConfirmRemove
    | OnSMSPhone1 String
    | OnUSSDPhone String
    | OnAdminPhone String
    | OnAdminCode String
    | OnStartEditParam String String String String
    | OnRestoreParam String (Dict String String) String
    | OnChangeParamValue String
    | OnConfirmParam String (Dict String String) String String
    | OnClearQueue String
    | OnShowQueue
    | OnCancelParam



-- type alias Queue =
--     Dict String String
-- | OnShowState ShowState
-- | OnAdminPhoneDone
