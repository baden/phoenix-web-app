module I18N.En exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Yours Fenixes" )
        , ( "Да", string "Yes" )
        , ( "Нет", string "No" )
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
                , ( "Настройки", string "Settings" )
                , ( "Выйти", string "Logout" )
                , ( "Выйти?", string "Logout?" )
                , ( "Вы действительно хотите выйти?", string "Вы действительно хотите выйти?" )
                ]
          )
        ]
