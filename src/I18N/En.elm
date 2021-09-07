module I18N.En exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Yours Fenixes" )
        , ( "Да", string "Yes" )
        , ( "Нет", string "No" )
        , ( "Режим", string "Mode" )
        , ( "Поиск", string "Search" )
        , ( "Ожидание", string "Standby" )
        , ( "themes"
          , object
                [ ( "dark", string "Dark" )
                , ( "light", string "Light" )
                ]
          )
        , ( "scales"
          , object
                [ ( "normal", string "Normal" )
                , ( "small", string "Small" )
                , ( "big", string "Big" )
                , ( "bigger", string "Bigger" )
                , ( "biggest", string "Biggest" )
                ]
          )
        , ( "menu"
          , object
                [ ( "Системные опции", string "System options" )
                , ( "Аккаунт", string "Account" )
                , ( "Язык", string "Language" )
                , ( "Тема", string "Theme" )
                , ( "Размер", string "Size" )
                , ( "Настройки", string "Settings" )
                , ( "Выйти", string "Logout" )
                , ( "Выйти?", string "Logout?" )
                , ( "Вы действительно хотите выйти?", string "Do you really want to get out?" )
                , ( "Список Фениксов", string "List of Fenixes" )
                , ( "Карта", string "Map" )
                , ( "Управление", string "Control" )
                , ( "Настройки", string "Settings" )
                , ( "События", string "Events" )
                , ( "Иконка и название Феникса", string "Fenix icon and name" )
                , ( "Основные настройки", string "Basic settings" )
                , ( "Расширенные настройки", string "Advanced settings" )
                , ( "Обслуживание батареи", string "Battery service" )
                , ( "Детали о Фениксе", string "Details of the Fenix" )
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
                , ( "На карте", string "На карте" )
                , ( "Управление", string "Управление" )
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
        , ( "config"
          , object
                [ ( "Основные настройки феникса", string "Basic Fenix settings" )
                , ( "Период выхода на связь", string "Period of communication" )
                , ( "Редко", string "Rarely" )
                , ( "Феникс будет выходить на связь один раз в сутки.", string "Fenix will be in contact once a day." )
                , ( "Ожидаемый срок службы батареи - 15 лет.", string "Expected battery life - 15 years." )
                , ( "Оптимально", string "Optimal" )
                , ( "Феникс будет выходить на связь каждые 6 часов.", string "Fenix will be in contact every six hours." )
                , ( "Ожидаемый срок службы батареи - 6 лет.", string "Expected battery life - 6 years." )
                , ( "Часто", string "Часто" )
                , ( "Феникс будет выходить на связь каждые 2 часа.", string "Fenix will be in touch every 2 hours." )
                , ( "Ожидаемый срок службы батареи - 2 года.", string "Expected battery life - 2 years." )
                , ( "Время работы в режиме Поиск", string "Working time in Search mode" )
                , ( "Продолжительно", string "Continuously" )
                , ( "Максимальное время работы в режиме Поиск - 12 часов.", string "Maximum operating time in Search mode - 12 hours." )
                , ( "Ёмкости батареи хватит на 15 активаций режима Поиск.", string "Battery capacity is sufficient for 15 Search mode activations." )
                , ( "Оптимально", string "Optimal" )
                , ( "Максимальное время работы в режиме Поиск - 6 часов.", string "Maximum operating time in Search mode - 6 hours." )
                , ( "Ёмкости батареи хватит на 30 активаций режима Поиск.", string "Battery capacity is sufficient for 30 Search mode activations." )
                , ( "Минимально", string "Minimum" )
                , ( "Максимальное время работы в режиме Поиск - 1 час.", string "Maximum operating time in Search mode - 1 hour." )
                , ( "Ёмкости батареи хватит на 100 активаций режима Поиск.", string "Battery capacity enough for 100 Search mode activations." )
                , ( "Информирование", string "Inform" )
                , ( "Когда происходят определенные события, Феникс может отправлять SMS на заданный номер", string "When certain events occur, Fenix can send an SMS to a given number" )
                , ( "Укажите номер телефона", string "Please give your phone number" )
                , ( "Выберите события", string "Select events" )
                , ( "Критический остаток средств", string "Critical balance of funds" )
                , ( "Низкий уровень заряда батареи", string "Low battery level" )
                , ( "Изменение режима (Поиск <-> Ожидание)", string "Changing mode ( Search) <-> Standby)" )
                , ( "Начало движения (в режиме Поиск)", string "Start driving (in Search mode)" )
                , ( "Включение и выключение Феникса", string "Switching Fenix on and off" )
                , ( "Вскрытие корпуса", string "Opening the enclosure" )
                , ( "Контроль баланса SIM-карты", string "Checking the SIM card balance" )
                , ( "USSD-запрос баланса SIM-карты", string "USSD request for SIM card balance" )
                , ( "Безопасность", string "Security" )
                , ( "Чтобы никто посторонний не смог получить управление Вашим Фениксом, вы можете привязать управление к конкретному телефону и установить свой код доступа.", string "To prevent anyone else from gaining control of your Fenix, you can link the control to a specific phone and protect SMS commands." )
                , ( "По умолчанию управление возможно с любого телефона.", string "By default, control is possible from any phone." )
                , ( "Управление возможно только с телефона:", string "Control is only possible from the phone:" )
                , ( "SMS-коды управления имеют вид:", string "The SMS-commands are as follows:" )
                , ( "Привязать к телефону", string "Tie it to the phone" )
                , ( "Установить пароль доступа", string "Protect SMS-commands" )
                , ( "Вводите только латинские буквы и цифры", string "Enter only Latin letters and numbers" )
                , ( "Далее", string "Next" )
                , ( "Назад", string "Back" )
                , ( "Применить", string "Apply" )
                , ( "Поздравляем!", string "Congratulations!" )
                , ( "Основные настройки применены", string "Basic settings applied" )
                , ( "Перейти к Фениксу", string "Go to the Fenix" )
                , ( "Удалить Феникс", string "Delete the Fenix" )
                , ( "Экзекутор в наличии", string "The Executor is available" )
                , ( "Не указан", string "Not indicated" )
                , ( "SIM-карта", string "SIM-card" )
                , ( "IMEI", string "IMEI" )
                , ( "Версия ПО", string "Software version" )
                , ( "Модель", string "Model" )
                , ( "Детали о Фениксе", string "Details of the Fenix" )
                , ( "Удалить Феникс?", string "Delete Fenix?" )
                , ( "remove_fx", string "Are you sure you want to delete Fenix “{{title}}”? This action cannot be undone." )
                , ( "Да, удалить", string "Yes, delete" )
                , ( "Нет", string "Not" )
                , ( "Иконка и название", string "Icon and name" )
                , ( "Название Феникса", string "The title of the Fenix" )
                , ( "Иконка Феникса", string " Fenix icon" )
                , ( "Ведите новое либо измените старое название", string "Lead a new name or change the old one" )
                , ( "Введите название", string "Enter a name" )
                , ( "Отмена", string "Cancel" )
                , ( "Сохранить", string "Save" )
                , ( "Иконка Феникса", string "Fenix icon" )
                , ( "Выберите подходящую иконку для вашего феникса", string "Choose a suitable icon for your fenix" )
                , ( "Обслуживание батареи", string "Battery service" )
                , ( "Предполагаемое время", string "Expected time" )
                , ( "работы батареи", string "battery life" )
                , ( "Статистика работы", string "Work statistics" )
                , ( "Начальная емкость батареи", string "Initial battery capacity" )
                , ( "Начало эксплуатации", string "Start of usage" )
                , ( "Общее время эксплуатации", string "Total operating time" )
                , ( "Израсходовано энергии батареи", string "Battery power consumed" )
                , ( "Замена батареи", string "Battery replacement" )
                , ( "Изменить начальную емкость", string "Change the initial capacity" )
                , ( "bat_replace_text", string "The battery must be replaced by an expert. Use the original SAFT LSH 14, 5800mAh battery. If you install a different type of battery, specify the initial capacity (mAh)." )
                , ( "Укажите начальную емкость батареи (мАч)", string "Specify the initial battery capacity (mAh)" )
                , ( "bat_ch_capacity", string "If you have a different battery type installed, specify the initial capacity (mAh)." )
                , ( "Предупреждение!", string "Warning!" )
                , ( "warning_custom", string "If you change the settings carelessly, the Fenix may become completely inoperable. Only change settings if you are absolutely sure about what you are doing." )
                , ( "error_custom", string "Download error or data not yet received from Fenix." )
                , ( "Отменить", string "Cancel" )
                , ( "Показать", string "Show" )
                , ( "изменения", string "changes" )
                , ( "Хорошо", string "Хорошо" )
                ]
          )
        , ( "control"
          , object
                [ ( "Текущий режим", string "Текущий режим" )
                , ( "Включить режим Поиск", string "Включить режим Поиск" )
                , ( "Связь", string "Связь" )
                , ( "Последний сеанс связи:", string "Последний сеанс связи:" )
                , ( "Следующий сеанс связи:", string "Следующий сеанс связи:" )
                , ( "Положение", string "Положение" )
                , ( "Положение определено:", string "Положение определено:" )
                , ( "Показать", string "Показать" )
                , ( "Обновить", string "Обновить" )
                , ( "Предполагаемое время работы батареи", string "Предполагаемое время работы батареи" )
                , ( "Режим", string "Режим" )
                , ( "SIM-карта", string "SIM-карта" )
                , ( "Баланс:", string "Баланс:" )
                , ( "Пополнить счет", string "Пополнить счет" )
                , ( "Заблокировать двигатель", string "Заблокировать двигатель" )
                , ( "Данные о состоянии еще не получены", string "Данные о состоянии еще не получены" )
                , ( "идет определение...", string "идет определение..." )
                , ( "Феникс выключен.", string "Феникс выключен." )
                , ( "Идет определение местоположения...", string "Идет определение местоположения..." )
                , ( "Поиск", string "ПОИСК" )
                , ( "Ожидание", string "ОЖИДАНИЕ" )
                , ( "Номер телефона был скопирован", string "Номер телефона был скопирован" )
                , ( "Переход в режим", string "Переход в режим" )
                , ( "Продлить режим", string "Продлить режим" )
                , ( "Продлить работу в режиме", string "Продлить работу в режиме" )
                , ( "Укажите на какое время вы хотите продлить работу", string "Укажите на какое время вы хотите продлить работу" )
                , ( "в режиме", string "в режиме" )
                , ( "На 4 часа", string "На 4 часа" )
                , ( "На сутки", string "На сутки" )
                , ( "Навсегда", string "Навсегда" )
                , ( "На ч", string "На {{h}} ч" )
                , ( "Включить режим", string "Включить режим" )
                , ( "Смена Режима", string "Смена Режима" )
                , ( "change_state_dialog", string "{{date}}, при следующем сеансе связи, Феникс будет переведён в режим {{state}}" )
                , ( "Информация будет доступна после выхода Феникса на связь.", string "Информация будет доступна после выхода Феникса на связь." )
                , ( "неизвестно", string "неизвестно" )
                , ( "Положение неизвестно", string "Положение неизвестно" )
                , ( "Разблокировать двигатель", string "Разблокировать двигатель" )
                , ( "wait_state", string "{{datetime}}, при следующем сеансе связи," )
                , ( "будет определено текущее местоположение", string "будет определено текущее местоположение" )
                , ( "будет продлена работа Феникса в режиме Поиск", string "будет продлена работа Феникса в режиме Поиск" )
                , ( "будет запущена отложенная блокировка двигателя", string "будет запущена отложенная блокировка двигателя" )
                , ( "будет запущена интеллектуальная блокировка двигателя", string "будет запущена интеллектуальная блокировка двигателя" )
                , ( "двигатель будет разблокирован", string "двигатель будет разблокирован" )
                , ( "Феникс будет выключен", string "Феникс будет выключен" )
                , ( "блокировка будет сброшена", string "блокировка будет сброшена" )
                , ( "Феникс будет переведён в режим", string "Феникс будет переведён в режим" )
                , ( "Внимание", string "Внимание" )
                , ( "Блокировка двигателя", string "Блокировка двигателя" )
                , ( "Интеллектуальная блокировка", string "Интеллектуальная блокировка" )
                , ( "block_smart_text", string "будет запущена интеллектуальная блокировка двигателя. Феникс даст возможность автомобилю беспрепятственно покинуть место отстоя, определит его координаты и при первой же остановке автомобиля – заблокирует двигатель." )
                , ( "block_smart_comment", string "Рекомендуется в случаях, если автомобиль может находиться в подземном гараже или в специальном «отстойнике», где определение координат может быть невозможным. В случае блокировки двигателя автомобиль не сможет покинуть место отстоя своим ходом, что насторожит угонщиков и приведёт к устранению «неисправности» и обнаружению Феникса." )
                , ( "block_lazy_text", string "будет запущена отложенная блокировка двигателя. Если автомобиль находится в движении – Феникс заблокирует двигатель при его остановке, если автомобиль неподвижен – Феникс заблокирует двигатель немедленно." )
                , ( "block_lazy_comment", string "Рекомендуется в случаях, если автомобиль точно не успел доехать до «отстойника» или если автомобиль находится в прямой видимости." )
                , ( "Заблокировать", string "Заблокировать" )
                , ( "Вы сможете нажать эту кнопку после того как Феникc исполнит команды которые ждут выполнения", string "Вы сможете нажать эту кнопку после того как Феникc исполнит команды которые ждут выполнения" )
                ]
          )
        , ( "params"
          , object
                [ ( "accel.count", string "Длительность импульса акселерометра, ms" )
                , ( "accel.deb", string "Программный антидребезг, число повторов (2-6)" )
                , ( "accel.lvl", string "Чувствительность акселерометра, mg" )
                , ( "accel.time", string "Время успокоения акселерметра, секунды (10-300)" )
                , ( "adc.fix.du", string "Порог изменения напряжения резервного питания, V (?-?)" )
                , ( "adc.fix.dub", string "Порог изменения напряжения основного питания, V (?-?)" )
                , ( "adc.fix.umax", string "Порог максимально допустимого питания, /29.528, V (350-1200)" )
                , ( "adc.in.1", string "Логический порог напряжения входа 1, /?, V (?-?)" )
                , ( "adc.in.2", string "Логический порог напряжения входа 2, /?, V (?-?)" )
                , ( "adc.photo", string "Чувствительность фотодатчика, (100-2000; 2000-max)" )
                , ( "adc.photo.delay", string "Время включения фотоохраны, сек (1-32000)" )
                , ( "photo.delay", string "Время включения фотоохраны, сек (1-32000)" )
                , ( "adc.u.off", string "Порог выключения основного питания, /29.528, V (100-1000)" )
                , ( "adc.u.on", string "Порог включения основного питания, /29.528, V (100-1000)" )
                , ( "akkum.block.vbat", string "-- добавить описание ---" )
                , ( "akkum.block.vdd", string "-- добавить описание ---" )
                , ( "akkum.charge.0", string "Индикация полного разряда батареи, /310.29, V (1050-1150)" )
                , ( "akkum.charge.30", string "Индикация заряда батареи 30%, /310.29, V (1100-1200)" )
                , ( "akkum.charge.60", string "Индикация заряда батареи 60%, /310.29, V (1150-1250)" )
                , ( "akkum.charge.temp", string "Максимальная температура батареи, /?, градусов (?-?)" )
                , ( "akkum.i.0", string "?Начальный ток заряда батареи, х 20.408 mA (1-10)" )
                , ( "akkum.i.1", string "?Максимальный ток заряда батареи, х 20.408 mA (10-100)" )
                , ( "akkum.i.charge", string "-- добавить описание ---" )
                , ( "akkum.u.0", string "?Минимальное напряжение для обновления прошивки, /310.29, V (1100-1300)" )
                , ( "sleep", string "Время сна в режимах Ожидание и Поиск, мин" )
                , ( "adc.vi.fix", string "Коррекция показаний резервного питания." )
                , ( "admin", string "Телефон администратора." )
                , ( "alarm.balance", string "SMS о критическом балансе" )
                , ( "alarm.case", string "SMS о вскрытии корпуса" )
                , ( "alarm.delay", string "SMS о включении дежурного режима" )
                , ( "alarm.low", string "SMS о низком уровне ёмкости батареи" )
                , ( "alarm.error", string "SMS о невозможности определения координат" )
                , ( "alarm.gps", string "SMS об изменении координат" )
                , ( "alarm.mode", string "SMS о смене режима" )
                , ( "alarm.on", string "SMS о включении Феникса" )
                , ( "alarm.off", string "SMS о выключении Феникса" )
                , ( "alarm.stealth", string "SMS об активации режима Stealth" )
                , ( "admin", string "Номер телефона администратора" )
                , ( "alarm1", string "Первый номер телефона для отправки SMS" )
                , ( "alarm2", string "Второй номер телефона для отправки SMS" )
                , ( "alarm3", string "Третий номер телефона для отправки SMS" )
                , ( "alarm4", string "Четвертый номер телефона для отправки SMS" )
                , ( "auto.sleep", string "Автоматическое включение режима Ожидание, мин" )
                , ( "balance.skip", string "Пропуск цифр в отчёте оператора о балансе" )
                , ( "balance.ussd", string "USSD-запрос остатка средств на карточке" )
                , ( "config.send", string "Период сеансов связи в режиме Конфигуратор, мин" )
                , ( "delay", string "Задержка выключения GSM-модуля, в циклах связи" )
                , ( "distance", string "Максимально допустимое отклонение координат, м" )
                , ( "gps.angle", string "Минимальный регистрируемый угол поворота, градусов" )
                , ( "gps.aoff", string "Автовыключение GPS для экономии батареи, мин" )
                , ( "gps.delta", string "Принудительная регистрация координат при перемещении, м" )
                , ( "gps.fail", string "Задержка перезапуска GPS-модуля при пропадании спутников, мин" )
                , ( "gps.flush.move", string "Период отправки данных на сервер при движении, сек" )
                , ( "gps.flush.stop", string "Период отправки данных на сервер при стоянке, сек" )
                , ( "gps.flush", string "Период отправки данных на сервер, сек" )
                , ( "gps.tf.move", string "Принудительная регистрация координат при движении, сек" )
                , ( "gps.tf.stop", string "Период регистрации координат при остановке, сек" )
                , ( "gps.tf", string "Период регистрации координат, сек" )
                , ( "gps.tf.stop.acc", string "Период регистрации координат при стоянке, сек" )
                , ( "gps.valid.delay", string "Данные от GPS берутся не первые после fix, а пропускается указанное кол-во" )
                , ( "gps.vignacc", string "Скорость принудительной регистрации движения (игнорируется акселерометр) × 0,01852 км/ч" )
                , ( "gps.vstart", string "Скорость регистрации начала движения × 0,01852 км/ч" )
                , ( "gps.vstop", string "Скорость регистрирации остановки объекта × 0,01852 км/ч" )
                , ( "gps.data.1", string "Назначение дополнительного поля данных GPS" )
                , ( "gps.wait", string "Время ожидания обнаружения спутников, мин" )
                , ( "gsm.apn", string "Программируеная точка входа в Интернет - APN" )
                , ( "gsm.balance.period", string "Период контроля баланса, ч" )
                , ( "gsm.flags", string "Работа в роуминге, в том числе, в национальном" )
                , ( "gsm.lagtime", string "Период проверки GSM-модуля на предмет зависания, мин" )
                , ( "gsm.predelay", string "Время проверки GSM-ретрансляторов и ожидания SMS, мин" )
                , ( "gsm.user", string "Имя пользователя для GPRS-доступа" )
                , ( "gsm.pwd", string "Пароль для GPRS-доступа" )
                , ( "limit", string "Минимально допустимый баланс SIM-карты" )
                , ( "link.delay", string "Время удержания кнопки для привязки, сек" )
                , ( "mode", string "Режим работы" )
                , ( "photo", string "Фотодатчик" )
                , ( "secur.code", string "Код безопасности для SMS-команд" )
                , ( "sms.confirm", string "Оповещение о выполнении команды смены режима." )
                , ( "timezone", string "Разница между текущим и мировым часовыми поясами, ч" )
                , ( "vin.low", string "Напряжение для сообщения о разряде батареи, V" )
                , ( "vin.off", string "Напряжение автоматического выключения Феникса, V" )
                ]
          )
        ]
