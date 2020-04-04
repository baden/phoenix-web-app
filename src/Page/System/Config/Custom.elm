module Page.System.Config.Custom exposing (configCustomView)

import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE
import Dict
import API.System exposing (SystemDocumentParams)


configCustomView : Model -> String -> Maybe SystemDocumentParams -> List (UI Msg)
configCustomView model sysId sysparams =
    case sysparams of
        Nothing ->
            errorMsg ++ footer

        Just params ->
            warnMgs ++ (paramsWidget sysId params) ++ footer


warnMgs : List (UI Msg)
warnMgs =
    [ row [ p [] [ UI.text "Предупреждение!" ], p [] [ UI.text " Ручное изменение настроек может привести к полной неработоспособности трекера. Изменяйте параметры только если полностью уверены в своих действиях." ] ] ]


errorMsg : List (UI Msg)
errorMsg =
    [ row [ UI.text "Ошибка загрузки или данные от трекера еще не получены." ] ]


footer : List (UI Msg)
footer =
    [ row [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster) ] ]


paramsWidget : String -> SystemDocumentParams -> List (UI Msg)
paramsWidget sysId params =
    let
        prow ( name, { type_, value, default } ) =
            Html.div [ HA.class "row" ]
                [ Html.div [ HA.class "col s6 m3 offset-m3 l2 offset-l4 left-align" ] [ Html.text name ]
                , Html.div [ HA.class "col s6 m3 l2 right-align" ]
                    [ Html.text <| value ++ " "
                    , cmdIconButton "edit" (OnStartEditParam name)
                    ]
                ]
    in
        params.data
            |> List.map prow
