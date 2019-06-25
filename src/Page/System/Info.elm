module Page.System.Info exposing (init, update, view, Model, Msg(..))

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (class, href)
import Components.ChartSvg as ChartSvg
import Components.UI as UI
import API.System exposing (SystemDocumentInfo, SysState)


type alias Model =
    { showSomeDialog : Bool
    }


type Msg
    = OnSysCmd String


init : ( Model, Cmd Msg )
init =
    ( { showSomeDialog = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : SystemDocumentInfo -> Html Msg
view system =
    div []
        [ UI.row_item [ text system.title ]

        -- , div [] [ text <| "Id:" ++ system.id ]
        , UI.row_item [ ChartSvg.chartView "Батарея" 80 ]
        , UI.row_item [ text <| "Состояние: " ++ (sysState_of system.state) ]
        , UI.row_item (cmdPanel system.state)
        , UI.row_item [ text "Следующий сеанс связи через 04:25" ]
        , UI.button ("/map/" ++ system.id) "Смотреть на карте"
        , UI.row_item [ UI.button "/" "На главную" ]
        ]


sysState_of : Maybe SysState -> String
sysState_of sysState =
    case sysState of
        Nothing ->
            "-"

        Just state ->
            (state.current)


cmdPanel : Maybe SysState -> List (Html Msg)
cmdPanel sysState =
    case sysState of
        Nothing ->
            []

        Just state ->
            let
                b =
                    \i -> UI.cmdButton i (OnSysCmd i)
            in
                state.available
                    |> List.map b
