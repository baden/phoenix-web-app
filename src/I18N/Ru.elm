module I18N.Ru exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Список фениксов" )
        , ( "Да", string "Да" )
        , ( "Нет", string "Нет" )
        , ( "Режим", string "Режим" )
        , ( "Поиск", string "Поиск" )
        , ( "Ожидание", string "Ожидание" )
        , ( "themes"
          , object
                [ ( "dark", string "Темная" )
                , ( "light", string "Светлая" )
                ]
          )
        , ( "scales"
          , object
                [ ( "normal", string "Норма" )
                , ( "small", string "Меньше" )
                , ( "big", string "Больше" )
                , ( "bigger", string "БОЛЬШЕ" )
                , ( "biggest", string "ЕЩЕ БОЛЬШЕ!!!" )
                ]
          )
        , ( "menu"
          , object
                [ ( "Системные опции", string "Системные опции" )
                , ( "Аккаунт", string "Аккаунт" )
                , ( "Язык", string "Язык" )
                , ( "Тема", string "Тема" )
                , ( "Размер", string "Размер" )
                , ( "Настройки", string "Настройки" )
                , ( "Выйти", string "Выйти" )
                , ( "Выйти?", string "Выйти?" )
                , ( "Вы действительно хотите выйти?", string "Вы действительно хотите выйти?" )
                , ( "Список Фениксов", string "Список Фениксов" )
                , ( "Карта", string "Карта" )
                , ( "Управление", string "Управление" )
                , ( "Настройки", string "Настройки" )
                , ( "События", string "События" )
                , ( "Иконка и название Феникса", string "Иконка и название “Феникса”" )
                , ( "Основные настройки", string "Основные настройки" )
                , ( "Расширенные настройки", string "Расширенные настройки" )
                , ( "Обслуживание батареи", string "Обслуживание батареи" )
                , ( "Детали о Фениксе", string "Детали о Фениксе" )
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
                , ( "На карте", string "На карте" )
                , ( "Управление", string "Управление" )
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
        , ( "config"
          , object
                [ ( "Основные настройки феникса", string "Основные настройки феникса" )
                , ( "Период выхода на связь", string "Период выхода на связь" )
                , ( "Редко", string "Редко" )
                , ( "Феникс будет выходить на связь один раз в сутки.", string "Феникс будет выходить на связь один раз в сутки." )
                , ( "Ожидаемый срок службы батареи - 15 лет.", string "Ожидаемый срок службы батареи - 15 лет." )
                , ( "Оптимально", string "Оптимально" )
                , ( "Феникс будет выходить на связь каждые 6 часов.", string "Феникс будет выходить на связь каждые 6 часов." )
                , ( "Ожидаемый срок службы батареи - 6 лет.", string "Ожидаемый срок службы батареи - 6 лет." )
                , ( "Часто", string "Часто" )
                , ( "Феникс будет выходить на связь каждые 2 часа.", string "Феникс будет выходить на связь каждые 2 часа." )
                , ( "Ожидаемый срок службы батареи - 2 года.", string "Ожидаемый срок службы батареи - 2 года." )
                , ( "Время работы в режиме Поиск", string "Время работы в режиме Поиск" )
                , ( "Продолжительно", string "Продолжительно" )
                , ( "Максимальное время работы в режиме Поиск - 12 часов.", string "Максимальное время работы в режиме Поиск - 12 часов." )
                , ( "Ёмкости батареи хватит на 15 активаций режима Поиск.", string "Ёмкости батареи хватит на 15 активаций режима Поиск." )
                , ( "Оптимально", string "Оптимально" )
                , ( "Максимальное время работы в режиме Поиск - 6 часов.", string "Максимальное время работы в режиме Поиск - 6 часов." )
                , ( "Ёмкости батареи хватит на 30 активаций режима Поиск.", string "Ёмкости батареи хватит на 30 активаций режима Поиск." )
                , ( "Минимально", string "Минимально" )
                , ( "Максимальное время работы в режиме Поиск - 1 час.", string "Максимальное время работы в режиме Поиск - 1 час." )
                , ( "Ёмкости батареи хватит на 100 активаций режима Поиск.", string "Ёмкости батареи хватит на 100 активаций режима Поиск." )
                , ( "Информирование", string "Информирование" )
                , ( "Когда происходят определенные события, Феникс может отправлять SMS на заданный номер", string "Когда происходят определенные события, Феникс может отправлять SMS на заданный номер" )
                , ( "Укажите номер телефона", string "Укажите номер телефона" )
                , ( "Выберите события", string "Выберите события" )
                , ( "Критический остаток средств", string "Критический остаток средств" )
                , ( "Низкий уровень заряда батареи", string "Низкий уровень заряда батареи" )
                , ( "Изменение режима (Поиск <-> Ожидание)", string "Изменение режима (Поиск <-> Ожидание)" )
                , ( "Начало движения (в режиме Поиск)", string "Начало движения (в режиме Поиск)" )
                , ( "Включение и выключение Феникса", string "Включение и выключение Феникса" )
                , ( "Вскрытие корпуса", string "Вскрытие корпуса" )
                , ( "Контроль баланса SIM-карты", string "Контроль баланса SIM-карты" )
                , ( "USSD-запрос баланса SIM-карты", string "USSD-запрос баланса SIM-карты" )
                , ( "Безопасность", string "Безопасность" )
                , ( "Чтобы никто посторонний не смог получить управление Вашим Фениксом, вы можете привязать управление к конкретному телефону и установить свой код доступа.", string "Чтобы никто посторонний не смог получить управление Вашим Фениксом, вы можете привязать управление к конкретному телефону и защитить SMS-команды." )
                , ( "По умолчанию управление возможно с любого телефона.", string "По умолчанию управление возможно с любого телефона." )
                , ( "Управление возможно только с телефона:", string "Управление возможно только с телефона:" )
                , ( "SMS-коды управления имеют вид:", string "SMS-команды имеют вид:" )
                , ( "Привязать к телефону", string "Привязать к телефону" )
                , ( "Установить пароль доступа", string "Защитить SMS-команды" )
                , ( "Вводите только латинские буквы и цифры", string "Вводите только латинские буквы и цифры" )
                , ( "Далее", string "Далее" )
                , ( "Назад", string "Назад" )
                , ( "Применить", string "Применить" )
                , ( "Поздравляем!", string "Поздравляем!" )
                , ( "Основные настройки применены", string "Основные настройки применены" )
                , ( "Перейти к Фениксу", string "Перейти к Фениксу" )
                , ( "Удалить Феникс", string "Удалить Феникс" )
                , ( "Экзекутор в наличии", string "Экзекутор в наличии" )
                , ( "Не указан", string "Не указан" )
                , ( "SIM-карта", string "SIM-карта" )
                , ( "IMEI", string "IMEI" )
                , ( "Версия ПО", string "Версия ПО" )
                , ( "Модель", string "Модель" )
                , ( "Детали о Фениксе", string "Детали о Фениксе" )
                , ( "Удалить Феникс?", string "Удалить Феникс?" )
                , ( "remove_fx", string "Вы уверены, что хотите удалить Феникс “{{title}}”? Это действие не может быть отменено." )
                , ( "Да, удалить", string "Да, удалить" )
                , ( "Нет", string "Нет" )
                , ( "Иконка и название", string "Иконка и название" )
                , ( "Название Феникса", string "Название “Феникса”" )
                , ( "Иконка Феникса", string "Иконка “Феникса”" )
                , ( "Ведите новое либо измените старое название", string "Ведите новое либо измените старое название" )
                , ( "Введите название", string "Введите название" )
                , ( "Отмена", string "Отмена" )
                , ( "Сохранить", string "Сохранить" )
                , ( "Иконка Феникса", string "Иконка “Феникса”" )
                , ( "Выберите подходящую иконку для вашего феникса", string "Выберите подходящую иконку для вашего феникса" )
                , ( "Обслуживание батареи", string "Обслуживание батареи" )
                , ( "Предполагаемое время", string "Предполагаемое время" )
                , ( "работы батареи", string "работы батареи" )
                , ( "Статистика работы", string "Статистика работы" )
                , ( "Начальная емкость батареи", string "Начальная емкость батареи" )
                , ( "Начало эксплуатации", string "Начало эксплуатации" )
                , ( "Общее время эксплуатации", string "Общее время эксплуатации" )
                , ( "Израсходовано энергии батареи", string "Израсходовано энергии батареи" )
                , ( "Замена батареи", string "Замена батареи" )
                , ( "Изменить начальную емкость", string "Изменить начальную емкость" )
                , ( "bat_replace_text", string "Замена батареи должна осуществляться специалистом. Используйте оригинальную батарею SAFT LSH 14, 5800мАч. Если у вы устанавливаете другой тип батареи, укажите ее начальную емкость (мАч)." )
                , ( "Укажите начальную емкость батареи (мАч)", string "Укажите начальную емкость батареи (мАч)" )
                , ( "bat_ch_capacity", string "Если у вас установлен другой тип батареи, укажите ее начальную емкость (мАч)." )
                , ( "Предупреждение!", string "Предупреждение!" )
                , ( "warning_custom", string "Необдуманное изменение настроек может привести к полной неработоспособности Феникса. Изменяйте параметры только если полностью уверены в своих действиях." )
                , ( "error_custom", string "Ошибка загрузки или данные от Феникса еще не получены." )
                , ( "Отменить", string "Отменить" )
                , ( "Показать", string "Показать" )
                , ( "изменения", string "изменения" )
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
                , ( "Вы сможете нажать эту кнопку после того как Феникc исполнит команды которые ждут выполнения", string "Вы сможете нажать эту кнопку после того как Феникc выполнит команды, которые ждут выполнения." )
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
