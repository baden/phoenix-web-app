module Page.System.Info.Session exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events as HE
import Page.System.Info.Types exposing (..)
import Types.Dt as DT



-- ++ Dates.nextSession appState system.dynamic


view : AppState.AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t, now } as appState) model system =
    div [ class "details-item" ]
        [ div [ class "title" ] [ text <| t "control.Связь" ]
        , div [ class "content" ] <|
            case system.dynamic of
                Nothing ->
                    -- [ text "Информация будет доступна после выхода Феникса на связь." ]
                    [ div [ class "content-item" ]
                        [ span [ class "name" ] [ text <| t "control.Информация будет доступна после выхода Феникса на связь." ]
                        ]
                    ]

                Just dynamic ->
                    let
                        last_session =
                            case dynamic.lastping of
                                Nothing ->
                                    DT.fromInt 0

                                Just lastping ->
                                    lastping

                        tz =
                            appState.timeZone

                        nextSessionTextRow =
                            case dynamic.state of
                                Just System.Off ->
                                    []

                                _ ->
                                    [ div [ class "content-item" ]
                                        [ span [ class "name" ] [ text <| t "control.Следующий сеанс связи:" ]
                                        , span [ class "text" ] [ text <| Dates.nextSessionText appState last_session dynamic.next tz ]
                                        ]
                                    ]
                    in
                    [ div [ class "content-item" ]
                        [ span [ class "name" ] [ text <| t "control.Последний сеанс связи:" ]
                        , span [ class "text" ] [ text <| (last_session |> DT.toPosix |> Dates.dateTimeFormat tz) ]
                        ]
                    ]
                        ++ nextSessionTextRow
        ]



-- nextSession : AppState.AppState -> Maybe System.Dynamic -> List (Html msg)
-- nextSession appState maybeSystemDynamic =
