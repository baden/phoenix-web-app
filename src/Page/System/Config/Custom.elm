module Page.System.Config.Custom exposing (configCustomView)

import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE
import Dict exposing (Dict)
import API.System exposing (SystemDocumentParams)
import Page.System.Config.ParamDesc as ParamDesc


configCustomView : Model -> String -> Maybe SystemDocumentParams -> List (UI Msg)
configCustomView model sysId sysparams =
    case sysparams of
        Nothing ->
            errorMsg ++ (footer sysId Dict.empty)

        Just params ->
            warnMgs ++ (paramsWidget sysId params model.showQueue) ++ (footer sysId params.queue)


warnMgs : List (UI Msg)
warnMgs =
    [ row [ p [] [ UI.text "Предупреждение!" ], p [] [ UI.text " Ручное изменение настроек может привести к полной неработоспособности трекера. Изменяйте параметры только если полностью уверены в своих действиях." ] ] ]


errorMsg : List (UI Msg)
errorMsg =
    [ row [ UI.text "Ошибка загрузки или данные от трекера еще не получены." ] ]


footer : String -> Dict String String -> List (UI Msg)
footer sysId queue =
    case Dict.isEmpty queue of
        True ->
            []

        False ->
            [ Html.div [ HA.class "row param_row_filler" ] []
            , Html.div [ HA.class "params_footer right-align" ]
                [ Html.div [ HA.class "container" ]
                    [ UI.cmdTextIconButtonR "trash" "Отменить внесенные изменения" (OnClearQueue sysId)
                    , UI.cmdIconButton "question-circle" OnShowQueue
                    ]
                ]
            ]


paramsWidget : String -> SystemDocumentParams -> Bool -> List (UI Msg)
paramsWidget sysId params showQueue =
    let
        prow queue ( name, { type_, value, default } ) =
            let
                valueField =
                    case Dict.get name queue of
                        Nothing ->
                            [ Html.span [ HA.class "params params_default" ] [ Html.text value ]
                            , cmdIconButton "edit" (OnStartEditParam sysId name value (ParamDesc.description name))
                            ]

                        Just expect ->
                            [ Html.span [ HA.class "params params_waited" ]
                                [ Html.text value
                                , Html.i [ HA.class "fas fa-arrow-right", HA.style "margin" "0 5px 0 5px" ] []
                                , Html.text expect
                                ]
                            , cmdIconButtonR "trash-restore" (OnRestoreParam sysId queue name)
                            ]
            in
                Html.div [ HA.class "row param_row valign-wrapper" ]
                    [ Html.div [ HA.class "col s8 m9 left-align" ]
                        [ Html.div [ HA.class "name" ] [ Html.text name ]
                        , Html.text (ParamDesc.description name)
                        ]
                    , Html.div [ HA.class "col s4 m3 right-align" ] valueField
                    ]

        _ =
            Debug.log "params" params

        data =
            case showQueue of
                False ->
                    params.data

                True ->
                    params.data
                        |> List.filter (\( name, _ ) -> Dict.member name params.queue)
    in
        data
            |> List.map (prow params.queue)
