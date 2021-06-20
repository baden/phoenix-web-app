module Components.UI.Calendar exposing (..)

import AppState exposing (AppState)
import Components.DateTime
import Html exposing (Html, a, button, div, i, table, td, text, tr)
import Html.Attributes as HA exposing (class, href)
import Html.Events as HE exposing (onClick)
import Html.Lazy exposing (lazy, lazy4)
import List.Extra exposing (unique)
import Set exposing (Set)
import Time
import Url.Builder as UB


type alias Model =
    { mSysId : Maybe String
    , state : VisState
    , hours : List Int
    }


type Msg
    = DoOpen
    | DoClose
    | LoadHours (List Int)



-- | LoadTrack String


type VisState
    = Closed
    | Opened



-- type alias Config msg =
--     { setDate : Int -> msg
--     }


init : Maybe String -> Model
init mSysId =
    { mSysId = mSysId
    , state = Closed
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



-- LoadTrack day ->
--     -- TODO: Это событие будет перехвачено в родительском элементе
--     -- Решение наверное не самое элегантное
--     -- update DoClose model
--     ( { model | state = Choosed day }, Cmd.none )
-- Не понимаю как работает lazy2, но я чет не вижу чтобы оно помогало


view : AppState -> String -> Maybe String -> Model -> Html Msg
view appState sysId mday model =
    case model.state of
        Closed ->
            viewPanelWidget appState mday model

        Opened ->
            viewCalendarWidget appState sysId mday model


viewPanelWidget : AppState -> Maybe String -> Model -> Html Msg
viewPanelWidget appState mday model =
    -- div [ onClick DoOpen ]
    -- [ text "Треки" ]
    Html.button [ class "btn btn-md btn-secondary btn-compact", onClick DoOpen ]
        [ Html.i [ class "material-icons" ] [ text "moving" ]
        , text " "
        , case mday of
            Nothing ->
                text "Треки"

            Just day ->
                text day
        ]


viewChoosed : String -> AppState -> Model -> Html Msg
viewChoosed day appState model =
    -- div [ onClick DoOpen ]
    --     [ text day
    --     ]
    Html.button [ class "btn btn-md btn-secondary", onClick DoOpen ]
        [ Html.i [ class "material-icons" ] [ text "moving" ], text " ", text day ]


viewCalendarWidget : AppState -> String -> Maybe String -> Model -> Html Msg
viewCalendarWidget appState sysId mday model =
    div [ class "calendar_opened" ]
        [ -- , weeksView appState model
          lazy4 dayListWidget appState.timeZone model.hours sysId mday
        , div [ class "calendar_control" ]
            [ a [ class "custom-btn", href <| UB.absolute [ "map", sysId ] [] ] [ text "Скрыть трек" ]
            , div [ class "custom-btn", onClick DoClose ] [ text "Закрыть" ]
            ]
        ]


dayListWidget : Time.Zone -> List Int -> String -> Maybe String -> Html Msg
dayListWidget timeZone hours sysId mday =
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
                                ( hour2day e, hour2day e ) :: acc

                            ( h, d ) :: rest ->
                                if d == hour2day e then
                                    acc

                                else
                                    -- Для универсальности будем сохранять два значения:
                                    -- 1. то что используется в JS
                                    -- 2. то, что отображается в списке
                                    -- Сейчас эти значения одинаковые, но например, на другом языке второе значение может отличаться
                                    ( hour2day e, hour2day e ) :: acc
                    )
                    []

        -- _ =
        --     Debug.log "day_list" ( day_list, timeZone )
        key ( h, d ) =
            a [ HA.classList [ ( "selected", (mday |> Maybe.withDefault "") == d ) ], href <| UB.absolute [ "map", sysId ] [ UB.string "day" d ], class "calendar_control" ] [ text d ]
    in
    day_list
        |> List.map key
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
