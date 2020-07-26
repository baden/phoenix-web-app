module Page.System.Info.Types exposing (..)

import API.System as System exposing (SystemDocumentInfo, State, State(..))


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , showSleepProlongDialog : Bool
    , showCommandConfirmDialog : Maybe State
    , offId : String
    , batteryExtendView : BatteryViewPage
    , newBatteryCapacity : BatteryChange
    , smartBlock : Bool
    }


type BatteryViewPage
    = BVP1
    | BVP2
    | BVP3


type BatteryChange
    = BC_None
    | BC_Change String
    | BC_Capacity String


type Msg
    = OnSysCmd String System.State
    | OnSysCmdPre String System.State
    | OnSysCmdCancel String
    | OnSmartBlockCheck Bool
    | OnExtendInfo
    | OnConfirmOff
    | OnCancelOff
    | OnShowProlongSleepDialog
    | OnHideProlongSleepDialog
    | OnHideCmdConfirmDialog
    | OnProlongSleep String Int
    | OnBatteryClick
    | OnBatteryMaintance
    | OnBatteryMaintanceDone
    | OnBatteryChange BatteryChange
    | OnBatteryCapacityConfirm String String
    | OnBatteryCapacityCancel
    | OnNoCmd
