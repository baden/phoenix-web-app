module Page.Home exposing (..)

import Html exposing (Html)
import API
import API.Account exposing (AccountDocumentInfo)
import API.System as System exposing (SystemDocumentInfo)
import Dict exposing (Dict)
import Time
import Components.UI as UI exposing (text)
import Components.DateTime as DT
import Msg
import AppState
import Types.Dt as DT


type alias Model =
    { showRemodeDialog : Bool
    , removeIndex : Int
    }


type Msg
    = OnRemove Int
    | OnCancelRemove
    | OnConfirmRemove


init : ( Model, Cmd Msg )
init =
    ( { showRemodeDialog = False
      , removeIndex = -1
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Msg.UpMsg )
update msg model =
    case msg of
        OnRemove index ->
            ( { model | showRemodeDialog = True, removeIndex = index }, Cmd.none, Nothing )

        OnCancelRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Nothing )

        OnConfirmRemove ->
            ( { model | showRemodeDialog = False }, Cmd.none, Just (Msg.RemoveSystemFromList model.removeIndex) )


view : AppState.AppState -> Model -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Html Msg
view appState model acc systems =
    UI.column12 <|
        [ auth_info acc systems appState.timeZone

        -- , UI.button "/login" "Авторизация"
        -- , UI.button "/map" "Карта"
        ]
            ++ (viewRemoveWidget model)


viewRemoveWidget : Model -> List (Html Msg)
viewRemoveWidget model =
    if model.showRemodeDialog then
        [ UI.modal
            "Удаление"
            [ UI.ModalText "Вы уверены что хотите удалить систему из списка наблюдения?"
            , UI.ModalText "Напоминаю, что вы не можете просто добавить систему в список наблюдения, необходимо проделать определенную процедуру."
            ]
            [ UI.cmdButton "Да" (OnConfirmRemove)
            , UI.cmdButton "Нет" (OnCancelRemove)
            ]
        , UI.modal_overlay OnCancelRemove
        ]
    else
        []


auth_info : Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> Html Msg
auth_info macc systems timeZone =
    UI.card_panel <|
        case macc of
            Nothing ->
                [ text "Чтобы пользоваться сервисом, вы должны "
                , UI.linkButton "авторизоваться" "/login"
                , text " в системе."
                ]

            Just acc ->
                if List.length acc.systems == 0 then
                    [ UI.row_item [ text <| "Добро пожаловать!" ]
                    , UI.row_item [ text <| "Добавьте систему в список наблюдения" ]
                    , UI.row_item [ UI.linkButton "Добавить систему" "/linksys" ]
                    ]
                else
                    [ -- UI.row_item [ text <| "Вы авторизованы как " ++ acc.realname ]
                      -- UI.row_item [ text <| "В списке наблюдения систем: " ++ (String.fromInt <| List.length acc.systems) ]
                      systemList acc.systems systems timeZone
                    , UI.row_item [ UI.linkButton "Добавить систему" "/linksys" ]
                    ]


systemList : List String -> Dict String SystemDocumentInfo -> Time.Zone -> Html Msg
systemList sysIds systems timeZone =
    UI.row
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
        body =
            case Dict.get sysId systems of
                Nothing ->
                    [ UI.row_item [ UI.text "Данные по трекеру еще не получены или недостаточно прав для доступа к трекеру" ]
                    ]

                Just system ->
                    [ UI.info_2_10 "Название:" system.title
                    , UI.info_2_10 "Состояние:" (sysState_of system.dynamic timeZone)
                    , UI.info_2_10 "Последная известная позиция:" (position_of system.dynamic timeZone)
                    ]

        footer =
            [ UI.row_item
                [ UI.linkButton "Управление" ("/system/" ++ sysId)
                , UI.cmdButton "Удалить" (OnRemove index)
                ]
            ]
    in
        -- UI.card (title ++ body ++ footer)
        UI.card (body ++ footer)


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
                    (System.stateAsString state)


position_of : Maybe System.Dynamic -> Time.Zone -> String
position_of maybe_system_dynamic timeZone =
    case maybe_system_dynamic of
        Nothing ->
            "неизвестно"

        Just dynamic ->
            -- ((String.fromFloat lastPosition.lat)
            --     ++ ", "
            --     ++ (String.fromFloat lastPosition.lon)
            --     ++ "@"
            --     ++ (dtFormat lastPosition.dt timeZone)
            -- )
            ("{TBD}, {TBD}")


dtFormat : DT.Dt -> Time.Zone -> String
dtFormat v timeZone =
    (DT.toInt v) * 1000 |> Time.millisToPosix |> DT.dateTimeFormat timeZone
