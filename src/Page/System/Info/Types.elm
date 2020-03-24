module Page.System.Info.Types exposing (Model, Msg(..))

import API.System as System exposing (SystemDocumentInfo, State, State(..))


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , showSleepProlongDialog : Bool
    , offId : String
    }


type Msg
    = OnSysCmd String System.State
    | OnSysCmdCancel String
    | OnExtendInfo
    | OnConfirmOff
    | OnCancelOff
    | OnShowProlongSleepDialog
    | OnHideProlongSleepDialog
    | OnProlongSleep String Int
    | OnNoCmd
