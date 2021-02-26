module I18N.Ru exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Список фениксов" )
        , ( "Да", string "Да" )
        , ( "Нет", string "Нет" )
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
                , ( "Настройки", string "Настройки" )
                , ( "Выйти", string "Выйти" )
                , ( "Выйти?", string "Выйти?" )
                , ( "Вы действительно хотите выйти?", string "Вы действительно хотите выйти?" )
                ]
          )
        , ( "login"
          , object
                [ ( "Добро пожаловать", string "Добро пожаловать" )
                , ( "Войдите, чтобы продолжить", string "Войдите, чтобы продолжить" )
                , ( "Введите Ваш логин", string "Введите Ваш логин" )
                , ( "name_not_found", string "Имя пользователя не найдено. Пожалуйста проверьте и попробуйте снова." )
                , ( "Введите Ваш пароль", string "Введите Ваш пароль" )
                , ( "Войти в систему", string "Войти в систему" )
                , ( "У вас нет аккаунта?", string "У вас нет аккаунта?" )
                , ( "Зарегистрироваться", string "Зарегистрироваться" )
                , ( "Создать аккаунт", string "Создать аккаунт" )
                , ( "Чтобы начать работать", string "Чтобы начать работать" )
                , ( "Повторите Ваш пароль", string "Повторите Ваш пароль" )
                , ( "Я прочитал и принимаю условия", string "Я прочитал и принимаю условия" )
                , ( "пользовательского соглашения", string "пользовательского соглашения" )
                , ( "Уже есть аккаунт?", string "Уже есть аккаунт?" )
                , ( "Введите имя пользователя", string "Введите имя пользователя" )
                , ( "Укажите пароль", string "Укажите пароль" )
                , ( "Укажите пароль повторно", string "Укажите пароль повторно" )
                , ( "Пароль указан неверно", string "Пароль указан неверно" )
                , ( "Вы должны принять условия", string "Вы должны принять условия" )
                ]
          )
        , ( "list"
          , object
                [ ( "Добавьте ещё один Феникс", string "Добавьте ещё один Феникс" )
                , ( "в список наблюдения", string "в список наблюдения" )
                , ( "Добавить", string "Добавить" )
                , ( "Режим Поиск:", string "Режим Поиск:" )
                , ( "Режим Ожидание:", string "Режим Ожидание:" )
                ]
          )
        , ( "master"
          , object
                [ ( "Далeе", string "Далeе" )
                , ( "Назад", string "Назад" )
                , ( "Подготовка SIM-карты", string "Подготовка SIM-карты" )
                , ( "Установите SIM-карту в мобильный телефон.", string "Установите SIM-карту в мобильный телефон." )
                , ( "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора.", string "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора." )
                , ( "Убедитесь в том, что PIN-код при включении телефона выключен.", string "Убедитесь в том, что PIN-код при включении телефона выключен." )
                , ( "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора.", string "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора." )
                , ( "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту.", string "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту." )
                , ( "Установка подготовленной SIM-карты в Феникс", string "Установка подготовленной SIM-карты в Феникс" )
                , ( "Выкрутите 4 винта и снимите крышку корпуса.", string "Выкрутите 4 винта и снимите крышку корпуса." )
                , ( "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает.", string "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает." )
                , ( "Установите подготовленную SIM-карту в Феникс.", string "Установите подготовленную SIM-карту в Феникс." )
                , ( "В случае необходимости произведите привязку экзекуторов.", string "В случае необходимости произведите привязку экзекуторов." )
                , ( "Привязать экзекутор", string "Привязать экзекутор" )
                , ( "Экзекутор в наличии", string "Экзекутор в наличии" )
                , ( "Привязка экзекуторов и активация Феникса", string "Привязка экзекуторов и активация Феникса" )
                , ( "Исходное состояние: Феникс – выключен.", string "Исходное состояние: Феникс – выключен." )
                , ( "Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания.", string "Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания." )
                , ( "Нажмите и удерживайте 3 секунды кнопку Фениска – загорится светодиод.", string "Нажмите и удерживайте 3 секунды кнопку Фениска – загорится светодиод." )
                , ( "Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки.", string "Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки." )
                , ( "Закройте крышку корпуса Фениска и закрутите 4 винта.", string "Закройте крышку корпуса Фениска и закрутите 4 винта." )
                , ( "Активация Феникса", string "Активация Феникса" )
                , ( "Нажмите кнопку Феникса – светодиодный индикатор подтвердит включение.", string "Нажмите кнопку Феникса – светодиодный индикатор подтвердит включение." )
                , ( "Закройте крышку корпуса Феникса и закрутите 4 винта.", string "Закройте крышку корпуса Феникса и закрутите 4 винта." )
                , ( "Добавление Феникса в наблюдение", string "Добавление Феникса в наблюдение" )
                , ( "Отправьте на телефонный номер SIM-карты Феникса SMS: link", string "Отправьте на телефонный номер SIM-карты Феникса SMS: link" )
                , ( "В ответ придёт уникальный код – введите его в поле ниже:", string "В ответ придёт уникальный код – введите его в поле ниже:" )
                , ( "Введите уникальный код из SMS", string "Введите уникальный код из SMS" )
                , ( "Подтвердить", string "Подтвердить" )
                , ( "Мастер добавления Феникса", string "Мастер добавления Феникса" )
                , ( "Свериться с", string "Свериться с" )
                , ( "индикатором", string "индикатором" )
                ]
          )
        ]
