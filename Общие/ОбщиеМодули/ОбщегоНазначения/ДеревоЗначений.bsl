
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

// Выгружает результат запроса в дерево, аналогично РезультатЗапроса.Выгрузить(),
// и дополняет его служебными полями - результатами одноименных функций выборки: Группировка(), ТипЗаписи(), Уровень().
// Значения функций помещаются в колонки с указанными наименованиями.
// Если наименование колонки функции не указано, она не добавляется.
//
// Параметры:
//  РезультатЗапроса		 - РезультатЗапроса			 - Выгружаемый результат запроса.
//  ТипОбхода				 - ОбходРезультатаЗапроса	 - Вариант обхода. Если не задан, будет Прямой.
//  ИмяКолонкиГруппировка	 - Строка					 - Имя поля для функции ВыборкаИзРезультатаЗапроса.Группировка()
//  ИмяКолонкиТипЗаписи		 - Строка					 - Имя поля для функции ВыборкаИзРезультатаЗапроса.ТипЗаписи()
//  ИмяКолонкиУровень		 - Строка					 - Имя поля для функции ВыборкаИзРезультатаЗапроса.Уровень()
//	ПараметрыСлужебный		 - Структура				 - Служебные параметры. 
//		* ТипЗаписиСтрокой	 - Булево					 - Если Истина, то в колонке [ИмяКолонкиТипЗаписи] типы записей будут записаны строками.
//														Типы записей: "ДетальнаяЗапись", "ИтогПоГруппировке", "ИтогПоИерархии", "ОбщийИтог".
//
// Возвращаемое значение:
//   ДеревоЗначений			 - Результат выгрузки
//
Функция ДеревоЗначенийИзРезультатаЗапроса(
	РезультатЗапроса, 
	ТипОбхода = Неопределено,
	ИмяКолонкиГруппировка = "Группировка",
	ИмяКолонкиТипЗаписи = "ТипЗаписи",
	ИмяКолонкиУровень = "Уровень",
	Знач ПараметрыСлужебный = Неопределено) Экспорт

	Если ТипЗнч(РезультатЗапроса) = Тип("ВыборкаИзРезультатаЗапроса") Тогда
	
		СтрокиДерева = ПараметрыСлужебный.ТекущиеСтроки;
		Выборка = РезультатЗапроса;
		Пока Выборка.Следующий() Цикл 
			
			СтрокаДерева = СтрокиДерева.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева, Выборка); 
			Группировка = Выборка.Группировка();
			ТипЗаписи = Выборка.ТипЗаписи();
			Уровень = Выборка.Уровень();
			Если ЗначениеЗаполнено(ИмяКолонкиГруппировка) Тогда
				СтрокаДерева[ИмяКолонкиГруппировка] = Группировка;
			КонецЕсли;
			Если ЗначениеЗаполнено(ИмяКолонкиТипЗаписи) Тогда                             
				Если ПараметрыСлужебный.ТипЗаписиСтрокой Тогда
				    СтрокаДерева[ИмяКолонкиТипЗаписи] = ПараметрыСлужебный.ТипыЗаписиСтрокой[ТипЗаписи]; 
				Иначе
					СтрокаДерева[ИмяКолонкиТипЗаписи] = ТипЗаписи;
				КонецЕсли;
			КонецЕсли;
			Если ЗначениеЗаполнено(ИмяКолонкиУровень) Тогда
				СтрокаДерева[ИмяКолонкиУровень] = Уровень;
			КонецЕсли;
			ПараметрыСлужебный.ТекущиеСтроки = СтрокаДерева.Строки;
			
			Если ТипЗаписи = ТипЗаписиЗапроса.ИтогПоИерархии Тогда
				ВыборкаДочерние = Выборка.Выбрать(ТипОбхода, Группировка);
			Иначе
				ВыборкаДочерние = Выборка.Выбрать(ТипОбхода);
			КонецЕсли;
			ДеревоЗначенийИзРезультатаЗапроса(
				ВыборкаДочерние, 
				ТипОбхода, 
				ИмяКолонкиГруппировка,
				ИмяКолонкиТипЗаписи,
				ИмяКолонкиУровень,
				ПараметрыСлужебный
			);   
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда

		Если ТипОбхода = Неопределено Тогда
			ТипОбхода = ОбходРезультатаЗапроса.Прямой;
		КонецЕсли;
		
		Если ТипЗнч(ПараметрыСлужебный) <> Тип("Структура") Тогда
			ПараметрыСлужебный = Новый Структура;
		КонецЕсли;
		Если Не ПараметрыСлужебный.Свойство("ТипЗаписиСтрокой") Тогда
			ПараметрыСлужебный.Вставить("ТипЗаписиСтрокой", Ложь);		
		КонецЕсли; 
		Если ПараметрыСлужебный.ТипЗаписиСтрокой Тогда
			ТипыЗаписиСтрокой = Новый Соответствие;
			ТипыЗаписиСтрокой[ТипЗаписиЗапроса.ДетальнаяЗапись]		 = "ДетальнаяЗапись";
			ТипыЗаписиСтрокой[ТипЗаписиЗапроса.ИтогПоГруппировке]	 = "ИтогПоГруппировке";
			ТипыЗаписиСтрокой[ТипЗаписиЗапроса.ИтогПоИерархии]		 = "ИтогПоИерархии";
			ТипыЗаписиСтрокой[ТипЗаписиЗапроса.ОбщийИтог]			 = "ОбщийИтог";
			ПараметрыСлужебный.Вставить("ТипыЗаписиСтрокой", ТипыЗаписиСтрокой);
		КонецЕсли;
		
		Дерево = Новый ДеревоЗначений;
		Для каждого Колонка Из РезультатЗапроса.Колонки Цикл
			Дерево.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, , Колонка.Ширина);
		КонецЦикла;
		Если ЗначениеЗаполнено(ИмяКолонкиГруппировка) Тогда
			Дерево.Колонки.Добавить(ИмяКолонкиГруппировка, Новый ОписаниеТипов("Строка"));
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяКолонкиТипЗаписи) Тогда
			Дерево.Колонки.Добавить(ИмяКолонкиТипЗаписи);
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяКолонкиУровень) Тогда
			Дерево.Колонки.Добавить(ИмяКолонкиУровень, Новый ОписаниеТипов("Число"));
		КонецЕсли; 
		ПараметрыСлужебный.Вставить("Дерево", Дерево);
		ПараметрыСлужебный.Вставить("ТекущиеСтроки", Дерево.Строки);
		
		ДеревоЗначенийИзРезультатаЗапроса(
			РезультатЗапроса.Выбрать(ТипОбхода), 
			ТипОбхода, 
			ИмяКолонкиГруппировка,
			ИмяКолонкиТипЗаписи,
			ИмяКолонкиУровень,
			ПараметрыСлужебный
		);

		Возврат Дерево;

	Иначе

		ВызватьИсключение "Параметр РезультатЗапроса: Ожидается тип РезультатЗапроса";

	КонецЕсли;
	
КонецФункции // ДеревоЗначенийИзРезультатаЗапроса()      

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

// Перемещает строку дерева значений с подчиненными элементами.
//
// Параметры:
//  СтрокаДерева - СтрокаДереваЗначений			 - Копируемая строка дерева, вместе с подчиненными.
//  Размещение	 - КоллекцияСтрокДереваЗначений	 - Коллекция строк, в которой размещается копия ветви.
//												Если производится копирование в другое дерево, 
//												то его набор колонок и типов значений в них остаётся прежним.
//												Если совпадает с исходным размещением, то переноса не произойдёт.
//				 - Неопределено					 - Из строки будет создано новое дерево значений.
//
// Возвращаемое значение:
//   СтрокаДереваЗначений, ДеревоЗначений  - Скопированная строка или ветвь.
//
Функция ПереместитьСтрокуДереваЗначений(СтрокаДерева, Размещение = Неопределено) Экспорт
	
	Если ТипЗнч(Размещение) = Тип("КоллекцияСтрокДереваЗначений") Тогда

		НоваяСтрокаДерева = СкопироватьСтрокуДереваЗначений(СтрокаДерева, Размещение, Истина);
		Размещение.Строки.Удалить(СтрокаДерева);

		Возврат НоваяСтрокаДерева;

	ИначеЕсли Размещение = Неопределено Тогда

		Если ТипЗнч(СтрокаДерева) = Тип("СтрокаДереваЗначений") Тогда

			НовоеДерево = СкопироватьСтрокуДереваЗначений(СтрокаДерева, Неопределено, Истина);
			СтрокаДерева.Родитель().Строки.Удалить(СтрокаДерева);

			Возврат НовоеДерево;

		Иначе

			ВызватьИсключение "Параметр СтрокаДерева: Неожиданный тип значения";
	
		КонецЕсли;

	Иначе

		ВызватьИсключение "Параметр Размещение: Неожиданный тип значения";
	
	КонецЕсли;

КонецФункции

// Копирует строку дерева значений с подчиненными элементами.
//
// Параметры:
//  СтрокаДерева - СтрокаДереваЗначений			 - Копируемая строка дерева, вместе с подчиненными.
//  Размещение	 - КоллекцияСтрокДереваЗначений	 - Коллекция строк, в которой размещается копия ветви.
//												Если производится копирование в другое дерево, 
//												то его набор колонок и типов значений в них остаётся прежним.
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

			ВызватьИсключение "Параметр СтрокаДерева: Неожиданный тип значения";
	
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

		ЭтоЛист = Не ЗначениеЗаполнено(Ветвь.Строки);

		Если ЭтоЛист Или Не ТолькоЛистья Тогда
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
