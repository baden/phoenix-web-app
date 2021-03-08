module Page.Home exposing (..)

import API
import API.Account exposing (AccountDocumentInfo)
import API.System as System exposing (SystemDocumentInfo)
import AppState exposing (AppState)
import Components.DateTime as DT
import Components.UI as UI exposing (text)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HA
import Msg as GMsg
import Page.Home.List as List
import Page.Home.Types exposing (Model, Msg(..))
import Time
import Types.Dt as DT


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


view : AppState -> Model -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Html Msg
view appState model acc systems =
    -- TODO: Remove one level - transfer function to List (Html Msg)
    Html.div [ HA.class "container" ] <|
        auth_info appState acc systems
            ++ viewRemoveWidget appState model


auth_info : AppState -> Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> List (Html Msg)
auth_info ({ t } as appState) macc systems =
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
                  List.systemListTitle (t "Список Фениксов")
                , List.systemList acc.systems systems appState
                ]



-- dtFormat : DT.Dt -> Time.Zone -> String
-- dtFormat v timeZone =
--     DT.toInt v * 1000 |> Time.millisToPosix |> DT.dateTimeFormat timeZone


viewRemoveWidget : AppState -> Model -> List (Html Msg)
viewRemoveWidget { t } model =
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
