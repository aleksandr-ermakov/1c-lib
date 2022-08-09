// BSLLS-off

#Использовать asserts


Перем ЮнитТестирование;
Перем Данные;
Перем Модуль;

// основной метод для тестирования
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	Контекст = Новый Структура;
	Модуль = ЗагрузитьСценарий(
		".\Общие\ОбщиеМодули\ОбщегоНазначения\ОбщегоНазначенияКлиентСервер.bsl", 
		Контекст
	);

	ВсеТесты = Новый Массив;
	
	#Область НайтиЭлементыКоллекцииПоТипу
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипу");
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипам");
	ВсеТесты.Добавить("НайтиЭлементыКоллекцииПоТипу_ИзвлечениеЗначенийПоТипамСтрокой");
	#КонецОбласти // НайтиЭлементыКоллекцииПоТипу
	
	Возврат ВсеТесты;

КонецФункции

#Область ИмяМетода

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


#КонецОбласти // ИмяМетода

