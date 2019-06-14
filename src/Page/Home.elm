module Page.Home exposing (view)

import Html exposing (Html)
import API
import API.Account exposing (AccountDocumentInfo)
import API.System exposing (SystemDocumentInfo, LastPosition)
import Dict exposing (Dict)
import Time
import Components.UI as UI exposing (text)
import Components.DateTime as DT


view : Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> Html a
view acc systems timeZone =
    UI.column12
        [ UI.app_title
        , UI.qr_code
        , auth_info acc systems timeZone
        , UI.button "/login" "Авторизация"
        , UI.button "/map" "Карта"
        ]


auth_info : Maybe AccountDocumentInfo -> Dict String SystemDocumentInfo -> Time.Zone -> Html a
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


systemList : List String -> Dict String SystemDocumentInfo -> Time.Zone -> Html a
systemList sysIds systems timeZone =
    UI.row
        (sysIds
            |> List.map (systemItem systems timeZone)
        )


systemItem : Dict String SystemDocumentInfo -> Time.Zone -> String -> Html a
systemItem systems timeZone sysId =
    UI.card <|
        case Dict.get sysId systems of
            Nothing ->
                [ UI.info_2_10 "ID:" sysId
                , UI.row_item [ UI.text "Данные по трекеру еще не получены" ]
                , UI.row_item [ UI.linkButton "Управление" ("/system/" ++ sysId) ]
                ]

            Just system ->
                [ UI.info_2_10 "ID:" sysId
                , UI.info_2_10 "Название:" system.title
                , UI.info_2_10 "Последная известная позиция:" (position_of system.lastPosition timeZone)
                , UI.row_item
                    [ UI.linkButton "Управление" ("/system/" ++ sysId)
                    , UI.linkButton "Удалить" ("/system/delete/" ++ sysId)
                    ]
                ]


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
