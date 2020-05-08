module Page.System.Config.Master.Widget exposing (..)

import Page.System.Config.Types exposing (..)
import Components.UI as UI exposing (..)
import Dict exposing (Dict)


masterFooterFirst : List (UI Msg)
masterFooterFirst =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "cogs" "Ручное" (OnMasterCustom)
    , UI.cmdTextIconButton "arrow-right" "Далее" (OnMasterNext)
    ]


masterFooterMiddle : List (UI Msg)
masterFooterMiddle =
    [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
    , UI.cmdTextIconButton "arrow-left" "Назад" (OnMasterPrev)
    , UI.cmdTextIconButton "arrow-right" "Далее" (OnMasterNext)
    ]


masterFooterLast : String -> Dict String String -> Dict String String -> List (UI Msg)
masterFooterLast sysId customQueue masterQueue =
    let
        mixedQueue =
            Dict.union masterQueue customQueue
    in
        [ UI.cmdTextIconButton "times-circle" "Отмена" (OnCancelMaster)
        , UI.cmdTextIconButton "arrow-left" "Назад" (OnMasterPrev)
        , UI.cmdTextIconButton "thumbs-up" "Применить" (OnConfirmMaster sysId mixedQueue)
        , UI.cmdIconButton "question-circle" (OnShowChanges)
        ]
