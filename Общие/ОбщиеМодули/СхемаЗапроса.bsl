// Объединяет схемы запроса
//
// Параметры:
//  ИсходнаяСхема            - СхемаЗапроса  - Обобщающая схема
//  ПрисоединяемаяСхема      - СхемаЗапроса  - схема, которая будет добавлена к исходной
//
Процедура ПрисоединитьСхемуЗапроса(ИсходнаяСхема, ПрисоединяемаяСхема)

        Если Ложь Тогда ИсходнаяСхема		= Новый СхемаЗапроса КонецЕсли;
        Если Ложь Тогда ПрисоединяемаяСхема	= Новый СхемаЗапроса КонецЕсли;

        Для каждого ПрисоединяемыйЗапрос Из ПрисоединяемаяСхема.ПакетЗапросов Цикл
                Если ИсходнаяСхема.ПакетЗапросов.Количество() = 1
                        И ТипЗнч(ИсходнаяСхема.ПакетЗапросов[0]) = Тип("ЗапросВыбораСхемыЗапроса")
                        И НЕ ИсходнаяСхема.ПакетЗапросов[0].Колонки.Количество() Тогда     // Первый запрос пакета не задан
                        ЗапросПакета = ИсходнаяСхема.ПакетЗапросов[0];
                Иначе
                        ЗапросПакета = ИсходнаяСхема.ПакетЗапросов.Добавить(ТипЗнч(ПрисоединяемыйЗапрос));
                КонецЕсли;
                Если ТипЗнч(ПрисоединяемыйЗапрос) = Тип("ЗапросВыбораСхемыЗапроса") Тогда
                        ЗапросПакета.УстановитьТекстЗапроса(ПрисоединяемыйЗапрос.ПолучитьТекстЗапроса());
                ИначеЕсли ТипЗнч(ПрисоединяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
                        ЗапросПакета.ИмяТаблицы        = ПрисоединяемыйЗапрос.ИмяТаблицы;
                КонецЕсли;
        КонецЦикла;

КонецПроцедуры

// Создаёт запросы пакета на уничтожение временных таблиц
//
// Параметры:
//  СхемаЗапроса             - СхемаЗапроса  -
//
Процедура ДобавитьУничтожениеВременныхТаблицСхемыЗапроса(СхемаЗапроса)

        Если Ложь Тогда СхемаЗапроса = Новый СхемаЗапроса КонецЕсли;

        СуществующиеВременныеТаблицы = Новый Массив; // Удалённые после создания схемы временные таблицы почему-то остаются среди доступных
        Для каждого ЗапросСхемы Из СхемаЗапроса.ПакетЗапросов Цикл
                Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") Тогда
                        Если ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) Тогда
                                СуществующиеВременныеТаблицы.Добавить(ЗапросСхемы.ТаблицаДляПомещения);
                        КонецЕсли;
                Иначе  // Уничтожение
                        Индекс = СуществующиеВременныеТаблицы.Найти(ЗапросСхемы.ИмяТаблицы);
                        Если Индекс <> Неопределено Тогда
                                СуществующиеВременныеТаблицы.Удалить(Индекс);
                        КонецЕсли;
                КонецЕсли;
        КонецЦикла;

        ЗапросСхемы = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
        ИмяВременнойТаблицыРезультата = ЗапросСхемы.ТаблицаДляПомещения;     // На случай, если результатом запроса является временная таблица

        // Уничтожим временные таблицы:
        ГруппыДоступныхТаблиц = ЗапросСхемы.ДоступныеТаблицы;
        ДоступныеТаблицы = ГруппыДоступныхТаблиц[ГруппыДоступныхТаблиц.Количество() - 1].Состав;    // Временные таблицы
        Для каждого ДоступнаяТаблица Из ДоступныеТаблицы Цикл
                Если ДоступнаяТаблица.Имя = ИмяВременнойТаблицыРезультата Тогда Продолжить КонецЕсли;
                Если СуществующиеВременныеТаблицы.Найти(ДоступнаяТаблица.Имя) = Неопределено Тогда Продолжить КонецЕсли;
                ЗапросСхемы = СхемаЗапроса.ПакетЗапросов.Добавить(Тип("ЗапросУничтоженияТаблицыСхемыЗапроса"));
                ЗапросСхемы.ИмяТаблицы = ДоступнаяТаблица.Имя;
        КонецЦикла;

КонецПроцедуры    // ДобавитьУничтожениеВременныхТаблицСхемыЗапроса()

// Добавляет источник - временную таблицу из менеджера временных таблиц
//
// Параметры:
//  ОператорСхемы			 - ОператорВыбратьСхемыЗапроса	 - Оператор, в который добавляется источник.
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц	 - Источник сведений о таблице
//  ИмяТаблицы				 - Строка	 - Имя таблицы в менеджере
//  Псевдоним				 - Строка	 - Псевдоним добавляемого источника
//
// Возвращаемое значение:
//  ИсточникСхемыЗапроса - Добавленный источник
//
Функция ДобавитьИсточникСхемыЗапросаВременнуюТаблицу(ОператорСхемы, МенеджерВременныхТаблиц, ИмяТаблицы, Псевдоним = "")
sdfdfa
	Если Ложь Тогда СхемаЗапроса = Новый СхемаЗапроса; ОператорСхемы = СхемаЗапроса.ПакетЗапросов[0].Операторы[0] КонецЕсли;
	Если Ложь Тогда МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц КонецЕсли;

	ВременнаяТаблица = МенеджерВременныхТаблиц.Таблицы.Найти(ИмяТаблицы);
	ИсточникСхемы = ОператорСхемы.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"), ВременнаяТаблица.ПолноеИмя, ?(ЗначениеЗаполнено(Псевдоним), Псевдоним, Неопределено));
	Для каждого Колонка Из ВременнаяТаблица.Колонки Цикл
		ИсточникСхемы.Источник.ДоступныеПоля.Добавить(Колонка.Имя, ТипЗнч(Колонка.ТипЗначения.ПривестиЗначение()));
	КонецЦикла;
	Псевдоним = ИсточникСхемы.Источник.Псевдоним;
	Возврат ИсточникСхемы;

КонецФункции // ДобавитьИсточникСхемыЗапросаВременнуюТаблицу()
