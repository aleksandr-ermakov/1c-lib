// BSLLS-off
// cSpell:disable

#Использовать asserts

Перем ЮнитТестирование;
Перем Данные;
Перем Модуль;
Перем ИмяМодуля;
Перем ОбщегоНазначения;
Перем ОбщегоНазначенияКлиентСервер;

// основной метод для тестирования
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТаблицаЗначенийИзСоответствия");
	
	ВсеТесты.Добавить("ТаблицаЗначенийИзСпискаЗначений");
	
	ВсеТесты.Добавить("ТаблицаЗначенийИзМассива");

	ВсеТесты.Добавить("СтруктураИзДереваЗначений");
	
	ВсеТесты.Добавить("ТаблицаЗначенийИзCSV");
	
	#Область ПримитивныеЗначения
	
	ВсеТесты.Добавить("БулевоИзСтроки");

	ВсеТесты.Добавить("ДатаИзСтроки");

	ВсеТесты.Добавить("ЧислоИзСтроки");

	#КонецОбласти // ПримитивныеЗначения

	Возврат ВсеТесты;

КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	
	Контекст = Новый Структура;

	Модуль = ЗагрузитьСценарий(
		".\Общие\ОбщиеМодули\ОбщегоНазначения\ПреобразованиеЗначений.bsl", 
		Контекст
	);
	ИмяМодуля = "ПреобразованиеЗначений";

	ОбщегоНазначения = ЗагрузитьСценарий(
		".\Общие\ОбщиеМодули\ОбщегоНазначения\ОбщегоНазначения.bsl", 
		Контекст
	);
	ОбщегоНазначенияКлиентСервер = ЗагрузитьСценарий(
		".\Общие\ОбщиеМодули\ОбщегоНазначения\ОбщегоНазначенияКлиентСервер.bsl", 
		Контекст
	);

КонецПроцедуры

#Область ТаблицаЗначенийИзСоответствия

Процедура ТаблицаЗначенийИзСоответствия() Экспорт

	ИмяМетода = "ТаблицаЗначенийИзСоответствия";

	// Исключение, если передано не соответствие
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(Неопределено);
	Ожидаем
		.Что(Модуль, "Исключение, если передано не соответствие")
		.Метод(ИмяМетода, Параметры).ВыбрасываетИсключение();
	
	// Пустая шаблонная таблица
	Результат = Модуль.ТаблицаЗначенийИзСоответствия(Новый Соответствие);
	Ожидаем.Что(Результат, "Получили таблицу").ИмеетТип("ТаблицаЗначений");
	Ожидаем.Что(Результат, "Она пустая").Не_().Заполнено();
	Ожидаем.Что(Результат.Колонки[0].Имя).Равно("Ключ");
	Ожидаем.Что(Результат.Колонки[1].Имя).Равно("Значение");
	
	// Пустая таблица с именами колонок
	Результат = Модуль.ТаблицаЗначенийИзСоответствия(Новый Соответствие, "Первая, Вторая");
	Ожидаем.Что(Результат, "Получили таблицу").ИмеетТип("ТаблицаЗначений");
	Ожидаем.Что(Результат, "Она пустая").Не_().Заполнено();
	Ожидаем.Что(Результат.Колонки[0].Имя).Равно("Первая");
	Ожидаем.Что(Результат.Колонки[1].Имя).Равно("Вторая");
	
	#Область ПробнаяТаблица
	
	Соответствие = Новый Соответствие;
	Соответствие[123] = "АБВ";
	Соответствие[456] = "ГДЕ";

	ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	ОжидаемоеЗначение.Колонки.Добавить("Цифры",	 Новый ОписаниеТипов("Число"));
	ОжидаемоеЗначение.Колонки.Добавить("Буквы", Новый ОписаниеТипов("Строка"));
	Для каждого ЭлементСответствия Из Соответствие Цикл
		Строка = ОжидаемоеЗначение.Добавить();
		Строка[0] = ЭлементСответствия.Ключ;
		Строка[1] = ЭлементСответствия.Значение;
	КонецЦикла; 

	Результат = Модуль.ТаблицаЗначенийИзСоответствия(Соответствие, "Цифры, Буквы");
	Ожидаем.Что(Результат, "Получили таблицу").ИмеетТип("ТаблицаЗначений");
	Ожидаем.Что(Результат, "Она заполнена").Заполнено();
	Ожидаем.Что(Результат.Количество()).Равно(Соответствие.Количество());
	Ожидаем.Что(Результат.Колонки[0].Имя).Равно("Цифры");
	Ожидаем.Что(Результат.Колонки[1].Имя).Равно("Буквы");

	Для каждого СтрокаТаблицы Из Результат Цикл
		Ожидаем.Что(Соответствие[СтрокаТаблицы[0]]).Равно(СтрокаТаблицы[1]);
	КонецЦикла;
	
	#КонецОбласти // ПробнаяТаблица

КонецПроцедуры

#КонецОбласти // ТаблицаЗначенийИзСоответствия

Процедура ТаблицаЗначенийИзСпискаЗначений() Экспорт

	ИмяМетода = "ТаблицаЗначенийИзСпискаЗначений";

	// Исключение, если передан не список значений
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(Неопределено);
	Ожидаем
		.Что(Модуль, "Исключение, если передан не список значений")
		.Метод(ИмяМетода, Параметры).ВыбрасываетИсключение();

	#Область Полный

	Список = Новый СписокЗначений;
	Список.Добавить(123, "Цифры", Истина);
	Список.Добавить("АБВ", "Буквы", Ложь);
	Список.Добавить(ТекущаяДата(), "Дата", Истина);

	Типы = Новый Массив;
	Типы.Добавить(Тип("Число"));
	Типы.Добавить(Тип("Строка"));
	Типы.Добавить(Тип("Дата"));
	ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	ОжидаемоеЗначение.Колонки.Добавить("Значение",		 Новый ОписаниеТипов(Типы));
	ОжидаемоеЗначение.Колонки.Добавить("Представление",	 Новый ОписаниеТипов("Строка"));	
	ОжидаемоеЗначение.Колонки.Добавить("Пометка",		 Новый ОписаниеТипов("Булево"));	
	Для каждого ЭлементСписка Из Список Цикл
		СтрокаТаблицы = ОжидаемоеЗначение.Добавить();
		СтрокаТаблицы.Значение		 = ЭлементСписка.Значение;
		СтрокаТаблицы.Представление	 = ЭлементСписка.Представление;
		СтрокаТаблицы.Пометка			 = ЭлементСписка.Пометка;
	КонецЦикла;

	Результат = Модуль.ТаблицаЗначенийИзСпискаЗначений(Список);

	Ожидаем.Что(Результат, "Получили таблицу").ИмеетТип("ТаблицаЗначений");
	Ожидаем.Что(Результат, "Она заполнена").Заполнено();
	Ожидаем.Что(Результат.Количество()).Равно(ОжидаемоеЗначение.Количество());
	Ожидаем.Что(Результат.Колонки.Количество()).Равно(ОжидаемоеЗначение.Колонки.Количество());
	Для ИндексСтроки = 0 По ОжидаемоеЗначение.Количество() - 1 Цикл
		Для ИндексКолонки = 0 По ОжидаемоеЗначение.Колонки.Количество() - 1 Цикл
			Ожидаем
				.Что(Результат[ИндексСтроки][ИндексКолонки])
				.Равно(ОжидаемоеЗначение[ИндексСтроки][ИндексКолонки]);
		КонецЦикла;
	КонецЦикла;

	#КонецОбласти

КонецПроцедуры

Процедура ТаблицаЗначенийИзМассива() Экспорт

	ИмяМетода = "ТаблицаЗначенийИзМассива";

	// Исключение, если передан не список значений
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(Неопределено);
	Ожидаем
		.Что(Модуль, "Исключение, если передан не список значений")
		.Метод(ИмяМетода, Параметры).ВыбрасываетИсключение();

	#Область Полный

	Массив = Новый Массив;
	Массив.Добавить(123);
	Массив.Добавить("АБВ");
	Массив.Добавить('20010101');

	ИмяКолонки = "Колонка";

	Типы = Новый Массив;
	Типы.Добавить(Тип("Число"));
	Типы.Добавить(Тип("Строка"));
	Типы.Добавить(Тип("Дата"));
	ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	ОжидаемоеЗначение.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов(Типы));
	Для каждого ЭлементМассива Из Массив Цикл
		ОжидаемоеЗначение.Добавить()[0] = ЭлементМассива;	
	КонецЦикла; 

	Результат = Модуль.ТаблицаЗначенийИзМассива(Массив, ИмяКолонки);

	Ожидаем.Что(Результат, "Получили таблицу").ИмеетТип("ТаблицаЗначений");
	Ожидаем.Что(Результат, "Она заполнена").Заполнено();
	Ожидаем.Что(Результат.Количество(), "Проверяем количество строк").Равно(ОжидаемоеЗначение.Количество());
	Ожидаем.Что(Результат.Колонки.Количество(), "Проверяем количество колонок").Равно(1);
	Ожидаем.Что(Результат.Колонки[0].Имя, "Проверяем имя колонки").Равно(ИмяКолонки);
	Для ИндексСтроки = 0 По ОжидаемоеЗначение.Количество() - 1 Цикл
		Ожидаем
			.Что(Результат[ИндексСтроки][0])
			.Равно(ОжидаемоеЗначение[ИндексСтроки][0]);
	КонецЦикла;
	
	#КонецОбласти

КонецПроцедуры

Процедура СтруктураИзДереваЗначений() Экспорт

	ИмяМетода = "СтруктураИзДереваЗначений";

	ТекстСообщения = "Пустое дерево";
	ДеревоЗначений = Новый ДеревоЗначений;
	КлючСтроки	 = "Строки";
	КлючРодитель = "Родитель";
	КлючВладелец = "Владелец";
	Результат = Модуль.СтруктураИзДереваЗначений(ДеревоЗначений, , КлючСтроки, КлючРодитель, КлючВладелец);
	Ожидаем
		.Что(Результат, ТекстСообщения)
		.ИмеетТип("Структура");
	Ожидаем
		.Что(Результат.Свойство(КлючСтроки), "Есть свойство Строки")
		.ЭтоИстина();
	Ожидаем
		.Что(Результат.Количество(), "Только один элемент")
		.Равно(1);
	Ожидаем.Что(Результат[КлючСтроки]).Не_().Заполнено();

	ТекстСообщения = "Небольшое дерево";
	ДеревоЗначений = Новый ДеревоЗначений;
	ДеревоЗначений.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка"));
		ДеревоЗначений.Строки.Добавить()[0] = "0";
			ДеревоЗначений.Строки[0].Строки.Добавить()[0] = "0.0";
		ДеревоЗначений.Строки.Добавить()[0] = "1";
			ДеревоЗначений.Строки[1].Строки.Добавить()[0] = "1.0";
			ДеревоЗначений.Строки[1].Строки.Добавить()[0] = "1.1";
				ДеревоЗначений.Строки[1].Строки[1].Строки.Добавить()[0] = "1.1.1";
	ДеревоЗначений.Колонки.Добавить("НенужнаяКолонка");
	Колонки = ДеревоЗначений.Колонки[0].Имя;
	КлючСтроки	 = "Строки";
	КлючРодитель = "Родитель";
	КлючВладелец = "Владелец";
	Результат = Модуль.СтруктураИзДереваЗначений(ДеревоЗначений, "Значение", КлючСтроки, КлючРодитель, КлючВладелец);
	Ожидаем
		.Что(Результат,						 "Есть корневой элемент").Заполнено()
		.Что(Результат.Количество(),		 "он один").Равно(1)
		.Что(Результат.Свойство(КлючСтроки), "он называется как надо").ЭтоИстина()
		.Что(Результат.Свойство(КлючРодитель),	 "У корня нет родителя").ЭтоЛожь()
		.Что(Результат.Свойство(КлючВладелец),	 "У корня нет владельца").ЭтоЛожь();
	Ожидаем
		.Что(Результат[КлючСтроки].Количество(), "В корне две подчиненные строки")
		.Равно(ДеревоЗначений.Строки.Количество());
	Строка0 = Результат.Строки["Строка0"];
	Ожидаем
		.Что(Строка0, "Это структура").ИмеетТип("Структура")
		.Что(Строка0.Свойство(КлючСтроки), "Есть свойство подчиненных строк").ЭтоИстина()
		.Что(Строка0[КлючСтроки], "есть подчиненные строки").Заполнено()
		.Что(Строка0.Свойство(КлючРодитель), "Есть родитель").ЭтоИстина()
		.Что(Строка0[КлючРодитель],			 "Родитель это корень").Равно(Результат)
		.Что(Строка0.Свойство(КлючВладелец), "Есть владелец").ЭтоИстина()
		.Что(Строка0[КлючВладелец],			 "Вледелец это корень").Равно(Результат)
		.Что(Строка0.Свойство("Значение"),	 "Есть колонка Значение").ЭтоИстина()
		.Что(Строка0.Свойство("НенужнаяКолонка"), "Нет колонки НенужнаяКолонка").ЭтоЛожь();
	Строка00 = Строка0.Строки["Строка0"];
	Ожидаем
		.Что(Строка00.Свойство(КлючСтроки), "Есть свойство подчиненных строк").ЭтоИстина()
		.Что(Строка00[КлючСтроки], "Подчиненных строк нет").Не_().Заполнено()
		.Что(Строка00[КлючРодитель], "Родитель указывает правильно").Равно(Строка0)
		.Что(Строка00[КлючВладелец], "Владелец указывает в корень").Равно(Результат);

	ТекстСообщения = "Дерево на много элементов";
	КоличествоЭлементов = 100;
	ДеревоЗначений = Новый ДеревоЗначений;
	Для Индекс = 1 По КоличествоЭлементов Цикл
		ДеревоЗначений.Строки.Добавить();
	КонецЦикла;
	Результат = Модуль.СтруктураИзДереваЗначений(ДеревоЗначений);
	Ожидаем
		.Что(Результат.Строки.Количество(), "Столько же элементов, сколько в дереве").Равно(КоличествоЭлементов);

КонецПроцедуры

Процедура ТаблицаЗначенийИзCSV() Экспорт
	
	ИмяМетода = "ТаблицаЗначенийИзCSV";

	#Область ТаблицаСЗаголовками

	ТекстCSV = 
	"Колонка 1, Колонка 2, Колонка 3
	|1, 2, 3
	|4, 5, 6";

	Референс = Новый ТаблицаЗначений;
	Референс.Колонки.Добавить("Колонка1");
	Референс.Колонки.Добавить("Колонка2");
	Референс.Колонки.Добавить("Колонка3");
	Стр = Референс.Добавить(); Стр[0] = "1"; Стр[1] = "2"; Стр[2] = "3";
	Стр = Референс.Добавить(); Стр[0] = "4"; Стр[1] = "5"; Стр[2] = "6";

	Результат = Модуль.ТаблицаЗначенийИзCSV(ТекстCSV);
	Ожидаем
		.Что(Результат, "Получилось привести простую таблицу с заголовками")
		.ИмеетТип("ТаблицаЗначений")
		.Что(ТаблицыЗначенийРавны(Результат, Референс), "Таблица равна ожидаемой")
		.ЭтоИстина();
	
	#КонецОбласти // ТаблицаСЗаголовками

	#Область ТаблицаБезЗаголовков
	
	ТекстCSV = 
	"1, 2, 3
	|4, 5, 6";

	Референс = Новый ТаблицаЗначений;
	Референс.Колонки.Добавить("Колонка1");
	Референс.Колонки.Добавить("Колонка2");
	Референс.Колонки.Добавить("Колонка3");
	Стр = Референс.Добавить(); Стр[0] = "1"; Стр[1] = "2"; Стр[2] = "3";
	Стр = Референс.Добавить(); Стр[0] = "4"; Стр[1] = "5"; Стр[2] = "6";

	ЕстьЗаголовки = Ложь;
	Результат = Модуль.ТаблицаЗначенийИзCSV(ТекстCSV, ",", ЕстьЗаголовки);
	Ожидаем
		.Что(Результат, "Получилось привести простую таблицу с заголовками")
		.ИмеетТип("ТаблицаЗначений")
		.Что(ТаблицыЗначенийРавны(Результат, Референс), "Таблица равна ожидаемой")
		.ЭтоИстина();

	#КонецОбласти // ТаблицаБезЗаголовков

	#Область ИменЗаголовкиКолонокТаблицы
	// Проверяем имена колонок и заголовки
	
	ТекстCSV = 
	"Первая, Вторая, Третья";

	Референс = Новый ТаблицаЗначений;
	Референс.Колонки.Добавить("Первая");
	Референс.Колонки.Добавить("Вторая");
	Референс.Колонки.Добавить("Третья");

	ЕстьЗаголовки = Истина;
	Результат = Модуль.ТаблицаЗначенийИзCSV(ТекстCSV, , ЕстьЗаголовки);
	Ожидаем
		.Что(Результат, "Получилось привести простую таблицу с заголовками")
		.ИмеетТип("ТаблицаЗначений")
		.Что(ТаблицыЗначенийРавны(Результат, Референс), "Таблица равна ожидаемой")
		.ЭтоИстина();
	Для ИндексКолонки = 1 По Результат.Колонки.Количество() - 1 Цикл
		Ожидаем
			.Что(Результат.Колонки[ИндексКолонки].Заголовок)
			.Равно(Референс.Колонки[ИндексКолонки].Заголовок);
	КонецЦикла;

	#КонецОбласти // ИменЗаголовкиКолонокТаблицы

	#Область АвтоприведениеЗначений

	ТекстCSV = 
	"КолонкаСтрока,	КолонкаЧисло,	КолонкаДата,			КолонкаБулево,	КолонкаНеопр,	КолонкаСмешанная
	|Раз,			,				31.12.2000,				Истина,			,				123
	|Два,			123,			8:00,					false,			,				Истина
	|Три,			""123 456.78"",	12.12.2012 12:12:12,	,				"""",			Строка";

	Референс = Новый ТаблицаЗначений;
	Референс.Колонки.Добавить("КолонкаСтрока",	 Новый ОписаниеТипов("Строка"));
	Референс.Колонки.Добавить("КолонкаЧисло",	 Новый ОписаниеТипов("Число"));
	Референс.Колонки.Добавить("КолонкаДата",	 Новый ОписаниеТипов("Дата"));
	Референс.Колонки.Добавить("КолонкаБулево",	 Новый ОписаниеТипов("Булево"));
	Референс.Колонки.Добавить("КолонкаНеопр");
	Референс.Колонки.Добавить("КолонкаСмешанная",	 Новый ОписаниеТипов("Булево, Число, Строка"));

	Стр = Референс.Добавить(); Стр[0] = "Раз"; Стр[1] = 0;			 Стр[2] = '20001231';		 Стр[3] = Истина;	 Стр[4] = Неопределено; Стр[5] = 123;
	Стр = Референс.Добавить(); Стр[0] = "Два"; Стр[1] = 123;		 Стр[2] = '00010101080000';	 Стр[3] = Ложь;		 Стр[4] = Неопределено; Стр[5] = Истина;
	Стр = Референс.Добавить(); Стр[0] = "Три"; Стр[1] = 123456.78;	 Стр[2] = '20121212121212';	 Стр[3] = Ложь;	 Стр[4] = Неопределено; Стр[5] = "Строка";
	
	ЕстьЗаголовки = Истина;
	Разделитель = ",";
	ПривестиЗначения = Истина;
	Результат = Модуль.ТаблицаЗначенийИзCSV(ТекстCSV, Разделитель, ЕстьЗаголовки, ПривестиЗначения);
	ТекстОшибки = "";
	ТаблицыРавны = ТаблицыЗначенийРавны(Результат, Референс, ТекстОшибки);

	Ожидаем
		.Что(Результат, "Получилось привести простую таблицу с заголовками")
		.ИмеетТип("ТаблицаЗначений")
		.Что(ТаблицыРавны, СтрШаблон("Таблица равна ожидаемой. Текст ошибки: %1", ТекстОшибки))
		.ЭтоИстина();
	Для ИндексКолонки = 1 По Результат.Колонки.Количество() - 1 Цикл
		КолонкаРезультат = Результат.Колонки[ИндексКолонки];
		КолонкаРеференс = Референс.Колонки[ИндексКолонки];
		Для каждого Тип Из КолонкаРеференс.ТипЗначения.Типы() Цикл
			Ожидаем
				.Что(КолонкаРеференс.ТипЗначения.СодержитТип(Тип), СтрШаблон("Тип колонки %1 совпадает", КолонкаРезультат.Имя))
				.ЭтоИстина();
		КонецЦикла;
	КонецЦикла;
	#КонецОбласти // АвтоприведениеЗначений

	

КонецПроцедуры // ТаблицаЗначенийИзCSV()

#Область ПримитивныеЗначения

Процедура БулевоИзСтроки() Экспорт
	
	Значения = Новый Соответствие;
	Значения["Истина"] = Истина;
	Значения["Ложь"] = Ложь;
	Значения["Да"] = Истина;
	Значения["Нет"] = Ложь;
	Значения[""] = Ложь;
	Значения["true"] = Истина;
	Значения["false"] = Ложь;

	СловарьПовтИсп = Неопределено;
	Для каждого Элемент Из Значения Цикл
		Строка = Элемент.Ключ;
		ОжадаемыйРезультат = Элемент.Значение;
		Результат = Модуль.БулевоИзСтроки(Строка, "ru", СловарьПовтИсп);
		Ожидаем.Что(Результат).Равно(ОжадаемыйРезультат);
	КонецЦикла;

КонецПроцедуры

Процедура ДатаИзСтроки() Экспорт
	
	ТекущаяДата = ТекущаяДата();

	Значения = Новый Соответствие;
	Значения[Строка(ТекущаяДата)] = ТекущаяДата;	// Каноничная форма
	Значения[""] = '00010101';
	Значения["31.12.2012"] = Дата(2012, 12, 31);
	Значения["00:00:00"] = '00010101000000';
	Значения["16:20"] = '00010101162000';
	Значения["Вчера"] = Неопределено;		// Строка
	Значения["14:88"] = Неопределено;		// Неправильное время
	Значения["31.04.2020"] = Неопределено;	// Неправильная дата
	Значения["29.02.2000"] = '20000229';	// Високосный
	Значения["29.02.2001"] = Неопределено;	// Не високосный
	Значения["2012-12-12"] = '20121212';	// Дата, сначала год
	Значения["2012-12-12 12:12"] = '20121212121200';	// Дата, сначала год
	Значения["2012-12-12T12:12"] = '20121212121200';	// Дата по ISO 8601

	Для каждого Элемент Из Значения Цикл
		Строка = Элемент.Ключ;
		ОжадаемыйРезультат = Элемент.Значение;
		ТекстИсключения = "";
		Результат = Модуль.ДатаИзСтроки(Строка, ТекстИсключения);
		ТекстСообщения = СтрШаблон("Текст исключения: %1", ТекстИсключения);
		Ожидаем.Что(Результат, ТекстСообщения).Равно(ОжадаемыйРезультат);
	КонецЦикла;

	#Область Производстельность
	
	// КоличествоИтераций = 10000;
	// НачалоЭтогоГода = НачалоГода(ТекущаяДата());
	// МассивДат = Новый Массив;
	// Разбег = 365 * 24 * 60 * 60;
	// ГСЧ = Новый ГенераторСлучайныхЧисел;
	// Для НомерИтерации = 1 По КоличествоИтераций Цикл
	// 	МассивДат.Добавить(НачалоЭтогоГода + ГСЧ.СлучайноеЧисло(0, Разбег));
	// КонецЦикла;
	// ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	// Для каждого ТекДата Из МассивДат Цикл
	// 	Модуль.ДатаИзСтроки(ТекДата);
	// КонецЦикла;
	// ЗатраченоВсего = ТекущаяУниверсальнаяДатаВМиллисекундах() - ВремяНачала;
	// ЗатраченоНаИтерацию = Окр(ЗатраченоВсего / КоличествоИтераций, 3);
	// Сообщить(СтрШаблон(
	// 	"Итераций: %1
	// 	|ОбщееВремя: %2 мсек
	// 	|На итерацию: %3 мсек",
	// 	КоличествоИтераций,
	// 	ЗатраченоВсего,
	// 	ЗатраченоНаИтерацию));
		
	#КонецОбласти // Производстельность

КонецПроцедуры

Процедура ЧислоИзСтроки() Экспорт
	
	Значения = Новый Соответствие;
	Значения["0"] = 0;
	Значения[""] = 0;
	Значения["12345"] = 12345;
	Значения["123" + Символы.НПП + "456,789"] = 123456.789;
	Значения["987 654.321"] = Неопределено;
	Значения["Стопицот"] = Неопределено;

	Для каждого Элемент Из Значения Цикл
		Строка = Элемент.Ключ;
		ОжадаемыйРезультат = Элемент.Значение;
		Результат = Модуль.ЧислоИзСтроки(Строка);
		Ожидаем.Что(Результат).Равно(ОжадаемыйРезультат);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти // ПримитивныеЗначения

#Область СлужебныеПроцедурыИФункции


#КонецОбласти // СлужебныеПроцедурыИФункции

ПередЗапускомТеста();

#Область РучноеВыполнение

// ТаблицаЗначенийИзCSV();

#КонецОбласти // РучноеВыполнение