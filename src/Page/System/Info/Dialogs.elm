module Page.System.Info.Dialogs exposing (..)

import API.System as System exposing (State(..))
import AppState exposing (AppState)
import Components.UI as UI
import Html exposing (Html, a, br, button, div, img, span, text)
import Html.Attributes exposing (alt, class, href, src)
import Html.Events exposing (onClick)
import Page.System.Info.Types exposing (Model, Msg(..))


prolongSleepDialogView : AppState -> Model -> String -> List (Html Msg)
prolongSleepDialogView { t } model sysId =
    if model.showSleepProlongDialog then
        [ -- UI.modal
          --     ""
          --     [ UI.ModalText "Продлить работу в режиме Поиск"
          --     , UI.ModalHtml <| UI.cmdButton "На 4 часа" (OnProlongSleep sysId 4)
          --     , UI.ModalHtml <| UI.cmdButton "На сутки" (OnProlongSleep sysId 24)
          --     , UI.ModalHtml <| UI.cmdButton "Навсегда" (OnProlongSleep sysId 100)
          --     ]
          --     [ UI.cmdButton "Отменить" (OnHideProlongSleepDialog)
          --     ]
          -- , UI.modal_overlay OnHideProlongSleepDialog
          div [ class "modal-bg show" ]
            [ div [ class "modal-wr" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-close close modal-close-btn", onClick OnHideProlongSleepDialog ] []
                    , div [ class "modal-img-mob" ]
                        [ img [ alt "", src "/images/search_continue.svg" ] [] ]
                    , div [ class "modal-title" ]
                        [ text <| t "control.Продлить работу в режиме"
                        , text " "
                        , span [ class "uppercase-txt" ] [ text <| t "control.Поиск" ]
                        ]
                    , div [ class "modal-body" ]
                        [ span [ class "modal-text" ]
                            [ text <| t "control.Укажите на какое время вы хотите продлить работу"
                            , text " "
                            , br [] []
                            , text <| t "control.в режиме"
                            , text " "
                            , span [ class "uppercase-txt" ] [ text <| t "control.Поиск" ]
                            ]
                        , div [ class "extend-mode" ]
                            [ button [ class "btn extend-mode-btn", onClick (OnProlongSleep sysId 4) ] [ span [] [ text <| t "control.На 4 часа" ] ]
                            , button [ class "btn extend-mode-btn", onClick (OnProlongSleep sysId 24) ] [ span [] [ text <| t "control.На сутки" ] ]
                            , button [ class "btn extend-mode-btn", onClick (OnProlongSleep sysId 100) ] [ span [] [ text <| t "control.Навсегда" ] ]
                            ]
                        ]
                    , div [ class "modal-btn-group" ]
                        [ button [ class "btn btn-md btn-secondary modal-close-btn", onClick OnHideProlongSleepDialog ] [ text <| t "config.Отмена" ]

                        --     , button [ class "btn btn-md btn-primary" ] [ text "Продлить" ]
                        ]
                    ]
                ]
            ]
        ]

    else
        []


viewModalDialogs : Model -> List (Html Msg)
viewModalDialogs model =
    if model.showConfirmOffDialog then
        [ UI.modal
            "Внимание!"
            [ UI.ModalText "Это действие необратимо."
            , UI.ModalText "Для включения потребуется доступ к Фениксу."
            , UI.ModalText "Вы действительно хотите выключить Феникс?"
            ]
            [ UI.cmdButton "Да" OnConfirmOff
            , UI.cmdButton "Нет" OnCancelOff
            ]
        , UI.modal_overlay OnCancelOff
        ]

    else
        []


waitStateLabel : AppState -> State -> String
waitStateLabel { t, tr } waitState =
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
            t "control.Феникс будет переведён в режим" ++ " " ++ (System.stateAsString wState |> String.toUpper)
