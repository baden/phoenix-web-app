module I18N.Ru exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Список фениксов" )
        , ( "themes"
          , object
                [ ( "dark", string "Темная" )
                , ( "light", string "Светлая" )
                ]
          )
        , ( "menu"
          , object
                [ ( "Системные опции", string "Системнi опцii" )
                , ( "Аккаунт", string "Аккаунт" )
                , ( "Язык", string "Язык" )
                ]
          )
        ]
