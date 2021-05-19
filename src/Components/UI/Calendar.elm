module Components.UI.Calendar exposing (..)

import AppState exposing (AppState)
import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (class)
import Html.Events as HE exposing (onClick)


type alias Model =
    { state : VisState }


type Msg
    = DoOpen
    | DoClose


type VisState
    = Closed
    | Opened


init : Maybe String -> Model
init _ =
    { state = Closed
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoOpen ->
            ( { model | state = Opened }, Cmd.none )

        DoClose ->
            ( { model | state = Closed }, Cmd.none )


view : AppState -> Model -> Html Msg
view appState model =
    case model.state of
        Closed ->
            viewPanelWidget model

        Opened ->
            viewCalendarWidget model


viewPanelWidget : Model -> Html Msg
viewPanelWidget model =
    div [ onClick DoOpen ]
        [ text "Календарь"
        ]


viewCalendarWidget : Model -> Html Msg
viewCalendarWidget model =
    div [ class "calendar_opened" ]
        [ div [] [ text "Май" ]
        , weeksView model
        , div [ class "calendar_control", onClick DoClose ] [ text "Закрыть" ]
        ]


weeksView : Model -> Html Msg
weeksView model =
    let
        weeks =
            [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ]
    in
    weeks
        |> List.map (\d -> div [] [ text d ])
        |> div [ class "calenrad_weeks" ]
