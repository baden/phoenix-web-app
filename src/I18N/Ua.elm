module I18N.Ua exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "custom"
          , object
                [ ( "morning", string "Morning" )
                , ( "evening", string "Evening" )
                , ( "afternoon", string "Afternoon" )
                ]
          )
        , ( "hello", string "hello" )
        , ( "Список фениксов", string "Список Фенiксiв" )
        ]



-- use it like this
-- t translations "custom.morning" -- "Morning"
