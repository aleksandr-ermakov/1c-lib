
#Область OneScript
	// BSLLS:CognitiveComplexity-off
#КонецОбласти // OneScript

// Выгружает строки из узла дерева значений в таблицу значений
//
// Параметры:
//  Узел				 - ДеревоЗначений		 - Дерево, чьи подчиненные элементы будут выгружены. 
//						 - СтрокаДереваЗначений	 - Строка, чьи подчиненные элементы будут выгружены.
//  Рекурсивно			 - Булево				 - Рекурсивная выгрузка. 
//												Если Ложь - будут выгружены только подчиненные строки переданного узла 
//												(или корневые строки переданного дерева).
//  ИмяКолонкиРодитель	 - Строка				 - Колонка, содержащая ссылки в этой же таблице на строки, 
//												являющиеся родителями выгруженных.
//												Для строк корневого уровня не заполняется.       
//												Используется, если Рекурсивно = Истина.
//												Тип колонки: СтрокаТаблицыЗначений
//  ТаблицаЗначений		 - ТаблицаЗначений		 - (Служебный)
// 
// Возвращаемое значение:
//	ТаблицаЗначений - Полученная таблица
//
Функция ВыгрузитьКоллекциюСтрокДереваЗначений(
	Узел, 
	Рекурсивно = Ложь, 
	ИмяКолонкиРодитель = "Родитель", 
	Знач ТаблицаЗначений = Неопределено) Экспорт
	
	Если ТаблицаЗначений = Неопределено Тогда
		
		УзелЭтоДеревоЗначений = ТипЗнч(Узел) = Тип("ДеревоЗначений");
		ДеревоЗначений = ?(УзелЭтоДеревоЗначений, Узел, Узел.Владелец());
		ТаблицаЗначений = Новый ТаблицаЗначений;
	    Для каждого Колонка Из ДеревоЗначений.Колонки Цикл
			ТаблицаЗначений.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина); 
		КонецЦикла; 	
		Если Рекурсивно Тогда                                  
			ТипыКолонкиРодитель = Новый Массив;
			ТипыКолонкиРодитель.Добавить(Тип("СтрокаТаблицыЗначений"));
			ТипыКолонкиРодитель.Добавить(Тип("Null"));
			ОписаниеТиповСтрокаТаблицыЗначений = Новый ОписаниеТипов(ТипыКолонкиРодитель);
			ТаблицаЗначений.Колонки.Добавить(ИмяКолонкиРодитель, ОписаниеТиповСтрокаТаблицыЗначений);
		КонецЕсли;
	
	КонецЕсли;                                                                                       
	
	Если Рекурсивно И ЗначениеЗаполнено(ТаблицаЗначений) Тогда
		СтрокаРодитель = ТаблицаЗначений[ТаблицаЗначений.Количество() - 1];
	Иначе
		СтрокаРодитель = Неопределено;
	КонецЕсли;
	Для каждого СтрокаДерева Из Узел.Строки Цикл
		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаДерева);
		Если Рекурсивно И СтрокаРодитель <> Неопределено Тогда
			СтрокаТаблицы[ИмяКолонкиРодитель] = СтрокаРодитель;
		КонецЕсли;  
		Если Рекурсивно Тогда
		    ВыгрузитьКоллекциюСтрокДереваЗначений(СтрокаДерева, Рекурсивно, ИмяКолонкиРодитель, ТаблицаЗначений);		
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаЗначений;

КонецФункции // ВыгрузитьКоллекциюСтрокДереваЗначений() 

// Загружает строки дерева значений из источника.
// Существующие строки не удаляются.
//
// Параметры:
//  Узел				 - ДеревоЗначений		 - Загружаемое дерево значений.
//						 - СтрокаДереваЗначений	 - Загружаемая ветвь дерева значений.
//  Источник			 - ТаблицаЗначений		 - Таблица значений - источник данных. 
//						 - Произвольный			 - Любая коллекция, доступная для обхода посредством оператора Для Каждого ... Цикл
//  ИмяКолонкиРодитель	 - Строка				 - Если указано, анализируется одноименная колонка таблицы-источника
//											для построения иерархии.
//											При этом, в качестве источника обязательно должна быть указана ТаблицаЗначений.
//											Тип колонки источника может быть:
//											* СтрокаТаблицыЗначений	 - Указатель на строку в этой же таблице
//											* Число					 - Индекс в этой же таблице
//											Для корневых элементов допускается Неопределено и Null.
//											Циклические ссылки внутри таблицы не проверяются! 
//	ТаблицаЗначений		 - ТаблицаЗначений		 - (Служебный)
//
// Варианты вызова:
//	ЗагрузитьКоллекциюСтрокДереваЗначений(ДеревоЗначений, Массив) - Загрузка значений в коллекцию строк в один уровень.
//	ЗагрузитьКоллекциюСтрокДереваЗначений(ДеревоЗначений, ТаблицаЗначений, "Родитель") - Загрузка значений рекурсивно.
//
Процедура ЗагрузитьКоллекциюСтрокДереваЗначений(
	Узел, 
	Источник, 
	ИмяКолонкиРодитель = "", 
	Знач ТаблицаЗначений = Неопределено) Экспорт
		
	ЕстьРекурсия = ЗначениеЗаполнено(ИмяКолонкиРодитель);
	Если Не ЕстьРекурсия Тогда  
		
		Для каждого Элемент Из Источник Цикл    
			НоваяСтрока = Узел.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
		КонецЦикла; 
		
		Возврат;
		
	КонецЕсли;
	
	ЭтоНачалоРекурсии = ТаблицаЗначений = Неопределено;
	Если ЭтоНачалоРекурсии Тогда
		Если ТипЗнч(Источник) <> Тип("ТаблицаЗначений") Тогда
			ВызватьИсключение "Параметр Источник: Ожидается тип ТаблицаЗначений";	
		КонецЕсли;
		ТаблицаЗначений = Источник;	
		ИндексТаблицыПоРодителю = ТаблицаЗначений.Индексы.Добавить(ИмяКолонкиРодитель);
	КонецЕсли;
		
	КолонкаРодитель = ТаблицаЗначений.Колонки.Найти(ИмяКолонкиРодитель);
	Если КолонкаРодитель = Неопределено Тогда
		ВызватьИсключение СтрШаблон("ТаблицаЗначений-источник не содержит колонку %1", ИмяКолонкиРодитель);		
	КонецЕсли;
	
	РодительЭтоИндекс	 = КолонкаРодитель.ТипЗначения.СодержитТип(Тип("Число"));
	РодительЭтоУказатель = КолонкаРодитель.ТипЗначения.СодержитТип(Тип("СтрокаТаблицыЗначений"));
	Если РодительЭтоИндекс = РодительЭтоУказатель Тогда
		ТекстИсключения = СтрШаблон(
			"Колонка таблицы %1 должна поддерживать только один тип: СтрокаТаблицыЗначений или Число", 
			ИмяКолонкиРодитель
		);
		ВызватьИсключение ТекстИсключения;	
	КонецЕсли;
	
	СтрокиТекущегоУровня = Новый Массив;
	Если ЭтоНачалоРекурсии Тогда                    
		Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
			Если СтрокаТаблицы[ИмяКолонкиРодитель] = Неопределено
				Или СтрокаТаблицы[ИмяКолонкиРодитель] = Null Тогда
				СтрокиТекущегоУровня.Добавить(СтрокаТаблицы);				
			КонецЕсли;
		КонецЦикла; 
	Иначе
		СтрокиТекущегоУровня = Источник;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из СтрокиТекущегоУровня Цикл
		
		СтрокаДерева = Узел.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДерева, СтрокаТаблицы);
		
		Если РодительЭтоИндекс Тогда
			ПараметрыПоискаДочерних = Новый Структура(ИмяКолонкиРодитель, ТаблицаЗначений.Индекс(СтрокаТаблицы));
		Иначе
			ПараметрыПоискаДочерних = Новый Структура(ИмяКолонкиРодитель, СтрокаТаблицы);		
		КонецЕсли;
		ДочерниеСтроки = ТаблицаЗначений.НайтиСтроки(ПараметрыПоискаДочерних);
		Если ЗначениеЗаполнено(ДочерниеСтроки) Тогда
			ЗагрузитьКоллекциюСтрокДереваЗначений(СтрокаДерева, ДочерниеСтроки, ИмяКолонкиРодитель, ТаблицаЗначений);
		КонецЕсли;
	
	КонецЦикла;
	
	Если ЭтоНачалоРекурсии Тогда
		ТаблицаЗначений.Индексы.Удалить(ИндексТаблицыПоРодителю);
	КонецЕсли;

КонецПроцедуры // ЗагрузитьКоллекциюСтрокДереваЗначений()

// Копирует строку дерева значений с подчиненными элементами.
//
// Параметры:
//  СтрокаДерева - СтрокаДереваЗначений			 - Копируемая строка дерева, вместе с подчиненными.
//  Размещение	 - КоллекцияСтрокДереваЗначений	 - Коллекция строк, в которой размещается копия ветви.
//				 - Неопределено					 - Строка будет скопирована в новое дерево значений.
//	Рекурсивно	 - Булево						 - Если Истина, строка будет скопирована с подчиненными.
//
// Возвращаемое значение:
//   СтрокаДереваЗначений, ДеревоЗначений  - Скопированная строка или ветвь.
//
Функция СкопироватьСтрокуДереваЗначений(СтрокаДерева, Размещение = Неопределено, Рекурсивно = Истина) Экспорт

	Если ТипЗнч(Размещение) = Тип("КоллекцияСтрокДереваЗначений") Тогда

		НоваяСтрокаДерева = Размещение.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, СтрокаДерева);
		Если Рекурсивно Тогда
			Для каждого ПодчиненнаяСтрокаДерева Из СтрокаДерева.Строки Цикл
				СкопироватьСтрокуДереваЗначений(ПодчиненнаяСтрокаДерева, НоваяСтрокаДерева.Строки, Рекурсивно);
			КонецЦикла;
		КонецЕсли;

		Возврат НоваяСтрокаДерева;

	ИначеЕсли Размещение = Неопределено Тогда

		Если ТипЗнч(СтрокаДерева) = Тип("СтрокаДереваЗначений") Тогда

			ИсходноеДерево = СтрокаДерева.Владелец;
			НовоеДерево = Новый ДеревоЗначений;
			Для каждого Колонка Из ИсходноеДерево.Колонки Цикл
				НовоеДерево.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина);
			КонецЦикла;
			СкопироватьСтрокуДереваЗначений(СтрокаДерева, НовоеДерево.Строки, Рекурсивно);

			Возврат НовоеДерево;

		Иначе

			ВызватьИсключение "Параметр Ветвь: Неожиданный тип значения";
	
		КонецЕсли;

	Иначе

		ВызватьИсключение "Параметр Размещение: Неожиданный тип значения";
	
	КонецЕсли;
	
КонецФункции

// Получает различные значения указанных полей дерева значений.
//
// Параметры:
//  Узел		 - ДеревоЗначений	 - Дерево значений
//  ИмяКолонки	 - Строка			 - Имена получаемых полей
//  Значения	 - Неопределено		 - (служебный)
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Полученные значения.
//
Функция РазличныеЗначенияКолонкиДереваЗначений(Узел, ИмяКолонки, Значения = Неопределено) Экспорт
	
	ЭтоНачалоРекурсии = Значения = Неопределено;

	Если ТипЗнч(Узел) = Тип("СтрокаДереваЗначений") Тогда
		
		Значения.Вставить(Узел[ИмяКолонки]);
		Для каждого Ветвь Из Узел.Строки Цикл
			РазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, Значения)
		КонецЦикла;
	
	ИначеЕсли ТипЗнч(Узел) = Тип("ДеревоЗначений") Тогда
		
		Значения = Новый Соответствие;
		
		Для каждого Ветвь Из Узел.Строки Цикл
			РазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, Значения);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Узел) = Тип("Строка") и ЭтоАдресВременногоХранилища(Узел) Тогда
		
		Возврат РазличныеЗначенияКолонкиДереваЗначений(ПолучитьИзВременногоХранилища(Узел), ИмяКолонки);
		
	КонецЕсли; 
	
	Если ЭтоНачалоРекурсии Тогда // Формируем результирующий массив
		
		МассивЗначений = Новый Массив;
		Для каждого Элемент Из Значения Цикл
			МассивЗначений.Добавить(Элемент.Ключ);
		КонецЦикла; 
		
		Возврат МассивЗначений;
			
	КонецЕсли; 
	
	Возврат Значения;

КонецФункции // РазличныеЗначенияКолонкиДереваЗначений()

// Получает адресацию конечных листьев, содержащих значения определенной колонки
//
// Параметры:
//  Узел		 - ДеревоЗначений, СтрокаДереваЗначений	 - Дерево значений, или его строка
//	ИмяКолонки	 - Строка	 - Имя колонки, содержащей перечень исходных значений
//  ТолькоЛистья - Булево	 - Если Истина - то расположение значений получается только для листьев дерева значений
// 
// Возвращаемое значение:
//  Соответствие - Тип ключа соответствует типу значений в колонке, Значение - Массив, содержащий узлы коллекции.
//
Функция РасположениеЗначенийКолонкиДереваЗначенийРекурсивно(Узел, ИмяКолонки, ТолькоЛистья = Ложь) Экспорт

	Расположение = Новый Соответствие;	// {Произвольный; Массив:СтрокаДереваЗначений}

	Для каждого Ветвь Из Узел.Строки Цикл

		ЭтоЛист = не ЗначениеЗаполнено(Ветвь.Строки);

		Если ЭтоЛист или не ТолькоЛистья Тогда
			Если Расположение[Ветвь[ИмяКолонки]] = Неопределено Тогда
				Расположение[Ветвь[ИмяКолонки]] = Новый Массив;
			КонецЕсли;
			Расположение[Ветвь[ИмяКолонки]].Добавить(Ветвь);
		КонецЕсли;

		Для каждого Элемент Из РасположениеЗначенийКолонкиДереваЗначенийРекурсивно(Ветвь, ТолькоВидимые, ТолькоДоступные) Цикл
			РасположениеЗначения = Расположение.Получить(Элемент.Ключ);
			Если РасположениеЗначения = Неопределено Тогда
				Расположение.Вставить(Элемент.Ключ, Элемент.Значение);
			Иначе
				Для каждого Лист Из Элемент.Значение Цикл
					РасположениеЗначения.Добавить(Лист);	
				КонецЦикла; 
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла; 	
	
	Возврат Расположение;

КонецФункции // РасположениеЗначенийКолонкиДереваЗначенийРекурсивно()
