module Page.System.Config.Custom exposing (..)

import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Html exposing (Html, div, text, a, form, p, label, input, span)
import Html.Attributes as HA exposing (class, href, attribute, type_, checked)
import Html.Events as HE


configCustomView : Model -> String -> List (UI Msg)
configCustomView model sysId =
    [ warnMgs
    , row [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster) ]
    ]


warnMgs : UI Msg
warnMgs =
    row [ p [] [ UI.text "Предупреждение!" ], p [] [ UI.text " Ручное изменение настроек может привести к полной неработоспособности трекера. Изменяйте параметры только если полностью уверены в своих действиях." ] ]
