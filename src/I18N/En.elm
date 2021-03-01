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
                , ( "Вы действительно хотите выйти?", string "Do you really want to get out?" )
                , ( "Список Фениксов", string "___Список Фениксов" )
                , ( "Карта", string "___Карта" )
                , ( "Управление", string "___Управление" )
                , ( "Настройки", string "___Настройки" )
                , ( "События", string "___События" )
                ]
          )
        , ( "login"
          , object
                [ ( "Добро пожаловать", string "Welcome" )
                , ( "Войдите, чтобы продолжить", string "Log in to continue" )
                , ( "Введите Ваш логин", string "Enter your username" )
                , ( "name_not_found", string "The username was not found. Please check and try again." )
                , ( "Введите Ваш пароль", string "Enter your password" )
                , ( "Войти в систему", string "Log in" )
                , ( "У вас нет аккаунта?", string "Don't have an account?" )
                , ( "Зарегистрироваться", string "Register" )
                , ( "Создать аккаунт", string "Create an account" )
                , ( "Чтобы начать работать", string "To get started" )
                , ( "Повторите Ваш пароль", string "Repeat your password" )
                , ( "Я прочитал и принимаю условия", string "I have read and accept the terms and conditions" )
                , ( "пользовательского соглашения", string "user agreement" )
                , ( "Уже есть аккаунт?", string "Already have an account?" )
                , ( "Введите имя пользователя", string "Enter user name" )
                , ( "Укажите пароль", string "Enter your password" )
                , ( "Укажите пароль повторно", string "Enter the password again" )
                , ( "Пароль указан неверно", string "The password is incorrect" )
                , ( "Вы должны принять условия", string "You have to accept the conditions" )
                ]
          )
        , ( "list"
          , object
                [ ( "Добавьте ещё один Феникс", string "Add another Fenix" )
                , ( "в список наблюдения", string "to the watch list" )
                , ( "Добавить", string "Add" )
                , ( "Режим Поиск:", string "Search mode:" )
                , ( "Режим Ожидание:", string "Standby mode:" )
                ]
          )
        , ( "master"
          , object
                [ ( "Далeе", string "Next" )
                , ( "Назад", string "Back" )
                , ( "Подготовка SIM-карты", string "Preparing the SIM card" )
                , ( "Установите SIM-карту в мобильный телефон.", string "Install the SIM card in your mobile phone." )
                , ( "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора.", string "Activate the SIM card according to your GSM operator's instructions." )
                , ( "Убедитесь в том, что PIN-код при включении телефона выключен.", string "Ensure that the PIN code is switched off when the phone is switched on." )
                , ( "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора.", string "If necessary, register your SIM card on the GSM operator's website." )
                , ( "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту.", string "Switch off your mobile phone and remove the prepared SIM card." )
                , ( "Установка подготовленной SIM-карты в Феникс", string "Installing a prepared SIM card in the Fenix" )
                , ( "Выкрутите 4 винта и снимите крышку корпуса.", string "Remove the 4 screws and enclosure cover." )
                , ( "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает.", string "Make sure that the Phoenix is switched off - the LED is off and not flashing." )
                , ( "Установите подготовленную SIM-карту в Феникс.", string "Install the prepared SIM card in the Fenix." )
                , ( "В случае необходимости произведите привязку экзекуторов.", string "Bind the Executors if necessary." )
                , ( "Привязать экзекутор", string "Bind the Executor" )
                , ( "Экзекутор в наличии", string "Executor available" )
                , ( "Привязка экзекуторов и активация Феникса", string "Binding the Executors and activating the Fenix" )
                , ( "Исходное состояние: Феникс – выключен.", string "Initial status: Fenix - off." )
                , ( "Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания.", string "De-energise all tethered excecutors and prepare them for power supply." )
                , ( "Нажмите и удерживайте 3 секунды кнопку Фениска – загорится светодиод.", string "Press and hold the Fenix button for 3 seconds - the LED lights up." )
                , ( "Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки.", string "As soon as the LED lights up - apply power to all tethered exciters - the LED will flash a series of frequent flashes and begin to flash rare single flashes." )
                , ( "Закройте крышку корпуса Фениска и закрутите 4 винта.", string "Close the lid of the Fenisk housing and tighten the 4 screws." )
                , ( "Активация Феникса", string "Fenix activation" )
                , ( "Нажмите кнопку Феникса – светодиодный индикатор подтвердит включение.", string "Press the Fenix button - the LED will confirm activation." )
                , ( "Закройте крышку корпуса Феникса и закрутите 4 винта.", string "Close the lid of the Fenix housing and tighten the 4 screws." )
                , ( "Добавление Феникса в наблюдение", string "Adding Fenix to surveillance" )
                , ( "Отправьте на телефонный номер SIM-карты Феникса SMS: link", string "Send an SMS to the Fenix SIM card phone number: link" )
                , ( "В ответ придёт уникальный код – введите его в поле ниже:", string "You will receive a unique code - enter it in the box below:" )
                , ( "Введите уникальный код из SMS", string "Enter a unique code from the SMS" )
                , ( "Подтвердить", string "Confirm" )
                , ( "Мастер добавления Феникса", string "Fenix Addition Wizard" )
                , ( "Свериться с", string "Check with" )
                , ( "индикатором", string "indicator" )
                ]
          )
        ]
