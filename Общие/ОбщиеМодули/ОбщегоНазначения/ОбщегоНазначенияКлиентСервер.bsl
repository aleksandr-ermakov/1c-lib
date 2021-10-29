
#Область ПримитивныеТипы

// Разбивает заданный период на нериоды с заданной периодичностью
//
// Параметры:
//	Период	 - СтандартныйПериод - Разделяемый период
//	Периодичность	 - Строка - Вид периода. 
//		Возможные значения:
//		* Минута
//		* Час
//		* День
//		* Неделя
//		* Месяц
//		* Год
//
// Возвращаемое значение:
//	Массив - Массив периодов в результате разделения. Элемент: СтандартныйПериод
//
// Пример:
//	РазделитьНаПериоды(Новый СтандартныйПериод(ВариантСтандартногоПериода.ЭтотКвартал), "Месяц"); // Вернёт массив стандартных периодов - месяцов квартала
//
Функция РазделитьНаПериоды(Период, Периодичность = "Месяц")

	НачалоТекущегоПериода	 = '00010101';
	НачалоПоследнегоПериода	 = '00010101';

	Если Периодичность = "Минута" Тогда
		НачалоТекущегоПериода	 = НачалоМинуты(Период.ДатаНачала);
		НачалоПоследнегоПериода	 = НачалоМинуты(Период.ДатаОкончания);
	ИначеЕсли Периодичность = "Час" Тогда
		НачалоТекущегоПериода	 = НачалоЧаса(Период.ДатаНачала);
		НачалоПоследнегоПериода	 = НачалоЧаса(Период.ДатаОкончания);
	ИначеЕсли Периодичность = "День" Тогда
		НачалоТекущегоПериода	 = НачалоДня(Период.ДатаНачала);
		НачалоПоследнегоПериода	 = НачалоДня(Период.ДатаОкончания);
	ИначеЕсли Периодичность = "Неделя" Тогда
		НачалоТекущегоПериода	 = НачалоНедели(Период.ДатаНачала);
		НачалоПоследнегоПериода	 = НачалоНедели(Период.ДатаОкончания);
	ИначеЕсли Периодичность = "Месяц" Тогда
		НачалоТекущегоПериода	 = НачалоМесяца(Период.ДатаНачала);
		НачалоПоследнегоПериода	 = НачалоМесяца(Период.ДатаОкончания);
	ИначеЕсли Периодичность = "Год" Тогда
		НачалоТекущегоПериода	 = НачалоГода(Период.ДатаНачала);
		НачалоПоследнегоПериода	 = НачалоГода(Период.ДатаОкончания);
	Иначе
		ВызватьИсключение "Неверно указан период";
	КонецЕсли;

	Периоды = Новый Массив;

	Пока НачалоТекущегоПериода <= НачалоПоследнегоПериода Цикл

		Если Периодичность = "Минута" Тогда
			КонецТекущегоПериода = КонецМинуты(НачалоТекущегоПериода);
		ИначеЕсли Периодичность = "Час" Тогда
			КонецТекущегоПериода = КонецЧаса(НачалоТекущегоПериода);
		ИначеЕсли Периодичность = "День" Тогда
			КонецТекущегоПериода = КонецДня(НачалоТекущегоПериода);
		ИначеЕсли Периодичность = "Неделя" Тогда
			КонецТекущегоПериода = КонецНедели(НачалоТекущегоПериода);
		ИначеЕсли Периодичность = "Месяц" Тогда
			КонецТекущегоПериода = КонецМесяца(НачалоТекущегоПериода);
		ИначеЕсли Периодичность = "Год" Тогда
			КонецТекущегоПериода = КонецГода(НачалоТекущегоПериода);
		Иначе
			ВызватьИсключение "Что-то пошло не так";
		КонецЕсли;

		ТекущийПериод = Новый СтандартныйПериод(
			Макс(НачалоТекущегоПериода,	 Период.ДатаНачала),
			Мин(КонецТекущегоПериода,	 Период.ДатаОкончания)
		);
		Периоды.Добавить(ТекущийПериод);

		НачалоТекущегоПериода = КонецТекущегоПериода + 1;
			
	КонецЦикла;
	
	Возврат Периоды;

КонецФункции // РазделитьНаПериоды()

#КонецОбласти // ПримитивныеТипы

// Работает аналогично ЗаполнитьЗначенияСвойств(),
// но позволяет поменять имена свойств приёмника.
// Служит для того, когда имена свойств источника и приёмника отличаются
//
// Параметры:
//	Источник			 - Произвольный - Объект-источник.
//	Приемник			 - Произвольный - Объект-приемник.
//	СвойстваИсточника	 - Строка - Перечень имён свойств источника.
//	СвойстваИсточника	 - Строка - Перечень имён свойств приемника.
//	ПереноситьПрочие	 - Булево - Переносить свойства с именами, не указанными в СвойстваИсточника.
//	ИсключаяСвойства	 - Строка - Имена свойств, которые переносить не следует. 
//									Используется, если ПереноситьПрочие = Истина.
//
// Пример:
//	Источник = Новый Структура("Раз, Два, Три, Четыре, Пять", 1, 2, 3, 4, 5);
//	Приемник = Новый Структура("Раз, Два, Три, Четыре, Пять");
//	ПеренестиЗначенияСвойств(
//		Источник,
//		Приемник,
//		"Раз, Два, Три",
//		"Раз, Три, Два",
//		Истина,
//		"Пять");	// Приемник станет Структура("Раз, Два, Три, Четыре, Пять", 1, 3, 2, 4, Неопределено)
//
Процедура ПеренестиЗначенияСвойств(Источник, Приемник, СвойстваИсточника = "", СвойстваПриемника = "", ПереноситьПрочие = Ложь, ИсключаяСвойства = "")
	
	Если Не ЗначениеЗаполнено(СвойстваИсточника)
		И Не ЗначениеЗаполнено(СвойстваПриемника)
		И Не ПереноситьПрочие Тогда
		Возврат;
	КонецЕсли;

	КлючиИсточника = СтрРазделить(СвойстваИсточника, ", ", Ложь);
	КлючиПриемника = СтрРазделить(СвойстваИсточника, ", ", Ложь);

	Если КлючиИсточника.Количество() <> КлючиПриемника.Количество() Тогда
		ВызватьИсключение "Различается количество указанных ключей источника и приемника";
	КонецЕсли;

	Если ПереноситьПрочие Тогда

		// Для ситуаций, когда ключи источника присутствуют в приемнике,
		// но значения этих ключей переносятся на другие позиции,
		// что избежать изменения значения этих ключей,
		// Мы резервируем ключи Приемника, которые присутствуют в Источнике.
		ЗначенияПриемникаРезерв	 = Новый Структура;
		Для каждого Ключ Из КлючиИсточника Цикл
			ЗначенияПриемникаРезерв.Вставить(Ключ);
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(ЗначенияПриемникаРезерв, Приемник);
		ЗаполнитьЗначенияСвойств(Приемник, Источник, , ИсключаяСвойства);
		ЗаполнитьЗначенияСвойств(Приемник, ЗначенияПриемникаРезерв);

	КонецЕсли;

	Если ЗначениеЗаполнено(КлючиИсточника) Тогда
		Для Индекс = 0 По СвойстваИсточника.ВГраница() Цикл
			Приемник[КлючиПриемника[Индекс]] = Источник[КлючиИсточника[Индекс]];
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#Область Коллекции

#Область ДревовидныеКоллекции

// Получает коллекцию подчиненных элементов
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - ДанныеФормыКоллекцияЭлементовДерева, КоллекцияСтрокДереваЗначений
//
Функция ПолучитьВетви(Узел)

	ЭтоЭлементДереваФормы = ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева")
		Или ТипЗнч(Узел) = Тип("ДанныеФормыДерево");
		
	Возврат ?(ЭтоЭлементДереваФормы, Узел.ПолучитьЭлементы(), Узел.Строки)

КонецФункции // ПолучитьВетви()

// Проверяет, является ли Узел элементом древовидной коллекции
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - Булево
//
Функция ЭтоУзелДерева(Узел)
	ЭтоУзелДерева = ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева");
	#Если Сервер Тогда
		ЭтоУзелДерева = ЭтоУзелДерева ИЛИ ТипЗнч(Узел) = Тип("СтрокаДереваЗначений");
	#КонецЕсли
	Возврат ЭтоУзелДерева;
КонецФункции	// ЭтоУзелДерева()

// Проверяет, является ли Узел листом древовидной коллекции
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, Произвольный - Узел дерева
//
// Возвращаемое значение:
//   Булево - Признак того что проверяемый узел не имеет дочерних узлов.
//
Функция ЭтоЛистДерева(Узел)

	Если ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева") Тогда
		Возврат Не ЗначениеЗаполнено(Узел.ПолучитьЭлементы());
	КонецЕсли;

	#Если Сервер Тогда
	Если ТипЗнч(Узел) = Тип("СтрокаДереваЗначений") Тогда
		Возврат Не ЗначениеЗаполнено(Узел.Строки);
	КонецЕсли;
	#КонецЕсли

	Возврат Ложь;

КонецФункции	// ЭтоЛистДерева()

// Проверяет, является ли Узел элементом древовидной коллекции формы
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений - Узел или корень дерева
//
// Возвращаемое значение:
//   - Булево
//
Функция ЭтоЭлементДереваФормы(Узел)

	Возврат ТипЗнч(Узел) = Тип("ДанныеФормыЭлементДерева")
		ИЛИ ТипЗнч(Узел) = Тип("ДанныеФормыДерево")

КонецФункции // ЭтоЭлементДереваФормы()

// Получает конечные элементы предоставленной коллекции
//
// Параметры:
//  Узел - ДанныеФормыДерево, ДанныеФормыЭлементДерева, ДеревоЗначений, СтрокаДереваЗначений	 -
//
// Возвращаемое значение:
//   - Массив{ДанныеФормыЭлементДерева, СтрокаДереваЗначений}
//
Функция ПолучитьЛистьяДереваРекурсивно(Узел, Отбор = Неопределено)

	ВозвращаемоеЗначение = Новый Массив;
	Коллекция = ПолучитьВетви(Узел);
	Если ЗначениеЗаполнено(Коллекция) Тогда
		Для каждого Ветвь Из Коллекция Цикл
			Для каждого Лист Из ПолучитьЛистьяДереваРекурсивно(Ветвь, Отбор) Цикл 
				ВозвращаемоеЗначение.Добавить(Лист);
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли ЭтоУзелДерева(Узел) Тогда
		Если Отбор = Неопределено Тогда
			ВозвращаемоеЗначение.Добавить(Узел)
		Иначе
			УзелСоответстветОтбору = Истина;
			Для каждого Элемент Из Отбор Цикл
				Если Узел[Элемент.Ключ] <> Элемент.Значение Тогда
					УзелСоответстветОтбору = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если УзелСоответстветОтбору Тогда
				ВозвращаемоеЗначение.Добавить(Узел);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ВызватьИсключение "Что-то пошло не так.";
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;

КонецФункции // ПолучитьЛистьяДереваЗначенийРекурсивно()

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
Функция ПолучитьПоляЛистьевДерева(Узел, Поля = "", Отбор = Неопределено)

	ЕстьОтбор = Отбор <> Неопределено;

	КоллекцияДанных = Новый Массив;
	КоллекцияПодчиненных = ПолучитьВетви(Узел);

	Листья = ?(ЕстьОтбор, КоллекцияПодчиненных.НайтиСтроки(Отбор, Истина), ПолучитьЛистьяДереваРекурсивно(Узел));

	Для каждого Лист Из Листья Цикл
		Если ЕстьОтбор И Не ЭтоЛистДерева(Лист) Тогда 
			Продолжить; 
		КонецЕсли;	// По отбору могут быть подобраны узлы, имеющие подчиненные элементы.
		СтруктураДанных = Новый Структура(Поля);
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Лист);
		КоллекцияДанных.Добавить(СтруктураДанных);
	КонецЦикла;

	Возврат КоллекцияДанных;

КонецФункции // ПолучитьПоляЛистьевДерева()

// Получает поля элементов дерева
//
// Параметры:
//  Узел						 - ДанныеФормыДерево, ДанныеФормыЭлементДерева	 -
//  Поля						 - Строка										 - Имена полей, через запятую
//  Отбор						 - Структура									 - Какие элементы опрашиваются
//
// Возвращаемое значение:
//  Массив - Структуры данных
//
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

#КонецОбласти // ДревовидныеКоллекции

#Область ТаблицаЗначений

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

#КонецОбласти // ТаблицаЗначений

#Область ДеревоЗначений

#КонецОбласти	// ДеревоЗначений

#Область Массив

// Удаляет незаполненные значения из массива.
// Заполненность значений проверяется методом ЗначениеЗаполнено()
// 
// Параметры:
//	Массив				 - Массив из Произвольный - Массив элементов.
//	ИгнорируемыеЗначения - Массив из Произвольный - Значения, которые следует оставить при проверке
//
Процедура УдалитьНезаполненныеЗначенияМассива(Массив, Знач ИгнорируемыеЗначения = Неопределено)

	Если ИгнорируемыеЗначения = Неопределено Тогда
		ИгнорируемыеЗначения = Новый Массив;
	КонецЕсли;

	Для ДопИндекс = - Массив.ВГраница() По 0 Цикл

		Индекс = - ДопИндекс;
		ЭлементМассива = Массив[Индекс];
		Если Не ЗначениеЗаполнено(ЭлементМассива) 
			И ИгнорируемыеЗначения.Найти(ЭлементМассива) = Неопределено Тогда

			Массив.Удалить(Индекс);

		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры // УдалитьНезаполненныеЗначенияМассива()

// Преобразует коллекцию в двумерный массив (массив массивов)
//
// Параметры:
//  ИсходнаяКоллекция		 - Произвольный	 - Любая коллекция, доступная для обхода "Для каждого ... Цикл". 
//  РазмерВложенногоМассива	 - Число		 - Максимальное количество элементов вложенного массива.
// 
// Возвращаемое значение:
//  Массив - Результирующий массив.
//
Функция ДвумерныйМассивИзКоллекции(Знач ИсходнаяКоллекция, Знач РазмерВложенногоМассива = 1)
	
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
	
КонецФункции // ДвумерныйМассивИзКоллекции

// Вырезает элементы из массива, и на их место вставляет новые элементы.
//
// Параметры:
//  Массив				 - Массив	 - Массив, из которого вырезаются/вставляются элементы.
//  Индекс				 - Число	 - Индекс первого удаляемого элемента, а также вставки элементов.
//  КоличествоУдаляемых	 - Число	 - Количество удаляемых элементов массива.
//  Вставка				 - Массив, Произвольный	 - Вставляемые элементы. 
//										Если указано значение типа, отличного от Массив, оно будет вставлено по указанонму указанному индексу.
//										Если требуется вставить Массив или Неопределено в качестве элемента - следует передать его в качестве вложенного в массив.
// 
// Возвращаемое значение:
//  Массив - Удаленные элементы
//
Функция СраститьМассив(Массив, Индекс = 0, КоличествоУдаляемых = 0, Вставка = Неопределено)

	Удаленные = Новый Массив;
	ОсталосьУдалить = КоличествоУдаляемых;
	
	Пока ОсталосьУдалить Цикл
		Удаленные.Добавить(Массив[Индекс]);
		Массив.Удалить(Индекс);
		ОсталосьУдалить = ОсталосьУдалить - 1;
	КонецЦикла;   
	
	Если Вставка <> Неопределено Тогда
	
		Если ТипЗнч(Вставка) = Тип("Массив") Тогда
			Для каждого Элемент Из Вставка Цикл
				Массив.Вставить(Индекс, Элемент);	
			КонецЦикла; 	
		Иначе
			Массив.Вставить(Индекс, Вставка);	
		КонецЕсли; 
	
	КонецЕсли; 
	
	Возврат Удаленные;

КонецФункции // СраститьМассив()

#КонецОбласти	// Массив

// Нумерует элементы коллекции
//
// Параметры:
//	Коллекция		 - Произвольный	 - Коллекция для обработки
//	ИмяПоляНомер	 - Строка		 - Имя поля или колонки, содержащей номер
//	НачальныйНомер	 - Число		 - Номер пермого элемента в коллекции
//
Процедура ПронумероватьКоллекцию(Коллекция, ИмяПоляНомер, НачальныйНомер = 1)

	НомерЭлемента = НачальныйНомер - 1;
	Для каждого ЭлементКоллекции Из Коллекция Цикл
		НомерЭлемента = НомерЭлемента + 1;
		ЭлементКоллекции[ИмяПоляНомер] = НомерЭлемента;
	КонецЦикла;

КонецПроцедуры // ПронумероватьКоллекцию()

#КонецОбласти	// Коллекции

// Производит заполнение шаблона со строковыми параметрами
//
// Параметры:
//  Шаблон		 - Строка	 - Строка вида "Параметр %Параметр% содержит значение %Значение%"
//  Поля		 - Структура - Структурам с именами параметров и текстом, который надо подставить в шаблон. Например: Новый Структура("Параметр, Значение", "Цвет", "Красный")
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
// Пример: 
//	Разыменование вида Поле1.Поле2.Поле3 будет разложено на массив вида [Поле1, Поле1.Поле2, Поле1.Поле2.Поле3]
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

#Область Строка

// Выполняет транслитерацию строки.
// см. https://ru.wikipedia.org/wiki/Транслитерация_русского_алфавита_латиницей
//
// Параметры:
//  Фраза	 - Строка	 - Исходная строка
//  Стандарт - Строка	 - Стандарт транслитерации. Варианты:
//		* 4271	 - Приказ МИД N 4271 (2016-н/в) (см. http://www.consultant.ru/document/cons_doc_LAW_198429/c956ff01bf42465d7052431dec215b77d0404875)
//		* 310	 - Приказ МВД N 310 (1997-2010)
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
	
КонецФункции // ТранслитерироватьСтроку

// Различающиеся символы раскладок клавиатуры Йцукен и Qwerty
//
// Возвращаемое значение:
//   Структура - Символы раскладок в порядке, соответствующем положению клавиш на клавиатуре.
//		* Йцукен - Строка - Символы раскладки кириллицы
//		* Qwerty - Строка - Символы раскладки латиницы
//
Функция РазлСимволыРаскладокЙцукенQwerty()
	
	Йцукен			= "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,Ё!""№;%:?/"; // Заглавный алфавит, потом верхний ряд с Ё до 7, потом шифт-черта
	Qwerty			= "QWERTYUIOP{}ASDFGHJKL:""ZXCVBNM<>?~!@#$%^&|"; // Заглавный алфавит, потом верхний ряд с ~ до 7, потом шифт-черта
	Йцукен = Йцукен + "йцукенгшщзхъфывапролджэячсмитьбю.ё";			 // Строчный алфавит и ё
	Qwerty = Qwerty + "qwertyuiop[]asdfghjkl;'zxcvbnm,./`";			 // Строчный алфавит и `

	Раскладки = Новый Структура;
	Раскладки.Вставить("Йцукен", Йцукен);
	Раскладки.Вставить("Qwerty", Qwerty);

	Если СтрДлина(Йцукен) <> СтрДлина(Qwerty) Тогда
		ВызватьИсключение "Количество символов в раскладках не совпадает";
	КонецЕсли;

	Возврат Раскладки;

КонецФункции // СоответствиеРаскладокЙцукенQwerty

// см. СтрокаИзДругойРаскладки()
//
Функция СтрокаQwertyИзЙцукен(ИсходнаяСтрока) Экспорт
	
	Возврат СтрокаИзДругойРаскладки(ИсходнаяСтрока, "Йцукен", "Qwerty");

КонецФункции // СтрокаQwertyИзЙцукен()

// см. СтрокаИзДругойРаскладки()
//
Функция СтрокаЙцукенИзQwerty(ИсходнаяСтрока) Экспорт
	
	Возврат СтрокаИзДругойРаскладки(ИсходнаяСтрока, "Qwerty", "Йцукен");

КонецФункции // СтрокаЙцукенИзQwerty()

// Посимвольно преобразует строку из другой раскладки в порядке расположения клавиш клиавиатуры другой раскладки.
//
// Параметры:
//  ИсходнаяСтрока			 - Строка
//  ИмяРаскладкиИсточник	 - Строка - см. ИмяРаскладкиНазначение
//	ИмяРаскладкиНазначение	 - Строка:
//		* "Qwerty" - Латиница
//		* "Йцукен" - Кириллица
//
// Возвращаемое значение:
//   Строка   - Преобразованная строка
//
Функция СтрокаИзДругойРаскладки(ИсходнаяСтрока, ИмяРаскладкиИсточник, ИмяРаскладкиНазначение)
	
	Раскладки			 = РазлСимволыРаскладокЙцукенQwerty();
	РаскладкаИсточник	 = Раскладки[ИмяРаскладкиИсточник];
	РаскладкаНазначение	 = Раскладки[ИмяРаскладкиНазначение];

	Результат = "";
	ЕстьСимволыДругойРаскладки = Ложь;
	Для НомерСимвола = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		
		ТекСимвол = Сред(ИсходнаяСтрока, НомерСимвола, 1);

		Если Не ЕстьСимволыДругойРаскладки Тогда
			ЕстьСимволыДругойРаскладки = Булево(СтрНайти(РаскладкаИсточник, ТекСимвол));
			Если ЕстьСимволыДругойРаскладки Тогда
				// Построим соответствия раскладок
				СоответствиеСимволов = Новый Соответствие;
				Для НомерСимволаРаскладки = 1 По СтрДлина(РаскладкаИсточник) Цикл
					СимволРаскладкиИсточник		 = Сред(РаскладкаИсточник,	 НомерСимволаРаскладки, 1);
					СимволРаскладкиНазначение	 = Сред(РаскладкаНазначение, НомерСимволаРаскладки, 1);
					СоответствиеСимволов[СимволРаскладкиИсточник] = СимволРаскладкиНазначение;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		Если ЕстьСимволыДругойРаскладки Тогда
			СимволНазначение = СоответствиеСимволов[ТекСимвол];
			Результат = Результат + ?(СимволНазначение <> Неопределено, СимволНазначение, ТекСимвол);
		Иначе
			Результат = Результат + ТекСимвол;
		КонецЕсли; 

	КонецЦикла;

	Возврат Результат;

КонецФункции // СтрокаИзДругойРаскладки()

#КонецОбласти // Строка

#Область УникальныйИдентификатор

// Преобразует уникальный идентификатор в шестнадцатеричное число,
//	которое используется в навигационных ссылках
//
// Параметры:
//  УникальныйИдентификатор	 - УникальныйИдентификатор, Строка	 - Преобразуемый идентификатор
//  ДобавитьПрефикс			 - Булево							 - Если Истина - к числу будет добавлен префикс "0x"
// 
// Возвращаемое значение:
//   - Строка   - Сформированное строковое представление числа, 
//					Если формат идентификатора не верен, возвращается Неопределено.
//
Функция УникальныйИдентификаторВШестнадцатеричноеЧисло(Знач УникальныйИдентификатор, ДобавитьПрефикс = Истина)

	// Входящее:	00112233-4455-6677-8899-aabbccddeeff
	// Ожидается:	[0x]8899aabbccddeeff6677445500112233
	
	СоставныеЧасти = СтрРазделить(Строка(УникальныйИдентификатор), "-", Ложь);
	Если СоставныеЧасти.Количество() <> 5 Тогда Возврат Неопределено КонецЕсли; 	
	
	ШестнадцатеричноеЧисло = 
	?(ДобавитьПрефикс, "0x", "")
	+ СоставныеЧасти[3]		// 8899 
	+ СоставныеЧасти[4]		// aabbccddeeff
	+ СоставныеЧасти[2]		// 6677
	+ СоставныеЧасти[1]		// 4455
	+ СоставныеЧасти[0];	// 00112233
	
	Возврат ШестнадцатеричноеЧисло;

КонецФункции // УникальныйИдентификаторВШестнадцатеричноеЧисло()

// Формирует уникальный идентификатор из шестнадцатеричного числа
//
// Параметры:
//  ШестнадцатеричноеЧисло	 - Строка	 - Шестнадцатиричное число. Может предваряться префиксом "0x"
// 
// Возвращаемое значение:
//  УникальныйИдентификатор - Сформированный уникальный идентификатор
//
Функция УникальныйИдентификаторИзШестнадцатеричногоЧисла(Знач ШестнадцатеричноеЧисло)

	// Входящее:	[0x]8899aabbccddeeff6677445500112233
	// Ожидается:	00112233-4455-6677-8899-aabbccddeeff
	
	ШестнадцатеричноеЧислоБезПрефикса = СтрЗаменить(ШестнадцатеричноеЧисло, "0x", "");
	Если СтрДлина(ШестнадцатеричноеЧислоБезПрефикса) <> 32 Тогда Возврат Неопределено КонецЕсли;
	
	// Разметка:        1   5           17  21  25
	// Входящее:	[0x]8899aabbccddeeff6677445500112233
	ЧастиЧисла = Новый Массив;
	ЧастиЧисла.Добавить(Сред(ШестнадцатеричноеЧислоБезПрефикса, 1,	 4));	// 8899
	ЧастиЧисла.Добавить(Сред(ШестнадцатеричноеЧислоБезПрефикса, 5,	 12));	// aabbccddeeff
	ЧастиЧисла.Добавить(Сред(ШестнадцатеричноеЧислоБезПрефикса, 17,	 4));	// 6677
	ЧастиЧисла.Добавить(Сред(ШестнадцатеричноеЧислоБезПрефикса, 21,	 4));	// 4455
	ЧастиЧисла.Добавить(Сред(ШестнадцатеричноеЧислоБезПрефикса, 25,	 8));	// 00112233
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор(
			ЧастиЧисла[4]		// 00112233
	+ "-" + ЧастиЧисла[3]		// 4455
	+ "-" + ЧастиЧисла[2]		// 6677
	+ "-" + ЧастиЧисла[0]		// 8899 
	+ "-" + ЧастиЧисла[1]		// aabbccddeeff
	);
	
	Возврат УникальныйИдентификатор;

КонецФункции // УникальныйИдентификаторИзШестнадцатеричногоЧисла()

#КонецОбласти // УникальныйИдентификатор

#Область НавигационныеСсылки

Функция ПредставленияНавигационныхСсылок(НавигационныеСсылки)
	
	Представления = Новый Соответствие;

	ПредставленияНавСсылок = ПолучитьПредставленияНавигационныхСсылок(НавигационныеСсылки);
	Для Индекс = 0 По НавигационныеСсылки.ВГраница() Цикл
		ПредставлениеНавСсылки = ПредставленияНавСсылок[Индекс];
		Если ТипЗнч(ПредставлениеНавСсылки) = Тип("ПредставлениеНавигационнойСсылки") Тогда
			Представление = ПредставлениеНавСсылки.Текст;
		Иначе
			Представление = Неопределено;
		КонецЕсли; 
		Представления.Вставить(НавигационныеСсылки[Индекс], Представление);
	КонецЦикла; 	
	
	Возврат Представления;

КонецФункции // ПредставленияНавигационныхСсылок()
 
Функция ПредставлениеНавигационнойСсылки(НавигационнаяСсылка)
	
	Представление = "";
	
	НавигационныеСсылки = Новый Массив;
	Если ЗначениеЗаполнено(НавигационнаяСсылка) Тогда
		НавигационныеСсылки.Добавить(НавигационнаяСсылка);
	КонецЕсли; 
	ПредставленияНавСсылок = ПолучитьПредставленияНавигационныхСсылок(НавигационныеСсылки);
	Если ЗначениеЗаполнено(ПредставленияНавСсылок) Тогда
		ПредставлениеНавСсылки = ПредставленияНавСсылок[0];
		Если ТипЗнч(ПредставлениеНавСсылки) = Тип("ПредставлениеНавигационнойСсылки") Тогда
			Представление = ПредставлениеНавСсылки.Текст;
		КонецЕсли; 
	КонецЕсли;

	Возврат Представление;
	
КонецФункции	// ПредставлениеНавигационнойСсылки()

#КонецОбласти // НавигационныеСсылки