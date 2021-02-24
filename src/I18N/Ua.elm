module I18N.Ua exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Список Фенiксiв" )
        , ( "Да", string "Так" )
        , ( "Нет", string "Нi" )
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
                , ( "Настройки", string "Налаштування" )
                , ( "Выйти", string "Вийти" )
                , ( "Выйти?", string "Вийти?" )
                , ( "Вы действительно хотите выйти?", string "Ви дiйсно бажа_те вийти?" )
                ]
          )
        ]
