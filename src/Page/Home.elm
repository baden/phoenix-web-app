module Page.Home exposing (..)

import API
import API.Account exposing (AccountDocumentInfo)
import API.System as System exposing (SystemDocumentInfo)
import AppState
import Components.DateTime as DT
import Components.UI as UI exposing (text)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HA
import Msg as GMsg
import Time
import Types.Dt as DT


type alias Model =
    { showRemodeDialog : Bool
    , removeId : String
    }


type Msg
    = OnRemove String
    | OnCancelRemove
    | OnConfirmRemove


init : ( Model, Cmd Msg )
init =
    ( { showRemodeDialog = False
      , removeId = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe GMsg.UpMsg )
update msg model =
    case msg of
        OnRemove sid ->
            ( { model | showRemodeDialog = True, removeId = sid }, Cmd.none, Nothing )

        OnCancelRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Nothing )

        OnConfirmRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Just (GMsg.RemoveSystemFromList model.removeId) )


view : AppState.AppState -> Model -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Html Msg
view appState model acc systems =
    -- UI.column12 <|
    -- TODO: Remove one level - transfer function to List (Html Msg)
    Html.div [ HA.class "container" ] <|
        auth_info appState acc systems appState.timeZone
            ++ viewRemoveWidget model


viewRemoveWidget : Model -> List (Html Msg)
viewRemoveWidget model =
    if model.showRemodeDialog then
        [ UI.modal
            "Удаление"
            [ UI.ModalText "Вы уверены что хотите удалить систему из списка наблюдения?"
            , UI.ModalText "Напоминаю, что вы не можете просто добавить систему в список наблюдения, необходимо проделать определенную процедуру."
            ]
            [ UI.cmdButton "Да" OnConfirmRemove
            , UI.cmdButton "Нет" OnCancelRemove
            ]
        , UI.modal_overlay OnCancelRemove
        ]

    else
        []


auth_info : AppState.AppState -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> List (Html Msg)
auth_info { t } macc systems timeZone =
    -- UI.card_panel <|
    case macc of
        Nothing ->
            --[ UI.smallForm
            [ UI.formHeader "Добро пожаловать"
            , UI.formSubtitle "Чтобы пользоваться сервисом, вы должны "
            , UI.greenLink "/login" "авторизоваться"
            , text " или "
            , UI.greenLink "/auth" "зарегистрироваться"
            , text " в системе."
            ]

        --]
        Just acc ->
            if List.length acc.systems == 0 then
                -- [ UI.row_item [ text <| "Добро пожаловать!" ]
                -- , UI.row_item [ text <| "Добавьте объект в список наблюдения" ]
                -- , UI.row_item [ UI.linkIconTextButton "plus-square" "Добавить Феникс" "/linksys" ]
                -- ]
                [ UI.wellcomeContent
                    [ UI.wellcomeTitle "Добро пожаловать!"
                    , UI.formSubtitle "Добавьте Феникс в список наблюдения"
                    , UI.wellcomeButton "Добавить"
                    ]
                ]

            else
                [ -- UI.row_item [ text <| "Вы авторизованы как " ++ acc.realname ]
                  -- UI.row_item [ text <| "В списке наблюдения систем: " ++ (String.fromInt <| List.length acc.systems) ]
                  UI.systemListTitle (t "Список Фениксов")
                , systemList acc.systems systems timeZone
                , UI.row_item [ UI.linkIconTextButton "plus-square" "Добавить Феникс" "/linksys" ]
                ]


systemList : List String -> Dict String SystemDocumentInfo -> Time.Zone -> Html Msg
systemList sysIds systems timeZone =
    UI.systemList
        (sysIds
            |> List.indexedMap (systemItem systems timeZone)
        )


systemItem : Dict String SystemDocumentInfo -> Time.Zone -> Int -> String -> Html Msg
systemItem systems timeZone index sysId =
    let
        -- title =
        --     [ UI.info_2_10 "Index:" (String.fromInt index)
        --     , UI.info_2_10 "ID:" sysId
        --     ]
        maybe_system =
            Dict.get sysId systems

        header =
            case maybe_system of
                Nothing ->
                    []

                Just system ->
                    [ UI.cardHeader (sysState_of system.dynamic timeZone) ("/system/" ++ sysId ++ "/config") ]

        body =
            case maybe_system of
                Nothing ->
                    [ UI.row_item [ UI.text "Данные по объекту еще не получены или недостаточно прав для доступа" ]
                    ]

                Just system ->
                    [ UI.cardBody
                        [ UI.cardTitle system.title
                        , UI.cardPwrPanel

                        -- , UI.info_2_10 "Текущий режим:" (sysState_of system.dynamic timeZone)
                        -- , curState (sysState_of system.dynamic timeZone)
                        ]
                    ]

        footer =
            -- [ UI.row_item <|
            --     [ UI.linkIconTextButton "gamepad" "Управление" ("/system/" ++ sysId)
            --     , UI.linkIconTextButton "cog" "Настройка" ("/system/" ++ sysId ++ "/config")
            --     ]
            --         ++ ifPosition maybe_system
            --
            -- -- ++ [ UI.cmdTextIconButton "trash" "Удалить" (OnRemove index)]
            -- ]
            [ UI.cardFooter ("/system/" ++ sysId) (ifPosition maybe_system) ]
    in
    -- UI.card (title ++ body ++ footer)
    UI.card <| header ++ body ++ footer


curState : String -> Html Msg
curState t =
    UI.row_item
        [ Html.span
            [ HA.class "blue-text text-darken-2"
            , HA.style "font-size" "1.2em"
            , HA.style "font-weight" "bold"
            ]
            [ Html.text t ]
        ]


ifPosition : Maybe SystemDocumentInfo -> Maybe String
ifPosition maybe_system =
    case maybe_system of
        Nothing ->
            Nothing

        Just system ->
            case system.dynamic of
                Nothing ->
                    Nothing

                Just dynamic ->
                    case ( dynamic.latitude, dynamic.longitude ) of
                        ( Just _, Just _ ) ->
                            Just ("/map/" ++ system.id)

                        _ ->
                            Nothing


sysState_of : Maybe System.Dynamic -> Time.Zone -> String
sysState_of dynamic timeZone =
    case dynamic of
        Nothing ->
            "-"

        Just d ->
            case d.state of
                Nothing ->
                    "-"

                Just state ->
                    System.stateAsString state


position_of : Maybe System.Dynamic -> Time.Zone -> String
position_of maybe_system_dynamic timeZone =
    case maybe_system_dynamic of
        Nothing ->
            "неизвестно"

        Just dynamic ->
            maybeLatLong dynamic.latitude dynamic.longitude


maybeLatLong : Maybe Float -> Maybe Float -> String
maybeLatLong mlatitude mlongitude =
    case ( mlatitude, mlongitude ) of
        -- ( Nothing, _ ) ->
        --     "данные не получены"
        --
        -- ( _, Nothing ) ->
        --     "данные не получены"
        ( Just latitude, Just longitude ) ->
            (String.fromFloat latitude
                ++ ", "
                ++ String.fromFloat longitude
             -- ++ "@"
             -- ++ (dtFormat lastPosition.dt timeZone)
            )

        ( _, _ ) ->
            "данные не получены"


dtFormat : DT.Dt -> Time.Zone -> String
dtFormat v timeZone =
    DT.toInt v * 1000 |> Time.millisToPosix |> DT.dateTimeFormat timeZone
