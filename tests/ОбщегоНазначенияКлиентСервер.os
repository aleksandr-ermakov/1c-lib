// BSLLS-off
// cSpell:disable

#Использовать asserts


Перем ЮнитТестирование;
Перем Данные;
Перем Модуль;

Перем ОбщегоНазначенияКлиентСервер;

Процедура ПередЗапускомТеста() Экспорт
	
	Контекст = Новый Структура;
	Модуль = ЗагрузитьСценарий(
		".\Общие\ОбщиеМодули\ОбщегоНазначения\ОбщегоНазначенияКлиентСервер.bsl", 
		Контекст
	);
	ОбщегоНазначенияКлиентСервер = Модуль;

КонецПроцедуры

// основной метод для тестирования
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

	ВсеТесты = Новый Массив;
	
	#Область Коллекции

	#Область Деревья
	
	#КонецОбласти // Деревья

	#Область Массив
	
	ВсеТесты.Добавить("ЕстьПересечениеМассивов");
	ВсеТесты.Добавить("МассивИзЗначения");
	ВсеТесты.Добавить("МассивЗначений");
	ВсеТесты.Добавить("МассивОтсортирован");
	ВсеТесты.Добавить("МассивыРавны");
	ВсеТесты.Добавить("ПересечениеМассивов");
	
	#КонецОбласти // Массив

	#Область Соответствие
	
	#КонецОбласти // Соответствие

	#Область Структура
	
	ВсеТесты.Добавить("СтруктурыРавны");

	#КонецОбласти // Структура
	
	ВсеТесты.Добавить("ВыгрузитьПолеКоллекции");
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу");
	ВсеТесты.Добавить("ПоменятьМестамиКлючиИЗначения");
	ВсеТесты.Добавить("СкопироватьКоллекцию");
	ВсеТесты.Добавить("СортироватьКоллекцию");

	#КонецОбласти // Коллекции

	ВсеТесты.Добавить("РимскийЛитерал");
	ВсеТесты.Добавить("РимскийЛитерал_Исключения");
	ВсеТесты.Добавить("ОбратныйПорядок");
	ВсеТесты.Добавить("ОбеспечитьСвойствоСтруктуры");
	ВсеТесты.Добавить("РаспределитьДатыПоХронологии");
	ВсеТесты.Добавить("ЭтоВисокосныйГод");
	ВсеТесты.Добавить("СтрНайтиЦеликом");
	
	#Область Объекты
	
	ВсеТесты.Добавить("ПеренестиЗначенияСвойств");

	#КонецОбласти // Объекты

	#Область Коллекции

	#КонецОбласти // Коллекции

	#Область Строка
	
	#Область РимскоеЧисло
	ВсеТесты.Добавить("РимскоеЧисло_Простой");
	// ВсеТесты.Добавить("РимскоеЧисло_ПолнаяТаблица");
	#КонецОбласти // РимскоеЧисло

	#Область ЧислоИзРимскогоЧисла
	ВсеТесты.Добавить("ЧислоИзРимскогоЧисла");
	#КонецОбласти // ЧислоИзРимскогоЧисла

	ВсеТесты.Добавить("ЭтоУникальныйИдентификатор");
	

	#КонецОбласти // Строка

	Возврат ВсеТесты;

КонецФункции

#Область ОписанияТипов

#КонецОбласти // ОписанияТипов

#Область ПримитивныеТипы

#КонецОбласти // ПримитивныеТипы

#Область Объекты

Процедура ПеренестиЗначенияСвойств() Экспорт
	
	Источник = Новый Структура("Один, Два", 1, 2);
	Приемник = Новый Структура("Первый, Второй, Третий");
	Свойства = Новый Структура("Первый, Второй", "Один", "Два");

	Модуль.ПеренестиЗначенияСвойств(Приемник, Источник, Свойства);
	ТекстСообщения = "Свойства по структуре перенеслись верно";
	Ожидаем
		.Что(Приемник["Первый"], ТекстСообщения).Равно(Источник["Один"])
		.Что(Приемник["Второй"], ТекстСообщения).Равно(Источник["Два"])
		.Что(Приемник["Третий"], ТекстСообщения).Равно(Неопределено);

КонецПроцедуры

#КонецОбласти // Объекты

#Область Коллекции

#Область Массив

Процедура ЕстьПересечениеМассивов() Экспорт

	ПервыйМассив = Новый Массив;
	ПервыйМассив.Добавить(1);
	ПервыйМассив.Добавить(2);
	ПервыйМассив.Добавить(3);

	ВторойМассив = Новый Массив;
	ВторойМассив.Добавить(4);
	ВторойМассив.Добавить(2);
	ВторойМассив.Добавить(3);

	ОжидаемыйРезультат = Новый Массив;
	ОжидаемыйРезультат.Добавить(2);
	ОжидаемыйРезультат.Добавить(3);

	Результат = Модуль.ЕстьПересечениеМассивов(ПервыйМассив, ВторойМассив);

	Если Результат = Ложь Тогда
		ВызватьИсключение "Неожиданный результат";
	КонецЕсли;
	
КонецПроцедуры

Процедура МассивИзЗначения() Экспорт
	
	Значение = Новый УникальныйИдентификатор;
	Результат = Модуль.МассивИзЗначения(Значение);
	Ожидаем.Что(Результат).ИмеетТип("Массив").ИмеетДлину(1);
	Ожидаем.Что(Результат[0]).Равно(Значение);

КонецПроцедуры

Процедура МассивЗначений() Экспорт

	Результат = Модуль.МассивЗначений();
	Ожидаем.Что(Результат).ИмеетТип("Массив").НЕ_().Заполнено();

	Результат = Модуль.МассивЗначений(1, 2, 3);
	Ожидаем.Что(Результат).ИмеетТип("Массив").Заполнено().ИмеетДлину(3);
	Ожидаем.Что(Результат[0]).Равно(1);
	Ожидаем.Что(Результат[1]).Равно(2);
	Ожидаем.Что(Результат[2]).Равно(3);
	
	// Первый Null должен попасть в массив, второй - нет.

	Результат = Модуль.МассивЗначений(1, Null, 3, Null);
	Ожидаем.Что(Результат).ИмеетТип("Массив").Заполнено().ИмеетДлину(3);
	Ожидаем.Что(Результат[0]).Равно(1);
	Ожидаем.Что(Результат[1]).Равно(Null);
	Ожидаем.Что(Результат[2]).Равно(3);
	
КонецПроцедуры

Процедура МассивОтсортирован() Экспорт

	ИмяМетода = "МассивОтсортирован";

	Параметры = Новый Массив(1); // Один параметр - Неопределено
	Ожидаем
		.Что(Модуль, "Исключение при неверном параметре")
		.Метод(ИмяМетода, Параметры)
		.ВыбрасываетИсключение();

	Массив = Новый Массив;
	Результат = Модуль.МассивОтсортирован(Массив);
	Ожидаем
		.Что(Результат, "Пустой массив отсортирован")
		.Равно(Истина);

	Массив = Новый Массив;
	Массив.Добавить(1);
	Массив.Добавить(2);
	Массив.Добавить(3);
	Результат = Модуль.МассивОтсортирован(Массив);
	Ожидаем
		.Что(Результат, "Простой массив отсортирован")
		.Равно(Истина);

	Массив = Новый Массив;
	Массив.Добавить(3);
	Массив.Добавить(2);
	Массив.Добавить(1);
	ПоУбыванию = Истина;
	Результат = Модуль.МассивОтсортирован(Массив, ПоУбыванию);
	Ожидаем
		.Что(Результат, "Простой массив отсортирован по убыванию")
		.Равно(Истина);

	Массив = Новый Массив;
	Массив.Добавить(1);
	Массив.Добавить(3);
	Массив.Добавить(2);
	Результат = Модуль.МассивОтсортирован(Массив);
	Ожидаем
		.Что(Результат, "Простой неотсортированный массив")
		.Равно(Ложь);

	Список = Новый СписокЗначений;
	Список.Добавить(Неопределено);
	Список.Добавить(Ложь);
	Список.Добавить(0);
	Список.Добавить('00010101');
	Список.СортироватьПоЗначению();
	Массив = Список.ВыгрузитьЗначения();
	Результат = Модуль.МассивОтсортирован(Массив);
	Ожидаем
		.Что(Результат, "Отсортированный массив со смешанными типами")
		.Равно(Истина);

КонецПроцедуры // МассивОтсортирован()

Процедура МассивыРавны() Экспорт
	
	ПервыйМассив = Новый Массив;
	ВторойМассив = Новый Массив;

	Ожидаем
		.Что(Модуль.МассивыРавны(ПервыйМассив, ВторойМассив), "Пустые массивы равны")
		.ЭтоИстина();

	ПервыйМассив.Добавить(1);
	ПервыйМассив.Добавить(2);
	ПервыйМассив.Добавить(3);

	ВторойМассив.Очистить();
	ВторойМассив.Добавить(1);
	ВторойМассив.Добавить(2);
	ВторойМассив.Добавить(3);

	Ожидаем
		.Что(Модуль.МассивыРавны(ПервыйМассив, ВторойМассив), "Одинаковые массивы равны")
		.ЭтоИстина();

	ВторойМассив.Очистить();
	ВторойМассив.Добавить(1);
	ВторойМассив.Добавить(2);

	Ожидаем
		.Что(Модуль.МассивыРавны(ПервыйМассив, ВторойМассив), "Разные массивы не равны")
		.ЭтоЛожь();

	ВторойМассив.Очистить();
	ВторойМассив.Добавить(3);
	ВторойМассив.Добавить(2);
	ВторойМассив.Добавить(1);

	Ожидаем
		.Что(Модуль.МассивыРавны(ПервыйМассив, ВторойМассив), "Разный порядок элементов")
		.ЭтоЛожь();

КонецПроцедуры // МассивыРавны()

Процедура ПересечениеМассивов() Экспорт

	ПервыйМассив = Новый Массив;
	ПервыйМассив.Добавить(1);
	ПервыйМассив.Добавить(2);
	ПервыйМассив.Добавить(3);

	ВторойМассив = Новый Массив;
	ВторойМассив.Добавить(4);
	ВторойМассив.Добавить(2);
	ВторойМассив.Добавить(3);

	ОжидаемыйРезультат = Новый Массив;
	ОжидаемыйРезультат.Добавить(2);
	ОжидаемыйРезультат.Добавить(3);

	Результат = Модуль.ПересечениеМассивов(ПервыйМассив, ВторойМассив);

	Если ОжидаемыйРезультат.Количество() <> Результат.Количество() Тогда
		ВызватьИсключение "Неожиданные количество в результате";
	КонецЕсли;
	Для Индекс = 0 По Результат.ВГраница() Цикл
		Если Результат[Индекс] <> ОжидаемыйРезультат[Индекс] Тогда
			ВызватьИсключение "Неожиданные элементы в результате";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // Массив

#Область Соответствие

#КонецОбласти // Соответствие

#Область Структура

Процедура СтруктурыРавны() Экспорт

	ПерваяСтруктура = Новый Структура;
	ВтораяСтруктура = Новый Структура;

	Ожидаем
		.Что(Модуль.СтруктурыРавны(ПерваяСтруктура, ВтораяСтруктура), "Пустые структуры равны")
		.ЭтоИстина();

	ПерваяСтруктура.Вставить("Раз", 1);
	ПерваяСтруктура.Вставить("Два", 2);
	ПерваяСтруктура.Вставить("Три", 3);

	ВтораяСтруктура.Вставить("Раз", 1);
	ВтораяСтруктура.Вставить("Два", 2);
	ВтораяСтруктура.Вставить("Три", 3);

	Ожидаем
		.Что(Модуль.СтруктурыРавны(ПерваяСтруктура, ВтораяСтруктура), "Одинаковые структуры равны")
		.ЭтоИстина();

	ВтораяСтруктура.Очистить();
	ВтораяСтруктура.Вставить("Раз", 1);
	ВтораяСтруктура.Вставить("Два", 2);

	Ожидаем
		.Что(Модуль.СтруктурыРавны(ПерваяСтруктура, ВтораяСтруктура), "Разное количество элементов")
		.ЭтоЛожь();

	ВтораяСтруктура.Очистить();
	ВтораяСтруктура.Вставить("Раз", 1);
	ВтораяСтруктура.Вставить("Два", 2);
	ВтораяСтруктура.Вставить("Три", 3);
	ВтораяСтруктура.Вставить("Четыре", 4);

	Ожидаем
		.Что(Модуль.СтруктурыРавны(ПерваяСтруктура, ВтораяСтруктура), "Разное количество элементов")
		.ЭтоЛожь();
	
	
КонецПроцедуры // СтруктурыРавны()

#КонецОбласти // Структура


Процедура ПоменятьМестамиКлючиИЗначения() Экспорт

	// Структура:
	Коллекция = Новый Структура("Раз, Два, Три", "One", "Two", "Three");
	Референс = Новый Структура("One, Two, Three", "Раз", "Два", "Три");
	Результат = Модуль.ПоменятьМестамиКлючиИЗначения(Коллекция);
	Ожидаем
		.Что(Результат).ИмеетТип("Структура")
		.Заполнено()
		.Что(Результат.Количество()).Равно(Референс.Количество());
	Для каждого Элемент Из Референс Цикл
		Ожидаем
			.Что(Результат[Элемент.Ключ]).Равно(Референс[Элемент.Ключ]);
	КонецЦикла;

	// Соответствие:
	Коллекция = Новый Соответствие;
	Коллекция["Раз"] = "One";
	Коллекция["Два"] = "Two";
	Коллекция["Три"] = "Three";
	Референс = Новый Соответствие;
	Референс["One"] = "Раз";
	Референс["Two"] = "Два";
	Референс["Three"] = "Три";
	Результат = Модуль.ПоменятьМестамиКлючиИЗначения(Коллекция);
	Ожидаем
		.Что(Результат).ИмеетТип("Соответствие")
		.Заполнено()
		.Что(Результат.Количество()).Равно(Референс.Количество());
	Для каждого Элемент Из Референс Цикл
		Ожидаем
			.Что(Результат[Элемент.Ключ]).Равно(Референс[Элемент.Ключ]);
	КонецЦикла;
	
КонецПроцедуры // ПоменятьМестамиКлючиИЗначения()

Процедура СкопироватьКоллекцию() Экспорт

	ТестироватьТаблицуДерево = Истина;


	
КонецПроцедуры // СкопироватьКоллекцию()

Процедура СортироватьКоллекцию() Экспорт

	ИмяМетода = "СортироватьКоллекцию";

	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ИсходнаяТаблица = Новый ТаблицаЗначений;
	ИсходнаяТаблица.Колонки.Добавить("Поле1", ОписаниеТипаЧисло);
	ИсходнаяТаблица.Колонки.Добавить("Поле2", ОписаниеТипаЧисло);
	ИсходнаяТаблица.Колонки.Добавить("Поле3", ОписаниеТипаЧисло);

	ГСЧ = Новый ГенераторСлучайныхЧисел;
	Семя = ГСЧ.СлучайноеЧисло(1, 999);
	// Семя = 384;
	ГСЧ = Новый ГенераторСлучайныхЧисел(Семя);
	ЧислоСтрок = 1000;
	Для НомерСтроки = 1 По ЧислоСтрок Цикл
		НоваяСтрока = ИсходнаяТаблица.Добавить();
		НоваяСтрока[0] = ГСЧ.СлучайноеЧисло(0, 9);
		НоваяСтрока[1] = ГСЧ.СлучайноеЧисло(0, 9);
		НоваяСтрока[2] = ГСЧ.СлучайноеЧисло(0, 9);
	КонецЦикла;

	Поля = "Поле1, Поле2 Убыв, Поле3 Возр";
	Референс = ИсходнаяТаблица.Скопировать();
	Референс.Сортировать(Поля);
	Коллекция = ИсходнаяТаблица.Скопировать();
	Модуль.СортироватьКоллекцию(Коллекция, Поля);
	Для Индекс = 0 По Референс.Количество() - 1 Цикл
		Для каждого Колонка Из Референс.Колонки Цикл
			ИмяПоля = Колонка.Имя;
			ТекстСообщения = СтрШаблон(
				"Таблица значений отсортирована так же как методом Сортировать()
				|Индекс: %1
				|Поле: %2
				|Семя: %3",
				Индекс,
				ИмяПоля,
				Семя
			);
			Ожидаем
				.Что(Коллекция[Индекс][ИмяПоля], ТекстСообщения)
				.Равно(Референс[Индекс][ИмяПоля]);
		КонецЦикла;
	КонецЦикла;

	// Массив структур:
	Поля = "Поле1, Поле2 Убыв, Поле3 Возр";
	Референс = ИсходнаяТаблица.Скопировать();
	Референс.Сортировать(Поля);
	ПоляСтруктуры = Новый Массив;
	Для каждого Колонка Из ИсходнаяТаблица.Колонки Цикл
		ПоляСтруктуры.Добавить(Колонка.Имя);
	КонецЦикла;
	ПоляСтруктуры = СтрСоединить(ПоляСтруктуры, ", ");
	Коллекция = Новый Массив;
	Для каждого ТекущаяСтрока Из ИсходнаяТаблица Цикл
		ЭлементКоллекции = Новый Структура(ПоляСтруктуры);
		ЗаполнитьЗначенияСвойств(ЭлементКоллекции, ТекущаяСтрока);
		Коллекция.Добавить(ЭлементКоллекции);
	КонецЦикла;
	Модуль.СортироватьКоллекцию(Коллекция, Поля);
	Для Индекс = 0 По Референс.Количество() - 1 Цикл
		Для каждого Колонка Из Референс.Колонки Цикл
			ИмяПоля = Колонка.Имя;
			ТекстСообщения = СтрШаблон(
				"Массив структур отсортирован так же как методом ТаблицаЗанчений.Сортировать()
				|Индекс: %1
				|Поле: %2
				|Семя: %3",
				Индекс,
				ИмяПоля,
				Семя
			);
			Ожидаем
				.Что(Коллекция[Индекс][ИмяПоля], ТекстСообщения)
				.Равно(Референс[Индекс][ИмяПоля]);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры // СортироватьКоллекцию()

Процедура ВыгрузитьПолеКоллекции() Экспорт

	ИмяМетода = "ВыгрузитьПолеКоллекции";

	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Поле");

	ЧислоЭлементов = 42;
	Генератор = Новый ГенераторСлучайныхЧисел;
	Для НомерЭлемента = 1 По ЧислоЭлементов Цикл
		Таблица.Добавить().Поле = Генератор.СлучайноеЧисло(1, 99);
	КонецЦикла;

	Референс = Таблица.ВыгрузитьКолонку(0);
	Результат = Модуль.ВыгрузитьПолеКоллекции(Таблица, "Поле");
	Для Индекс = 0 По Референс.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], "Результат соответствует ТаблицаЗначений.ВыгрузитьКолонку()")
			.Равно(Референс[Индекс]);
	КонецЦикла;
	
КонецПроцедуры // ВыгрузитьПолеКоллекции()

Процедура НайтиЭлементыКоллекцииПоТипу() Экспорт

	#Область ИзвлечениеЗначенийПоТипу
	
	Коллекция = Новый Массив;
	Коллекция.Добавить(Неопределено);
	Коллекция.Добавить(Истина);
	Коллекция.Добавить(1);
	Коллекция.Добавить("два");
	Коллекция.Добавить('20030303');

	Тип = Тип("Число");

	ОжидаемыйРезультат = Новый Массив;
	ОжидаемыйРезультат.Добавить(1);

	Результат = Модуль.НайтиЭлементыКоллекцииПоТипу(Коллекция, Тип);
	Если ОжидаемыйРезультат.Количество() <> Результат.Количество() Тогда
		ВызватьИсключение "Неожиданные количество в результате";
	КонецЕсли;
	Для Индекс = 0 По Результат.ВГраница() Цикл
		Если Результат[Индекс] <> ОжидаемыйРезультат[Индекс] Тогда
			ВызватьИсключение "Неожиданные элементы в результате";
		КонецЕсли;
	КонецЦикла;

	#КонецОбласти // ИзвлечениеЗначенийПоТипу

	#Область ИзвлечениеЗначенийПоТипам
	
	Коллекция = Новый Массив;
	Коллекция.Добавить(Неопределено);
	Коллекция.Добавить(Истина);
	Коллекция.Добавить(1);
	Коллекция.Добавить("два");
	Коллекция.Добавить('20030303');

	Тип = Новый ОписаниеТипов("Строка, Число");

	ОжидаемыйРезультат = Новый Массив;
	ОжидаемыйРезультат.Добавить(1);
	ОжидаемыйРезультат.Добавить("два");

	Результат = Модуль.НайтиЭлементыКоллекцииПоТипу(Коллекция, Тип);
	Если ОжидаемыйРезультат.Количество() <> Результат.Количество() Тогда
		ВызватьИсключение "Неожиданные количество в результате";
	КонецЕсли;
	Для Индекс = 0 По Результат.ВГраница() Цикл
		Если Результат[Индекс] <> ОжидаемыйРезультат[Индекс] Тогда
			ВызватьИсключение "Неожиданные элементы в результате";
		КонецЕсли;
	КонецЦикла;

	#КонецОбласти // ИзвлечениеЗначенийПоТипам

	#Область ИзвлечениеЗначенийПоТипамСтрокой
	
	Коллекция = Новый Массив;
	Коллекция.Добавить(Неопределено);
	Коллекция.Добавить(Истина);
	Коллекция.Добавить(1);
	Коллекция.Добавить("два");
	Коллекция.Добавить('20030303');

	Тип = "Строка, Число";

	ОжидаемыйРезультат = Новый Массив;
	ОжидаемыйРезультат.Добавить(1);
	ОжидаемыйРезультат.Добавить("два");

	Результат = Модуль.НайтиЭлементыКоллекцииПоТипу(Коллекция, Тип);

	Если ОжидаемыйРезультат.Количество() <> Результат.Количество() Тогда
		ВызватьИсключение "Неожиданные количество в результате";
	КонецЕсли;
	Для Индекс = 0 По Результат.ВГраница() Цикл
		Если Результат[Индекс] <> ОжидаемыйРезультат[Индекс] Тогда
			ВызватьИсключение "Неожиданные элементы в результате";
		КонецЕсли;
	КонецЦикла;

	#КонецОбласти // ИзвлечениеЗначенийПоТипамСтрокой

КонецПроцедуры


#КонецОбласти // Коллекции

#Область Строка

#Область РимскийЛитерал

Процедура РимскийЛитерал() Экспорт
	
	// Ожидаем.Что(Модуль.РимскийЛитерал(0)).ВыбрасываетИсключение();
	Ожидаем.Что(Модуль.РимскийЛитерал(1)).Равно("Ⅰ");
	Ожидаем.Что(Модуль.РимскийЛитерал(2)).Равно("Ⅱ");
	Ожидаем.Что(Модуль.РимскийЛитерал(3)).Равно("Ⅲ");
	Ожидаем.Что(Модуль.РимскийЛитерал(4)).Равно("Ⅳ");
	Ожидаем.Что(Модуль.РимскийЛитерал(5)).Равно("Ⅴ");
	Ожидаем.Что(Модуль.РимскийЛитерал(6)).Равно("Ⅵ");
	Ожидаем.Что(Модуль.РимскийЛитерал(7)).Равно("Ⅶ");
	Ожидаем.Что(Модуль.РимскийЛитерал(8)).Равно("Ⅷ");
	Ожидаем.Что(Модуль.РимскийЛитерал(9)).Равно("Ⅸ");
	Ожидаем.Что(Модуль.РимскийЛитерал(10)).Равно("Ⅹ");
	Ожидаем.Что(Модуль.РимскийЛитерал(11)).Равно("Ⅺ");
	Ожидаем.Что(Модуль.РимскийЛитерал(12)).Равно("Ⅻ");
	//Ожидаем.Что(Модуль.РимскийЛитерал(13)).ВыбрасываетИсключение();
	//Ожидаем.Что(Модуль.РимскийЛитерал(Неопределено)).ВыбрасываетИсключение();

КонецПроцедуры

Процедура РимскийЛитерал_Исключения() Экспорт
	
	ИмяМетода = "РимскийЛитерал";
	Параметры = Модуль.МассивЗначений(0);
	Ожидаем.Что(Модуль, "Вызываем с параметром 0").Метод(ИмяМетода, Параметры).ВыбрасываетИсключение();

КонецПроцедуры // РимскийЛитерал_Исключения()

#КонецОбласти // РимскийЛитерал

#Область РимскоеЧисло

Процедура РимскоеЧисло_Простой() Экспорт

	Ожидаем.Что(Модуль.РимскоеЧисло(1)).Равно("I");
	Ожидаем.Что(Модуль.РимскоеЧисло(5)).Равно("V");
	Ожидаем.Что(Модуль.РимскоеЧисло(10)).Равно("X");
	Ожидаем.Что(Модуль.РимскоеЧисло(50)).Равно("L");
	Ожидаем.Что(Модуль.РимскоеЧисло(100)).Равно("C");
	Ожидаем.Что(Модуль.РимскоеЧисло(500)).Равно("D");
	Ожидаем.Что(Модуль.РимскоеЧисло(1000)).Равно("M");

	Ожидаем.Что(Модуль.РимскоеЧисло(1666)).Равно("MDCLXVI");
	
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 0)).Равно("CDXCIX");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 1)).Равно("LDVLIV");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 2)).Равно("XDIX");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 3)).Равно("VDIV");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 4)).Равно("ID");
	
	Ожидаем.Что(Модуль.РимскоеЧисло(1999, Истина)).Равно("MCMXCIX");
	Ожидаем.Что(Модуль.РимскоеЧисло(1999, Ложь)).Равно("MIM");
	
КонецПроцедуры

Процедура РимскоеЧисло_ПолнаяТаблица() Экспорт

	ТаблицаДляТеста = РимскоеЧисло_ПолнаяТаблицаИзФайла();

	Для каждого ТекущаяСтрока Из ТаблицаДляТеста Цикл
		Число = ТекущаяСтрока[0];
		Для Форма = 0 По 1 Цикл
			ОжидаемоеЗначение = ТекущаяСтрока[Форма + 1];
			Ожидаем.Что(Модуль.РимскоеЧисло(Число, Форма)).Равно(ОжидаемоеЗначение);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Функция РимскоеЧисло_ПолнаяТаблицаИзФайла()

	ПолноеИмяФайлаЧисел = ".\tests\assets\РимскиеЧисла.csv";

	Файл = Новый Файл(ПолноеИмяФайлаЧисел);
	Если Не Файл.Существует() Тогда
		ВызватьИсключение "Файл чисел не существует";
	КонецЕсли;

	// Файл - это CSV-таблица со строкой шапки из колонок:
	// Число;Римское0;Римское1;Римское2;Римское3;Римское4
	// где РимскоеN - это значение функции РИМСКОЕ(Число;N)

	ЧтениеТекста = Новый ЧтениеТекста;
	ЧтениеТекста.Открыть(ПолноеИмяФайлаЧисел);

	ТаблицаЧисел = Новый ТаблицаЗначений;
	ТаблицаЧисел.Колонки.Добавить("Число", Новый ОписаниеТипов("Число"));
	ТаблицаЧисел.Колонки.Добавить("Римское0", Новый ОписаниеТипов("Строка"));
	ТаблицаЧисел.Колонки.Добавить("Римское1", Новый ОписаниеТипов("Строка"));
	ТаблицаЧисел.Колонки.Добавить("Римское2", Новый ОписаниеТипов("Строка"));
	ТаблицаЧисел.Колонки.Добавить("Римское3", Новый ОписаниеТипов("Строка"));
	ТаблицаЧисел.Колонки.Добавить("Римское4", Новый ОписаниеТипов("Строка"));

	ЭтоСтрокаЗаголовка = Истина;
	Пока Истина Цикл
		ТекущаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
		Если ТекущаяСтрока = Неопределено Тогда
			Прервать;
		КонецЕсли;
		Если ЭтоСтрокаЗаголовка Тогда
			ЭтоСтрокаЗаголовка = Ложь;
			Продолжить;
		КонецЕсли;

		СоставСтроки = СтрРазделить(ТекущаяСтрока, ";");
		СтрокаЧисел = ТаблицаЧисел.Добавить();
		Для Индекс = 0 По 5 Цикл
			СтрокаЧисел[Индекс] = СоставСтроки[Индекс];
		КонецЦикла;
	КонецЦикла;

	ЧтениеТекста.Закрыть();

	Возврат ТаблицаЧисел;

КонецФункции // РимскоеЧисло_ПолнаяТаблицаИзФайла()

#КонецОбласти // РимскоеЧисло
	
Процедура ЧислоИзРимскогоЧисла() Экспорт

	#Область Простой
	
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("I")).Равно(1);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("V")).Равно(5);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("X")).Равно(10);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("L")).Равно(50);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("C")).Равно(100);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("D")).Равно(500);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("M")).Равно(1000);
	
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("MDCLXVI")).Равно(1666);

	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("CDXCIX"))	.Равно(499);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("LDVLIV"))	.Равно(499);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("XDIX"))	.Равно(499);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("VDIV"))	.Равно(499);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("ID"))		.Равно(499);
	
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("MCMXCIX"))	.Равно(1999);
	Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла("MIM"))		.Равно(1999);

	#КонецОбласти // Простой

	#Область Полный

	ТестироватьПолный = Ложь;
	Если ТестироватьПолный Тогда
		
		ТаблицаДляТеста = РимскоеЧисло_ПолнаяТаблицаИзФайла();

		Для каждого ТекущаяСтрока Из ТаблицаДляТеста Цикл
			ОжидаемоеЗначение = ТекущаяСтрока[0];
			Для Форма = 0 По 1 Цикл
				РимскоеЧисло = ТекущаяСтрока[Форма + 1];
				Ожидаем.Что(Модуль.ЧислоИзРимскогоЧисла(РимскоеЧисло)).Равно(ОжидаемоеЗначение);
			КонецЦикла;
		КонецЦикла;
	
	КонецЕсли;

	#КонецОбласти // Полный

КонецПроцедуры

#КонецОбласти // Строка


Процедура ОбратныйПорядок() Экспорт

	ЧтоПроверяем = "Обратный порядок по пустому масиву";
	Ожидаем.Что(Модуль.ОбратныйПорядок(Новый Массив), ЧтоПроверяем)
		.ИмеетТип("Массив")
		.Не_().Заполнено();

	ЧтоПроверяем = "Обратный порядок списка значений";
	ИсходнаяКоллекция = Новый СписокЗначений;
	ИсходнаяКоллекция.Добавить(1);
	ИсходнаяКоллекция.Добавить(Истина);
	ИсходнаяКоллекция.Добавить('20010101');
	Результат = Модуль.ОбратныйПорядок(ИсходнаяКоллекция);
	Ожидаем.Что(Результат, ЧтоПроверяем).ИмеетТип("Массив");
	Ожидаем.Что(Результат, ЧтоПроверяем).ИмеетДлину(3);
	Ожидаем.Что(Результат[0]).Равно(ИсходнаяКоллекция[2]);
	Ожидаем.Что(Результат[1]).Равно(ИсходнаяКоллекция[1]);
	Ожидаем.Что(Результат[2]).Равно(ИсходнаяКоллекция[0]);

КонецПроцедуры

Процедура ОбеспечитьСвойствоСтруктуры() Экспорт

	ИмяМетода = "ОбеспечитьСвойствоСтруктуры";
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(Неопределено, "Ключ");
	Ожидаем
		.Что(Модуль, "Исключение при неверном параметре")
		.Метод(ИмяМетода, Параметры)
		.ВыбрасываетИсключение();

	Структура = Новый Структура;
	Ключ = "Ключ";
	Значение = 123;
	
	Ожидаем
		.Что(Модуль.ОбеспечитьСвойствоСтруктуры(Структура, Ключ, Значение), "Вернется значение из параметра")
		.Равно(Значение);

	Структура = Новый Структура(Ключ, 456);
	Ключ = "Ключ";
	Значение = 123;
	Ожидаем
		.Что(Модуль.ОбеспечитьСвойствоСтруктуры(Структура, Ключ, Значение), "Вернется значение из структуры")
		.Равно(456);

	Структура = Новый Структура(Ключ, 456);
	Ключ = "ВложеннаяСтруктура";
	Значение = Новый Структура;
	Ожидаем
		.Что(Модуль.ОбеспечитьСвойствоСтруктуры(Структура, Ключ, Значение), "Вернется переданное значение")
		.Равно(Значение);
	
КонецПроцедуры // ОбеспечитьСвойствоСтруктуры

Процедура РаспределитьДатыПоХронологии() Экспорт
	
	ИмяМетода = "РаспределитьДатыПоХронологии";

	ТекстСообщения  = "Исключение на неожиданный параметр";
	ИсходныеДаты = Неопределено;
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(ИсходныеДаты);
	Ожидаем
		.Что(Модуль, ТекстСообщения)
		.Метод(ИмяМетода, Параметры)
		.ВыбрасываетИсключение();

	ТекстСообщения  = "Исключение на число в массиве";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20000101');
	ИсходныеДаты.Добавить(123456);
	ИсходныеДаты.Добавить('20000101');
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(ИсходныеДаты);
	Ожидаем
		.Что(Модуль, ТекстСообщения)
		.Метод(ИмяМетода, Параметры)
		.ВыбрасываетИсключение();

	ТекстСообщения  = "Пустой результат на пустой масив";
	ИсходныеДаты = Новый Массив;
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Ожидаем
		.Что(Результат, ТекстСообщения)
		.ИмеетТип("Массив")
		.Не_().Заполнено();

	ТекстСообщения  = "Проверяем изначально отсортированные даты";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить(НачалоГода(ТекущаяДата()) + 0);
	ИсходныеДаты.Добавить(НачалоГода(ТекущаяДата()) + 1);
	ИсходныеДаты.Добавить(НачалоГода(ТекущаяДата()) + 2);
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Для Индекс = 0 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Равно(ИсходныеДаты[Индекс]);
	КонецЦикла;
	
	ТекстСообщения  = "Простая перестановка одной даты";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить(НачалоГода(ТекущаяДата()) + 0);
	ИсходныеДаты.Добавить(НачалоГода(ТекущаяДата()) + 2);
	ИсходныеДаты.Добавить(НачалоГода(ТекущаяДата()) + 1);
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Для Индекс = 0 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[0], ТекстСообщения).Равно(ИсходныеДаты[0])
			.Что(Результат[1], ТекстСообщения).Равно(ИсходныеДаты[2])
			.Что(Результат[2], ТекстСообщения).Равно(ИсходныеДаты[1]);
	КонецЦикла;

	ТекстСообщения = "Большой массив одинаковых дат";
	РазмерМассива = 10000;
	ИсходныеДаты = Новый Массив;
	Дата = НачалоГода(ТекущаяДата());
	Для НомерЭлемента = 1 По РазмерМассива Цикл
		ИсходныеДаты.Добавить(Дата);
	КонецЦикла;
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Ожидаем.Что(Результат.Количество(), ТекстСообщения).Равно(ИсходныеДаты.Количество());
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения).Больше(Результат[Индекс - 1]);
	КонецЦикла;

	ТекстСообщения = "Большой массив случайных дат";
	РазмерМассива = 1000;
	ИсходныеДаты = Новый Массив;
	НачалоГода = НачалоГода(ТекущаяДата());
	Генератор = Новый ГенераторСлучайныхЧисел;
	КоличествоСекундВГоду = 365 * 24 * 60 * 60;
	Для НомерЭлемента = 1 По РазмерМассива Цикл
		ИсходныеДаты.Добавить(Дата + Генератор.СлучайноеЧисло(0, КоличествоСекундВГоду - 1));
	КонецЦикла;
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Ожидаем.Что(Результат.Количество(), ТекстСообщения).Равно(ИсходныеДаты.Количество());
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Больше(Результат[Индекс - 1]);
	КонецЦикла;

	ТекстСообщения  = "Слишком много дат на одну минуту";
	РазмерМассива = 99;
	ИсходныеДаты = Новый Массив;
	Дата = НачалоГода(ТекущаяДата());
	Для НомерЭлемента = 1 По РазмерМассива Цикл
		ИсходныеДаты.Добавить(Дата);
	КонецЦикла;
	Период = "Минута";
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(ИсходныеДаты, Период);
	ФрагментИсключения = "много дат";
	Ожидаем
		.Что(Модуль, ТекстСообщения)
		.Метод(ИмяМетода, Параметры)
		.ВыбрасываетИсключение(ФрагментИсключения);

	ТекстСообщения  = "Нужно разместить даты до закрытия дня со сдвигом назад, чтобы все попали в один день";
	РазмерМассива = 5;
	ИсходныеДаты = Новый Массив;
	Дата = Дата(2023, 12, 31, 23, 59, 59);
	Для НомерЭлемента = 1 По РазмерМассива Цикл
		ИсходныеДаты.Добавить(Дата);
	КонецЦикла;
	Период = "День";
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты, Период);
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.МеньшеИлиРавно(КонецДня(Дата));
	КонецЦикла;

	ТекстСообщения  = "Запрет перехода дат между периодами";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120102');
	ИсходныеДаты.Добавить('20120101');
	Период = "День";
	Параметры = ОбщегоНазначенияКлиентСервер.МассивЗначений(ИсходныеДаты, Период);
	ФрагментИсключения = "период";
	Ожидаем
		.Что(Модуль, ТекстСообщения)
		.Метод(ИмяМетода, Параметры)
		.ВыбрасываетИсключение(ФрагментИсключения);
	
	ТекстСообщения  = "Даты в разных периодах";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120101');
	ИсходныеДаты.Добавить('20120101');
	ИсходныеДаты.Добавить('20120102');
	ИсходныеДаты.Добавить('20120102');
	Период = "День";
	ОжидаемыйРезультат = Новый Массив;
	ОжидаемыйРезультат.Добавить(ИсходныеДаты[0] + 0);
	ОжидаемыйРезультат.Добавить(ИсходныеДаты[1] + 1);
	ОжидаемыйРезультат.Добавить(ИсходныеДаты[2] + 0);
	ОжидаемыйРезультат.Добавить(ИсходныеДаты[3] + 1);
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты, Период);
	Для Индекс = 0 По ОжидаемыйРезультат.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Равно(ОжидаемыйРезультат[Индекс]);
	КонецЦикла;

	ТекстСообщения  = "Первая дата максимальна, а последине две одинаковы";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120101120000'); // 12:00
	ИсходныеДаты.Добавить('20120101');
	ИсходныеДаты.Добавить('20120101');
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Больше(Результат[Индекс - 1]);
	КонецЦикла;

	ТекстСообщения  = "Максимальаня дата между минимальными";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120101');
	ИсходныеДаты.Добавить('20120101120000'); // 12:00
	ИсходныеДаты.Добавить('20120101');
	ИсходныеДаты.Добавить('20120101');
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Больше(Результат[Индекс - 1]);
	КонецЦикла;

	ТекстСообщения  = "Отсортированные примыкающие даты в разных периодах поменяться не должны";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120101' - 1);
	ИсходныеДаты.Добавить('20120101');
	Период = "День";
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты, Период);
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Равно(Результат[Индекс]);
	КонецЦикла;

	ТекстСообщения  = "Минимальная дата между Максимальными";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120101120000'); // 12:00
	ИсходныеДаты.Добавить('20120101');
	ИсходныеДаты.Добавить('20120101130000'); // 13:00
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты);
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Больше(Результат[Индекс - 1]);
	КонецЦикла;

	ТекстСообщения  = "Минимальная дата между Максимальными";
	ИсходныеДаты = Новый Массив;
	ИсходныеДаты.Добавить('20120101200001'); // 20:00:01
	ИсходныеДаты.Добавить('20120101000002');
	ИсходныеДаты.Добавить('20120101000003');
	ИсходныеДаты.Добавить('20120101000003');
	ИсходныеДаты.Добавить('20120101200000'); // 20:00
	ИсходныеДаты.Добавить('20120101230000'); // 23:00
	Период = "День";
	Результат = Модуль.РаспределитьДатыПоХронологии(ИсходныеДаты, Период);
	Для Индекс = 1 По ИсходныеДаты.ВГраница() Цикл
		Ожидаем
			.Что(Результат[Индекс], ТекстСообщения)
			.Больше(Результат[Индекс - 1]);
	КонецЦикла;

		
КонецПроцедуры // РаспределитьДатыПоХронологии

Процедура ЭтоВисокосныйГод() Экспорт
	
	Годы = Новый Соответствие;
	Годы[2001] = Ложь;
	Годы[2345] = Ложь;
	Годы['20240101'] = Истина;
	Годы[1700] = Ложь;
	Годы[1800] = Ложь;
	Годы[1900] = Ложь;
	Годы[2100] = Ложь;
	Годы[2200] = Ложь;
	Годы[2300] = Ложь;
	Годы[2500] = Ложь;
	Годы[2600] = Ложь;
	Годы[2600] = Ложь;
	Годы[1600] = Истина;
	Годы[2000] = Истина;
	Годы[2400] = Истина;

	ИмяМетода = "ЭтоВисокосныйГод";

	Для каждого ВариантГода Из Годы Цикл
		Год = ВариантГода.Ключ;
		Високосный = ВариантГода.Значение;
		ТекстСообщения = СтрШаблон(
			"Год %1 - %2",
			?(ТипЗнч(Год) = Тип("Число"), Год, Год(Год)),
			?(Високосный, "Високосный", "НЕ високосный")
		);
		Ожидаем
			.Что(Модуль.ЭтоВисокосныйГод(Год), ТекстСообщения).Равно(Високосный);
	КонецЦикла;

КонецПроцедуры

#Область Строка

Процедура СтрНайтиЦеликом() Экспорт
	
	ИмяМетода = "СтрНайтиЦеликом";

	КонтрольнаяФраза = 
	"Кроваво-черное ничто пустилось вить систему клеток, связанных внутри, клеток, связанных внутри, 
	|клеток в едином стебле и явственно, до жути на фоне тьмы ввысь белым бил фонтан.";
	
	Строка = "";
	ПодстрокаПоиска = "тест";
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска);
	Ожидаем
		.Что(Результат, "по пустой строке - пустой результат")
		.Равно(0);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "черное";
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска);
	Ожидаем
		.Что(Результат, "Находим ""черное"", отделенное дефисом")
		.Равно(СтрДлина("Кроваво-") + 1);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "систем";
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска);
	Ожидаем
		.Что(Результат, "Не находим ""систем"", оно часть слова ""систему""")
		.Равно(0);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "фонтан";
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска, НаправлениеПоиска.СКонца);
	Ожидаем
		.Что(Результат, "Находим ""фонтан"", с конца строки")
		.Больше(0);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "связанных внутри";
	НомерВхождения = 2;
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска, , НомерВхождения);
	Ожидаем
		.Что(Результат, "Находим второе вхождение ""связанных внутри""")
		.Больше(0);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "связанных внутри";
	НомерВхождения = 3;
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска, , , НомерВхождения);
	Ожидаем
		.Что(Результат, "Не находим третье вхождение ""связанных внутри""")
		.Равно(0);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "клеток";
	Направление = НаправлениеПоиска.СКонца;
	НомерВхождения = 3;
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска, Направление, , НомерВхождения);
	Ожидаем
		.Что(Результат, "Находим третье вхождение ""клеток"" с конца")
		.Больше(0);

	Строка = КонтрольнаяФраза;
	ПодстрокаПоиска = "клеток";
	НачальнаяПозиция = СтрНайти(Строка, ПодстрокаПоиска) + СтрДлина(ПодстрокаПоиска);
	НомерВхождения = 3;
	Результат = Модуль.СтрНайтиЦеликом(Строка, ПодстрокаПоиска, , НачальнаяПозиция, НомерВхождения);
	Ожидаем
		.Что(Результат, "Не находим третье вхождение ""клеток"", поскольку искали после первого вхождения")
		.Равно(0);
	
КонецПроцедуры

#КонецОбласти // Строка

#Область УникальныйИдентификатор

Процедура ЭтоУникальныйИдентификатор() Экспорт

	ВариантыПроверки = Новый Соответствие;

	КоличествоИдентификаторов = 100;
	Для НомерИдентификатора = 1 По КоличествоИдентификаторов Цикл
		ВариантыПроверки[Строка(Новый УникальныйИдентификатор())] = Истина;
	КонецЦикла;
	ВариантыПроверки["123e4567-e89b-12d3-a456-426655440000"] = Истина;
	ВариантыПроверки["123e4567-e89b-12d3-a45642665544-0000"] = Ложь;
	ВариантыПроверки["фффффффф-фффф-фффф-фффф-фффффффффффф"] = Ложь;
	ВариантыПроверки["123e4567-e89b-12d3-a456-42665544"] = Ложь;
	ВариантыПроверки["{123e4567-e89b-12d3-a456-426655440000}"] = Ложь;

	ДопускатьСкобки = Ложь;
	Для каждого ВариантПроверки Из ВариантыПроверки Цикл
		ТекстСообщения = СтрШаблон(
			"Строка ""%1"" - Это %2 (%3)", 
			ВариантПроверки.Ключ,
			?(ВариантПроверки.Значение, "УникальныйИдентификатор", ("НЕ УникальныйИдентфикатор")),
			?(ДопускатьСкобки, "со скобками", "без скобок")
		);
		Ожидаем
			.Что(Модуль.ЭтоУникальныйИдентификатор(ВариантПроверки.Ключ, ДопускатьСкобки), ТекстСообщения)
			.Равно(ВариантПроверки.Значение);
	КонецЦикла;

	#Область Скобки

	ДопускатьСкобки = Истина;
	ВариантыПроверки.Очистить();
	ВариантыПроверки["123e4567-e89b-12d3-a456-426655440000"] = Истина;
	ВариантыПроверки["{123e4567-e89b-12d3-a456-426655440000}"] = Истина;
	ВариантыПроверки["(123e4567-e89b-12d3-a456-426655440000)"] = Истина;
	ВариантыПроверки["(123e4567-e89b-12d3-a456-426655440000}"] = Ложь;
	ВариантыПроверки["({123e4567-e89b-12d3-a456-426655440000})"] = Ложь;
	ВариантыПроверки["{(123e4567-e89b-12d3-a456-426655440000)}"] = Ложь;
	ВариантыПроверки["[123e4567-e89b-12d3-a456-426655440000]"] = Ложь;
	ВариантыПроверки["123e4567-e89b-12{}-a456-426655440000"] = Ложь;
	ВариантыПроверки["{123e4567-e89b-12{}-a456-426655440000}"] = Ложь;

	Для каждого ВариантПроверки Из ВариантыПроверки Цикл
		ТекстСообщения = СтрШаблон(
			"Строка ""%1"" - Это %2 (%3)", 
			ВариантПроверки.Ключ,
			?(ВариантПроверки.Значение, "УникальныйИдентификатор", ("НЕ УникальныйИдентфикатор")),
			?(ДопускатьСкобки, "со скобками", "без скобок")
		);
		Ожидаем
			.Что(Модуль.ЭтоУникальныйИдентификатор(ВариантПроверки.Ключ, ДопускатьСкобки), ТекстСообщения)
			.Равно(ВариантПроверки.Значение);
	КонецЦикла;

	#КонецОбласти // Скобки

	
КонецПроцедуры

#КонецОбласти // УникальныйИдентификатор

ПередЗапускомТеста(); 

#Область РучноеВыполнение

#КонецОбласти // РучноеВыполнение
