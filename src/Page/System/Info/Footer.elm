module Page.System.Info.Footer exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, br, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events exposing (onClick)
import Page.System.Info.Types exposing (..)
import Types.Dt as DT


view : AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    case system.dynamic of
        Nothing ->
            text "TBD"

        Just dynamic ->
            case dynamic.waitState of
                Nothing ->
                    footerNoWait appState model system dynamic.available

                Just waitState ->
                    footerWait appState model system waitState dynamic


footerWait : AppState -> Model -> SystemDocumentInfo -> System.State -> System.Dynamic -> Html Msg
footerWait ({ t, tr } as appState) model system waitState dynamic =
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
            Dates.nextSessionText appState last_session dynamic.next tz

        pre =
            tr "control.wait_state" [ ( "datetime", pre_date ) ]

        cmdWidget =
            Html.div [ HA.class "cmdWidget" ]

        tlabel t_ =
            Html.div [ class "cmdWaitLabel" ] [ text t_ ]

        hint =
            case waitState of
                Point ->
                    t "control.будет определено текущее местоположение"

                ProlongSleep duration ->
                    let
                        durationText h =
                            case h of
                                4 ->
                                    t "control.На 4 часа"

                                24 ->
                                    t "control.На сутки"

                                100 ->
                                    t "control.Навсегда"

                                _ ->
                                    tr "control.На ч" [ ( "h", String.fromInt h ) ]
                    in
                    t "control.будет продлена работа Феникса в режиме Поиск" ++ " " ++ String.toLower (durationText duration)

                Lock ->
                    t "control.будет запущена отложенная блокировка двигателя"

                SLock ->
                    t "control.будет запущена интеллектуальная блокировка двигателя"

                Unlock ->
                    t "control.двигатель будет разблокирован"

                Off ->
                    t "control.Феникс будет выключен"

                CLock ->
                    t "control.блокировка будет сброшена"

                wState ->
                    t "control.Феникс будет переведён в режим" ++ " " ++ System.stateAsString wState
    in
    div [ class "processing-engeine" ]
        [ div [ class "processing-engeine-wr" ]
            [ span [ class "icon-block orange-gradient-text" ] []
            , div [ class "text" ]
                [ text pre
                , text " "
                , text hint
                ]
            ]
        , div [ class "details-blue-title red-text", onClick (OnSysCmdCancel system.id) ] [ text <| t "config.Отмена" ]
        ]


footerNoWait : AppState -> Model -> SystemDocumentInfo -> List System.State -> Html Msg
footerNoWait ({ t } as appState) model system available =
    if List.member System.Unlock available then
        button [ class "green-gradient-text block-engine-btn modal-open cursor-pointer", onClick (OnSysCmdPre system.id System.Unlock) ]
            [ span [ class "icon-key" ] [], text <| t "control.Разблокировать двигатель" ]

    else
        -- text "TBD"
        button [ class "orange-gradient-text block-engine-btn modal-open cursor-pointer", onClick (OnSysCmdPre system.id System.SLock) ]
            [ span [ class "icon-block" ] [], text <| t "control.Заблокировать двигатель" ]
