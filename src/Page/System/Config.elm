module Page.System.Config exposing (init, update, view, Model, Msg(..))

import Html exposing (Html, div, text, a)
import Html.Attributes as HA
import AppState
import API.System as System exposing (SystemDocumentInfo, State, State(..))


type alias Model =
    { extendInfo : Bool
    , showConfirmOffDialog : Bool
    , offId : String
    }


type Msg
    = OnNoCmd


init : ( Model, Cmd Msg )
init =
    ( { extendInfo = False
      , showConfirmOffDialog = False
      , offId = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnNoCmd ->
            ( model, Cmd.none )


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view appState model system =
    Html.div []
        [ Html.text "Страница конфигурации для системы "
        , Html.span [ HA.class "blue-text text-darken-2" ] [ Html.text system.title ]
        , Html.text " находится в разработке..."
        ]
