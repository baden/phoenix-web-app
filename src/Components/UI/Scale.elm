module Components.UI.Scale exposing (..)

import AssocList as Dict exposing (Dict)


type ScaleID
    = ScaleID String


type alias Scale =
    { selectedScale : ScaleID
    }


type alias ScaleItem =
    { name : String
    , class_name : String
    }


type alias ScaleItems =
    Dict ScaleID ScaleItem


defaultScales : Dict ScaleID ScaleItem
defaultScales =
    Dict.fromList
        [ ( ScaleID "normal", ScaleItem "normal" "normal" )
        , ( ScaleID "small", ScaleItem "small" "small" )
        , ( ScaleID "big", ScaleItem "big" "big" )
        , ( ScaleID "bigger", ScaleItem "bigger" "bigger" )
        , ( ScaleID "biggest", ScaleItem "biggest" "biggest" )
        ]


replaceScale scaleName ( model, cmd ) =
    -- TODO: Type it.
    let
        appState =
            model.appState

        newAppState =
            { appState | scaleName = scaleName }
    in
    ( { model | appState = newAppState }, cmd )
