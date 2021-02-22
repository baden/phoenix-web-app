module I18N.En exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Yours Fenixes" )
        , ( "themes"
          , object
                [ ( "dark", string "Dark" )
                , ( "light", string "Light" )
                ]
          )
        , ( "menu"
          , object
                [ ( "Системные опции", string "System options" )
                , ( "Аккаунт", string "Account" )
                , ( "Язык", string "Language" )
                ]
          )
        ]
