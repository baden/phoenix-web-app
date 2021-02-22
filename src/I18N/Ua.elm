module I18N.Ua exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Список Фенiксiв" )
        , ( "themes"
          , object
                [ ( "dark", string "Темна" )
                , ( "light", string "Свiтла" )
                ]
          )
        , ( "menu"
          , object
                [ ( "Системные опции", string "Системнi опцii" )
                , ( "Аккаунт", string "Аккаунт" )
                , ( "Язык", string "Мова" )
                ]
          )
        ]
