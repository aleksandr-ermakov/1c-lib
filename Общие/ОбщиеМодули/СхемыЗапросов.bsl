// Присоединяет схему запроса к существуещей схеме.
//
// Параметры:
//  ИсходнаяСхемаЗапроса            - СхемаЗапроса  - Обобщающая схема
//  ПрисоединяемаяСхемаЗапроса      - СхемаЗапроса  - схема, которая будет добавлена к исходной
//
Процедура ПрисоединитьСхемуЗапроса(ИсходнаяСхемаЗапроса, ПрисоединяемаяСхемаЗапроса)

	Если Ложь Тогда ИсходнаяСхемаЗапроса		= Новый СхемаЗапроса КонецЕсли;
	Если Ложь Тогда ПрисоединяемаяСхемаЗапроса	= Новый СхемаЗапроса КонецЕсли;
	
	Для каждого ЗапросСхемыПрисоединяемый Из ПрисоединяемаяСхемаЗапроса.ПакетЗапросов Цикл
		Если ИсходнаяСхемаЗапроса.ПакетЗапросов.Количество() = 1
			И ТипЗнч(ИсходнаяСхемаЗапроса.ПакетЗапросов[0]) = Тип("ЗапросВыбораСхемыЗапроса")
			И НЕ ИсходнаяСхемаЗапроса.ПакетЗапросов[0].Колонки.Количество() Тогда     // Первый запрос пакета не задан
			ЗапросСхемыПрисоединенный = ИсходнаяСхемаЗапроса.ПакетЗапросов[0];
		Иначе
			ЗапросСхемыПрисоединенный = ИсходнаяСхемаЗапроса.ПакетЗапросов.Добавить(ТипЗнч(ЗапросСхемыПрисоединяемый));
		КонецЕсли;
		Если ТипЗнч(ЗапросСхемыПрисоединяемый) = Тип("ЗапросВыбораСхемыЗапроса") Тогда
			ЗапросСхемыПрисоединенный.УстановитьТекстЗапроса(ЗапросСхемыПрисоединяемый.ПолучитьТекстЗапроса());
		ИначеЕсли ТипЗнч(ЗапросСхемыПрисоединяемый) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
			ЗапросСхемыПрисоединенный.ИмяТаблицы        = ЗапросСхемыПрисоединяемый.ИмяТаблицы;
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

	Если Ложь Тогда СхемаЗапроса = Новый СхемаЗапроса; ОператорСхемы = СхемаЗапроса.ПакетЗапросов[0].Операторы[0] КонецЕсли;
	Если Ложь Тогда МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц КонецЕсли;

	ВременнаяТаблица = МенеджерВременныхТаблиц.Таблицы.Найти(ИмяТаблицы);
	ИсточникСхемы = ОператорСхемы.Источники.Добавить(Тип("ОписаниеВременнойТаблицыСхемыЗапроса"), ВременнаяТаблица.ПолноеИмя, ?(ЗначениеЗаполнено(Псевдоним), Псевдоним, Неопределено));
	Для каждого Колонка Из ВременнаяТаблица.Колонки Цикл
		Тип = ТипЗнч(Колонка.ТипЗначения.ПривестиЗначение());
		Если Тип = Тип("Неопределено") Тогда Тип = Неопределено КонецЕсли;
		Если Тип = Тип("Строка") Тогда Тип = Неопределено КонецЕсли;		// Для последующей связи возможнжы проблемы, т.к. по умолчанию это строка неограниченной длины.
		ИсточникСхемы.Источник.ДоступныеПоля.Добавить(Колонка.Имя, Тип);
	КонецЦикла;
	Псевдоним = ИсточникСхемы.Источник.Псевдоним;
	Возврат ИсточникСхемы;

КонецФункции // ДобавитьИсточникСхемыЗапросаВременнуюТаблицу()

// Производит поиск временной таблицы с указанным именем
//
// Параметры:
//  СхемаЗапроса - СхемаЗапроса	 - Схема, в которой будет произведён поиск
//  ИмяТаблицы	 - Строка		 - Имя искомой таблицы
// 
// Возвращаемое значение:
//  ЗапросВыбораСхемыЗапроса, Неопределено - Найденный запрос. Если запрос отсутствует, будет возвращено Неопределено.
//
Функция НайтиВременнуюТаблицуСхемыЗапроса(СхемаЗапроса, ИмяТаблицы)
	
	Для каждого ЗапросСхемы Из СхемаЗапроса.ПакетЗапросов Цикл
		Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") 
			И ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) 
			И ЗапросСхемы.ТаблицаДляПомещения = ИмяТаблицы Тогда
			Возврат ЗапросСхемы;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции // НайтиВременнуюТаблицу()

// Производит поиск временных таблиц с указанным именем
//
// Параметры:
//  СхемаЗапроса - СхемаЗапроса	 - Схема, в которой будет произведён поиск
//  ИмяТаблицы	 - Строка		 - Имя искомой таблицы
// 
// Возвращаемое значение:
//  Массив - Найденые таблицы. Элемент: ЗапросВыбораСхемыЗапроса
//
Функция НайтиВременныеТаблицыСхемыЗапроса(СхемаЗапроса, ИмяТаблицы)
	
	Перем ЗапросСхемы, НайденныеЗапросыСхемы;
	
	НайденныеЗапросыСхемы = Новый Массив;
	Для каждого ЗапросСхемы Из СхемаЗапроса.ПакетЗапросов Цикл
		Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") 
			И ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) 
			И ЗапросСхемы.ТаблицаДляПомещения = ИмяТаблицы Тогда
			НайденныеЗапросыСхемы.Добавить(ЗапросСхемы);
		КонецЕсли; 
	КонецЦикла;
	
	Возврат НайденныеЗапросыСхемы;

КонецФункции

