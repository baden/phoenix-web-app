module Page.System.Info.Footer exposing (..)

import API.System as System exposing (State(..), SystemDocumentInfo)
import AppState exposing (AppState)
import Components.Dates as Dates
import Components.UI as UI exposing (UI)
import Html exposing (Html, a, br, button, div, span, text)
import Html.Attributes as HA exposing (attribute, class, href, id)
import Html.Events exposing (onClick)
import Page.System.Info.Dialogs as Dialogs
import Page.System.Info.Types exposing (..)
import Types.Dt as DT


view : AppState -> Model -> SystemDocumentInfo -> Html Msg
view ({ t } as appState) model system =
    case system.dynamic of
        Nothing ->
            text ""

        Just dynamic ->
            case dynamic.state of
                Just Off ->
                    div [] []

                _ ->
                    case dynamic.waitState of
                        Nothing ->
                            if system.executor then
                                footerNoWait appState model system dynamic.available

                            else
                                text ""

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

        pre_date =
            Dates.nextSessionText appState last_session dynamic.next

        pre =
            tr "control.wait_state" [ ( "datetime", pre_date ) ]

        cmdWidget =
            Html.div [ HA.class "cmdWidget" ]

        tlabel t_ =
            Html.div [ class "cmdWaitLabel" ] [ text t_ ]

        hint =
            Dialogs.waitStateLabel appState waitState
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
    if List.member System.CLock available then
        button [ class "green-gradient-text block-engine-btn modal-open cursor-pointer", onClick (OnSysCmd system.id System.CLock) ]
            [ span [ class "icon-key" ] [], text <| t "control.Отмена процедуры блокировки" ]

    else if List.member System.Unlock available then
        button [ class "green-gradient-text block-engine-btn modal-open cursor-pointer", onClick (OnSysCmdPre system.id System.Unlock) ]
            [ span [ class "icon-key" ] [], text <| t "control.Разблокировать двигатель" ]

    else
        -- text "TBD"
        button [ class "orange-gradient-text block-engine-btn modal-open cursor-pointer", onClick (OnSysCmdPre system.id System.SLock) ]
            [ span [ class "icon-block" ] [], text <| t "control.Заблокировать двигатель" ]
