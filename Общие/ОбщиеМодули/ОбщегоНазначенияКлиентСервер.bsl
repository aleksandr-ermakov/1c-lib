#Область КоллекцииДанных

// Получает коллекцию подчиненных элементов
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - ДанныеФормыКоллекцияЭлементовДерева, КоллекцияСтрокДереваЗначений
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьВетви(Узел)

	Возврат ?(ЭтоЭлементДереваФормы(Узел), Узел.ПолучитьЭлементы(), Узел.Строки)

КонецФункции // ПолучитьВетви()

// Проверяет, является ли Узел элементом древовидной коллекции
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция ЭтоУзелДерева(Узел)
	ЭтоУзелДерева = ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева");
	#Если Сервер Тогда
		ЭтоУзелДерева = ЭтоУзелДерева ИЛИ ТипЗнч(Узел) = Тип("СтрокаДереваЗначений");
	#КонецЕсли
	Возврат ЭтоУзелДерева
КонецФункции	// ЭтоУзелДерева()

// Проверяет, является ли Узел листом древовидной коллекции
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция ЭтоЛистДерева(Узел)

	Возврат ЭтоУзелДерева(Узел) и не ПолучитьВетви(Узел).Количество()

КонецФункции	// ЭтоЛистДерева()

// Проверяет, является ли Узел элементом древовидной коллекции формы
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция ЭтоЭлементДереваФормы(Узел)

	Возврат ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева")
		ИЛИ ТипЗнч(Узел) = Тип("ДанныеФормыДерево")

КонецФункции // ЭтоЭлементДереваФормы()

// Проверяет, является ли текущий узел ветвью дерева, в которую ещё не загружены дочерние элементы
//
// Параметры:
//  Узел - ДанныеФормыЭлементКоллекции	 -
//
// Возвращаемое значение:
//   - Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция ЭтоНезагруженнаяВетвьДереваФормы(Узел)

	Если ТипЗнч(Узел) <> Тип("ДанныеФормыДерево") И ТипЗнч(Узел) <> Тип("ДанныеФормыЭлементДерева")  Тогда Возврат Ложь КонецЕсли;
	Коллекция = Узел.ПолучитьЭлементы();
	Если Коллекция.Количество() <> 1  Тогда Возврат Ложь КонецЕсли;

	Возврат Коллекция[0].Служебная;

КонецФункции // ЭтоНезагруженнаяВетвьДереваФормы()

// Получает конечные элементы предоставленной коллекции
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений	 -
//
// Возвращаемое значение:
//   - Массив{ДанныеФормыЭлементДерева, СтрокаДереваЗначений}
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЛистьяДереваРекурсивно(Узел, Отбор = Неопределено)

	ВозвращаемоеЗначение = Новый Массив;
	Коллекция = ПолучитьВетви(Узел);
	Если Коллекция.Количество() Тогда
		Для каждого Ветвь Из Коллекция Цикл
			Для каждого Лист Из ПолучитьЛистьяДереваРекурсивно(Ветвь, Отбор) Цикл  ВозвращаемоеЗначение.Добавить(Лист) КонецЦикла;
		КонецЦикла;
	ИначеЕсли ЭтоУзелДерева(Узел) Тогда
		Если Отбор = Неопределено Тогда
			ВозвращаемоеЗначение.Добавить(Узел)
		Иначе
			УзелСоответстветОтбору = Истина;
			Для каждого Элемент Из Отбор Цикл
				Если Узел[Элемент.Ключ] <> Элемент.Значение Тогда
					УзелСоответстветОтбору = Ложь;
					Прервать
				КонецЕсли;
			КонецЦикла;
			Если УзелСоответстветОтбору Тогда
				ВозвращаемоеЗначение.Добавить(Узел)
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат ВозвращаемоеЗначение

КонецФункции // ПолучитьЛистьяДереваЗначенийРекурсивно()

// → ПолучитьПоляЛистьевДерева()
//  В качестве узла может быть передан адрес во временном хранилище
//
// Параметры:
//  Адрес			 - Строка	 - Адрес дерева во временном хранилище
//  Идентификатор	 - УникальныйИдентификатор	 - Используется, если в качеств
//  Поля			 - Строка	 -
//  Отбор			 - Структура	 -
//
// Возвращаемое значение:
//   - Массив
//
&НаСервереБезКонтекста
Функция ПолучитьПоляЛистьевДереваНаСервере(Адрес, Идентификатор = Неопределено, Поля = "Идентификатор", Отбор = Неопределено)

	ВозвращаемоеЗначение = Новый Массив;

	Если ЭтоАдресВременногоХранилища(Адрес) Тогда
		ДеревоДанных = ПолучитьИзВременногоХранилища(Адрес);
		Если ДеревоДанных = Неопределено Тогда Возврат ВозвращаемоеЗначение КонецЕсли;
		Если Идентификатор = Неопределено Тогда
			ВозвращаемоеЗначение = ПолучитьПоляЛистьевДерева(ДеревоДанных, Поля, Отбор);
		Иначе
			Узел = ДеревоДанных.Строки.Найти(Идентификатор, "Идентификатор", Истина);
			Если Узел <> Неопределено Тогда
				ВозвращаемоеЗначение = ПолучитьПоляЛистьевДерева(Узел, Поля, Отбор);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;

КонецФункции // ПолучитьПоляЛистьевДереваНаСервере()

// Получает поля листьев дерева
//
// Параметры:
//  Узел						 - ДанныеФормыДерево, ДанныеФормыЭлементДерева	 -
//  Поля						 - Строка										 - Имена полей
//  Отбор						 - Структура									 - Какие элементы опрашиваются
//
// Возвращаемое значение:
//  Массив - Структуры данных
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПоляЛистьевДерева(Узел, Поля = "", Отбор = Неопределено)

	ЕстьОтбор = Отбор <> Неопределено;

	КоллекцияДанных = Новый Массив;
	КоллекцияПодчиненных = ПолучитьВетви(Узел);

	Листья = ?(ЕстьОтбор, КоллекцияПодчиненных.НайтиСтроки(Отбор, Истина), ПолучитьЛистьяДереваРекурсивно(Узел));

	Для каждого Лист Из Листья Цикл
		Если ЕстьОтбор И не ЭтоЛистДерева(Лист) Тогда Продолжить КонецЕсли;	// По отбору могут быть подобраны узлы, имеющие подчиненные элементы.
		СтруктураДанных = Новый Структура(Поля);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Лист);
		КоллекцияДанных.Добавить(СтруктураДанных);
	КонецЦикла;

	Возврат КоллекцияДанных;

КонецФункции // ПолучитьПоляЛистьевДерева()

// → ПолучитьПоляДанныхДереваРекурсивно()
// В качестве узла может быть передан адрес во временном хранилище
//
&НаСервереБезКонтекста
Функция ПолучитьПоляДанныхДереваНаСервере(Узел, Поля = "Идентификатор", Отбор = Неопределено)

	Если ЭтоАдресВременногоХранилища(Строка(Узел)) Тогда
		ДеревоДанных = ПолучитьИзВременногоХранилища(Узел);
		Возврат ПолучитьПоляДанныхДереваРекурсивно(ДеревоДанных, Поля, Отбор);
	КонецЕсли;

	Возврат ПолучитьПоляДанныхДереваРекурсивно(Узел, Поля, Отбор);

КонецФункции // ПолучитьПоляДанныхДереваНаСервере()

// Получает поля элементов дерева
//
// Параметры:
//  Узел						 - ДанныеФормыДерево, ДанныеФормыЭлементДерева	 -
//  Поля						 - Строка										 - Имена полей
//  Отбор						 - Структура									 - Какие элементы опрашиваются
//
// Возвращаемое значение:
//  Массив - Структуры данных
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПоляДанныхДереваРекурсивно(Узел, Поля = "Идентификатор, ИдентификаторСтроки", Отбор = Неопределено)

	КоллекцияДанных = Новый Массив;

	Если ЭтоУзелДерева(Узел) и ЭлементСоответствуетОтбору(Узел, Отбор) Тогда
		СтруктураДанных = Новый Структура(Поля);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Узел);
		Если СтруктураДанных.Свойство("ИдентификаторСтроки") и ЭтоЭлементДереваФормы(Узел) Тогда
			СтруктураДанных.ИдентификаторСтроки = Узел.ПолучитьИдентификатор();
		КонецЕсли;
		КоллекцияДанных.Добавить(СтруктураДанных);
	КонецЕсли;

	Коллекция = ПолучитьВетви(Узел);

	Для каждого Ветвь Из Коллекция Цикл
		ДанныеПодчиненных = ПолучитьПоляДанныхДереваРекурсивно(Ветвь, Поля, Отбор);
		Для каждого СтруктураДанных Из ДанныеПодчиненных Цикл
			КоллекцияДанных.Добавить(СтруктураДанных);
		КонецЦикла;
	КонецЦикла;

	Возврат КоллекцияДанных;

КонецФункции // ПолучитьПоляДанныхДереваРекурсивно()

// Получает поля элементов дерева в иерархическом виде
//
// Параметры:
//  Узел						 - ДанныеФормыДерево, ДанныеФормыЭлементДерева	 -
//  Поля						 - Строка										 - Имена полей
//  ИмяКоллекцииВложенныхСтрок	 - Строка										 - Имя массива вложенных строк
//
// Возвращаемое значение:
//  Структура{[ИмяПоля], ИмяКоллекцииВложенныхСтрок} данных
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПоляДанныхДереваФормыИерархическиРекурсивно(Узел, Поля = "Идентификатор, ИдентификаторСтроки", ИмяКоллекцииВложенныхСтрок = "Строки", ИсключаяСлужебные = Истина)

	СтруктураДанных = Новый Структура(Поля);

	Если ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева") Тогда
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Узел);
		Если СтруктураДанных.Свойство("ИдентификаторСтроки") Тогда
			СтруктураДанных.ИдентификаторСтроки = Узел.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	СтруктураДанных.Вставить(ИмяКоллекцииВложенныхСтрок, Новый Массив);

	Для каждого Ветвь Из Узел.ПолучитьЭлементы() Цикл
		Если ИсключаяСлужебные и Ветвь.Служебная Тогда Продолжить КонецЕсли;
		СтруктураДанных[ИмяКоллекцииВложенныхСтрок].Добавить(ПолучитьПоляДанныхДереваФормыИерархическиРекурсивно(Ветвь, Поля, ИмяКоллекцииВложенныхСтрок));
	КонецЦикла;

	Возврат СтруктураДанных;

КонецФункции // ПолучитьПоляДанныхДереваФормыИерархическиРекурсивно()

#Область ДеревоЗначений

#КонецОбласти	// ДеревоЗначений

#Область Массив

// Преобразует коллекцию в двумерный массив (массив массивов)
//
// Параметры:
//  ИсходнаяКоллекция		 - Произвольный	 - Любая коллекция, доступная для обхода "Для каждого ... Цикл". 
//  РазмерВложенногоМассива	 - Число		 - Максимальное количество элементов вложенного массива.
// 
// Возвращаемое значение:
//  Массив - Результирующий массив.
//
Функция ДвумерныйМассив(Знач ИсходнаяКоллекция, Знач РазмерВложенногоМассива = 1)
	
	МаксИндексВложенногоМассива = РазмерВложенногоМассива - 1;
	ДвумерныйМассив = Новый Массив;
	ИндексВложенногоМассива = -1;
	Для каждого ТекущийЭлемент Из ИсходнаяКоллекция Цикл
		ИндексВложенногоМассива = ИндексВложенногоМассива + 1;
		Если ИндексВложенногоМассива > МаксИндексВложенногоМассива Тогда ИндексВложенногоМассива = 0 КонецЕсли; 
		Если ИндексВложенногоМассива = 0 Тогда
			ВложенныйМассив = Новый Массив;
			ДвумерныйМассив.Добавить(ВложенныйМассив);
		КонецЕсли; 
		ВложенныйМассив.Добавить(ТекущийЭлемент);
	КонецЦикла;
	
	Возврат ДвумерныйМассив;
	
КонецФункции

#КонецОбласти	// Массив

#Область КэшИдентификаторов

// Производит поиск по идентификатору с учетом кэша
//
// Параметры:
//  Идентификатор			 - УникальныйИдентификатор	 - Соответствует идентификатору реестра
//  ИспользоватьКэш			 - Булево							 -
//  ПродолжитьПоискВнеКэша	 - Булево							 -
//
// Возвращаемое значение:
//  ДанныеФормыЭлементКоллекции, Неопределено - Элемент реестра платежей
//
&НаКлиенте
Функция НайтиСтрокуРеестраПоИдентификатору(Идентификатор, ИспользоватьКэш = Истина, ПродолжитьПоискВнеКэша = Истина)

	Реестр = РеестрРаспоряжений;
	Позиция = Неопределено;

	Если ИспользоватьКэш Тогда

		ИдентификаторСтроки = Неопределено;
		СтрокиКэша = КэшИдентификаторовРеестра.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
		Если ЗначениеЗаполнено(СтрокиКэша) Тогда
			ИдентификаторСтроки = СтрокиКэша[0].ИдентификаторСтроки
		КонецЕсли;

		Если ИдентификаторСтроки = Неопределено Тогда // Промах по кэшу
			Если ПродолжитьПоискВнеКэша Тогда
				ИдентификаторыСтрок = НайтиСтрокиДереваФормы(Реестр, Новый Структура("Идентификатор", Идентификатор), Истина);
				Если ЗначениеЗаполнено(ИдентификаторыСтрок) Тогда
					ИдентификаторСтроки = ИдентификаторыСтрок[0];
					КэшироватьИдентификатор(ИдентификаторСтроки, Идентификатор);
					Позиция = Реестр.НайтиПоИдентификатору(ИдентификаторыСтрок[0]);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Позиция = Реестр.НайтиПоИдентификатору(ИдентификаторСтроки);
			Если Позиция = Неопределено Тогда	// Кэш врёт
				ОчиститьКэшИдентификаторов();
				Позиция = НайтиСтрокуРеестраПоИдентификатору(Идентификатор, ИспользоватьКэш, Истина)	// При пустом кэше будет поиск по дереву
			КонецЕсли;
		КонецЕсли;

	Иначе

		Позиции = НайтиСтрокиДереваФормы(Реестр, Новый Структура("Идентификатор", Идентификатор), Истина);
		Если ЗначениеЗаполнено(Позиции) Тогда Позиция = Реестр.НайтиПоИдентификатору(Позиции[0]) КонецЕсли;

	КонецЕсли;

	Возврат Позиция

КонецФункции // НайтиСтрокуРеестраПоИдентификатору()

// Получает итог по колонке таблицы с приминением отбора.
//
// Параметры:
//  ТаблицаЗначений	 - ТаблицаЗначений	 - Исходная таблица.
//  ПараметрыОтбора	 - Структура		 - Отбор строк, по которым будет подсчитан итог.
//  Ресурс			 - Строка			 - Имя колонки итога.
// 
// Возвращаемое значение:
//   - Число   - Полученный итог
//
&НаСервереБезКонтекста
Функция ИтогТаблицыЗначенийПоОтбору(ТаблицаЗначений, ПараметрыОтбора, Ресурс)

	Возврат ТаблицаЗначений.Скопировать(ПараметрыОтбора, Ресурс).Итог(Ресурс);

КонецФункции // ИтогТаблицыЗначенийПоОтбору()

// Получает итоги по колонкам таблицы с приминением отбора.
//
// Параметры:
//  ТаблицаЗначений	 - ТаблицаЗначений	 - Исходная таблица.
//  ПараметрыОтбора	 - Структура		 - Отбор строк, по которым будут подсчитаны итоги.
//  Ресурсы			 - Строка			 - Имена колонок итога.
// 
// Возвращаемое значение:
//   - Структура   - Полученные итоги. Ключ: Имя колонки, Значение: Число.
//
&НаСервереБезКонтекста
Функция ИтогиТаблицыЗначенийПоОтбору(ТаблицаЗначений, ПараметрыОтбора, Ресурсы)

	Итоги = Новый Структура(Ресурсы);
	ТаблицаИтогов = ТаблицаЗначений.Скопировать(ПараметрыОтбора, Ресурсы);
	ТаблицаИтогов.Свернуть(, Ресурсы);
	Если ЗначениеЗаполнено(ТаблицаИтогов) Тогда
		ЗаполнитьЗначенияСвойств(Итоги, ТаблицаИтогов[0]);
	Иначе
		Для каждого Элемент Из Итоги Цикл
			Элемент.Значение = 0;
		КонецЦикла;  	
	КонецЕсли; 
	
	Возврат Итоги;

КонецФункции // ИтогиТаблицыЗначенийПоОтбору()

#КонецОбласти	// КоллекцииДанных

#Область ТекстЗапросаОтбораКомпоновкиДанных

// Формирует отбор в формате языка запросов по отбору СКД
//
// Параметры:
//  Узел				 - ОтборКомпоновкиДанных, ГруппаЭлементовОтбораКомпоновкиДанных, ЭлементОтбораКомпоновкиДанных	 - Текущий узел обхода.
//  КомпоновщикНастроек	 - КомпоновщикНастроекКомпоновкиДанных															 - Компоновщик текущей схемы
//  ПараметрыЗапроса	 - Структура																					 - Содержит параметры, которые необходимо передать в запрос
//  ПрефиксПоляДанных	 - Строка																						 - Префикс, который будет использоваться в тексте запроса для обозначения поля данных
//
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьТекстЗапросаОтбораКомпоновкиДанных(Узел, КомпоновщикНастроек, ПараметрыЗапроса, ПрефиксПоляДанных = "#") Экспорт

	ТекстОтбора = "";

	Если (ТипЗнч(Узел) = Тип("ЭлементОтбораКомпоновкиДанных") ИЛИ ТипЗнч(Узел) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных"))
		И НЕ Узел.Использование Тогда
		Возврат ТекстОтбора;
	КонецЕсли;

	Если ТипЗнч(Узел) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда

		ТекстОтбора = ПолучитьТекстЗапросаЭлементаОтбораКомпоновкиДанных(Узел, КомпоновщикНастроек, ПараметрыЗапроса, ПрефиксПоляДанных);

	ИначеЕсли ТипЗнч(Узел) = Тип("ОтборКомпоновкиДанных") ИЛИ ТипЗнч(Узел) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда

		ЛогическийПрефикс	= "";
		ЛогическаяОперация	= "И";
		Если ТипЗнч(Узел) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если  Узел.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда
				ЛогическаяОперация = "ИЛИ";
			ИначеЕсли Узел.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
				ЛогическийПрефикс	= "НЕ";
				ЛогическаяОперация	= "И";
			Иначе
				ЛогическаяОперация = "И";
			КонецЕсли;
		КонецЕсли;

		ЭтоСоставнойОператор = Узел.Элементы.Количество() > 1;
		Для каждого Элемент Из Узел.Элементы Цикл
			ТекстПодчиненногоОтбора = ПолучитьТекстЗапросаОтбораКомпоновкиДанных(Элемент, КомпоновщикНастроек, ПараметрыЗапроса, ПрефиксПоляДанных);
			Если ЗначениеЗаполнено(ТекстПодчиненногоОтбора) Тогда
				ТекстОтбора = ТекстОтбора
				+ ?(ЗначениеЗаполнено(ТекстОтбора), Символы.ПС + ЛогическаяОперация + " ", "")
				+ ?(ЭтоСоставнойОператор, "(", "")
				+ ТекстПодчиненногоОтбора
				+ ?(ЭтоСоставнойОператор, ")", "");
			КонецЕсли;
		КонецЦикла;

		Если ЗначениеЗаполнено(ЛогическийПрефикс) Тогда
			ТекстОтбора = СтрШаблон("%1 (%2)", ЛогическийПрефикс, ТекстОтбора);
		КонецЕсли;

	КонецЕсли;

	Возврат ТекстОтбора;

КонецФункции

// Получает представление конечного эдемента отбора компоновки данных в формате языка запросов
//
// Параметры:
//  ЭлементОтбора		 - ЭлементОтбораКомпоновкиДанных		 - Элемент, который будет преобразовн
//  КомпоновщикНастроек	 - КомпоновщикНастроекКомпоновкиДанных	 - Связанынй компоновщик настроек
//  ПараметрыЗапроса	 - Структура							 - Содержит параметры, которые необходимо передать в запрос
//  ПрефиксПоляДанных	 - Строка								 - Префикс, который будет использоваться в тексте запроса для обозначения поля данных
//
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьТекстЗапросаЭлементаОтбораКомпоновкиДанных(ЭлементОтбора, КомпоновщикНастроек, ПараметрыЗапроса, ПрефиксПоляДанных)

	Виды = ВидСравненияКомпоновкиДанных;
	ПрефиксОтрицания = "НЕ ";
	ОперацииСравнения = Новый Соответствие;
	ОперацииСравнения.Вставить(Виды.Равно,					"=");
	ОперацииСравнения.Вставить(Виды.НеРавно,				ПрефиксОтрицания + "=");
	ОперацииСравнения.Вставить(Виды.Меньше,					"<");
	ОперацииСравнения.Вставить(Виды.МеньшеИлиРавно,			"<=");
	ОперацииСравнения.Вставить(Виды.Больше,					">");
	ОперацииСравнения.Вставить(Виды.БольшеИлиРавно,			">=");
	ОперацииСравнения.Вставить(Виды.ВСписке,				"В");
	ОперацииСравнения.Вставить(Виды.ВСпискеПоИерархии,		"В ИЕРАРХИИ");
	ОперацииСравнения.Вставить(Виды.ВИерархии,				"В ИЕРАРХИИ");
	ОперацииСравнения.Вставить(Виды.НеВСписке,				ПрефиксОтрицания + "В");
	ОперацииСравнения.Вставить(Виды.НеВСпискеПоИерархии,	ПрефиксОтрицания + "В ИЕРАРХИИ");
	ОперацииСравнения.Вставить(Виды.НеВИерархии,			ПрефиксОтрицания + "В ИЕРАРХИИ");
	// Подобия:
	ОперацииСравнения.Вставить(Виды.Подобно,				"ПОДОБНО");
	ОперацииСравнения.Вставить(Виды.НачинаетсяС,			"ПОДОБНО");
	ОперацииСравнения.Вставить(Виды.Содержит,				"ПОДОБНО");
	ОперацииСравнения.Вставить(Виды.НеПодобно,				ПрефиксОтрицания + "ПОДОБНО");
	ОперацииСравнения.Вставить(Виды.НеНачинаетсяС,			ПрефиксОтрицания + "ПОДОБНО");
	ОперацииСравнения.Вставить(Виды.НеСодержит,				ПрефиксОтрицания + "ПОДОБНО");
	// Хитрые операции:
	ОперацииСравнения.Вставить(Виды.Заполнено,				ПрефиксОтрицания + "В");	// В качестве аргумента будут пустые значения
	ОперацииСравнения.Вставить(Виды.НеЗаполнено,			"В");

	ТипыКоллекций = Новый Массив;
	ТипыКоллекций.Добавить(Тип("СписокЗначений"));
	ТипыКоллекций.Добавить(Тип("Массив"));
	ТипыКоллекций.Добавить(Тип("ФиксированныйМассив"));

	ОперацияСравнения = ОперацииСравнения.Получить(ЭлементОтбора.ВидСравнения);
	Если ОперацияСравнения <> Неопределено Тогда

		ЭтоОтрицание = СтрНачинаетсяС(ОперацияСравнения, ПрефиксОтрицания);
		Если ЭтоОтрицание Тогда
			ОперацияСравнения = Прав(ОперацияСравнения, СтрДлина(ОперацияСравнения) - СтрДлина(ПрефиксОтрицания));
		КонецЕсли;

		ТекстШаблона = "%1 %2 %3";

		ЛевоеЗначениеЭтоМножество	= ТипыКоллекций.Найти(ТипЗнч(ЭлементОтбора.ЛевоеЗначение)) <> Неопределено;
		ПравоеЗначениеЭтоМножество	= ТипыКоллекций.Найти(ТипЗнч(ЭлементОтбора.ПравоеЗначение)) <> Неопределено ИЛИ Найти(ОперацияСравнения, "В");
		Если ЛевоеЗначениеЭтоМножество Тогда ТекстШаблона = СтрЗаменить(ТекстШаблона, "%1", "(%1)") КонецЕсли;
		Если ПравоеЗначениеЭтоМножество Тогда ТекстШаблона = СтрЗаменить(ТекстШаблона, "%3", "(%3)") КонецЕсли;

		ЛевоеПредставление	= ПолучитьПредставлениеПоляДляТекстаЗапроса(ЭлементОтбора.ЛевоеЗначение, ПараметрыЗапроса, ПрефиксПоляДанных);
		Если ЭлементОтбора.ВидСравнения = Виды.Заполнено ИЛИ ЭлементОтбора.ВидСравнения = Виды.НеЗаполнено Тогда
			//Найдём доступное поле:
			ДоступноеПоле = Неопределено;
			КоллекцияДоступныхПолей = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы;
			ДоступноеПоле = НайтиДоступноеПолеКомпоновкиДанных(ЭлементОтбора.ЛевоеЗначение, КоллекцияДоступныхПолей);
			Если ДоступноеПоле <> Неопределено Тогда
				ПравоеПредставление	= ПолучитьПредставлениеПоляДляТекстаЗапроса(ДоступноеПоле, ПараметрыЗапроса, ПрефиксПоляДанных);
			Иначе	// Нет доступного поля, действуем по резервному сценарию - берём поле из правого значения
				ПравоеПредставление	= ПолучитьПредставлениеПоляДляТекстаЗапроса(ЭлементОтбора.ПравоеЗначение, ПараметрыЗапроса, ПрефиксПоляДанных);
			КонецЕсли;
		Иначе
			ПравоеПредставление	= ПолучитьПредставлениеПоляДляТекстаЗапроса(ЭлементОтбора.ПравоеЗначение, ПараметрыЗапроса, ПрефиксПоляДанных);
		КонецЕсли;

		// Подобия:
		Если ЭлементОтбора.ВидСравнения = Виды.НачинаетсяС Тогда
			ПравоеПредставление = Лев(ПравоеПредставление, СтрДлина(ПравоеПредставление) - 1) + "%""";	// В аргумент % справа внутрь скобок
		КонецЕсли;
		Если ЭлементОтбора.ВидСравнения = Виды.Содержит Тогда
			ПравоеПредставление = """%" + Сред(ПравоеПредставление, 2, СтрДлина(ПравоеПредставление) - 2) + "%""";	// В аргумент % слева и справа внутрь скобок
		КонецЕсли;

		ТекстОтбора = СтрШаблон(ТекстШаблона, ЛевоеПредставление, ОперацияСравнения, ПравоеПредставление);

		Если ЭтоОтрицание Тогда
			ТекстОтбора = ПрефиксОтрицания + ТекстОтбора;
		КонецЕсли;
	КонецЕсли;

	Возврат ТекстОтбора;

КонецФункции // ПолучитьТекстЗапросаЭлементаОтбораКомпоновкиДанных()

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
		Возврат СтрШаблон("ДАТАВРЕМЯ(%1, %2, %3, %4, %5, %6)", Формат(Год(Поле.Дата), "ЧГ=0"), Месяц(Поле.Дата), День(Поле.Дата), Час(Поле.Дата), Минута(Поле.Дата), Секунда(Поле.Дата));
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

// Производит поиск доступного поля компоновки данных
//
// Параметры:
//  Поле					 - ПолеКомпоновкиДанных, Строка				 - Например, "Контрагент.ИНН"
//  КоллекцияДоступныхПолей	 - КоллекцияДоступныхПолейКомпоновкиДанных	 - Коллекция, в которой будет осуществлён поиск
//
// Возвращаемое значение:
//   - ДоступноеПолеКомпоновкиДанных, ДоступноеПолеОтбораКомпоновкиДанных, Неопределено   - Найденное поле
//
Функция НайтиДоступноеПолеКомпоновкиДанных(Знач Поле, Знач КоллекцияДоступныхПолей)

	ОчередьПолей = Новый Массив;
	Поле = Строка(Поле);
	Пока Истина Цикл
		ОчередьПолей.Вставить(0, Поле);
		ПозицияТочки = СтрНайти(Поле, ".", НаправлениеПоиска.СКонца);
		Если ПозицияТочки = 0 Тогда Прервать КонецЕсли;
		Поле = Лев(Поле, ПозицияТочки - 1);
	КонецЦикла;
	ДоступноеПоле = Неопределено;

	Для каждого Поле Из ОчередьПолей Цикл
		ДоступноеПоле = КоллекцияДоступныхПолей.Найти(Поле);
		Если ДоступноеПоле = Неопределено Тогда
			Прервать;
		КонецЕсли;
		КоллекцияДоступныхПолей = ДоступноеПоле.Элементы;
	КонецЦикла;

	Возврат ДоступноеПоле;

КонецФункции // НайтиДоступноеПолеКомпоновкиДанных()

#КонецОбласти	// ТекстЗапросаОтбораКомпоновкиДанных

// Производит заполнение шаблона со строковыми параметрами
//
// Параметры:
//  Шаблон		 - Строка	 - Строка вида "Параметр %Параметр% содержит значение %Значение%"
//  Поля		 - Структура - Структурам с именами параметров и текстом, который надо подставить в шаблон. Наример: Новый Структура("Параметр, Значение", "Цвет", "Красный")
//  ПрефиксПоля	 - Строка	 - Префикс поля в шаблоне
//  СуффиксПоля	 - Строка	 - Суффикс поля в шаблоне
// 
// Возвращаемое значение:
//  Строка - Шаблон с подставленными параметрами
//
Функция ЗаполнитьПоляШаблона(Шаблон, Поля, ПрефиксПоля = "%", СуффиксПоля = "%") Экспорт

	Результат = Шаблон;
	Для каждого Поле Из Поля Цикл
		Результат = СтрЗаменить(Результат, ПрефиксПоля + Поле.Ключ + СуффиксПоля, Поле.Значение);
	КонецЦикла; 
	
	Возврат Результат;

КонецФункции // ЗаполнитьПоляШаблона()

// Делит разыменование поля на составляющие с неполными путями
// Пример: Разыменование вида Поле1.Поле2.Поле3 будет разложено на массив вида [Поле1, Поле1.Поле2, Поле1.Поле2.Поле3]
//
// Параметры:
//  Разыменование	 - Строка	 - Делимое разыменование
// 
// Возвращаемое значение:
//  Массив - Элемент: Строка
//
Функция РазделитьРазыменованиеНаНеполныеПути(Знач Разыменование)

	МассивПолей	= СтрРазделить(Разыменование, ".");
	МассивПутей = Новый Массив;
	Для Индекс = 0 по МассивПолей.ВГраница() Цикл
		НеполныйПуть = Новый Массив;
		Для НеполныйИндекс = 0 По Индекс Цикл
			НеполныйПуть.Добавить(МассивПолей[НеполныйИндекс]);
		КонецЦикла; 		
		МассивПутей.Добавить(СтрСоединить(НеполныйПуть, "."));
	КонецЦикла; 
	
	Возврат МассивПутей;	

КонецФункции // РазделитьРазыменованиеНаНеполныеПути()

// Проверяет элемент данных на соответствие отбору.
//
// Параметры:
//  Элемент	 - Произвольный				 - Произвольная коллекция, к которой возможно обращение по имени поля. Например, СтрокаДереваЗначений.
//  Отбор	 - Структура, Неопределено	 - Накладываемый отбор. Поля отбора должны присутствовать в проверяемом элементе. Если Неопределено - элемент считается соответствующим отбору.
// 
// Возвращаемое значение:
//  Булево - Истина, если элемент соответствет отбору или отбор не определён
//
Функция ЭлементСоответствуетОтбору(Знач Элемент, Знач Отбор)

	Если Отбор = Неопределено Тогда Возврат Истина КонецЕсли; 
	
	Для каждого ЭлементОтбора Из Отбор Цикл
		Если Элемент[ЭлементОтбора.Ключ] <> ЭлементОтбора.Значение Тогда Возврат Ложь КонецЕсли 
	КонецЦикла; 

	Возврат Истина
	
КонецФункции // ЭлементСоответствуетОтбору()

// Выполняет транслитерацию строки.
// см. https://ru.wikipedia.org/wiki/Транслитерация_русского_алфавита_латиницей
//
// Параметры:
//  Фраза	 - Строка	 - Исходная строка
//  Стандарт - Строка	 - Стандарт транслитерации. Варианты:
//		* 4271	 - Приказ МИД N 4271 (2016–н/в) (см. http://www.consultant.ru/document/cons_doc_LAW_198429/c956ff01bf42465d7052431dec215b77d0404875)
//		* 310	 - Приказ МВД N 310 (1997–2010)
// 
// Возвращаемое значение:
//  Строка - Результат транслитерации
//
Функция ТранслитерироватьСтроку(Знач Фраза, Стандарт = "4271")
	
	// Контрольный пример: абвгдеёжзийклмнопрстуфхцчшщъыьэюя. Съешь этих мягких французских булочек, да выпей же чаю. ВЕРХНИЙРЕГИСТР, Перваязаглавная, нижнийрегистр, СмешанныйРегистр. Слова123с5434Цифрами.и_$ЗНАКАМИ%вперемешку.
	
	ФразаЛатиницей = "";
	
	СоответствиеБукв = Новый Соответствие;
	#Область ОбщиеДляВсехСтандартовСимволы
	
	// Те символы, которые различаются в стандартах - не заполнены
	СоответствиеБукв.Вставить("а", "a");
	СоответствиеБукв.Вставить("б", "b");
	СоответствиеБукв.Вставить("в", "v");
	СоответствиеБукв.Вставить("г", "g");
	СоответствиеБукв.Вставить("д", "d");
	СоответствиеБукв.Вставить("е", "");
	СоответствиеБукв.Вставить("ё", "");
	СоответствиеБукв.Вставить("ж", "");
	СоответствиеБукв.Вставить("з", "z");
	СоответствиеБукв.Вставить("и", "");
	СоответствиеБукв.Вставить("й", "");
	СоответствиеБукв.Вставить("к", "k");
	СоответствиеБукв.Вставить("л", "l");
	СоответствиеБукв.Вставить("м", "m");
	СоответствиеБукв.Вставить("н", "n");
	СоответствиеБукв.Вставить("о", "o");
	СоответствиеБукв.Вставить("п", "p");
	СоответствиеБукв.Вставить("р", "r");
	СоответствиеБукв.Вставить("с", "s");
	СоответствиеБукв.Вставить("т", "t");
	СоответствиеБукв.Вставить("у", "u");
	СоответствиеБукв.Вставить("ф", "f");
	СоответствиеБукв.Вставить("х", "");
	СоответствиеБукв.Вставить("ц", "");
	СоответствиеБукв.Вставить("ч", "");
	СоответствиеБукв.Вставить("ш", "");
	СоответствиеБукв.Вставить("щ", "");
	СоответствиеБукв.Вставить("ъ", "");
	СоответствиеБукв.Вставить("ы", "");
	СоответствиеБукв.Вставить("ь", "");
	СоответствиеБукв.Вставить("э", "");
	СоответствиеБукв.Вставить("ю", "");
	СоответствиеБукв.Вставить("я", "");
	
	// Буквы-исключения: Е, Ё, Ж, И, Й, Х, Ц, Ч, Ш, Щ, Ъ, Ы, Ь, Э, Ю, Я.
	БуквыИсключения = СтрРазделить("е, ё, ж, и, й, х, ц, ч, ш, щ, ъ, ы, ь, э, ю, я", ", ", Ложь);
	Для каждого ТекущийСимвол Из БуквыИсключения Цикл
		СоответствиеБукв.Вставить(ТекущийСимвол, "");
	КонецЦикла; 
	
	#КонецОбласти // ОбщиеДляВсехСтандартовСимволы 
	
	#Область ОписаниеСтандартов
	Если Стандарт = "4271" Тогда
		
		СоответствиеБукв.Вставить("е", "e");
		СоответствиеБукв.Вставить("ё", "e");
		СоответствиеБукв.Вставить("ж", "zh");
		СоответствиеБукв.Вставить("и", "i");
		СоответствиеБукв.Вставить("й", "i");
		СоответствиеБукв.Вставить("х", "kh");
		СоответствиеБукв.Вставить("ц", "ts");
		СоответствиеБукв.Вставить("ч", "ch");
		СоответствиеБукв.Вставить("ш", "sh");
		СоответствиеБукв.Вставить("щ", "shch");
		СоответствиеБукв.Вставить("ъ", "ie");
		СоответствиеБукв.Вставить("ы", "y");
		СоответствиеБукв.Вставить("ь", ""); // пропускается
		СоответствиеБукв.Вставить("э", "e");
		СоответствиеБукв.Вставить("ю", "iu");
		СоответствиеБукв.Вставить("я", "ia");		
		
	ИначеЕсли Стандарт = "310" Тогда
		
		// см. СтроковыеФункцииКлиентСервер.СоответствиеКириллицыИЛатиницы() 
		// или СтроковыеФункцииКлиентСервер.СоответствиеНациональногоАлфавитаИЛатиницы() (БСП)
		СоответствиеБукв.Вставить("е", "e");
		СоответствиеБукв.Вставить("ё", "e");
		СоответствиеБукв.Вставить("ж", "zh");
		СоответствиеБукв.Вставить("и", "i");
		СоответствиеБукв.Вставить("й", "y");
		СоответствиеБукв.Вставить("х", "kh");
		СоответствиеБукв.Вставить("ц", "ts");
		СоответствиеБукв.Вставить("ч", "ch");
		СоответствиеБукв.Вставить("ш", "sh");
		СоответствиеБукв.Вставить("щ", "shch");
		СоответствиеБукв.Вставить("ъ", """");
		СоответствиеБукв.Вставить("ы", "y");
		СоответствиеБукв.Вставить("ь", ""); // пропускается
		СоответствиеБукв.Вставить("э", "e");
		СоответствиеБукв.Вставить("ю", "yu");
		СоответствиеБукв.Вставить("я", "ya");	
		
	Иначе 
		
		Возврат "";
		
	КонецЕсли; 
	#КонецОбласти // ОписаниеСтандартов 
	
	ПредыдущийСимвол = "";
	
	Слово = "";
	СловоЛатиницей = "";
	ДлинаСтроки = СтрДлина(Фраза);
	Для Позиция = 1 По ДлинаСтроки Цикл
		
		ТекущийСимвол = Сред(Фраза, Позиция, 1);
		
		ЭтоБуква = СоответствиеБукв[НРег(ТекущийСимвол)] <> Неопределено;
		
		Если ЭтоБуква Тогда
			
			Буква = ТекущийСимвол;
			БукваЛатиницей = СоответствиеБукв[НРег(ТекущийСимвол)]; // Поиск соответствия без учета регистра.
			Если Буква = ВРег(Буква) Тогда
				БукваЛатиницей = ТРег(БукваЛатиницей);			
			КонецЕсли; 
			
			Слово = Слово + Буква;
			СловоЛатиницей = СловоЛатиницей + БукваЛатиницей;			
		
		КонецЕсли; 
		
		СловоЗакончилось = ЗначениеЗаполнено(Слово) и (не ЭтоБуква или Позиция = ДлинаСтроки);
		
		Если СловоЗакончилось Тогда
			
			Если Слово = Врег(Слово) Тогда
				СловоЛатиницей = ВРег(СловоЛатиницей);
			ИначеЕсли Слово = НРег(Слово) Тогда
				СловоЛатиницей = НРег(СловоЛатиницей);
			ИначеЕсли Слово = ТРег(Слово) Тогда
				СловоЛатиницей = ТРег(СловоЛатиницей);
			КонецЕсли; 
			ФразаЛатиницей = ФразаЛатиницей + СловоЛатиницей;	
			
			Слово = "";
			СловоЛатиницей = "";
		
		КонецЕсли; 
		
		Если не ЭтоБуква Тогда
		
			ФразаЛатиницей = ФразаЛатиницей + ТекущийСимвол;
		
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат ФразаЛатиницей;
	
КонецФункции
