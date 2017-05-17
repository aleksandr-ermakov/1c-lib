 

// Формирует представление дерева значений в форме табличного документа средствами СКД
//
// Параметры:
//  ДеревоЗначений	 - ДеревоЗначений	 
// 
// Возвращаемое значение:
//  ТабличныйДокумент
//
Функция ДеревоЗначенийВТабличныйДокумент(ДеревоЗначений) Экспорт

	Если Ложь Тогда ДеревоЗначений = Новый ДеревоЗначений КонецЕсли; 
	
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
	ТаблицаДанных.Колонки.Добавить(ИмяПоляИдентификатор,			новый ОписаниеТипов("Число"), "Идентификатор (служебная)");
	ТаблицаДанных.Колонки.Добавить(ИмяПоляИдентификаторРодитель,	новый ОписаниеТипов("Число"), "Идентификатор-Родитель (служебная)");
	
	#Область ПодготовкаТаблицы
		
	СтэкИндексов	= Новый Массив;
	СтэкКоллекций	= Новый Массив;
	СтэкГраниц		= Новый Массив;
	СтэкРодителей	= Новый Массив;
	ТекИндекс		= -1;
	ТекКоллекция	= ДеревоЗначений.Строки;
	ТекГраница		= ДеревоЗначений.Строки.Количество() - 1;
	ТекРодитель		= 0;
	ГраницаСтэка	= -1;
	НомерСтроки		= 0;
	Если ЗначениеЗаполнено(ТекКоллекция) Тогда
	
		Для ТекИндекс = 0 По ТекГраница Цикл
			
			НомерСтроки = НомерСтроки + 1;
			
			ПозицияДерева	= ТекКоллекция[ТекИндекс];
			ПозицияТаблицы	= ТаблицаДанных.Добавить();
			
			ЗаполнитьЗначенияСвойств(ПозицияТаблицы, ПозицияДерева);
			
			ПозицияТаблицы[ИмяПоляИдентификатор]			= НомерСтроки;
			ПозицияТаблицы[ИмяПоляИдентификаторРодитель]	= ТекРодитель;
			
			Если ЗначениеЗаполнено(ПозицияДерева.Строки) Тогда
				
				#Область ПомещениеВСтэк
				СтэкИндексов.Добавить(ТекИндекс);
				СтэкКоллекций.Добавить(ТекКоллекция);
				СтэкГраниц.Добавить(ТекГраница);
				СтэкРодителей.Добавить(ТекРодитель);
				ГраницаСтэка = ГраницаСтэка + 1;
				ТекИндекс = -1;
				ТекКоллекция	= ПозицияДерева.Строки;
				ТекГраница		= ПозицияДерева.Строки.Количество() - 1;
				ТекРодитель		= ПозицияТаблицы[ИмяПоляИдентификатор];
				#КонецОбласти	// ПомещениеВСтэк 
				
			КонецЕсли; 
			
			Пока ТекИндекс = ТекГраница и ГраницаСтэка >= 0 Цикл
			
				#Область Извлечение
				ТекИндекс		= СтэкИндексов[ГраницаСтэка];
				ТекКоллекция	= СтэкКоллекций[ГраницаСтэка];
				ТекГраница		= СтэкГраниц[ГраницаСтэка];
				ТекРодитель		= СтэкРодителей[ГраницаСтэка];
				СтэкИндексов.Удалить(ГраницаСтэка);
				СтэкКоллекций.Удалить(ГраницаСтэка);
				СтэкГраниц.Удалить(ГраницаСтэка);
				СтэкРодителей.Удалить(ГраницаСтэка);
				ГраницаСтэка	= ГраницаСтэка - 1;
				#КонецОбласти	// Извлечение 
			
			КонецЦикла; 
		
		КонецЦикла; 
	
	КонецЕсли; 
	
	#КонецОбласти	// ПодготовкаТаблицы 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Компонуем по методологии, изложенной на ИТС в статье "Работа с иерархическими детальными записями" (https://its.1c.ru/db/metod8dev#content:2498)
	#Область Компоновка
	ВнешниеНаборыДанных = Новый Структура("ТаблицаДанных", ТаблицаДанных);
	
	Схема = Новый СхемаКомпоновкиДанных;
	ИсточникДанныхСхемы = Схема.ИсточникиДанных.Добавить();
	ИсточникДанныхСхемы.СтрокаСоединения	= "Local";
	ИсточникДанныхСхемы.ТипИсточникаДанных	= "Local";
	ИсточникДанныхСхемы.Имя					= "Local";
	
	НаборДанных = Схема.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанных.Имя				= "ТаблицаДанных";
	НаборДанных.ИсточникДанных	= ИсточникДанныхСхемы.Имя;
	НаборДанных.ИмяОбъекта		= "ТаблицаДанных";
	Для каждого Колонка Из ТаблицаДанных.Колонки Цикл
		ПолеДанных				= НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеДанных.Поле			= Колонка.Имя;
		ПолеДанных.ПутьКДанным	= Колонка.Имя;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
		ПолеДанных.Заголовок	= Колонка.Заголовок;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
		Если ПолеДанных.Поле		= ИмяПоляИдентификатор Тогда
			ПолеДанных.Роль.Обязательное = Истина;		
		ИначеЕсли ПолеДанных.Поле	= ИмяПоляИдентификаторРодитель Тогда
			ПолеДанных.Роль.Обязательное = Истина;		
		КонецЕсли; 
	КонецЦикла; 
	
	Связь = Схема.СвязиНаборовДанных.Добавить();
	Связь.НаборДанныхИсточник	= НаборДанных.Имя;
	Связь.НаборДанныхПриемник	= НаборДанных.Имя;
	Связь.ВыражениеИсточник		= ИмяПоляИдентификатор;
	Связь.ВыражениеПриемник		= ИмяПоляИдентификаторРодитель;
	Связь.НачальноеВыражение	= "0";
	
	Вариант = Схема.ВариантыНастроек[0];
	
	Структура = Вариант.Настройки.Структура;
	
	Группировка	= Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("АвтоПолеГруппировкиКомпоновкиДанных"));
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Для каждого ПолеДанных Из НаборДанных.Поля Цикл
		
		Если ПолеДанных.Поле = ИмяПоляИдентификатор			Тогда Продолжить КонецЕсли;	// Идентификаторы не выводим 
		Если ПолеДанных.Поле = ИмяПоляИдентификаторРодитель	Тогда Продолжить КонецЕсли;	// Идентификаторы не выводим 
		
		ВыбранноеПоле	= Вариант.Настройки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле	= Вариант.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле	= Новый ПолеКомпоновкиДанных(ПолеДанных.Поле);
	КонецЦикла; 
	
	КомпоновщикМакета = новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровки = новый ДанныеРасшифровкиКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Схема, Схема.НастройкиПоУмолчанию, ДанныеРасшифровки);
	ПроцессорКомпоновки = новый ПроцессорКомпоновкиДанных;
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
				Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") и ЭлементРасшифровки.ОсновноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
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

КонецФункции // ДеревоЗначенийВТабличныйДокумент()
 


