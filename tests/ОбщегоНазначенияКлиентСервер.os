// BSLLS-off

#Использовать asserts


Перем ЮнитТестирование;
Перем Данные;
Перем Модуль;

Процедура ПодключитьМодульДляТестирования()
	
	Контекст = Новый Структура;
	Модуль = ЗагрузитьСценарий(
		".\Общие\ОбщиеМодули\ОбщегоНазначения\ОбщегоНазначенияКлиентСервер.bsl", 
		Контекст
	);

КонецПроцедуры

// основной метод для тестирования
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

	ВсеТесты = Новый Массив;
	
	#Область НайтиЭлементыКоллекцииПоТипу
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипу");
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипам");
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипамСтрокой");
	#КонецОбласти // НайтиЭлементыКоллекцииПоТипу

	#Область ПересечениеМассивов
	ВсеТесты.Добавить("ПересечениеМассивов");
	#КонецОбласти // ПересечениеМассивов
	
	#Область ЕстьПересечениеМассивов
	ВсеТесты.Добавить("ЕстьПересечениеМассивов");
	#КонецОбласти // ЕстьПересечениеМассивов

	#Область МассивИзЗначения
	ВсеТесты.Добавить("МассивИзЗначения");
	#КонецОбласти // МассивИзЗначения
	
	#Область МассивПоЗначениям
	ВсеТесты.Добавить("МассивПоЗначениям_Пустой");
	ВсеТесты.Добавить("МассивПоЗначениям_Простой");
	ВсеТесты.Добавить("МассивПоЗначениям_Дырка");
	#КонецОбласти // МассивПоЗначениям

	ВсеТесты.Добавить("РимскийЛитерал");

	#Область РимскоеЧисло
	ВсеТесты.Добавить("РимскоеЧисло_Числа");
	#КонецОбласти // РимскоеЧисло

	Возврат ВсеТесты;

КонецФункции

#Область НайтиЭлементыКоллекцииПоТипу

Процедура НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипу() Экспорт

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

КонецПроцедуры

Процедура НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипам() Экспорт

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

КонецПроцедуры

Процедура НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипамСтрокой() Экспорт

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

КонецПроцедуры


#КонецОбласти // НайтиЭлементыКоллекцииПоТипу

#Область ПересечениеМассивов

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

#КонецОбласти // ПересечениеМассивов

#Область ЕстьПересечениеМассивов

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

#КонецОбласти // ЕстьПересечениеМассивов

#Область МассивИзЗначения

Процедура МассивИзЗначения() Экспорт
	
	Значение = Новый УникальныйИдентификатор;
	Результат = Модуль.МассивИзЗначения(Значение);
	Ожидаем.Что(Результат).ИмеетТип("Массив").ИмеетДлину(1);
	Ожидаем.Что(Результат[0]).Равно(Значение);

КонецПроцедуры

#КонецОбласти // МассивИзЗначения

#Область МассивПоЗначениям

Процедура МассивПоЗначениям_Пустой() Экспорт

	Результат = Модуль.МассивПоЗначениям();
	Ожидаем.Что(Результат).ИмеетТип("Массив").НЕ_().Заполнено();
	
КонецПроцедуры

Процедура МассивПоЗначениям_Простой() Экспорт

	Результат = Модуль.МассивПоЗначениям(1, 2, 3);
	Ожидаем.Что(Результат).ИмеетТип("Массив").Заполнено().ИмеетДлину(3);
	Ожидаем.Что(Результат[0]).Равно(1);
	Ожидаем.Что(Результат[1]).Равно(2);
	Ожидаем.Что(Результат[2]).Равно(3);
	
КонецПроцедуры

Процедура МассивПоЗначениям_Дырка() Экспорт

	// Первый Null должен попасть в массив, второй - нет.

	Результат = Модуль.МассивПоЗначениям(1, Null, 3, Null);
	Ожидаем.Что(Результат).ИмеетТип("Массив").Заполнено().ИмеетДлину(3);
	Ожидаем.Что(Результат[0]).Равно(1);
	Ожидаем.Что(Результат[1]).Равно(Null);
	Ожидаем.Что(Результат[2]).Равно(3);
	
КонецПроцедуры

#КонецОбласти // МассивПоЗначениям

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

#КонецОбласти // РимскийЛитерал

#Область РимскоеЧисло

Процедура РимскоеЧисло_Числа() Экспорт

	Ожидаем.Что(Модуль.РимскоеЧисло(1)).Равно("I");
	Ожидаем.Что(Модуль.РимскоеЧисло(5)).Равно("V");
	Ожидаем.Что(Модуль.РимскоеЧисло(10)).Равно("X");
	Ожидаем.Что(Модуль.РимскоеЧисло(50)).Равно("L");
	Ожидаем.Что(Модуль.РимскоеЧисло(100)).Равно("C");
	Ожидаем.Что(Модуль.РимскоеЧисло(500)).Равно("D");
	Ожидаем.Что(Модуль.РимскоеЧисло(1000)).Равно("M");
	
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 0)).Равно("CDXCIX");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 1)).Равно("LDVLIV");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 2)).Равно("XDIX");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 3)).Равно("VDIV");
	Ожидаем.Что(Модуль.РимскоеЧисло(499, 4)).Равно("ID");
	
	Ожидаем.Что(Модуль.РимскоеЧисло(1999, Истина)).Равно("MCMXCIX");
	Ожидаем.Что(Модуль.РимскоеЧисло(1999, Ложь)).Равно("MIM");
	

КонецПроцедуры

#КонецОбласти // РимскоеЧисло

ПодключитьМодульДляТестирования();

// МассивПоЗначениям_Простой();