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
        , ( "login"
          , object
                [ ( "Добро пожаловать", string "Welcome" )
                , ( "Войдите, чтобы продолжить", string "Войдите, чтобы продолжить" )
                , ( "Введите Ваш логин", string "Введите Ваш логин" )
                , ( "name_not_found", string "Имя пользователя не найдено. Пожалуйста проверьте и попробуйте снова." )
                , ( "Введите Ваш пароль", string "Введите Ваш пароль" )
                , ( "Войти в систему", string "Войти в систему" )
                , ( "У вас нет аккаунта?", string "У вас нет аккаунта?" )
                , ( "Зарегистрироваться", string "Зарегистрироваться" )
                ]
          )
        ]
