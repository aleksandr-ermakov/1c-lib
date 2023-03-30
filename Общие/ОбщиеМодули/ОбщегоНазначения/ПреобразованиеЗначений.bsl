
// Преобразовывает Дерево значений в Таблицу значений
//
// Параметры:
//	УзелДерева		 - ДеревоЗначений, СтрокаДереваЗначений - Дерево значений или его ветка, которую следует преобразовать.
//	ТолькоЛистья	 - Булево - Если Истина, в таблицу будут выгружены только строки дерева значений,
//								не имеющие подчиненных строк.
//	ТаблицаЗначений	 - ТаблицаЗначений - (служебный) Содержит выходную таблицу значений
//
Функция ТаблицаЗначенийИзДереваЗначений(УзелДерева, ТолькоЛистья = Ложь, ТаблицаЗначений = Неопределено)

	Если ТипЗнч(УзелДерева) <> Тип("СтрокаДереваЗначений") И ТипЗнч(УзелДерева) <> Тип("ДеревоЗначений") Тогда
		ВызватьИсключение "Параметр УзелДерева: Ожидается тип СтрокаДереваЗначений или ДеревоЗначений";
	КонецЕсли;

	ЭтоСтрокаДерева = ТипЗнч(УзелДерева) = Тип("СтрокаДереваЗначений");
	ЭтоКореньДерева = Не ЭтоСтрокаДерева;
	ЭтоЛистДерева = Не ЗначениеЗаполнено(УзелДерева.Строки);

	Если ТипЗнч(ТаблицаЗначений) <> Тип("ТаблицаЗначений") Тогда

		ТаблицаЗначений = Новый ТаблицаЗначений;
		Если ЭтоКореньДерева Тогда
			Колонки = УзелДерева.Колонки;
		Иначе
			Колонки = УзелДерева.Владелец().Колонки;
		КонецЕсли;
		Для каждого Колонка Из Колонки Цикл
			ТаблицаЗначений.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина);
		КонецЦикла;

	КонецЕсли;

	Если ЭтоСтрокаДерева 
		И (ЭтоЛистДерева Или Не ТолькоЛистья) Тогда

		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		Для каждого Колонка Из ТаблицаЗначений.Колонки Цикл
			СтрокаТаблицы[Колонка.Имя] = УзелДерева[Колонка.Имя];
		КонецЦикла;
		
	КонецЕсли;

	Для каждого СтрокаДерева Из УзелДерева.Строки Цикл
		ТаблицаЗначенийИзДереваЗначений(СтрокаДерева, ТолькоЛистья, ТаблицаЗначений)
	КонецЦикла;

	Возврат ТаблицаЗначений;

КонецФункции // ТаблицаЗначенийИзДереваЗначений()

// Создаёт типизированную таблицу значений из соответствия
//
// Параметры:
//  Соответствие - Соответствие	 - Исходное соответствие.
//  ИменаКолонок - Строка		 - Имена двух колонок новой таблицы через запятую.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Сформированная таблица
//
Функция ТаблицаЗначенийИзСоответствия(Соответствие, Знач ИменаКолонок = "Ключ, Значение") Экспорт
	
	Если ТипЗнч(Соответствие) <> Тип("Соответствие") Тогда
		ВызватьИсключение "Параметр Соответствие: Ожидается тип Соответствие";
	ИначеЕсли ТипЗнч(ИменаКолонок) <> Тип("Строка") Тогда
		ВызватьИсключение "Параметр ИменаКолонок: Ожидается тип Строка";
	ИначеЕсли Не СтрНайти(ИменаКолонок, ",") Тогда
		ВызватьИсключение "Параметр ИменаКолонок: Ожидается два имени через запятую";
	КонецЕсли; 
	
	ИменаКолонок = СтрРазделить(ИменаКолонок, ", ", Ложь);
	ЗначенияКлючей			 = Новый Массив;
	ЗначенияЗначений		 = Новый Массив;
	ТипыКлючей				 = Новый Массив;
	ТипыЗначений			 = Новый Массив;
	ПредыдущийТипКлюча		 = Неопределено;
	ПредыдущийТипЗначения	 = Неопределено;
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	Для каждого ЭлементСоответствия Из Соответствие Цикл
		
		ТаблицаЗначений.Добавить();
		ЗначенияКлючей.Добавить(ЭлементСоответствия.Ключ);
		ЗначенияЗначений.Добавить(ЭлементСоответствия.Значение);
		
		ТипКлюча = ТипЗнч(ЭлементСоответствия.Ключ);
		Если ТипКлюча <> ПредыдущийТипКлюча
			И ТипыКлючей.Найти(ТипКлюча) = Неопределено Тогда
			ТипыКлючей.Добавить(ТипКлюча);
		КонецЕсли; 
		ПредыдущийТипКлюча = ТипКлюча;
		
		ТипЗначения = ТипЗнч(ЭлементСоответствия.Значение);
		Если ТипЗначения <> ПредыдущийТипЗначения
			И ТипыЗначений.Найти(ТипЗначения) = Неопределено Тогда
			ТипыЗначений.Добавить(ТипЗначения);
		КонецЕсли; 
		ПредыдущийТипЗначения = ТипЗначения;
		
	КонецЦикла; 
	
	ТаблицаЗначений.Колонки.Добавить(ИменаКолонок[0], Новый ОписаниеТипов(ТипыКлючей));	
	ТаблицаЗначений.Колонки.Добавить(ИменаКолонок[1], Новый ОписаниеТипов(ТипыЗначений));	
	ТаблицаЗначений.ЗагрузитьКолонку(ЗначенияКлючей,	 0);
	ТаблицаЗначений.ЗагрузитьКолонку(ЗначенияЗначений,	 1);
	
	Возврат ТаблицаЗначений;
	
КонецФункции

// Создаёт типизированную таблицу значений из массива.
//
// Параметры:
//  Массив		 - Массив - Исходный массив.
//  ИмяКолонки	 - Строка - Имя единственной колонки создавамой таблицы
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Результирующая таблица
//
Функция ТаблицаЗначенийИзМассива(Массив, ИмяКолонки = "Значение") Экспорт

	Если ТипЗнч(Массив) <> Тип("Массив") Тогда
		ВызватьИсключение "Параметр Массив: Ожидается тип Массив";
	ИначеЕсли ТипЗнч(ИмяКолонки) <> Тип("Строка") Тогда
		ВызватьИсключение "Параметр ИменаКолонок: Ожидается тип Строка";
	КонецЕсли; 
	
	ТипыЗначений			 = Новый Массив;
	ПредыдущийТипЗначения	 = Неопределено;
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	Для каждого ЭлементМассива Из Массив Цикл
		
		ТаблицаЗначений.Добавить();
		
		ТипЗначения = ТипЗнч(ЭлементМассива);
		Если ТипЗначения <> ПредыдущийТипЗначения
			И ТипыЗначений.Найти(ТипЗначения) = Неопределено Тогда
			ТипыЗначений.Добавить(ТипЗначения);
		КонецЕсли; 
		ПредыдущийТипЗначения = ТипЗначения;
		
	КонецЦикла; 
	
	ТаблицаЗначений.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов(ТипыЗначений));	
	ТаблицаЗначений.ЗагрузитьКолонку(Массив, 0);

	Возврат ТаблицаЗначений;
	
КонецФункции // ТаблицаЗначенийИзМассива()

// Создаёт типизированную таблицу значений из списка значений.
//
// Параметры:
//  СписокЗначений	 - СписокЗначений - Исходный список значений.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Результирующая таблица. Колонки:
//		* Значение		 - Произвольный
//		* Представление	 - Строка
//		* Пометка		 - Булево
//
Функция ТаблицаЗначенийИзСпискаЗначений(СписокЗначений) Экспорт

	Если ТипЗнч(СписокЗначений) <> Тип("СписокЗначений") Тогда
		ВызватьИсключение "Параметр СписокЗначений: Ожидается тип СписокЗначений";
	КонецЕсли; 
	
	Значения		 = Новый Массив;
	Представления	 = Новый Массив;
	Пометки			 = Новый Массив;
	
	ТипыЗначений			 = Новый Массив;
	ПредыдущийТипЗначения	 = Неопределено;
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	Для каждого ЭлементСписка Из СписокЗначений Цикл
		
		Значения.Добавить(ЭлементСписка.Значение);
		Представления.Добавить(ЭлементСписка.Представление);
		Пометки.Добавить(ЭлементСписка.Пометка);
		
		ТаблицаЗначений.Добавить();
		
		ТипЗначения = ТипЗнч(ЭлементСписка.Значение);
		Если ТипЗначения <> ПредыдущийТипЗначения
			И ТипыЗначений.Найти(ТипЗначения) = Неопределено Тогда
			ТипыЗначений.Добавить(ТипЗначения);
		КонецЕсли; 
		ПредыдущийТипЗначения = ТипЗначения;
		
	КонецЦикла; 
	
	ТаблицаЗначений.Колонки.Добавить("Значение",		 Новый ОписаниеТипов(ТипыЗначений));	
	ТаблицаЗначений.Колонки.Добавить("Представление",	 Новый ОписаниеТипов("Строка"));	
	ТаблицаЗначений.Колонки.Добавить("Пометка",			 Новый ОписаниеТипов("Булево"));	
	ТаблицаЗначений.ЗагрузитьКолонку(Значения,		 0);
	ТаблицаЗначений.ЗагрузитьКолонку(Представления,	 1);
	ТаблицаЗначений.ЗагрузитьКолонку(Пометки,		 2);

	Возврат ТаблицаЗначений;
	
КонецФункции // ТаблицаЗначенийИзМассива()

// Формирует массив структур с именами колонок таблицы.
//
// Параметры:
//	ТаблицаЗначений	 - ТаблицаЗначений	 - Исходная таблица.
//	ИменаКолонок	 - Строка			 - Имена колонок таблицы, и ключей выгружаемых структур.
//
// Возвращаемое значение:
//	Массив из Структура
//
Функция МассивСтруктурИзТаблицыЗначений(ТаблицаЗначений, Знач ИменаКолонок = Неопределено) Экспорт
	
	Если ИменаКолонок = Неопределено Тогда
		ИменаКолонок = Новый Массив;
		Для каждого Колонка Из ТаблицаЗначений.Колонки Цикл
			ИменаКолонок.Добавить(Колонка.Имя);
		КонецЦикла;
		ИменаКолонок = СтрСоединить(ИменаКолонок, ", ");
	ИначеЕсли ТипЗнч(ИменаКолонок) = Тип("Строка") Тогда
		Для каждого ИмяКолонки Из ИменаКолонок Цикл
			Если ТаблицаЗначений.Колонки.Найти(ИмяКолонки) = Неопределено Тогда
				ВызватьИсключение СтрШаблон("Таблица не содержит колонки с именем %1", ИмяКолонки);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ВызватьИсключение "Параметр ИменаКолонок: Ожидается Строка";
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ТаблицаЗначений) 
		Или ПустаяСтрока(ИменаКолонок) Тогда
		Возврат Новый Массив;
	КонецЕсли;

	МассивСтруктур = Новый Массив;
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		Структура = Новый Структура(ИменаКолонок);
		ЗаполнитьЗначенияСвойств(Структура, СтрокаТаблицы);
		МассивСтруктур.Добавить(Структура);
	КонецЦикла;

	Возврат МассивСтруктур; 

КонецФункции // МассивСтруктурИзТаблицыЗначений()

// Формирует структуру из дерева значений.
// Отличия структуры от дерева:
//	Корневой элемент - это тоже Структура.
//	У элементов первого уровня будет заполнен Родитель - элементом первого уровня.
//	Владелец всех элементов будет указывать на корневой элемент,
//		даже если структура построена от промежуточного узла дерева.
//
// Параметры:
//	НачальныйУзел	 - ДеревоЗначений		 - Исходное дерево значений.
//					 - СтрокаДереваЗначений	 - Исходный узел дерева значений.
//	Колонки			 - Строка - Имена выгружаемых колонок дерева. Если не указан, будут выгружены все колонки.
//	КлючСтроки		 - Строка - Обязательный. Элемент структуры, содержащий коллекцию вложенных структур.
//	КлючРодитель	 - Строка - Элемент структуры, содержащий структуру-родителя.
//	КлючВладелец	 - Строка - Элемент структуры, содержащий корневую структуру.
//
// Возвращаемое значение:
//	Структура - Полученная структура. Каждый элемент коллекции подчиненных строк будет иметь ключ СтрокаN, 
//				где N - это индекс подчиненной строки дерева.
//				Если передано ДеревоЗначений, то корневой элемент будет содержать только элемент <КлючСтроки>;
//
Функция СтруктураИзДереваЗначений(
	НачальныйУзел,
	Колонки = Неопределено, 
	КлючСтроки = "Строки", 
	КлючРодитель = "Родитель", 
	КлючВладелец = "Владелец") Экспорт

	Если ПустаяСтрока(КлючСтроки) Тогда
		ВызватьИсключение "Параметр Строки: Ожидается значение";
	КонецЕсли;

	Если ТипЗнч(НачальныйУзел) = Тип("ДеревоЗначений") Тогда
		Корень = НачальныйУзел;
	ИначеЕсли ТипЗнч(НачальныйУзел) = Тип("СтрокаДереваЗначений") Тогда
		Корень = НачальныйУзел.Владелец();
	Иначе
		ВызватьИсключение "Параметр НачальныйУзел: Ожидается тип ДеревоЗначений, СтрокаДереваЗначений";
	КонецЕсли;

	ЕстьКлючРодитель = Не ПустаяСтрока(КлючРодитель);
	ЕстьКлючВладелец = Не ПустаяСтрока(КлючВладелец);

	#Область ПоляСтруктуры

	ПоляСтруктуры = Новый Массив;
	Если ЗначениеЗаполнено(Колонки) Тогда
		ИменаКолонок = СтрРазделить(Колонки, ", ", Ложь);
		Для каждого ИмяКолонки Из ИменаКолонок Цикл
			Если Корень.Колонки.Найти(ИмяКолонки) = Неопределено Тогда
				ВызватьИсключение СтрШаблон("Параметр Колонки: Нет колонки с именем «%1»", ИмяКолонки);
			КонецЕсли;
			ПоляСтруктуры.Добавить(ИмяКолонки);
		КонецЦикла;
	Иначе
		Для каждого Колонка Из Корень.Колонки Цикл
			ПоляСтруктуры.Добавить(Колонка.Имя);
		КонецЦикла;
	КонецЕсли;
	
	СлужебныеКолонки = Новый Массив;
	СлужебныеКолонки.Добавить(КлючСтроки);
	Если ЕстьКлючРодитель Тогда
		СлужебныеКолонки.Добавить(КлючРодитель);
	КонецЕсли;
	Если ЕстьКлючВладелец Тогда
		СлужебныеКолонки.Добавить(КлючВладелец);
	КонецЕсли;
	Для Индекс = 0 По СлужебныеКолонки.ВГраница() Цикл
		ИмяКолонки = СлужебныеКолонки[Индекс];
		Если СлужебныеКолонки.Найти(ИмяКолонки) < Индекс Тогда
			ВызватьИсключение СтрШаблон("Дублируется служебная колонка с именем «%1»", ИмяКолонки);
		КонецЕсли;		
		Если ПоляСтруктуры.Найти(ИмяКолонки) <> Неопределено  Тогда
			ВызватьИсключение СтрШаблон("Колонка с именем «%1» уже выбрана для выгрузки из дерева!", ИмяКолонки);
		КонецЕсли;
	КонецЦикла;

	ПоляСтруктуры = СтрСоединить(ПоляСтруктуры, ", ");

	#КонецОбласти // ПоляСтруктуры

	СоответствиеУзлов = Новый Соответствие;	// {СтрокаДереваЗначений; СтруктураУзла: Структура}
	СтруктураДерева = Новый Структура;

	Узлы = Новый Массив;
	Узлы.Добавить(НачальныйУзел);

	НачальныйУзелЭтоДерево = (ТипЗнч(НачальныйУзел) = Тип("ДеревоЗначений"));
	Если НачальныйУзелЭтоДерево Тогда // Чтобы не проверять в цикле.
		СтруктураУзла = Новый Структура(КлючСтроки, Новый Структура);
		СоответствиеУзлов[НачальныйУзел]			 = СтруктураУзла;
		Для каждого Ветвь Из НачальныйУзел.Строки Цикл
			Узлы.Добавить(Ветвь);
		КонецЦикла;
	КонецЕсли;

	Индекс = ?(НачальныйУзелЭтоДерево, 1, 0); // Узел дерева уже обработан
	Пока Индекс <= Узлы.ВГраница() Цикл

		Узел = Узлы[Индекс];
		
		СтруктураУзла = Новый Структура(ПоляСтруктуры);
		ЗаполнитьЗначенияСвойств(СтруктураУзла, Узел);
		СтруктураУзла.Вставить("Строки", Новый Структура);
		СоответствиеУзлов[Узел] = СтруктураУзла;

		Для каждого Ветвь Из Узел.Строки Цикл
			Узлы.Добавить(Ветвь);
		КонецЦикла;

		УзелРодитель = Узел.Родитель;
		Если УзелРодитель = Неопределено И НачальныйУзелЭтоДерево Тогда
			УзелРодитель = НачальныйУзел;
		КонецЕсли;
		СтруктураРодитель = СоответствиеУзлов[УзелРодитель];
		Если ЕстьКлючРодитель Тогда
			СтруктураУзла.Вставить(КлючРодитель, СтруктураРодитель);
		КонецЕсли;
		Если СтруктураРодитель <> Неопределено Тогда
			ИндексУзла = УзелРодитель.Строки.Индекс(Узел);
			КлючВетви = СтрШаблон("Строка%1", XMLСтрока(ИндексУзла));
			СтруктураРодитель.Строки.Вставить(КлючВетви, СтруктураУзла);
		КонецЕсли;
		Индекс = Индекс + 1;

	КонецЦикла;

	Если ЕстьКлючВладелец Тогда
		СтруктураВладелец = СоответствиеУзлов[НачальныйУзел];
		Для Индекс = 1 По Узлы.ВГраница() Цикл
			СоответствиеУзлов[Узлы[Индекс]].Вставить(КлючВладелец, СтруктураВладелец);
		КонецЦикла;
	КонецЕсли;

	СтруктураДерева = СоответствиеУзлов[НачальныйУзел];

	Возврат СтруктураДерева;
	
КонецФункции