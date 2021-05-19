module Components.UI.Calendar exposing (..)

import AppState exposing (AppState)
import Components.DateTime
import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (class)
import Html.Events as HE exposing (onClick)
import Html.Lazy exposing (lazy, lazy2)
import List.Extra exposing (unique)
import Set exposing (Set)
import Time


type alias Model =
    { state : VisState
    , hours : List Int
    }


type Msg
    = DoOpen
    | DoClose
    | LoadHours (List Int)
    | LoadTrack Int


type VisState
    = Closed
    | Opened



-- type alias Config msg =
--     { setDate : Int -> msg
--     }


init : Maybe String -> Model
init _ =
    { state = Closed
    , hours = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoOpen ->
            ( { model | state = Opened }, Cmd.none )

        DoClose ->
            ( { model | state = Closed }, Cmd.none )

        LoadHours hs ->
            ( { model | hours = hs }, Cmd.none )

        LoadTrack hour_start ->
            -- TODO: Это событие будет перехвачено в родительском элементе
            -- Решение наверное не самое элегантное
            update DoClose model



-- Не понимаю как работает lazy2, но я чет не вижу чтобы оно помогало


view : AppState -> Model -> Html Msg
view appState model =
    case model.state of
        Closed ->
            viewPanelWidget appState model

        Opened ->
            viewCalendarWidget appState model


viewPanelWidget : AppState -> Model -> Html Msg
viewPanelWidget appState model =
    div [ onClick DoOpen ]
        [ text "Календарь"
        ]


viewCalendarWidget : AppState -> Model -> Html Msg
viewCalendarWidget appState model =
    div [ class "calendar_opened" ]
        [ -- , weeksView appState model
          lazy2 dayListWidget appState.timeZone model.hours
        , div [ class "calendar_control", onClick DoClose ] [ text "Закрыть" ]
        ]


dayListWidget : Time.Zone -> List Int -> Html Msg
dayListWidget timeZone hours =
    let
        -- TODO: Как-то бы формирование этого списка вынести в процедуру загрузки
        hour2day h =
            (h * 3600 * 1000)
                |> Time.millisToPosix
                |> Components.DateTime.dateFormatFull timeZone

        day_list =
            -- hours |> List.map hour2day |> Set.fromList |> Set.toList |> List.sort
            -- List.foldl (\e acc -> e :: acc) []
            -- TODO: Наверное это не самая быстрая реализация. Наверное это через fold* можно сделать быстрее
            -- hours |> List.sort |> List.map hour2day |> unique
            hours
                |> List.sort
                |> List.foldl
                    (\e acc ->
                        case acc of
                            [] ->
                                ( e, hour2day e ) :: acc

                            ( h, d ) :: rest ->
                                if d == hour2day e then
                                    acc

                                else
                                    ( e, hour2day e ) :: acc
                    )
                    []

        _ =
            Debug.log "day_list" ( day_list, timeZone )
    in
    day_list
        |> List.map (\( h, d ) -> div [ class "calendar_control", onClick (LoadTrack h) ] [ text d ])
        |> div [ class "calendar_day_list" ]


weeksView : AppState -> Model -> Html Msg
weeksView appState model =
    let
        weeks =
            [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ]
    in
    weeks
        |> List.map (\d -> div [] [ text d ])
        |> div [ class "calenrad_weeks" ]
