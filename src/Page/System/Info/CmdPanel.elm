module Page.System.Info.CmdPanel exposing (..)

import AppState
import API.System as System exposing (SystemDocumentInfo, State, State(..))
import Html exposing (Html, div, a, label, input, span)
import Html.Attributes as HA exposing (class, href)
import Html.Events as HE
import Page.System.Info.Types exposing (..)
import Types.Dt as DT
import Components.Dates as Dates
import Components.UI as UI exposing (..)


-- Состояние панели управления
-- type CmdPanelState
--     = CPS_Commands
--     | CPS_WaitStateExpanded
--     | CPS_WaitStateCompact


waitStateLabel : State -> String
waitStateLabel state =
    case state of
        Point ->
            "будет определено текущее местоположение"

        ProlongSleep duration ->
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
                ("будет продлена работа Феникса в режиме Поиск на " ++ durationText duration)

        Lock ->
            "двигатель будет заблокирован"

        Unlock ->
            "двигатель будет разблокирован"

        Off ->
            "Феникс будет выключен"

        wState ->
            "Феникс будет переведён в режим " ++ (System.stateAsString wState)


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
                                                [ UI.cmdTextIconButton (System.iconForCmdString i) (System.stateAsCmdString i) (OnSysCmdPre sysId i) ]
                                in
                                    [ cmdWidget
                                        (dynamic.available
                                            |> List.filter (\st -> st /= Off)
                                            -- Не очень элегантное решение заменить блокировку умной блокировкой
                                            |> List.map
                                                (\st ->
                                                    case st of
                                                        Lock ->
                                                            SLock

                                                        _ ->
                                                            st
                                                )
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


confirmDialog : Model -> String -> List (Html Msg)
confirmDialog model sysId =
    let
        pre =
            "При следующем сеансе связи "
    in
        case model.showCommandConfirmDialog of
            Nothing ->
                []

            Just state ->
                let
                    pmain =
                        case state of
                            SLock ->
                                [ UI.ModalText <| pre ++ "будет запущена отложенная блокировка двигателя."
                                , UI.ModalHtml <| checkbox "Умная блокировка" True (always <| OnSysCmdPre sysId Lock)
                                , UI.ModalText "Феникс даст возможность автомобилю беспрепятственно покинуть место отстоя, определит его координаты и при первой же остановке автомобиля – заблокирует двигатель."
                                , UI.ModalText "Рекомендуется в случаях, если автомобиль может находиться в подземном гараже или в специальном «отстойнике», где определение координат может быть невозможным. В случае блокировки двигателя автомобиль не сможет покинуть место отстоя своим ходом, что насторожит угонщиков и приведёт к устранению «неисправности» и обнаружению Феникса."
                                ]

                            Lock ->
                                [ UI.ModalText <| pre ++ "будет запущена отложенная блокировка двигателя."
                                , UI.ModalHtml <| checkbox "Умная блокировка" False (always <| OnSysCmdPre sysId SLock)
                                , UI.ModalText "Если автомобиль находится в движении – Феникс заблокирует двигатель при его остановке, если автомобиль неподвижен – Феникс заблокирует двигатель немедленно."
                                , UI.ModalText "Рекомендуется в случаях, если автомобиль точно не успел доехать до «отстойника» или если автомобиль находится в прямой видимости."
                                ]

                            _ ->
                                [ UI.ModalText <| pre ++ waitStateLabel state
                                ]
                in
                    [ UI.modal
                        ""
                        pmain
                        [ UI.cmdButton "Отменить" (OnHideCmdConfirmDialog)
                        , UI.cmdButton "Применить" (OnSysCmd sysId state)
                        ]
                    , UI.modal_overlay OnHideCmdConfirmDialog
                    ]


checkbox : String -> Bool -> (Bool -> Msg) -> UI Msg
checkbox label_ checked_ msg =
    row
        [ Html.div [ class "col s12 m10 offset-m1 l6 offset-l1" ]
            [ label []
                [ input [ HA.attribute "name" "group1", HA.type_ "checkbox", HA.checked checked_, HE.onCheck (msg) ] []
                , span [] [ Html.text label_ ]
                ]
            ]
        ]
