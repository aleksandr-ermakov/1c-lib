// Формирует текст выражения запроса, подставляя в него преданные параметры
//
// Параметры:
//  ИмяПоля		 - Строка		 - Поле
//  Вид			 - ВидСравнения	 -
//  ИмяПервогоПараметра - Строка		 - Строка, превращается в имя параметра
//  ИмяПервогоПараметра - Строка		 - Строка, превращается в имя параметра. Используется в интервалах
//
// Возвращаемое значение:
//  Строка - Строка вида "ИмяПоля МЕЖДУ &ИмяПараметра И &ИмяВторогоПараметра"
//
Функция ВыражениеЗапросаСравнения(ИмяПоля, Вид, ИмяПервогоПараметра, ИмяВторогоПараметра = "") Экспорт

	Шаблоны = Новый Соответствие;
	Шаблоны.Вставить(ВидСравнения.Равно,					"%1 = %2");
	Шаблоны.Вставить(ВидСравнения.НеРавно,					"%1 <> %2");
	Шаблоны.Вставить(ВидСравнения.ВСписке,					"%1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВСписке,				"НЕ %1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.ВСписке,					"%1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВСписке,				"НЕ %1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.ВСпискеПоИерархии,		"%1 В ИЕРАРХИИ (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВСпискеПоИерархии,		"НЕ %1 В ИЕРАРХИИ (%2)");
	Шаблоны.Вставить(ВидСравнения.ВИерархии,				"%1 В ИЕРАРХИИ (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВИерархии,				"НЕ %1 В ИЕРАРХИИ (%2)");

	Шаблоны.Вставить(ВидСравнения.Больше,					"%1 > %2");
	Шаблоны.Вставить(ВидСравнения.БольшеИлиРавно,			"%1 >= %2");
	Шаблоны.Вставить(ВидСравнения.Меньше,					"%1 < %2");
	Шаблоны.Вставить(ВидСравнения.МеньшеИлиРавно,			"%1 <= %2");
	Шаблоны.Вставить(ВидСравнения.Интервал,					"%1 > %2 И %1 < %3");
	Шаблоны.Вставить(ВидСравнения.ИнтервалВключаяНачало,	"%1 >= %2 И %1 < %3");
	Шаблоны.Вставить(ВидСравнения.ИнтервалВключаяОкончание,	"%1 > %2 И %1 <= %3");
	Шаблоны.Вставить(ВидСравнения.ИнтервалВключаяГраницы,	"%1 МЕЖДУ %2 И %3");

	Шаблоны.Вставить(ВидСравнения.Содержит,		"%1 ПОДОБНО ""%""+%2+""%""");
	Шаблоны.Вставить(ВидСравнения.НеСодержит,	"НЕ %1 ПОДОБНО ""%""+%2+""%""");

	Шаблон = Шаблоны[Вид];
	Если Найти(Шаблон, "%3") > 0 Тогда
		Возврат СтрШаблон(Шаблон, ИмяПоля, ИмяПервогоПараметра, ИмяВторогоПараметра);
	КонецЕсли;
	Возврат СтрШаблон(Шаблон, ИмяПоля, ИмяПервогоПараметра);

КонецФункции // ВыражениеЗапросаСравнения()

// Формирует выражения получения пустого значения для использования в тексте запроса
//
// Параметры:
//  Значение - ОписаниеТипов, Тип, Произвольный	 - Значение, которое приводится к выражению запроса
//
// Возвращаемое значение:
//   - Строка	- Выражение запроса
//
Функция ПривестиПустоеЗначениеВыраженияЗапроса(Знач Значение) Экспорт

	Если Ложь Тогда ОписаниеТипов = Новый ОписаниеТипов КонецЕсли;

	Если ТипЗнч(Значение) = Тип("ОписаниеТипов") Тогда
		ОписаниеТипов = Значение;
	ИначеЕсли ТипЗнч(Значение) = Тип("Тип") Тогда
		Типы = Новый Массив;
		Типы.Добавить(Значение);
		ОписаниеТипов = Новый ОписаниеТипов(Типы);
	Иначе
		Типы.Добавить(ТипЗнч(Значение));
		ОписаниеТипов = Новый ОписаниеТипов(Типы);
	КонецЕсли;

	Если ОписаниеТипов.Типы().Количество() > 1 Тогда
		Возврат "НЕОПРЕДЕЛЕНО";
	КонецЕсли;

	ПустоеЗначение = ОписаниеТипов.ПривестиЗначение();

	Если ТипЗнч(ПустоеЗначение) = Тип("Число")			Тогда Возврат "0"					КонецЕсли;
	Если ТипЗнч(ПустоеЗначение) = Тип("Строка")			Тогда Возврат """"""				КонецЕсли;
	Если ТипЗнч(ПустоеЗначение) = Тип("Булево")			Тогда Возврат "ЛОЖЬ"				КонецЕсли;
	Если ТипЗнч(ПустоеЗначение) = Тип("Дата")			Тогда Возврат "ДАТАВРЕМЯ(1, 1, 1)"	КонецЕсли;
	Если ТипЗнч(ПустоеЗначение) = Тип("Неопределено")	Тогда Возврат "НЕОПРЕДЕЛЕНО"		КонецЕсли;
	Если ТипЗнч(ПустоеЗначение) = Тип("Null")			Тогда Возврат "NULL"				КонецЕсли;

	Менеджеры = Новый Соответствие;
	Менеджеры.Вставить(Справочники,				"Справочник");
	Менеджеры.Вставить(Документы,				"Документ");
	Менеджеры.Вставить(Перечисления,			"Перечисление");
	Менеджеры.Вставить(ПланыВидовХарактеристик,	"ПланВидовХарактеристик");
	Менеджеры.Вставить(ПланыСчетов,				"ПланСчетов");
	Менеджеры.Вставить(ПланыВидовРасчета,		"ПланВидовРасчета");
	Менеджеры.Вставить(ПланыОбмена,				"ПланОбмена");
	Менеджеры.Вставить(БизнесПроцессы,			"БизнесПроцесс");
	Менеджеры.Вставить(Задачи,					"Задача");

	ТипЗначения = ТипЗнч(ПустоеЗначение);

	Для каждого Менеджер Из Менеджеры Цикл
		Если Менеджер.Ключ.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
			Возврат СтрШаблон("ЗНАЧЕНИЕ(%1.%2.ПустаяСсылка)", Менеджер.Значение, ПустоеЗначение.Метаданные().Имя);
		КонецЕсли;
	КонецЦикла;

	Возврат "НЕОПРЕДЕЛЕНО";

КонецФункции // ПривестиПустоеЗначениеВыраженияЗапроса()


// Формирует текстовое представление поля для использования в запросе.
//
// Параметры:
//  Поле				 - Произвольный, ПолеКомпоновкиДанных, ДоступноеПолеОтбораКомпоновкиДанных, Прочие	 - Преобразуемое поле. Варианты использования:
//  	- Примитивные типы	- Преобразуются в текст запроса.
//  	- ПолеКомпоновкиДанных - Дополняется префиксом и помещается в текст запроса.
//  	- ДоступноеПолеОтбораКомпоновкиДанных - В параметры помещается коллекция возможных пустых значений поля.
//  	- Прочие - Значение помещается в параметр
//  ПараметрыЗапроса	 - Структура																		 - Параметры, полученные из полей
//  ПрефиксПоляДанных	 - Строка																			 - Префикс поля данных
//
// Возвращаемое значение:
//   - Строка - Текстовое представление поля
//
Функция ПолучитьПредставлениеПоляДляТекстаЗапроса(Поле, ПараметрыЗапроса, ПрефиксПоляДанных = "#")

	Если ТипЗнч(Поле) = Тип("ПолеКомпоновкиДанных") Тогда
		Возврат	ПрефиксПоляДанных + Строка(Поле);
	ИначеЕсли ТипЗнч(Поле) = Тип("Булево") Тогда
		Возврат ?(Поле, "ИСТИНА", "ЛОЖЬ");
	ИначеЕсли ТипЗнч(Поле) = Тип("Число") Тогда
		Возврат Формат(Поле, "ЧГ=0");
	ИначеЕсли ТипЗнч(Поле) = Тип("Строка") Тогда
		Возврат СтрШаблон("""%1""", Поле);
	ИначеЕсли ТипЗнч(Поле) = Тип("СтандартнаяДатаНачала") Тогда
		Возврат СтрШаблон("ДАТАВРЕМЯ(%1, %2, %3, %4, %5, %6)", 
			Формат(Год(Поле.Дата), "ЧГ=0"), 
			Месяц(Поле.Дата), День(Поле.Дата), 
			Час(Поле.Дата), 
			Минута(Поле.Дата), 
			Секунда(Поле.Дата));
	ИначеЕсли ТипЗнч(Поле) = Тип("ДоступноеПолеОтбораКомпоновкиДанных") Тогда
		// Получаем все варианты не заданного значения
		ПустыеЗначения = Новый СписокЗначений;
		КоллекцияТипов = Поле.Тип.Типы();
		Если КоллекцияТипов.Количество() Тогда
			ПустыеЗначения.Добавить(Неопределено);
		КонецЕсли;
		Для каждого Тип Из КоллекцияТипов Цикл
			Типы = Новый Массив;
			Типы.Добавить(Тип);
			ОписаниеТипов = Новый ОписаниеТипов(Типы);
			ПустыеЗначения.Добавить(ОписаниеТипов.ПривестиЗначение());
		КонецЦикла;
		ИмяПараметра = "Параметр" + Формат(ПараметрыЗапроса.Количество() + 1, "ЧГ=0");
		ПредставлениеПоля = "&" + ИмяПараметра;
		ПараметрыЗапроса.Вставить(ИмяПараметра, ПустыеЗначения);
		Возврат ПредставлениеПоля;
	Иначе
		ИмяПараметра = "Параметр" + Формат(ПараметрыЗапроса.Количество() + 1, "ЧГ=0");
		ПредставлениеПоля = "&" + ИмяПараметра;
		ПараметрыЗапроса.Вставить(ИмяПараметра, Поле);
		Возврат ПредставлениеПоля;
	КонецЕсли;

	Возврат "";

КонецФункции

// Помещает заданную таблицу значений во временную таблицу 
// менеджера временных таблиц
//
// Параметры:
//	Таблица	 - ТаблицаЗначений - ПомещаемаяТаблица
//	Менеджер - МенеджерВременныхТаблиц - Менеджер, в котором будет размещена временная таблица
//	Имя		 - Строка - Имя временной таблицы
//	Поля	 - Строка - Перечень колонок временной таблицы, через запятую. Если не указан - будут помещены все колонки.
//	Индексы	 - Строка - Перечень колонок, по которым необходимо проиндексировать временную таблицу, через запятую.
//
Процедура ПоместитьТаблицуЗначенийВоВременнуюТаблицу(Таблица, Менеджер, Имя, Поля = "", Индексы = "")
	
	ИменаКолонок = Новый Массив;
	Если ЗначениеЗаполнено(Поля) Тогда
		ИменаКолонок = СтрРазделить(Поля, ", ", Ложь);
	Иначе	// Все колонки таблицы
		Для каждого Колонка Из Таблица.Колонки Цикл
			ИменаКолонок.Добавить(Колонка.Имя);
		КонецЦикла;
	КонецЕсли;

	Псевдоним = "т";

	ТекстЗапроса = "ВЫБРАТЬ";

	ТекстЗапроса = ТекстЗапроса + Символы.ПС + СтрСоединить(ИменаКолонок, ", ");

	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ПОМЕСТИТЬ " + Имя;

	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ИЗ &ТаблицаЗначений КАК " + Псевдоним;

	Если ЗначениеЗаполнено(Индексы) Тогда
		ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ИНДЕКСИРОВАТЬ ПО " + Индексы;
	КонецЕсли; 

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	Запрос.УстановитьПараметр("ТаблицаЗначений", Таблица);
	Запрос.Выполнить();

КонецПроцедуры

// Выгружает временную таблицу запроса
// 
// Параметры:
//	Источник - Запрос					 - Запрос, содержащий временную таблицу. 
//											Если запрос не содержит менеджер временных таблиц, 
//											запрос будет выполнен повторно.
//			 - МенеджерВременныхТаблиц	 - Менеджер временных таблиц, из которого выгружается таблица
//	ВременнаяТаблица - Строка			 - Имя временой таблицы
//					 - Число			 - Индекс временной таблицы
//
// Возвращаемое значение:
//	ТаблицаЗначений - Выгруженная таблица
//
// Совместимость: 8.3.8.
//
Функция ВыгрузитьВременнуюТаблицу(Источник, ВременнаяТаблица) Экспорт
	
	Если ТипЗнч(Источник) = Тип("Запрос") Тогда

		ЕстьМенеджер = Источник.МенеджерВременныхТаблиц <> Неопределено;
		Если ЕстьМенеджер Тогда

			Выгрузка = ВыгрузитьВременнуюТаблицу(Источник.МенеджерВременныхТаблиц, ВременнаяТаблица);

		Иначе

			МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
			Запрос.Текст = Источник.Текст;
			Для каждого ПараметрЗапроса Из Источник.Параметры Цикл
				Запрос.УстановитьПараметр(ПараметрЗапроса.Ключ, ПараметрЗапроса.Значение);
			КонецЦикла;
			Результат = Запрос.Выполнить();
			Выгрузка = ВыгрузитьВременнуюТаблицу(МенеджерВременныхТаблиц, ВременнаяТаблица);
			МенеджерВременныхТаблиц.Закрыть();

		КонецЕсли;

	ИначеЕсли ТипЗнч(Источник) = Тип("МенеджерВременныхТаблиц") Тогда

		Если ТипЗнч(ВременнаяТаблица) = Тип("Строка") Тогда
			Таблица = Источник.Таблицы.Найти(ВременнаяТаблица);
			Если Таблица <> Неопределено Тогда
				Выгрузка = Таблица.ПолучитьДанные().Выгрузить();
			Иначе
				ВызватьИсключение СтрШаблон("Временная таблица %1 отсутствует в менеджере временных таблиц", ВременнаяТаблица);
			КонецЕсли;

		ИначеЕсли ТипЗнч(ВременнаяТаблица) = Тип("Число") Тогда
			Если ВременнаяТаблица < Источник.Таблицы.Количество() Тогда
				Таблица = Источник[ВременнаяТаблица];
				Выгрузка = Таблица.ПолучитьДанные().Выгрузить();
			Иначе
				ВызватьИсключение СтрШаблон("Временная таблица с индексом %1 отсутствует в менеджере временных таблиц", ВременнаяТаблица);
			КонецЕсли;

		Иначе
			ВызватьИсключение "Параметр ВременнаяТаблица: Ожидается Строка или Число";

		КонецЕсли;

	Иначе
		ВызватьИсключение "Параметр Источник: Ожидается Запрос или МенеджерВременныхТаблиц";
		
	КонецЕсли;

	Возврат Выгрузка;

КонецФункции // ВыгрузитьВременнуюТаблицу()

// Выгружает все временные таблицы запроса
// 
// Параметры:
//	Источник - Запрос					 - Запрос, содержащий временную таблицу. 
//											Если запрос не содержит менеджер временных таблиц, 
//											запрос будет выполнен повторно.
//			 - МенеджерВременныхТаблиц	 - Менеджер временных таблиц, из которого выгружается таблица
//
// Возвращаемое значение:
//	Структура - Выгруженные таблицы. Элементы:
//		* Ключ		 - Строка			 - Имя временой таблицы
//		* Значение	 - ТаблицаЗначений	 - Содержимое временной таблицы.
//
// Совместимость: 8.3.8.
//
Функция ВыгрузитьВременныеТаблицы(Источник) Экспорт

	Если ТипЗнч(Источник) = Тип("Запрос") Тогда

		ЕстьМенеджер = Источник.МенеджерВременныхТаблиц <> Неопределено;
		Если ЕстьМенеджер Тогда

			Выгрузка = ВыгрузитьВременныеТаблицы(Источник.МенеджерВременныхТаблиц);

		Иначе

			МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
			Запрос.Текст = Источник.Текст;
			Для каждого ПараметрЗапроса Из Источник.Параметры Цикл
				Запрос.УстановитьПараметр(ПараметрЗапроса.Ключ, ПараметрЗапроса.Значение);
			КонецЦикла;
			Результат = Запрос.Выполнить();
			Выгрузка = ВыгрузитьВременныеТаблицы(МенеджерВременныхТаблиц);
			МенеджерВременныхТаблиц.Закрыть();

		КонецЕсли;

	ИначеЕсли ТипЗнч(Источник) = Тип("МенеджерВременныхТаблиц") Тогда

		Выгрузка = Новый Структура;

		Для каждого Таблица Из Источник.Таблицы Цикл
			Выгрузка.Вставить(Таблица.ПолноеИмя, Таблица.ПолучитьДанные().Выгрузить());
		КонецЦикла;

	Иначе
		ВызватьИсключение "Параметр Источник: Ожидается Запрос или МенеджерВременныхТаблиц";
		
	КонецЕсли;

	Возврат Выгрузка;
	
КонецФункции // ВыгрузитьВременныеТаблицы()


// Выгружает запрос в строку XML, которую можно вставить в Консоль запросов.
//  Аналогична функции БСП ОбщегоНазначения.ЗапросВСтрокуXML(),
//	но выгружает временные таблицы в качестве параметров,
//	и дополняет текст запросами помещения таблиц из параметров во временные таблицы.
//
// Параметры:
//   Запрос - Запрос - запрос, который необходимо выгрузить в формат строки XML.
//
// Возвращаемое значение:
//   Строка - строка в формате XML, которую можно извлечь при помощи метода "ОбщегоНазначения.ЗначениеИзСтрокиXML".
//       После извлечения получится объект типа "Структура" с полями:
//       * Текст     - Строка - текст запроса.
//       * Параметры - Структура - параметры запроса.
//
Функция ЗапросВСтрокуXML(Запрос) Экспорт

	ТекстЗапроса = Запрос.Текст;
	ПараметрыЗапроса = Новый Структура;
	Для каждого ПараметрЗапроса Из Запрос.Параметры Цикл
		ПараметрыЗапроса.Вставить(ПараметрЗапроса.Ключ, ПараметрЗапроса.Значение);
	КонецЦикла;
	
	#Область ВременныеТаблицы
	МенеджерВремТаб = Запрос.МенеджерВременныхТаблиц;
	Если МенеджерВремТаб <> Неопределено И ЗначениеЗаполнено(МенеджерВремТаб.Таблицы) Тогда
		
		ЧастиЗапроса = Новый Массив;

		Для каждого ВремТаблица Из МенеджерВремТаб.Таблицы Цикл
			
			ИмяВремТаблицы = ВремТаблица.ПолноеИмя;

			// Если таблица не упоминается в запросе, тогда не выгружаем.
			// Поиск простой - для скорости.
			Если СтрНайти(Запрос.Текст, ИмяВремТаблицы) = 0 Тогда
				Продолжить;
			КонецЕсли;

			СодержимоеВремТаблицы = ВремТаблица.ПолучитьДанные().Выгрузить();

			Счетчик = 0;
			ИмяПараметраЗанято = Истина;
			Пока ИмяПараметраЗанято Цикл
				ИмяПараметраВремТаблицы = "ВремТаб_" + ИмяВремТаблицы + Формат(Счетчик, "ЧГ=0");
				ИмяПараметраЗанято = ПараметрыЗапроса.Свойство(ИмяПараметраВремТаблицы);
				Счетчик = Счетчик + 1;
			КонецЦикла;
			ПараметрыЗапроса.Вставить(ИмяПараметраВремТаблицы, СодержимоеВремТаблицы);

			#Область ТекстЗапроса
			ВыбираемыеПоля = Новый Массив;
			Для каждого Колонка Из ВремТаблица.Колонки Цикл
				ВыбираемыеПоля.Добавить("	вт." + Колонка.Имя);
			КонецЦикла;
			ВыбираемыеПоля = СтрСоединить(ВыбираемыеПоля, "," + Символы.ПС);

			ТекстЗапросаВремТаблицы = СтрШаблон(
			"ВЫБРАТЬ
			|%1
			|ПОМЕСТИТЬ %3
			|ИЗ &%2 КАК вт",
			ВыбираемыеПоля,
			ИмяПараметраВремТаблицы,
			ИмяВремТаблицы);

			ЧастиЗапроса.Добавить(ТекстЗапросаВремТаблицы);
			#КонецОбласти

		КонецЦикла;

		ЧастиЗапроса.Добавить(ТекстЗапроса);
		ТекстЗапроса = СтрСоединить(ЧастиЗапроса, 
		";
		|
		|////////////////////////////////////////////////////////////////////////////////
		|");

	КонецЕсли;
	#КонецОбласти // ВременныеТаблицы

	ЗапросСтруктурой = Новый Структура("Текст, Параметры", ТекстЗапроса, ПараметрыЗапроса);

	#Область ЗначениеВСтрокуXML

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ЗапросСтруктурой, НазначениеТипаXML.Явное);
	
	ЗначениеСтрокойXML = ЗаписьXML.Закрыть();

	#КонецОбласти // ЗначениеВСтрокуXML

	Возврат ЗначениеСтрокойXML;

КонецФункции // ЗапросВСтрокуXML()

#Область Специфичные

// Формирует запрос получения каждого дня периода
//
Функция ТекстЗапросаКаждыйДеньПериода(ИмяПараметраНачалоПериода = "НачалоПериода", ИмяПараметраКонецПериода = "КонецПериода")

	// #СДЕЛАТЬ формирование запроса в зависимости от количества дней периода
	// #СДЕЛАТЬ подстановку имён параметров

	Возврат
	"ВЫБРАТЬ 0 КАК Ч
	|ПОМЕСТИТЬ ДесятьЧисел
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 1 
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 2
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 3
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 4 
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 5
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 6
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 7
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 8
	|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ 9
	|;
	|
	|ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(&НачалоПериода, День, Числа.Число) КАК День
	|ИЗ (
	|	
	|	ВЫБРАТЬ 
	|		Тысячи.Ч*1000 + Сотни.Ч*100 + Десятки.Ч*10 + Единицы.Ч КАК Число
	|	ИЗ 
	|		ДесятьЧисел КАК Тысячи
	|		ПОЛНОЕ СОЕДИНЕНИЕ  ДесятьЧисел КАК Сотни	 ПО Истина
	|		ПОЛНОЕ СОЕДИНЕНИЕ  ДесятьЧисел КАК Десятки	 ПО Истина
	|		ПОЛНОЕ СОЕДИНЕНИЕ  ДесятьЧисел КАК Единицы	 ПО Истина
	|	ГДЕ 
	|		(Тысячи.Ч*1000 + Сотни.Ч*100 + Десятки.Ч*10 + Единицы.Ч) <= РАЗНОСТЬДАТ(&НачалоПериода, &КонецПериода, День)	
	|		
	|) КАК Числа
	|УПОРЯДОЧИТЬ ПО День";

КонецФункции // ТекстЗапросаКаждыйДеньПериода()

// Формирует текст запроса транзитивного замыкания элементов справочника
//
// Параметры:
//	ИмяСправочника - Строка - Имя справочника в метаданных
//	МаксимальнаяДлинаПути - Число - Максимальная длина определяемого пути между элементами.
//		Если не задано, то определяется по ограничению количества уровней иерархии справочника. 
//		Если предел иерархии справочника не задан, принимается равным 64.
//
// ВозвращаемоеЗначение:
//	ТекстЗапроса - Строка - ТексЗапроса, формирующий таблицу с полями:
//		* Предок	 - СправочникСсылка	 - Элемент-предок справочника
//		* Потомок	 - СправочникСсылка	 - Элемент-потомок справочника
//		* ДлинаДуги	 - Число			 - Количество шагов наследственности от предка до потомка. 
//										Для непосредственных родителей равна 1.
//
Функция ТекстЗапросаТранзитивногоЗамыканияСправочника(ИмяСправочника, МаксимальнаяДлинаПути = Неопределено)

	// Методика: https://infostart.ru/public/158512/

	Если МаксимальнаяДлинаПути = Неопределено Тогда
		МетаСправочник = Метаданные.Справочники[ИмяСправочника];
		Если МетаСправочник.ОграничиватьКоличествоУровней Тогда
			МаксимальнаяДлинаПути = МетаСправочник.КоличествоУровней;
		ИначеЕсли не МетаСправочник.Иерархческий Тогда
			МаксимальнаяДлинаПути = 1;
		Иначе
			МаксимальнаяДлинаПути = 64;
		КонецЕсли
	КонецЕсли;

	Пролог = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ Родитель НачалоДуги, Ссылка КонецДуги, 1 ДлинаДуги 
	| ПОМЕСТИТЬ ЗамыканияДлины1 ИЗ Справочник.%1
	| ГДЕ Родитель <> Значение(Справочник.%1.ПустаяСсылка)
	| ОБЪЕДИНИТЬ ВЫБРАТЬ Ссылка, Ссылка, 0 ИЗ Справочник.%1";

	Рефрен = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПерваяДуга.НачалоДуги, ВтораяДуга.КонецДуги, ПерваяДуга.ДлинаДуги + ВтораяДуга.ДлинаДуги ДлинаДуги 
	| ПОМЕСТИТЬ ЗамыканияДлины%2 ИЗ ЗамыканияДлины%1 КАК ПерваяДуга
	| ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗамыканияДлины%1 КАК ВтораяДуга ПО ПерваяДуга.КонецДуги = ВтораяДуга.НачалоДуги;
	| УНИЧТОЖИТЬ ЗамыканияДлины%1";

	Эпилог = 
	"ВЫБРАТЬ НачалоДуги Предок, КонецДуги Потомок, ДлинаДуги ИЗ ЗамыканияДлины%1 ГДЕ НачалоДуги <> КонецДуги";

	ЧастиЗапроса = Новый Массив;
	ЧастиЗапроса.Добавить(СтрШаблон(Пролог, ИмяСправочника));	// Пролог

	МаксимальнаяДлинаЗамыканий = 1;
	Пока МаксимальнаяДлинаЗамыканий < МаксимальнаяДлинаПути Цикл	// Рефрен
		ЧастиЗапроса.Добавить(
			СтрШаблон(Рефрен, Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0"), 
			Формат(2 * МаксимальнаяДлинаЗамыканий, "ЧГ=0")));
		МаксимальнаяДлинаЗамыканий = 2 * МаксимальнаяДлинаЗамыканий;
	КонецЦикла;

	ЧастиЗапроса.Добавить(СтрШаблон(Эпилог, Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0")));	// Эпилог

	ТекстЗапроса = СтрСоединить(ЧастиЗапроса, ";" + Символы.ПС);

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти // Специфичные