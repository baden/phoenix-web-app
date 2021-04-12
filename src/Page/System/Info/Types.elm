module Page.System.Info.Types exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , showSleepProlongDialog : Bool
    , showCommandConfirmDialog : Maybe State
    , offId : String
    , showPhone : Bool
    , showCopyPhonePanel : Bool

    -- , smartBlock : Bool
    }


type Msg
    = OnSysCmd String System.State
    | OnSysCmdPre String System.State
    | OnSysCmdCancel String
      -- | OnSmartBlockCheck Bool
    | OnExtendInfo
    | OnConfirmOff
    | OnCancelOff
    | OnShowProlongSleepDialog
    | OnHideProlongSleepDialog
    | OnHideCmdConfirmDialog
    | OnProlongSleep String Int
      -- | OnBatteryClick
      -- | OnBatteryMaintance
      -- | OnBatteryMaintanceDone
    | OnNoCmd
    | OnShowPhone
    | OnHidePhone
    | OnCopyPhone String
    | OnCopyPhoneDone
