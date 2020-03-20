module Page.System.Info.Types exposing (Model, Msg(..))

import API.System as System exposing (SystemDocumentInfo, State, State(..))


type alias Model =
    { showTitleChangeDialog : Bool
    , newTitle : String
    , extendInfo : Bool
    , showConfirmOffDialog : Bool
    , showSleepProlongDialog : Bool
    , offId : String
    }


type Msg
    = OnSysCmd String System.State
    | OnSysCmdCancel String
    | OnTitleChangeStart String
    | OnTitleChange String
    | OnTitleConfirm String String
    | OnTitleCancel
    | OnExtendInfo
    | OnConfirmOff
    | OnCancelOff
    | OnShowProlongSleepDialog
    | OnHideProlongSleepDialog
    | OnProlongSleep String Int
    | OnNoCmd
