module Page.System.Config.Types exposing (Model, Msg(..))


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , offId : String
    , showTitleChangeDialog : Bool
    , newTitle : String
    , showMasterDialog : Bool
    , masterEcoValue : Int
    }


type Msg
    = OnTitleChangeStart String
    | OnTitleChange String
    | OnTitleConfirm String String
    | OnTitleCancel
    | OnStartMaster
    | OnCancelMaster
    | OnMasterEco1 Int Bool
    | OnNoCmd
