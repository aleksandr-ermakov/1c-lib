
// Формирует представление дерева значений в форме табличного документа средствами СКД
//
// Параметры:
//  ДеревоЗначений	 - ДеревоЗначений	 
// 
// Возвращаемое значение:
//  ТабличныйДокумент
//
Функция ТабличныйДокументИзДереваЗначений(ДеревоЗначений) Экспорт

	ИмяПоляИдентификатор			= "Идентификатор";
	ИмяПоляИдентификаторРодитель	= "ИдентификаторРодитель";
	ИмяПоляИдентификаторЭтоГруппа	= "ИдентификаторЭтоГруппа";
	
	// Подбираем префикс к служебным полям (вдруг, имена полей заняты)
	#Область ИменаСлужебныхПолей
	ИменаСлужебныхПолей = Новый Массив;
	ИменаСлужебныхПолей.Добавить(ИмяПоляИдентификатор);
	ИменаСлужебныхПолей.Добавить(ИмяПоляИдентификаторРодитель);
	ИменаСлужебныхПолей.Добавить(ИмяПоляИдентификаторЭтоГруппа);
	
	Префикс = "";
	ПодбиратьПрефикс = Истина;
	ИменаКолонок = Новый Массив;
	Для каждого Колонка Из ДеревоЗначений.Колонки Цикл
		ИменаКолонок.Добавить(Колонка.Имя);
	КонецЦикла; 
	Пока ПодбиратьПрефикс Цикл
		ПодбиратьПрефикс = Ложь;
		Для каждого ИмяСлужебногоПоля Из ИменаСлужебныхПолей Цикл
			ПодбиратьПрефикс = ПодбиратьПрефикс Или ИменаКолонок.Найти(ИмяСлужебногоПоля) <> Неопределено;
		КонецЦикла; 
		Если ПодбиратьПрефикс Тогда 
			Префикс = Префикс + "_";
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	Для Индекс = 0 По ИменаСлужебныхПолей.ВГраница() Цикл
		ИменаСлужебныхПолей.Установить(Индекс, Префикс + ИменаСлужебныхПолей[Индекс]);
	КонецЦикла; 
	ИмяПоляИдентификатор			= ИменаСлужебныхПолей[0];
	ИмяПоляИдентификаторРодитель	= ИменаСлужебныхПолей[1];
	ИмяПоляИдентификаторЭтоГруппа	= ИменаСлужебныхПолей[2];
	#КонецОбласти	// ИменаСлужебныхПолей 
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	Для каждого Колонка Из ДеревоЗначений.Колонки Цикл
		ТаблицаДанных.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина);		
	КонецЦикла; 
	ТаблицаДанных.Колонки.Добавить(
		ИмяПоляИдентификатор,			Новый ОписаниеТипов("Число"),	"Идентификатор (служебная)");
	ТаблицаДанных.Колонки.Добавить(
		ИмяПоляИдентификаторРодитель,	Новый ОписаниеТипов("Число"),	"Идентификатор-Родитель (служебная)");
	ТаблицаДанных.Колонки.Добавить(
		ИмяПоляИдентификаторЭтоГруппа,	Новый ОписаниеТипов("Булево"),	"Идентификатор является группой (служебная)");
	
	// Раскладываем дерево значений в таблицу значений.
	// В таблице значений заполняем служебные поля для сбора структуры через СКД.
	#Область ПодготовкаТаблицы
		
	СтекИндексов	= Новый Массив;
	СтекКоллекций	= Новый Массив;
	СтекГраниц		= Новый Массив;
	СтекРодителей	= Новый Массив;
	ТекИндекс		= -1;
	ТекКоллекция	= ДеревоЗначений.Строки;
	ТекГраница		= ДеревоЗначений.Строки.Количество() - 1;
	ТекРодитель		= 0;
	ГраницаСтека	= -1;
	НомерСтроки		= 0;
	Если ЗначениеЗаполнено(ТекКоллекция) Тогда
	
		Пока ТекИндекс < ТекГраница Цикл
			
			ТекИндекс = ТекИндекс + 1;
			
			НомерСтроки = НомерСтроки + 1;
			
			ПозицияДерева	= ТекКоллекция[ТекИндекс];
			ПозицияТаблицы	= ТаблицаДанных.Добавить();
			
			ЗаполнитьЗначенияСвойств(ПозицияТаблицы, ПозицияДерева);
			
			ПозицияТаблицы[ИмяПоляИдентификатор]			= НомерСтроки;
			ПозицияТаблицы[ИмяПоляИдентификаторРодитель]	= ТекРодитель;
			
			Если ЗначениеЗаполнено(ПозицияДерева.Строки) Тогда
				
				ПозицияТаблицы[ИмяПоляИдентификаторЭтоГруппа] = Истина;
				
				#Область ПомещениеВСтек
				СтекИндексов.Добавить(ТекИндекс);
				СтекКоллекций.Добавить(ТекКоллекция);
				СтекГраниц.Добавить(ТекГраница);
				СтекРодителей.Добавить(ТекРодитель);
				ГраницаСтека = ГраницаСтека + 1;
				ТекИндекс = -1;
				ТекКоллекция	= ПозицияДерева.Строки;
				ТекГраница		= ПозицияДерева.Строки.Количество() - 1;
				ТекРодитель		= ПозицияТаблицы[ИмяПоляИдентификатор];
				#КонецОбласти	// ПомещениеВСтек 
				
			КонецЕсли; 
			
			Пока ТекИндекс = ТекГраница и ГраницаСтека >= 0 Цикл
			
				#Область Извлечение
				ТекИндекс		= СтекИндексов[ГраницаСтека];
				ТекКоллекция	= СтекКоллекций[ГраницаСтека];
				ТекГраница		= СтекГраниц[ГраницаСтека];
				ТекРодитель		= СтекРодителей[ГраницаСтека];
				СтекИндексов.Удалить(ГраницаСтека);
				СтекКоллекций.Удалить(ГраницаСтека);
				СтекГраниц.Удалить(ГраницаСтека);
				СтекРодителей.Удалить(ГраницаСтека);
				ГраницаСтека	= ГраницаСтека - 1;
				#КонецОбласти	// Извлечение 
			
			КонецЦикла; 
		
		КонецЦикла; 
	
	КонецЕсли; 
	
	#КонецОбласти	// ПодготовкаТаблицы 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	#Область Компоновка
	ИмяНабора = "ТаблицаДанных";
	ВнешниеНаборыДанных = Новый Структура(ИмяНабора, ТаблицаДанных);
	
	Схема = Новый СхемаКомпоновкиДанных;
	ИсточникДанныхСхемы = Схема.ИсточникиДанных.Добавить();
	ИсточникДанныхСхемы.СтрокаСоединения	= "Local";
	ИсточникДанныхСхемы.ТипИсточникаДанных	= "Local";
	ИсточникДанныхСхемы.Имя					= "Local";
	
	НаборДанных = Схема.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанных.Имя				= ИмяНабора;
	НаборДанных.ИсточникДанных	= ИсточникДанныхСхемы.Имя;
	НаборДанных.ИмяОбъекта		= ИмяНабора;
	Для каждого Колонка Из ТаблицаДанных.Колонки Цикл
		ПолеДанных				= НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеДанных.Поле			= Колонка.Имя;
		ПолеДанных.ПутьКДанным	= Колонка.Имя;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
		ПолеДанных.Заголовок	= Колонка.Заголовок;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
		Если ПолеДанных.Поле		= ИмяПоляИдентификатор
			Или ПолеДанных.Поле	= ИмяПоляИдентификаторРодитель Тогда
			ПолеДанных.Роль.Обязательное = Истина;		
		КонецЕсли; 
	КонецЦикла; 
	
	Связь = Схема.СвязиНаборовДанных.Добавить();
	Связь.НаборДанныхИсточник	= НаборДанных.Имя;
	Связь.НаборДанныхПриемник	= НаборДанных.Имя;
	Связь.ВыражениеИсточник		= ИмяПоляИдентификатор;
	Связь.ВыражениеПриемник		= ИмяПоляИдентификаторРодитель;
	Связь.НачальноеВыражение	= "0";
	Связь.УсловиеСвязи			= ИмяПоляИдентификаторЭтоГруппа;	// Связь только ко групповым полям
	
	Вариант = Схема.ВариантыНастроек[0];
	
	Структура = Вариант.Настройки.Структура;
	
	ГруппировкаКомпоновки	= Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпоновки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Для каждого ПолеДанных Из НаборДанных.Поля Цикл
		
		Если ИменаСлужебныхПолей.Найти(ПолеДанных.Поле) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;	// Служебные поля не выводим
		
		ВыбранноеПоле	= Вариант.Настройки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле	= Вариант.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле	= Новый ПолеКомпоновкиДанных(ПолеДанных.Поле);

	КонецЦикла; 
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Схема, Схема.НастройкиПоУмолчанию, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, ВнешниеНаборыДанных, ДанныеРасшифровки);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	#КонецОбласти	// Компоновка 
	
	// В каждой ячейке определяем расшифровку
	#Область Расшифровка
	Для НомерСтроки = 2 по ТабличныйДокумент.ВысотаТаблицы Цикл
		
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			Расшифровка = Область.Расшифровка;
			Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
				ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];
				Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") 
					И ЭлементРасшифровки.ОсновноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
					ПоляРасшифровки = ЭлементРасшифровки.ПолучитьПоля();
					Если ЗначениеЗаполнено(ПоляРасшифровки) Тогда
						Область.Расшифровка	= ПоляРасшифровки[0].Значение;						
					КонецЕсли; 
				КонецЕсли; 		
			КонецЕсли; 
		КонецЦикла; 
	
	КонецЦикла;  
	#КонецОбласти	// Расшифровка 
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции // ТабличныйДокументИзДереваЗначений()

// Формирует табличное представление таблицы значений
//
// Параметры:
//	ТаблицаЗначений			 - ТаблицаЗначений
//	ЗаголовокИзИмениКолонки	 - Булево - Если Истина, в заголовке колонки будет выведено её имя.
//										В противном случае - указанный в колонке загловок, 
//										или интерпретация имени колонки, если загловок не указан.
//
// Возвращаемое значение:
//	ТабличныйДокумент
//
Функция ТабличныйДокументИзТаблицыЗначений(ТаблицаЗначений, ЗаголовокИзИмениКолонки = Ложь) Экспорт

	Схема = Новый СхемаКомпоновкиДанных;
	ИсточникДанныхСхемы = Схема.ИсточникиДанных.Добавить();
	ИсточникДанныхСхемы.ТипИсточникаДанных	= "Local";
	ИсточникДанныхСхемы.Имя					= "Локальный";
	
	ИмяНабора = "ТаблицаДанных";
	
	НаборДанных = Схема.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанных.Имя				= ИмяНабора;
	НаборДанных.ИсточникДанных	= ИсточникДанныхСхемы.Имя;
	НаборДанных.ИмяОбъекта		= ИмяНабора;
	
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		ПолеДанных				= НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеДанных.Поле			= Колонка.Имя;
		ПолеДанных.ПутьКДанным	= Колонка.Имя;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
		Если ЗаголовокИзИмениКолонки Тогда
			ПолеДанных.Заголовок = Колонка.Имя;
		Иначе
			ПолеДанных.Заголовок	= Колонка.Заголовок;
		КонецЕсли;
	КонецЦикла;
	
	#Область Структура

	Вариант = Схема.ВариантыНастроек[0];
	Структура = Вариант.Настройки.Структура;
	ГруппировкаКомпоновки	= Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпоновки.ПоляГруппировки.Элементы.Добавить(Тип("АвтоПолеГруппировкиКомпоновкиДанных"));
	ГруппировкаКомпоновки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ВыбранныеПоля = Вариант.Настройки.Выбор.Элементы;
	Для каждого ПолеДанных Из НаборДанных.Поля Цикл
		ВыбранноеПоле	= ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле	= Новый ПолеКомпоновкиДанных(ПолеДанных.Поле);
	КонецЦикла; 

	#КонецОбласти // Структура

	#Область Компоновка
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	Макет = КомпоновщикМакета.Выполнить(Схема, Схема.НастройкиПоУмолчанию, ДанныеРасшифровки);

	ВнешниеНаборыДанных = Новый Структура(ИмяНабора, ТаблицаЗначений);
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, ВнешниеНаборыДанных, ДанныеРасшифровки);

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	#КонецОбласти // Компоновка

	// В каждой ячейке определяем расшифровку
	#Область Расшифровка
	Для НомерСтроки = 2 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			Расшифровка = Область.Расшифровка;
			Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
				ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];
				Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") 
					И ЭлементРасшифровки.ОсновноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
					ПоляРасшифровки = ЭлементРасшифровки.ПолучитьПоля();
					Если ЗначениеЗаполнено(ПоляРасшифровки) Тогда
						Область.Расшифровка	= ПоляРасшифровки[0].Значение;						
					КонецЕсли; 
				КонецЕсли; 		
			КонецЕсли; 

		КонецЦикла; 
	КонецЦикла;  
	#КонецОбласти	// Расшифровка 

	Возврат ТабличныйДокумент;

КонецФункции // ТабличныйДокументИзТаблицыЗначений()

// Располагает рисунки табличного документа по сетке, в несколько столбцов и строк.
// Порядок расположения - слева направо, сверху вниз.
//
// Параметры:
//  КоллекцияРисунков				 - Произвольный	 - Коллекция объектов типа РисунокТабличногоДокумента
//  КоличествоСтолбцов				 - Число	 - Количество столбцов, по которым распределяются рисунки
//  ВертикальныйИнтервал			 - Число	 - Интервал между рисунками
//  ГоризонтальныйИнтервал			 - Число	 - Интервал между рисунками 
//  ВертикальноеПоложениеРисунков	 - ВеритикальноеПоложение	 - Выравнивание рисунков по сетке
//  ГоризонтальноеПоложениеРисунков	 - ГоризонтальноеПоложение	 - Выравнивание рисунков по сетке 
//
Процедура РасположитьРисункиТабличногоДокументаПоСтолбцам(
	Знач КоллекцияРисунков, 
	КоличествоСтолбцов = 2, 
	ВертикальныйИнтервал = 12, 
	ГоризонтальныйИнтервал = 12, 
	ВертикальноеПоложениеРисунков = Неопределено, 
	ГоризонтальноеПоложениеРисунков = Неопределено)
	
	//Ряды = ДвумерныйМассив(КоллекцияРисунков, КоличествоСтолбцов);
	ИсходнаяКоллекция = КоллекцияРисунков;
	РазмерВложенногоМассива = КоличествоСтолбцов;
	#Область ДвумерныйМассив
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
	#КонецОбласти // ДвумерныйМассив 
	Ряды = ДвумерныйМассив;	
	
	Если ТипЗнч(ВертикальноеПоложениеРисунков) <> Тип("ВертикальноеПоложение") Тогда
		ВертикальноеПоложениеРисунков	 = ВертикальноеПоложение.Верх;
	КонецЕсли; 
	Если ТипЗнч(ГоризонтальноеПоложениеРисунков) <> Тип("ГоризонтальноеПоложение") Тогда
		ГоризонтальноеПоложениеРисунков	 = ГоризонтальноеПоложение.Авто;
	КонецЕсли; 
	
	МаксВысотыРядов		 = Новый Соответствие;	// {Индекс ряда, Высота:Число}
	МаксШириныСтолбцов	 = Новый Соответствие;	// {Индекс столбца, Ширина:Число}
	
	// Определяем максимальные высоты рядов и ширины столбцов:
	Для ИндексРяда = 0 по Ряды.ВГраница() Цикл
		Ряд = Ряды[ИндексРяда];
		МаксВысотыРядов.Вставить(ИндексРяда, 0);		
		Если ИндексРяда = 0 Тогда
			Для ИндексСтолбца = 0 По Ряд.ВГраница() Цикл
				МаксШириныСтолбцов.Вставить(ИндексСтолбца, 0);	
			КонецЦикла; 
		КонецЕсли; 
		Для ИндексСтолбца = 0 По Ряд.ВГраница() Цикл
			ТекущийРисунок = Ряд[ИндексСтолбца];
			МаксВысотыРядов.Вставить(ИндексРяда,		 Макс(МаксВысотыРядов[ИндексРяда],		 ТекущийРисунок.Высота));
			МаксШириныСтолбцов.Вставить(ИндексСтолбца,	 Макс(МаксШириныСтолбцов[ИндексСтолбца], ТекущийРисунок.Ширина));
		КонецЦикла; 
	КонецЦикла; 
	
	// Расставляем элементы:
	Для ИндексРяда = 0 по Ряды.ВГраница() Цикл
		ТекущийРяд = Ряды[ИндексРяда];
		
		Для ИндексСтолбца = 0 По ТекущийРяд.ВГраница() Цикл
			ТекущийРисунок = ТекущийРяд[ИндексСтолбца];
			
			ПервыйРисунокРяда = ТекущийРяд[0];
			
			// Начинаем ряд сразу за следующим:
			Если ИндексРяда > 0 и ТекущийРисунок = ПервыйРисунокРяда Тогда
				ТекущийРисунок.Верх = Ряды[0][0].Верх + МаксВысотыРядов[ИндексРяда] + ВертикальныйИнтервал;
				ТекущийРисунок.Лево = Ряды[0][0].Лево;		// На всякий случай
			КонецЕсли; 
			
			// Смещение по вертикали в рамках сетки:
			ВысотаРяда = МаксВысотыРядов[ИндексРяда];
			Если ВертикальноеПоложениеРисунков = ВертикальноеПоложение.Верх Тогда
				ТекущийРисунок.Верх = ПервыйРисунокРяда.Верх;
				
			ИначеЕсли ВертикальноеПоложениеРисунков = ВертикальноеПоложение.Низ Тогда
				ТекущийРисунок.Верх = ПервыйРисунокРяда.Верх + ВысотаРяда - ТекущийРисунок.Высота;
				
			ИначеЕсли ВертикальноеПоложениеРисунков = ВертикальноеПоложение.Центр Тогда
				ТекущийРисунок.Верх = ПервыйРисунокРяда.Верх + (ВысотаРяда - ТекущийРисунок.Высота) / 2;
				
			КонецЕсли; 
			
			// Смещение по горизонтали в рамках сетки:
			ШиринаСтолбца = МаксШириныСтолбцов[ИндексСтолбца];
			Если ГоризонтальноеПоложениеРисунков = ГоризонтальноеПоложение.Лево
				Или ГоризонтальноеПоложениеРисунков = ГоризонтальноеПоложение.Авто
				Или ГоризонтальноеПоложениеРисунков = ГоризонтальноеПоложение.ПоШирине Тогда
				
				ТекущийРисунок.Лево = ПервыйРисунокРяда.Лево + (ШиринаСтолбца + ГоризонтальныйИнтервал) * ИндексСтолбца;
				
				Если ГоризонтальноеПоложениеРисунков = ГоризонтальноеПоложение.ПоШирине Тогда
					ТекущийРисунок.Ширина = ШиринаСтолбца
				КонецЕсли; 
				
			ИначеЕсли ГоризонтальноеПоложениеРисунков = ГоризонтальноеПоложение.Право Тогда
				ТекущийРисунок.Лево = ПервыйРисунокРяда.Лево 
				+ (ШиринаСтолбца + ГоризонтальныйИнтервал) * ИндексСтолбца 
				+ ШиринаСтолбца 
				- ТекущийРисунок.Ширина;
				
			ИначеЕсли ГоризонтальноеПоложениеРисунков = ГоризонтальноеПоложение.Центр Тогда
				ТекущийРисунок.Лево = ПервыйРисунокРяда.Лево 
				+ (ШиринаСтолбца + ГоризонтальныйИнтервал) * ИндексСтолбца  
				+ (ШиринаСтолбца - ТекущийРисунок.Ширина) / 2;
				
			КонецЕсли; 
			
		КонецЦикла; 
	КонецЦикла;

КонецПроцедуры


