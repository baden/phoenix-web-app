module Page.System.Info.Position exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events exposing (onClick)
import Page.System.Info.Types exposing (..)
import Types.Dt as DT


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    div [ class "details-item details-title-flat" ]
        [ div [ class "title" ] [ text <| t "control.Положение" ]
        , div [ class "content" ] <|
            case system.dynamic of
                Nothing ->
                    [ div [ class "content-item" ]
                        [ span [ class "name" ] [ text <| t "control.Информация будет доступна после выхода Феникса на связь." ]
                        ]
                    ]

                Just dynamic ->
                    [ case ( dynamic.latitude, dynamic.longitude, dynamic.dt ) of
                        ( Just latitude, Just longitude, Just dt ) ->
                            div [ class "content-item" ]
                                [ span [ class "name" ] [ text <| t "control.Положение определено:" ]
                                , span [ class "text" ] [ text (dt |> DT.toPosix |> Dates.dateTimeFormat appState.timeZone) ]
                                ]

                        ( _, _, _ ) ->
                            div [ class "content-item" ]
                                [ span [ class "name" ] [ text <| t "control.Положение неизвестно" ]
                                ]
                    , case dynamic.available |> List.member System.Point of
                        True ->
                            div [ class "content-item content-item-group" ]
                                [ a [ class "details-blue-title blue-gradient-text", href ("/map/" ++ system.id) ]
                                    [ span [ class "details-icon icon-map" ] [], text <| t "control.Показать" ]
                                , div [ class "details-blue-title blue-gradient-text", onClick (OnSysCmdPre system.id System.Point) ]
                                    [ span [ class "details-icon icon-refresh" ] [], text <| t "control.Обновить" ]
                                ]

                        False ->
                            text ""
                    ]
        ]



-- sysPosition : AppState.AppState -> String -> Maybe System.Dynamic -> List (Html msg)
-- sysPosition appState sid maybe_dynamic =
--     case maybe_dynamic of
--         Nothing ->
--             []
--
--         Just dynamic ->
--             case ( dynamic.latitude, dynamic.longitude, dynamic.dt ) of
--                 ( Just latitude, Just longitude, Just dt ) ->
--                     [ Html.div [ HA.class "row sessions" ]
--                         [ --text <| "Последнее положение определено: " ++ (dt |> DT.toPosix |> dateTimeFormat appState.timeZone) ++ " "
--                           Html.div [ HA.class "col s8 l6" ] [ text "Положение определено:" ]
--                         , Html.div [ HA.class "col s4 l3" ] [ text <| (dt |> DT.toPosix |> Dates.dateTimeFormat appState.timeZone) ]
--                         , Html.div [ HA.class "col s12 l3" ] [ UI.linkIconTextButton "map" "Карта" ("/map/" ++ sid) ]
--
--                         -- , Html.div [ HA.class "col s12 l3", HA.style "text-align" "left" ] [ UI.iconButton "map" ("/map/" ++ sid) ]
--                         ]
--                     ]
--
--                 ( _, _, _ ) ->
--                     [ UI.row_item [ text <| "Положение неизвестно" ] ]
