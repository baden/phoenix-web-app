module Page.Home exposing (..)

import Html exposing (Html)
import API
import API.Account exposing (AccountDocumentInfo)
import API.System exposing (SystemDocumentInfo, LastPosition, SysState)
import Dict exposing (Dict)
import Time
import Components.UI as UI exposing (text)
import Components.DateTime as DT
import Msg


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


view : Model -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> Html Msg
view model acc systems timeZone =
    UI.column12 <|
        [ UI.app_logo
        , UI.qr_code
        , auth_info acc systems timeZone
        , UI.button "/login" "Авторизация"
        , UI.button "/map" "Карта"
        ]
            ++ (if model.showRemodeDialog then
                    [ UI.modal
                        "Удаление"
                        [ "Вы уверены что хотите удалить систему из списка наблюдения?"
                        , "Напоминаю, что вы не можете просто добавить систему в список наблюдения, необходимо проделать определенную процедуру."
                        ]
                        [ UI.cmdButton "Да" (OnConfirmRemove)
                        , UI.cmdButton "Нет" (OnCancelRemove)
                        ]
                    , UI.modal_overlay OnCancelRemove
                    ]
                else
                    []
               )


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
                [ UI.row_item [ text <| "Вы авторизованы как " ++ acc.realname ]
                , UI.row_item [ text <| "У вас в списке наблюдения " ++ (String.fromInt <| List.length acc.systems) ++ " систем" ]
                , systemList acc.systems systems timeZone
                , UI.row_item [ UI.linkButton "Добавить систему в список наблюдения" "/linksys" ]
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
        title =
            [ UI.info_2_10 "Index:" (String.fromInt index)
            , UI.info_2_10 "ID:" sysId
            ]

        body =
            case Dict.get sysId systems of
                Nothing ->
                    [ UI.row_item [ UI.text "Данные по трекеру еще не получены" ]
                    ]

                Just system ->
                    [ UI.info_2_10 "Название:" system.title
                    , UI.info_2_10 "Состояние:" (sysState_of system.state timeZone)
                    , UI.info_2_10 "Последная известная позиция:" (position_of system.lastPosition timeZone)
                    ]

        footer =
            [ UI.row_item
                [ UI.linkButton "Управление" ("/system/" ++ sysId)
                , UI.cmdButton "Удалить" (OnRemove index)
                ]
            ]
    in
        UI.card (title ++ body ++ footer)


sysState_of : Maybe SysState -> Time.Zone -> String
sysState_of sysState timeZone =
    case sysState of
        Nothing ->
            "-"

        Just state ->
            (state.current)


position_of : Maybe LastPosition -> Time.Zone -> String
position_of last_position timeZone =
    case last_position of
        Nothing ->
            "неизвестно"

        Just lastPosition ->
            ((String.fromFloat lastPosition.lat)
                ++ ", "
                ++ (String.fromFloat lastPosition.lon)
                ++ "@"
                ++ (lastPosition.dt * 1000 |> Time.millisToPosix |> DT.dateTimeFormat timeZone)
            )
