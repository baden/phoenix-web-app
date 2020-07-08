module Page.System.Info.CmdPanel exposing (..)

import AppState
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import Html exposing (Html, div, a)
import Html.Attributes as HA exposing (class, href)
import Page.System.Info.Types exposing (..)
import Types.Dt as DT
import Components.Dates as Dates
import Components.UI as UI exposing (..)


-- Состояние панели управления


type CmdPanelState
    = CPS_Commands
    | CPS_WaitStateExpanded
    | CPS_WaitStateCompact


cmdPanel : AppState.AppState -> String -> Maybe System.Dynamic -> List (Html Msg)
cmdPanel appState sysId maybe_dynamic =
    case maybe_dynamic of
        Nothing ->
            []

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

                pre_date =
                    Dates.nextSessionText last_session dynamic.next tz

                pre =
                    pre_date ++ ", при следующем сеансе связи, "

                cmdWidget =
                    Html.div [ HA.class "cmdWidget" ]

                tlabel t =
                    Html.div [ class "cmdWaitLabel" ] [ text t ]
            in
                case dynamic.waitState of
                    Nothing ->
                        case dynamic.state of
                            Nothing ->
                                []

                            Just Config ->
                                cmdPanelConfig sysId

                            Just state ->
                                let
                                    b =
                                        \i ->
                                            -- Html.div [ HA.class "col s12 m6 l3 xl3" ]
                                            Html.div [ HA.class "cmdButton" ]
                                                -- [ UI.cmdButton (System.stateAsCmdString i) (OnSysCmd sysId i) ]
                                                [ UI.cmdTextIconButton (System.iconForCmdString i) (System.stateAsCmdString i) (OnSysCmd sysId i) ]
                                in
                                    [ cmdWidget
                                        (dynamic.available
                                            |> List.filter (\st -> st /= Off)
                                            |> List.map b
                                        )
                                    ]

                    Just Point ->
                        [ cmdWidget
                            [ preloader
                            , tlabel <| pre ++ "будет определено текущее местоположение"
                            , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                            ]
                        ]

                    Just (ProlongSleep duration) ->
                        let
                            durationText h =
                                case h of
                                    2 ->
                                        "2 часа"

                                    12 ->
                                        "12 часов"

                                    24 ->
                                        "сутки"

                                    _ ->
                                        String.fromInt h ++ " ч"
                        in
                            [ cmdWidget
                                [ preloader
                                , tlabel <| pre ++ "будет продлена работа Феникса в режиме Поиск на " ++ durationText duration
                                , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                                ]
                            ]

                    Just Lock ->
                        [ cmdWidget
                            [ preloader
                            , tlabel <| pre ++ "двигатель будет заблокирован"
                            , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                            ]
                        ]

                    Just Unlock ->
                        [ cmdWidget
                            [ preloader
                            , tlabel <| pre ++ "двигатель будет разблокирован"
                            , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                            ]
                        ]

                    Just Off ->
                        [ cmdWidget
                            [ preloader
                            , tlabel <| pre ++ "Феникс будет выключен"
                            , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                            ]
                        ]

                    Just wState ->
                        [ cmdWidget
                            [ preloader
                            , tlabel <| pre ++ "Феникс будет переведён в режим " ++ (System.stateAsString wState)
                            , UI.cmdButton "Отменить" (OnSysCmdCancel sysId)
                            ]
                        ]


cmdPanelConfig : String -> List (Html Msg)
cmdPanelConfig sysId =
    [ UI.text <| "В разработке..."
    ]


preloader : Html Msg
preloader =
    Html.div [ HA.class "progress" ]
        [ Html.div [ HA.class "indeterminate" ] []
        ]
