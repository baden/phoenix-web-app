module I18N.Ua exposing (translations)

import I18Next exposing (fromTree, object, string)


translations =
    fromTree
        [ ( "Список Фениксов", string "Список Фенiксiв" )
        , ( "Да", string "Так" )
        , ( "Нет", string "Нi" )
        , ( "Режим", string "Режим" )
        , ( "Поиск", string "Пошук" )
        , ( "Ожидание", string "Очікування" )
        , ( "themes"
          , object
                [ ( "dark", string "Темна" )
                , ( "light", string "Свiтла" )
                ]
          )
        , ( "scales"
          , object
                [ ( "normal", string "Звичайний" )
                , ( "small", string "Маленький" )
                , ( "big", string "Великий" )
                , ( "bigger", string "Більший" )
                , ( "biggest", string "Найбільший" )
                ]
          )
        , ( "menu"
          , object
                [ ( "Системные опции", string "Системнi опцiї" )
                , ( "Аккаунт", string "Акаунт" )
                , ( "Язык", string "Мова" )
                , ( "Тема", string "Тема" )
                , ( "Размер", string "Розмір" )
                , ( "Настройки", string "Налаштування" )
                , ( "Выйти", string "Вийти" )
                , ( "Выйти?", string "Вийти?" )
                , ( "Вы действительно хотите выйти?", string "Ви дiйсно бажаєте вийти?" )
                , ( "Список Фениксов", string "Список Фениксів" )
                , ( "Карта", string "Карта" )
                , ( "Управление", string "Управління" )
                , ( "Настройки", string "Налаштування" )
                , ( "События", string "Події" )
                , ( "Иконка и название Феникса", string "Іконка та назва Фенікса" )
                , ( "Основные настройки", string "Основні налаштування" )
                , ( "Расширенные настройки", string "Розширені налаштування" )
                , ( "Обслуживание батареи", string "Обслуговування батареї" )
                , ( "Детали о Фениксе", string "Детальніше про Фенікс" )
                ]
          )
        , ( "login"
          , object
                [ ( "Добро пожаловать", string "Ласкаво просимо!" )
                , ( "Войдите, чтобы продолжить", string "Увійдіть, щоб продовжити" )
                , ( "Введите Ваш логин", string "Введіть Ваш логін" )
                , ( "name_not_found", string "Ім'я користувача не знайдено. Будь ласка перевірте та спробуйте ще раз." )
                , ( "Введите Ваш пароль", string "Введіть Ваш пароль." )
                , ( "Войти в систему", string "Увійти в систему." )
                , ( "У вас нет аккаунта?", string "У Вас немає акаунта?" )
                , ( "Зарегистрироваться", string "Зареєструватись" )
                , ( "Создать аккаунт", string "Створити акаунт" )
                , ( "Чтобы начать работать", string "Щоб почати роботу" )
                , ( "Повторите Ваш пароль", string "Повторіть Ваш пароль" )
                , ( "Я прочитал и принимаю условия", string "Я прочитав і приймаю умови користування" )
                , ( "пользовательского соглашения", string "" )
                , ( "Уже есть аккаунт?", string "Вже є акаунт?" )
                , ( "Введите имя пользователя", string "Введіть ім`я користувача" )
                , ( "Укажите пароль", string "Вкажіть пароль" )
                , ( "Укажите пароль повторно", string "Вкажіть пароль повторно" )
                , ( "Пароль указан неверно", string "Пароль вказаний невірно" )
                , ( "Вы должны принять условия", string "Ви маєте прийняти умови користування" )
                ]
          )
        , ( "list"
          , object
                [ ( "Добавьте ещё один Феникс", string "Добавте ще один Фенікс" )
                , ( "в список наблюдения", string "у список спостереження" )
                , ( "Добавить", string "Додати" )
                , ( "Режим Поиск:", string "Режим Пошук:" )
                , ( "Режим Ожидание:", string "Режим Очікування:" )
                , ( "На карте", string "На карте" )
                , ( "Управление", string "Управление" )
                , ( "", string "" )
                ]
          )
        , ( "master"
          , object
                [ ( "Далeе", string "Далі" )
                , ( "Назад", string "Назад" )
                , ( "Подготовка SIM-карты", string "Підготовка SIM-карти" )
                , ( "Установите SIM-карту в мобильный телефон.", string "Встановіть SIM – карту в мобільний телефон." )
                , ( "Активируйте SIM-карту в соответствии с инструкциями GSM-оператора.", string "Активуйте сім карту у відповідності до інструкцій  GSM оператора." )
                , ( "Убедитесь в том, что PIN-код при включении телефона выключен.", string "Переконайтесь , що РIN – код при увімкненні телефону вимкнений." )
                , ( "В случае необходимости зарегистрируйте SIM-карту на сайте GSM-оператора.", string "При необхідності зареєструйте SIM-карту на сайті GSM-оператора." )
                , ( "Выключите мобильный телефон и извлеките из него подготовленную SIM-карту.", string "Вимкніть мобільний телефон і дістаньте з нього підготовлену  SIM-карту." )
                , ( "Установка подготовленной SIM-карты в Феникс", string "Встановлення підготовленої SIM-карти у Фенікс" )
                , ( "Выкрутите 4 винта и снимите крышку корпуса.", string "Викрутіть 4 гвинти і зніміть кришку корпусу." )
                , ( "Убедитесь в том, что Феникс выключен – светодиодный индикатор не горит и не мигает.", string "Переконайтесь в тому, що Фенікс вимкнений – світлодіодний індикатор не світиться і не блискає." )
                , ( "Установите подготовленную SIM-карту в Феникс.", string "Встановіть підготовлену  SIM-карту у Фенікс." )
                , ( "В случае необходимости произведите привязку экзекуторов.", string "При необхідності проведіть прив’язку езекуторів." )
                , ( "Привязать экзекутор", string "Прив’язати екзекутор." )
                , ( "Экзекутор в наличии", string "Екзекутор в наявності" )
                , ( "Привязка экзекуторов и активация Феникса", string "Прив’язка екзекуторів і активація Фенікса" )
                , ( "Исходное состояние: Феникс – выключен.", string "Початковий стан: Фенікс вимкнений." )
                , ( "Обесточьте все привязываемые экзекуторы и подготовьте их к подаче питания.", string "Знеструмте усі екзекутори, що будуть прив’язуватись і підготуйте їх до подачі напруги." )
                , ( "Нажмите и удерживайте 3 секунды кнопку Фениска – загорится светодиод.", string "Натисніть і утримуйте 3 секунди кнопку Фенікса  - засвітиться світлодіод." )
                , ( "Как только светодиод загорится – подайте питание на все привязываемые экзекуторы – светодиод отработает серию частых вспышек и начнёт отрабатывать редкие одиночные вспышки.", string "Як тільки світлодіод засвітиться – подайте струм на усі екзекутори, що прив’язуються до даного Фенікса – світлодіод відпрацює серію частих спалахів і почне відпрацьовувати рідкі поодиночні спалахи." )
                , ( "Закройте крышку корпуса Фениска и закрутите 4 винта.", string "Закрийте кришку корпусу Фенікса і закрутіть 4 гвинти." )
                , ( "Активация Феникса", string "Активация Феникса" )
                , ( "Нажмите кнопку Феникса – светодиодный индикатор подтвердит включение.", string "Натисніть кнопку Фенікса - світлодіодний індикатор підтвердить увімкнення." )
                , ( "Закройте крышку корпуса Феникса и закрутите 4 винта.", string "Закрийте кришку корпусу Фенікса і закрутіть 4 гвинти." )
                , ( "Добавление Феникса в наблюдение", string "Додавання Фенікса в спостереження" )
                , ( "Отправьте на телефонный номер SIM-карты Феникса SMS: link", string "Відправте на телефонний номер SIM-карти Фенікса SMS: link" )
                , ( "В ответ придёт уникальный код – введите его в поле ниже:", string "У відповідь прийде унікальний код – введіть його в поле нижче:" )
                , ( "Введите уникальный код из SMS", string "Введіть унікальний код із  SMS" )
                , ( "Подтвердить", string "Подтвердить" )
                , ( "Мастер добавления Феникса", string "Додавання Фенікса в спостереження." )
                , ( "Свериться с", string "Звіритись з" )
                , ( "индикатором", string "індикатором" )
                ]
          )
        , ( "config"
          , object
                [ ( "Основные настройки феникса", string "Основні налаштування фенікса" )
                , ( "Период выхода на связь", string "Період виходу на зв'язок" )
                , ( "Редко", string "Рідко" )
                , ( "Феникс будет выходить на связь один раз в сутки.", string "Фенікс буде виходити на зв'язок один раз на добу." )
                , ( "Ожидаемый срок службы батареи - 15 лет.", string "Очікуваний час роботи батареї - 15 років." )
                , ( "Оптимально", string "Оптимально" )
                , ( "Феникс будет выходить на связь каждые 6 часов.", string "Фенікс буде виходити на зв'язок кожні 6 годин." )
                , ( "Ожидаемый срок службы батареи - 6 лет.", string "Очікуваний час роботи батареї - 6 років." )
                , ( "Часто", string "Часто" )
                , ( "Феникс будет выходить на связь каждые 2 часа.", string "Фенікс буде виходити на зв'язок кожні 2 години." )
                , ( "Ожидаемый срок службы батареи - 2 года.", string "Очікуваний час роботи батареї - 2 роки." )
                , ( "Время работы в режиме Поиск", string "Час роботи в режимі Пошук" )
                , ( "Продолжительно", string "Тривало" )
                , ( "Максимальное время работы в режиме Поиск - 12 часов.", string "Максимальний час роботи в режимі Пошук - 12 годин." )
                , ( "Ёмкости батареи хватит на 15 активаций режима Поиск.", string "Ємкості батареї вистачить на 15 активацій режиму Пошук." )
                , ( "Оптимально", string "Оптимально" )
                , ( "Максимальное время работы в режиме Поиск - 6 часов.", string "Максимальний час роботи в режимі Пошук - 6 годин." )
                , ( "Ёмкости батареи хватит на 30 активаций режима Поиск.", string "Ємкості батареї вистачить на 30 активацій режиму Пошук." )
                , ( "Минимально", string "Мінімально" )
                , ( "Максимальное время работы в режиме Поиск - 1 час.", string "Максимальний час роботи в режимі Пошук - 1 година." )
                , ( "Ёмкости батареи хватит на 100 активаций режима Поиск.", string "Ємкості батареї вистачить на 100 активацій режиму Пошук." )
                , ( "Информирование", string "Інформування" )
                , ( "Когда происходят определенные события, Феникс может отправлять SMS на заданный номер", string "Коли виникаютьпевні події, Фенікс може відправляти SMS на заданий номер" )
                , ( "Укажите номер телефона", string "Вкажіть номер телефону" )
                , ( "Выберите события", string "Виберіть події" )
                , ( "Критический остаток средств", string "Критичний залишок коштів" )
                , ( "Низкий уровень заряда батареи", string "Низький рівень заряду батареї" )
                , ( "Изменение режима (Поиск <-> Ожидание)", string "Зміна режиму (Пошук <-> Очікування)" )
                , ( "Изменение местоположения (в режиме Поиск)", string "Зміна місця розташування (в режимі Пошук)" )
                , ( "Включение и выключение Феникса", string "Увімкнення та вимкнення Феніксу" )
                , ( "Вскрытие корпуса", string "Відкриття корпусу" )
                , ( "Контроль баланса SIM-карты", string "Контроль баланса SIM-карти" )
                , ( "USSD-запрос баланса SIM-карты", string "USSD-запит баланса SIM-карти" )
                , ( "Безопасность", string "Безпека" )
                , ( "Чтобы никто посторонний не смог получить управление Вашим Фениксом, вы можете привязать управление к конкретному телефону и установить свой код доступа.", string "Щоб ніхто посторонній не зміг отримати управління вашим Феніксом, ви можете прив'язати управляння до конкретного телефону і захистити SMS-команди." )
                , ( "По умолчанию управление возможно с любого телефона.", string "За умовчанням управління можливе з будь якого телефону." )
                , ( "Управление возможно только с телефона:", string "Управляння можливе лише з телефону:" )
                , ( "SMS-коды управления имеют вид:", string "SMS-команди мають вигляд:" )
                , ( "Привязать к телефону", string "Прив'язати до телефону" )
                , ( "Установить пароль доступа", string "Захистити SMS-команди" )
                , ( "Вводите только латинские буквы и цифры", string "Введіть лише латинські букви та цифри" )
                , ( "Далее", string "Далі" )
                , ( "Назад", string "Назад" )
                , ( "Применить", string "Застосувати" )
                , ( "Поздравляем!", string "Вітаємо!" )
                , ( "Основные настройки применены", string "Основні налаштування застосовані" )
                , ( "Перейти к Фениксу", string "Перейти до Феніксу" )
                , ( "Удалить Феникс", string "Видалити Фенікс" )
                , ( "Экзекутор в наличии", string "Екзекутор в наявності" )
                , ( "Не указан", string "Не вказано" )
                , ( "SIM-карта", string "SIM-карта" )
                , ( "IMEI", string "IMEI" )
                , ( "Версия ПО", string "Версія ПЗ" )
                , ( "Модель", string "Модель" )
                , ( "Детали о Фениксе", string "Детальніше про Фенікс" )
                , ( "Удалить Феникс?", string "Видалити Фенікс?" )
                , ( "remove_fx", string "Ви впевнені, що бажаєте видалити Фенікс “{{title}}”? Ця дія не може бути відмінена." )
                , ( "Да, удалить", string "Так, видалити" )
                , ( "Нет", string "Ні" )
                , ( "Иконка и название", string "Іконка і назва" )
                , ( "Название Феникса", string "Назва “Фенікса”" )
                , ( "Иконка Феникса", string "Іконка “Фенікса”" )
                , ( "Ведите новое либо измените старое название", string "Введіть нові або змініть стару назву" )
                , ( "Введите название", string "Введіть назву" )
                , ( "Отмена", string "Відміна" )
                , ( "Сохранить", string "Зберегти" )
                , ( "Иконка Феникса", string "Іконка “Фенікса”" )
                , ( "Выберите подходящую иконку для вашего феникса", string "Виберіть підходящу іконку для вашого Фенікса" )
                , ( "Обслуживание батареи", string "Обслуговування батареї" )
                , ( "Предполагаемое время", string "Очікуємий час" )
                , ( "работы батареи", string "роботи батареї" )
                , ( "Статистика работы", string "Статистика работи" )
                , ( "Начальная емкость батареи", string "Початкова ємкість батареї" )
                , ( "Начало эксплуатации", string "Початок експлуатації" )
                , ( "Общее время эксплуатации", string "Загальний час експлуатації" )
                , ( "Израсходовано энергии батареи", string "Використано енергії батареї" )
                , ( "Замена батареи", string "Заміна батареї" )
                , ( "Изменить начальную емкость", string "Змінити початкову ємкість" )
                , ( "bat_replace_text", string "Заміна батареї повинна виконуватись фахівцем. Використовуйте олригінальну батарею SAFT LSH 14, 5800мАг. Якщо ви встановлюєте інший тип батареї, вкажіть її початкову ємкість (мАг)." )
                , ( "Укажите начальную емкость батареи (мАч)", string "Вкажіть початкову ємкість батареї (мАг)" )
                , ( "bat_ch_capacity", string "Якщо у Вас встановлений інший тип батареї, вкажіть її початкову ємкість (мАг)." )
                , ( "Предупреждение!", string "Попередження!" )
                , ( "warning_custom", string "Необдумані зміни в налаштуваннях можуть призвести до повної непрацездатності Фенікса. Змінюйте параметри, якщо ви повністю впевнені у своїх діях." )
                , ( "error_custom", string "Помилка завантаження або дані від Фенікса ще не отримані." )
                , ( "Отменить", string "Відмінити" )
                , ( "Показать", string "Показати" )
                , ( "изменения", string "зміни" )
                , ( "Хорошо", string "Хорошо" )
                , ( "Максимальное время работы в режиме Поиск - ", string "Максимальное время работы в режиме Поиск - " )
                , ( "7 суток", string "7 суток" )
                , ( "24 часа", string "24 години" )
                , ( "6 часов", string "6 годин" )
                , ( "Рекомендуется для охраны автомобиля на длительной стоянке.", string "Рекомендується для охорони автомобіля на тривалій стоянці." )
                , ( "Рекомендуется для наиболее вероятного обнаружения угнанного автомобиля.", string "Рекомендується для найбільш ймовірного виявлення викраденого автомобіля." )
                , ( "Рекомендуется для максимальной экономии энергии батареи питания.", string "Рекомендується для максимальної економії енергії батареї живлення." )
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
                , ( "", string "" )
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
