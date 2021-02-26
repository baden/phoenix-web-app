module Page.Home.Types exposing (Model, Msg(..))


type alias Model =
    { showRemodeDialog : Bool
    , removeId : String
    }


type Msg
    = OnRemove String
    | OnCancelRemove
    | OnConfirmRemove
