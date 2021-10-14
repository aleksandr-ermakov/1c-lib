// Получает таблицу значений по набору данных схемы компоновки или макета компоновки данных
//
// Параметры:
//  НаборДанных				 - Строка, НаборДанныхОбъектСхемыКомпоновкиДанных, НаборДанныхОбъектМакетаКомпоновкиДанных	 - Набор - источник колонок таблицы.
//		Если указана Строка, производится поиск набора данных в КоллекцияНаборовДанных по имени объекта
//  КоллекцияНаборовДанных	 - НаборыДанныхСхемыКомпоновкиДанных, НаборыДанныхМакетаКомпоновкиДанных, Массив	 - Коллекция наборов данных, доступная к перебору циклом.
//		Указывается, если производится поиск набора.
// Вариант вызова:
//		НовыйТаблицаЗначенийПоНаборуДанных(Строка, НаборыДанныхСхемыКомпоновкиДанных)	 - Поиск набора данных по имени объекта.
//		НовыйТаблицаЗначенийПоНаборуДанных(НаборДанныхОбъектСхемыКомпоновкиДанных)		 - Формирование таблицы по указанному набору.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица, сформированная по набору. Если найбор не найден, будет возвращено Неопределено.
//
Функция НовыйТаблицаЗначенийПоНаборуДанных(Знач НаборДанных, КоллекцияНаборовДанных = Неопределено)
	
	Если ТипЗнч(НаборДанных) <> Тип("Строка")
		И ТипЗнч(НаборДанных) <> Тип("НаборДанныхОбъектСхемыКомпоновкиДанных") 
		И ТипЗнч(НаборДанных) <> Тип("НаборДанныхОбъектМакетаКомпоновкиДанных") Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Если ТипЗнч(НаборДанных) = Тип("Строка") Тогда
		// Поиск по имени объекта
	
		Для каждого ТекущийНаборДанных Из КоллекцияНаборовДанных Цикл
			Если ТипЗнч(ТекущийНаборДанных) = Тип("НаборДанныхОбъектСхемыКомпоновкиДанных")
				Или ТипЗнч(ТекущийНаборДанных) = Тип("НаборДанныхОбъектМакетаКомпоновкиДанных")
				И ТекущийНаборДанных.ИмяОбъекта = НаборДанных Тогда
				
				НаборДанных = ТекущийНаборДанных;					
							
			    Прервать;
				
			ИначеЕсли ТипЗнч(ТекущийНаборДанных) = Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных")
				Или ТипЗнч(ТекущийНаборДанных) = Тип("НаборДанныхОбъединениеМакетаКомпоновкиДанных") Тогда
				
				ТаблицаПоНабору = НовыйТаблицаЗначенийПоНаборуДанных(НаборДанных, ТекущийНаборДанных.Элементы);	// Рекурсивный вызов для дочернего набора
				Если ТипЗнч(ТаблицаПоНабору) = Тип("ТаблицаЗначений") Тогда
					Возврат ТаблицаПоНабору;
				КонецЕсли; 
				
			КонецЕсли; 	
		КонецЦикла; 
	
	КонецЕсли; 
	
	ТаблицаПоНабору = Неопределено;
	
	Если ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъектСхемыКомпоновкиДанных") 
		Или ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъектМакетаКомпоновкиДанных") Тогда
		
		ТаблицаПоНабору = Новый ТаблицаЗначений;
		Для каждого ПолеНабора Из НаборДанных.Поля Цикл
			
			Если ТипЗнч(ПолеНабора) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных")
				или  ТипЗнч(ПолеНабора) = Тип("ПолеНабораДанныхМакетаКомпоновкиДанных") Тогда
				
				ТаблицаПоНабору.Колонки.Добавить(ПолеНабора.Поле, ПолеНабора.ТипЗначения, ПолеНабора.Заголовок);	
				
			КонецЕсли; 
		
		КонецЦикла; 
		
	КонецЕсли;  
	
	Возврат ТаблицаПоНабору;

КонецФункции // НовыйТаблицаЗначенийПоНаборуДанных()

// Изменяет Тип колонки таблицы значений.
//  Порядок колонок и индексы таблицы сохраняются.
//
// Параметры:
//  ТаблицаЗначений				 - ТаблицаЗначений				 - Изменяемая таблица
//  Колонка						 - Строка						 - Имя изменяемой колонка
//								 - КолонкаТаблицыЗначений		 - Изменияемая колонка
//								 - Число						 - Индекс изменяемой колонки
//  ДобавляемыеТипы				 - Массив						 - Массив типов. Элемент: Тип
//								 - Строка						 - Типы через запятую
//  ВычитаемыеТипы				 - Массив						 - Массив типов. Элемент: Тип
//								 - Строка						 - Типы через запятую
//  КвалификаторыЧисла			 - КвалификаторыЧисла			 - Новые квалификаторы значений
//  КвалификаторыСтроки			 - КвалификаторыСтроки			 - Новые квалификаторы значений 
//  КвалификаторыДаты			 - КвалификаторыДаты			 - Новые квалификаторы значений
//  КвалификаторыДвоичныхДанных	 - КвалификаторыДвоичныхДанных	 - Новые квалификаторы значений
//
Процедура ИзменитьТипКолонкиТаблицыЗначений(ТаблицаЗначений, 
	Знач Колонка, 
	Знач ДобавляемыеТипы		 = Неопределено, 
	Знач ВычитаемыеТипы			 = Неопределено,
	КвалификаторыЧисла			 = Неопределено,
	КвалификаторыСтроки			 = Неопределено,
	КвалификаторыДаты			 = Неопределено,
	КвалификаторыДвоичныхДанных	 = Неопределено
	)

	Если Ложь Тогда 
		ТаблицаЗначений = Новый ТаблицаЗначений;
		Колонка = ТаблицаЗначений.Колонки[0];
	КонецЕсли;
	
	#Область ПараметрКолонка
	Если ТипЗнч(Колонка) = Тип("КолонкаТаблицыЗначений") Тогда
		// Ничего
		ИндексКолонки = ТаблицаЗначений.Колонки.Индекс(Колонка);
		Если ИндексКолонки = -1 Тогда
			ВызватьИсключение "Параметр Колонка: Колонка не принадлежит таблице";
		КонецЕсли; 
	ИначеЕсли ТипЗнч(Колонка) = Тип("Строка") Тогда
		Колонка = ТаблицаЗначений.Колонки.Найти(Колонка);
		Если Колонка = Неопределено Тогда
			ВызватьИсключение "Параметр Колонка: Нет колонки с указанным именем";
		КонецЕсли; 
		ИндексКолонки = ТаблицаЗначений.Колонки.Индекс(Колонка);
	ИначеЕсли ТипЗнч(Колонка) = Тип("Число") Тогда
		ИндексКолонки = Колонка;
		Если ИндексКолонки >= ТаблицаЗначений.Колонки.Количество() Тогда
			ВызватьИсключение "Параметр Колонка: Индекс колонки больше максимального";
		КонецЕсли; 
		Колонка = ТаблицаЗначений.Колонки[ИндексКолонки];
	Иначе
		ВызватьИсключение "Параметр Колонка: Ожидается Строка, Число, или КолонкаТаблицыЗначений";
	КонецЕсли; 
	#КонецОбласти // ПараметрКолонка 

	#Область УдалениеИндексов
	Индексы = Новый Массив;	// Массив строковых представлений индексов, которые нужно удалить, затем восстановить
	УдаляемыеИндексы = Новый Массив;
	Для каждого ИндексТаблицы Из ТаблицаЗначений.Индексы Цикл
		СоставИндекса = Новый Массив;
		УдалитьИндекс = Ложь;
		Для каждого ИмяКолонкиИндекса Из ИндексТаблицы Цикл
			СоставИндекса.Добавить(ИмяКолонкиИндекса);
			УдалитьИндекс = УдалитьИндекс Или Колонка.Имя = ИмяКолонкиИндекса;
		КонецЦикла; 
		Если УдалитьИндекс Тогда
			Индексы.Добавить(СтрСоединить(СоставИндекса, ", "));	// Запоминаем состав для восстановления
			УдаляемыеИндексы.Добавить(ИндексТаблицы);
		КонецЕсли; 
	КонецЦикла; 
	Для каждого Индекс Из УдаляемыеИндексы Цикл
		ТаблицаЗначений.Индексы.Удалить(Индекс);
	КонецЦикла; 
	#КонецОбласти // УдалениеИндексов 
	
	#Область ДобавлениеКолонки
	ОписаниеТиповНовойКолонки = Новый ОписаниеТипов(
		Колонка.ТипЗначения,
		ДобавляемыеТипы,
		ВычитаемыеТипы,
		КвалификаторыЧисла,
		КвалификаторыСтроки,
		КвалификаторыДаты,
		КвалификаторыДвоичныхДанных);
	НоваяКолонка = ТаблицаЗначений.Колонки.Добавить(, ОписаниеТиповНовойКолонки, Колонка.Заголовок, Колонка.Ширина);
	МаксИндексКолонок = ТаблицаЗначений.Колонки.Количество() - 1;
	ТаблицаЗначений.ЗагрузитьКолонку(ТаблицаЗначений.ВыгрузитьКолонку(Колонка), НоваяКолонка);
	ТаблицаЗначений.Колонки.Сдвинуть(НоваяКолонка, 	ИндексКолонки - МаксИндексКолонок + 1);
	ИмяКолонки = Колонка.Имя;
	ТаблицаЗначений.Колонки.Удалить(Колонка);
	НоваяКолонка.Имя = ИмяКолонки;
	#КонецОбласти // ДобавлениеКолонки 	
	
	#Область ВосстановлениеИндексов
	Для каждого СоставИндекса Из Индексы Цикл
		ТаблицаЗначений.Индексы.Добавить(СоставИндекса);	
	КонецЦикла; 	
	#КонецОбласти // ВосстановлениеИндексов 

КонецПроцедуры	// ИзменитьТипКолонкиТаблицыЗначений()

Процедура ИзменитьТипКолонкиТаблицыЗначений_Автотест()

	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("Число",			 Новый ОписаниеТипов("Число"));
	ТаблицаЗначений.Колонки.Добавить("Идентификатор",	 Новый ОписаниеТипов("УникальныйИдентификатор"));
	ТаблицаЗначений.Колонки.Добавить("Дата",			 Новый ОписаниеТипов("Дата"));
	
	#Область Заполнение
	
	Генератор = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	СтрокТаблицы = 9999;
	МаксЧисло = pow(2, 24);
	СекундВГоду = КонецГода(ТекущаяДатаСеанса()) - НачалоГода(ТекущаяДатаСеанса());
	НачалоГода = НачалоГода(ТекущаяДатаСеанса());
	
	Для НомерСтроки = 1 По СтрокТаблицы Цикл
		
		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		СтрокаТаблицы.Число			 = Генератор.СлучайноеЧисло(0, МаксЧисло);
		СтрокаТаблицы.Идентификатор	 = Новый УникальныйИдентификатор();
		СтрокаТаблицы.Дата			 = НачалоГода + Генератор.СлучайноеЧисло(0, СекундВГоду);
	
	КонецЦикла; 	
	
	#КонецОбласти // Заполнение 
	
	ТаблицаЗначений.Индексы.Добавить("Число");
	ТаблицаЗначений.Индексы.Добавить("Число, Идентификатор");
	ТаблицаЗначений.Индексы.Добавить("Идентификатор, Дата");
	ТаблицаЗначений.Индексы.Добавить("Число, Дата");
	ТаблицаЗначений.Индексы.Добавить("Дата");
	
	КвалификаторСтроки = Новый КвалификаторыСтроки(36);
	
	// Просто добавим тип Строка
	ИзменитьТипКолонкиТаблицыЗначений(
		ТаблицаЗначений,
	    "Идентификатор",
		"Строка");
		
	// Добавим булево, Уберем строку
	ИзменитьТипКолонкиТаблицыЗначений(
		ТаблицаЗначений,
	    ТаблицаЗначений.Колонки[1],
		"Булево",
		"Строка");
		
	// Добавим строку, уберем булево и уникальный идентификатор.
	// Ожидаем что преобразуются значения.
	ИзменитьТипКолонкиТаблицыЗначений(
		ТаблицаЗначений,
	    1,
		"Строка",
		"УникальныйИдентификатор, Булево",,
		КвалификаторСтроки);
		
КонецПроцедуры	// ИзменитьТипКолонкиТаблицыЗначений_Автотест()

// Сворачивает таблицу значений с использованием произвольных агрегатных функций СКД.
// Не упомянутые в параметрах колонки не будут присутствовать в результате. 
//
// Параметры:
//  ТаблицаЗначений  - ТаблицаЗначений	 - Сворачиваемая таблица.
//  Измерения	 	 - Строка			 - Выражения группировок, разделенные запятыми.
//										 Может содержать разыменование. В таком случае "точка" будет убрана из имени.
//										 Можно указать имя поля: "Поле Как ДругоеПоле".
//					 - СписокЗначений:
//						* Значение		 - Строка - Имя результирующей колонки
//						* Представление	 - Строка - Выражения для содержимого колонки.
//					 	Порядок следования колонок сохраняется
//					 - Соответствие, Структура:
//						* Ключ			 - Строка - Имя результирующей колонки
//						* Значение		 - Строка - Выражения для содержимого колонки.
//	Ресурсы			 - Строка			 - Агрегаты через запятую. 
//										 Допустимо указать просто имя поля. В таком случае значения будут просуммированы.
//										 Можно указать имя поля: "Сумма(Поле) Как ДругоеПоле".
//					 - СписокЗначений:
//						* Значение		 - Строка - Имя результирующей колонки
//						* Представление	 - Строка - Выражения для содержимого колонки.
//					 	Порядок следования колонок сохраняется
//					 - Соответствие, Структура:
//						* Ключ			 - Строка - Имя результирующей колонки
//						* Значение		 - Строка - Выражения для содержимого колонки.
//
// Возвращаемое значение:
//	ТаблицаЗначений   - Результат свертки
//
// Пример:
//	СвернутьТаблицуЗначений(ТаблицаЗначений, "Колонка1, ..., КолонкаN", "КолонкаM, ..., КолонкаP") - Работает аналогично ТаблицаЗначений.Свернуть()
//	СвернутьТаблицуЗначений(ТаблицаЗначений, "Фрукт", "Любой(Красный) КАК ЕстьКрасные, Каждый(Вкусный) КАК ВсеВкусные") - Для ТаблицаЗначений{Фрукт, ..., Красный:Булево, Вкусный:Булево} 
//		вернет ТаблицаЗначений{Фрукт, ЕстьКрасные:Булево, ВсеВкусные:Булево}
//
Функция СвернутьТаблицуЗначений(Знач ТаблицаЗначений, Измерения = "", Ресурсы = "") Экспорт

	#Область ПростаяСвертка
		
	МожноПростоСвернуть = ТипЗнч(Измерения) = Тип("Строка")	И Не ПустаяСтрока(Измерения) И Не СтрНайти(Измерения, "(")
		И ТипЗнч(Ресурсы) = Тип("Строка") И Не СтрНайти(Ресурсы, "(");

	Если МожноПростоСвернуть Тогда
		
		ИменаКолонок = Измерения + ?(ЗначениеЗаполнено(Измерения) И ЗначениеЗаполнено(Ресурсы), ", ", "") + Ресурсы;
		СвернутаяТаблицаЗначений = ТаблицаЗначений.Скопировать(, ИменаКолонок);
		СвернутаяТаблицаЗначений.Свернуть(Измерения, Ресурсы);
		Возврат СвернутаяТаблицаЗначений;

	КонецЕсли; 
	
	#КонецОбласти // ПростаяСвертка

	#Область Подготовка

	СуффиксПсевдоним = " Как ";              
	
	#Область ВыраженияИзмерений
	ВыраженияИзмерений = Новый СписокЗначений;
	Если ТипЗнч(Измерения) = Тип("Строка") Тогда
		ИменаИзмерений = СтрРазделить(Измерения, ", ", Ложь);
		Для каждого ИмяИзмерения Из ИменаИзмерений Цикл
			
			Выражение = ИмяИзмерения;
			
			ПозПсевдоним = СтрНайти(ВРег(Выражение), ВРег(СуффиксПсевдоним));
			ЕстьПсевдоним = Булево(ПозПсевдоним);    
			
			Если ЕстьПсевдоним Тогда
				ИмяПоля = Сред(Выражение, ПозПсевдоним + СтрДлина(СуффиксПсевдоним));
			Иначе	
				ИмяПоля = СтрЗаменить(Выражение, ".", "");	// Для разыменований
			КонецЕсли;
			ВыраженияИзмерений.Добавить(ИмяПоля, Выражение);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Измерения) = Тип("СписокЗначений") Тогда
		Для каждого Элемент Из Измерения Цикл
			ВыраженияИзмерений.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Измерения) = Тип("Структура")
		Или ТипЗнч(Измерения) = Тип("Соответствие") Тогда
		Для каждого Элемент Из Измерения Цикл
			ВыраженияИзмерений.Добавить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
	Иначе
		ВызватьИсключение "Параметр Измерения: Ожидается Строка, СписокЗначений, Структура, Сответствие";
	КонецЕсли;
	#КонецОбласти // ВыраженияИзмерений
	
	#Область ВыраженияРесурсов
	ВыраженияРесурсов = Новый СписокЗначений;
	Если ТипЗнч(Ресурсы) = Тип("Строка") Тогда
		ИменаРесурсов = СтрРазделить(Ресурсы, ",", Ложь); // Пробел в разделители не включен, из-за Количество(Различные ...)
		Для Индекс = 0 По ИменаРесурсов.ВГраница() Цикл
			ИменаРесурсов.Установить(Индекс, СокрЛП(ИменаРесурсов[Индекс]));
		КонецЦикла; 
		Для каждого ИмяРесурса Из ИменаРесурсов Цикл  
			
			Выражение = ИмяРесурса;

			ЕстьАгрегат = СтрНайти(Выражение, "(") И СтрНайти(Выражение, ")");
			Если ЕстьАгрегат Тогда
			
				ПозОткрСкобка = СтрНайти(Выражение, "(");
				ПозЗакрСкобка = СтрНайти(Выражение, ")");
				АгрегатВалиден = ПозОткрСкобка < ПозЗакрСкобка
					И СтрЧислоВхождений(Выражение, "(") = 1 И СтрЧислоВхождений(Выражение, ")") = 1;
				Если Не АгрегатВалиден Тогда
					ВызватьИсключение СтрШаблон("Выражение ресурса %1 указано неверно");
				КонецЕсли;	
			
			КонецЕсли;    
			
			ПозПсевдоним = СтрНайти(ВРег(Выражение), ВРег(СуффиксПсевдоним));
			ЕстьПсевдоним = Булево(ПозПсевдоним);
			
			Если ЕстьПсевдоним Тогда
			
				ИмяПоля = Сред(Выражение, ПозПсевдоним + СтрДлина(СуффиксПсевдоним));
			
			ИначеЕсли ЕстьАгрегат Тогда

				ИмяПоля = Сред(Выражение, ПозОткрСкобка + 1, ПозЗакрСкобка - ПозОткрСкобка - 1); 
				ПрефиксРазличные = "Различные ";
				Если СтрНачинаетсяС(НРег(ИмяПоля), НРег(ПрефиксРазличные)) Тогда
					ИмяПоля = Сред(ИмяПоля, СтрДлина(ПрефиксРазличные) + 1);				
				КонецЕсли; 

			Иначе

				ИмяПоля = Выражение;  
		
			КонецЕсли;  
			ИмяПоля = СтрЗаменить(ИмяПоля, ".", "");	// Для разыменований
			         
            Если ЕстьПсевдоним Тогда
				Выражение = Лев(Выражение, ПозПсевдоним - 1);			
			КонецЕсли;		
			Если Не ЕстьАгрегат Тогда
				Выражение = СтрШаблон("Сумма(%1)", Выражение);
			КонецЕсли;

			ВыраженияРесурсов.Добавить(ИмяПоля, Выражение);

		КонецЦикла;
	ИначеЕсли ТипЗнч(Ресурсы) = Тип("СписокЗначений") Тогда  
		
		Для каждого ЭлементСписка Из Ресурсы Цикл
			ВыраженияРесурсов.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЦикла; 
		
	ИначеЕсли ТипЗнч(Ресурсы) = Тип("Структура") 
		Или ТипЗнч(Ресурсы) = Тип("Соответствие") Тогда
		
		Для каждого Элемент Из Ресурсы Цикл
			ВыраженияРесурсов.Добавить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
	Иначе
		ВызватьИсключение "Параметр Ресурсы: Ожидается Строка, СписокЗначений, Структура, Сответствие"; 
		
	КонецЕсли;
	#КонецОбласти // ВыраженияРесурсов 

	#КонецОбласти // Подготовка

	#Область КомпоновкаДанныхДляКоллекцииЗначений    
	
	ТаблицаДанных = ТаблицаЗначений;
		
	СхемаКомпоновкиДанных	 = Новый СхемаКомпоновкиДанных;
	ВнешниеНаборыДанных		 = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ВнешнийНаборДанных", ТаблицаЗначений);
	ВозможностьИспользованияВнешнихФункций = Истина;
	
	#Область Схема 
	
	#Область ИсточникиДанных
	ИсточникиДанных = СхемаКомпоновкиДанных.ИсточникиДанных;
	ИсточникДанныхСхемы = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанныхСхемы.СтрокаСоединения	= "Local";
	ИсточникДанныхСхемы.ТипИсточникаДанных	= "Local";
	ИсточникДанныхСхемы.Имя					= "Local";
	#КонецОбласти // ИсточникиДанных

	#Область НаборыДанных
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанных.Имя				= "ВнешнийНаборДанных";
	НаборДанных.ИсточникДанных	= ИсточникДанныхСхемы.Имя;
	НаборДанных.ИмяОбъекта		= "ВнешнийНаборДанных";
	Для каждого Колонка Из ТаблицаДанных.Колонки Цикл
		ПолеДанных				= НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеДанных.Поле			= Колонка.Имя;
		ПолеДанных.ПутьКДанным	= Колонка.Имя;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
		ПолеДанных.Заголовок	= Колонка.Заголовок;
		ПолеДанных.ТипЗначения	= Колонка.ТипЗначения;
	КонецЦикла; 
	#КонецОбласти // НаборыДанных  
	
	#Область ВычисляемыеПоля
	// Для ресурсов с собственными псевдонимами
	ВычисляемыеПоля = СхемаКомпоновкиДанных.ВычисляемыеПоля;    
	
	Для каждого ВыражениеИзмерений Из ВыраженияИзмерений Цикл   
		
		ПутьКДанным	 = ВыражениеИзмерений.Значение; 
		Выражение	 = ВыражениеИзмерений.Представление;   
		
		ВычисляемоеПоле = ВычисляемыеПоля.Добавить();    
		ВычисляемоеПоле.ПутьКДанным	 = ПутьКДанным;
		ВычисляемоеПоле.Выражение	 = Выражение;
		ВычисляемоеПоле.Заголовок	 = ПутьКДанным;

	КонецЦикла;            
	
	Для каждого ВыражениеРесурсов Из ВыраженияРесурсов Цикл     
		
		ПутьКДанным	 = ВыражениеРесурсов.Значение; 
		Выражение	 = ВыражениеРесурсов.Представление; 
		
		ВычисляемоеПоле = ВычисляемыеПоля.Добавить();    
		ВычисляемоеПоле.ПутьКДанным	 = ПутьКДанным;
		ВычисляемоеПоле.Заголовок	 = ПутьКДанным;
	
	КонецЦикла;
	#КонецОбласти // ВычисляемыеПоля
	
	#Область Структура
	
	Группировка = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПоляГруппировки = Группировка.ПоляГруппировки.Элементы;                                           
	ПоляВыбора = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы;
	Для каждого ВыражениеИзмерений Из ВыраженияИзмерений Цикл   
		
		ПутьКДанным	 = ВыражениеИзмерений.Значение;
		Выражение	 = ВыражениеИзмерений.Представление; 
		Заголовок	 = ВыражениеИзмерений.Значение;
		Поле = Новый ПолеКомпоновкиДанных(ПутьКДанным);
		
		ПолеГруппировки = ПоляГруппировки.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Поле;    
		
		ПолеВыбора = ПоляВыбора.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ПолеВыбора.Поле = Поле;
		ПолеВыбора.Заголовок = Заголовок;    
		
	КонецЦикла;            
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	#КонецОбласти // Структура
	
	#Область Ресурсы
	Для каждого ВыражениеРесурсов Из ВыраженияРесурсов Цикл     
		
		ПутьКДанным	 = ВыражениеРесурсов.Значение; 
		Выражение	 = ВыражениеРесурсов.Представление;
		Поле = Новый ПолеКомпоновкиДанных(ПутьКДанным);
		Заголовок = ПутьКДанным;
		
		ПолеИтога				 = СхемаКомпоновкиДанных.ПоляИтога.Добавить();		
		ПолеИтога.ПутьКДанным	 = ПутьКДанным;
		ПолеИтога.Выражение		 = Выражение;   
		
		ПолеВыбора			 = ПоляВыбора.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ПолеВыбора.Поле		 = Поле;
		ПолеВыбора.Заголовок = Заголовок;    
	
	КонецЦикла;
	#КонецОбласти // Ресурсы    
	
	#Область Настройки
	СхемаКомпоновкиДанных.НастройкиПоУмолчанию.ПараметрыВывода.УстановитьЗначениеПараметра(
		"ВертикальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);		
	#КонецОбласти // Настройки
	
	#КонецОбласти // Схема
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, , ВозможностьИспользованияВнешнихФункций);
	
	РезультатКомпоновки = Новый ТаблицаЗначений;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(РезультатКомпоновки);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	#КонецОбласти // КомпоновкаДанныхДляКоллекцииЗначений 	
	
	Возврат РезультатКомпоновки;

КонецФункции // СвернутьТаблицуЗначений()       


// Разносит значения из определённой колонки таблицы в самостоятельные колонки.
//
// Параметры:
//	ИсходнаяТаблица		 - ТаблицаЗначений	 - Таблица для обработки
//	Измерения			 - Строка			 - Измерения, сохраняемые в таблице значений.
//	КолонкаПоказателя	 - Строка			 - Имя колонки, значения из которой  будут вынесены в отдельные колонки.
//	КолонкиПоказателя	 - Соответствие		 - Значения, которые будут разнесены по колонкам. В результирующей таблице будут только значения показателя, указанного в этой коллекции.
//		* Ключ		 - Произвольный	 - Значение, выделяемое в колонку 
//		* Значение	 - Строка		 - Префикс поздаваемой колонки.
//	Ресурсы				 - Строка - Имена ресурсов, которые будут выделены в самостоятельные колонки. 
//		Если указано больше одного ресурса, являются суффиксами создаваемых колонок.
//		Числовые ресурсы
//
// Пример:
//	СтрокиТаблицыЗначенийВКолонки(ТаблицаЗначений, "Номенклатура", "Склад", {Склад1:"Первый", Склад2:"Второй"}, "Количество");	// ТаблицаЗначений{Номенклатура, Первый, Второй}
//	СтрокиТаблицыЗначенийВКолонки(ТаблицаЗначений, "Номенклатура", "Склад", {Склад1:"Первый", Склад2:"Второй"}, "Количество, Стоимость"); // ТаблицаЗначений{Номенклатура, ПервыйКоличество, ПервыйСтоимость, ВторойКоличество, ВторойСтоимость}
//
// Возвращаемое значение:
//	ТаблицаЗначений - Таблица, содержащая переданные измерения и выделенные ресурсы.
//		Таблица свёрнута по комплектам измерений (параметр измерения).
//		Числовые показатели, если встречаются многократно, просуммированы. 
//		Прочие показатели выражаются последним значением из набора исходных данных.
//
Функция СтрокиТаблицыЗначенийВКолонки(ИсходнаяТаблица, Знач Измерения, КолонкаПоказателя, Знач КолонкиПоказателя, Знач Ресурсы)

	ИменаКолонокРесурсов = Новый Соответствие;

	ЕстьИзмерения = ЗначениеЗаполнено(Измерения);

	#Область КонструкторРезультирующаяТаблица

	Если ЕстьИзмерения Тогда
		РезультирующаяТаблица = ИсходнаяТаблица.СкопироватьКолонки(Измерения);
		ИменаКолонокИзмерений = СтрРазделить(Измерения, ", ", Ложь);
	Иначе
		РезультирующаяТаблица = Новый ТаблицаЗначений;
		ИменаКолонокИзмерений = Новый Массив;
	КонецЕсли;

	ИменаКолонокРесурсов = СтрРазделить(Ресурсы, ", ", Ложь);
	ИспользоватьСуффиксРесурсов = ИменаКолонокРесурсов.Количество() > 1;
	ИменаКолонокПоказателей = Новый Массив;
	Для Каждого КолонкаПоказатель Из КолонкиПоказателя Цикл
		Если ИменаКолонокПоказателей.Найти(КолонкаПоказатель.Значение) = Неопределено Тогда
			ИменаКолонокПоказателей.Добавить(КолонкаПоказатель.Значение);
		КонецЕсли;
	КонецЦикла;
	Для каждого ИмяКолонкиПоказателя Из ИменаКолонокПоказателей Цикл
		Для каждого ИмяКолонкиРесурса Из ИменаКолонокРесурсов Цикл
			ИмяКолонкиЗначения = ИмяКолонкиПоказателя + ?(ИспользоватьСуффиксРесурсов, ИмяКолонкиРесурса, ""); 
			РезультирующаяТаблица.Колонки.Добавить(ИмяКолонкиЗначения, ИсходнаяТаблица.Колонки[ИмяКолонкиРесурса].ТипЗначения);
		КонецЦикла;
	КонецЦикла;
	Если ЕстьИзмерения Тогда
		РезультирующаяТаблица.Индексы.Добавить(Измерения);
	КонецЕсли;
	#КонецОбласти	// КонструкторРезультирующаяТаблица

	ПредыдущаяПозицияРезультат = Неопределено;
	Для каждого ПозицияИсходная Из ИсходнаяТаблица Цикл
		
		Значение = ПозицияИсходная[КолонкаПоказателя];
		ИмяКолонкиПоказателя = КолонкиПоказателя[Значение];
		Если КолонкаЗначения = Неопределено Тогда Продолжить КонецЕсли;

		ПозицияРезультат = Неопределено;
		Если ЕстьИзмерения и ПредыдущаяПозицияРезультат <> Неопределено Тогда
			НужноНайтиСтроку = Ложь;
			Для каждого ИмяКолонкиИзмерения Из ИменаКолонокИзмерений Цикл
				Если ПредыдущаяПозицияРезультат[ИмяКолонкиИзмерения] <> ПозицияИсходная[ИмяКолонкиИзмерения] Тогда
					НужноНайтиСтроку = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НужноНайтиСтроку Тогда
				СтруктураПоиска = Новый Структура(Измерения);
				ЗаполнитьЗначенияСвойств(СтруктураПоиска, ПозицияИсходная);
			КонецЕсли;
		КонецЕсли; 
		Если ПозицияРезультат = Неопределено Тогда
			ПозицияРезультат = РезультирующаяТаблица.Добавить();
			Если ЗначениеЗаполнено(Измерения) Тогда
				ЗаполнитьЗначенияСвойств(ПозицияРезультат, ПозицияИсходная, Измерения);
			КонецЕсли;
		КонецЕсли; 
		
		Для каждого ИмяКолонкиРесурса Из ИменаКолонокРесурсов Цикл

			ИмяКолонкиПоказателя = ИмяКолонкиПоказателя + ?(ИспользоватьСуффиксРесурсов, ИмяКолонкиРесурса, "");

		КонецЦикла;


	КонецЦикла;

	Возврат РезультирующаяТаблица;

КонецФункции // СтрокиТаблицыЗначенийВКолонки()


// Выгружает значения нескольких колонок таблицы значений в один массив.
//	Порядок следования значений в массиве соответствует порядку следования колонок.
//
// Параметры:
//	ИсходнаяТаблица		 - ТаблицаЗначений	 - Таблица, данные которой требуется выгрузить
//	Колонки				 - Строка			 - Перечисление колонок, которые слудует выгрузить. Если не указан, выгружаются все колонки.
//	Отбор				 - Структура		 - Отбор, строк таблицы для выгрузки.
//	ТолькоЗаполненные	 - Булево			 - Будут выгружены только заполненные значения. 
//											Значения проверяются функцией ЗначениеЗаполнено().
//	ТолькоУникальные	 - Булево			 - Полученный массив будет содержать только уникальные значения. 
//											Порядок следования значений в массиве - произвольный.
//
// Возвращаемое значение:
//	Массив - Значения колонок исходной таблицы.
//
Функция ЗначенияТаблицыЗначенийВМассив(
	ИсходнаяТаблица, 
	Знач Колонки = "", 
	Отбор = Неопределено, 
	ТолькоЗаполненные = Ложь, 
	ТолькоУникальные = Ложь)
	
	РезультирующийМассив = Новый Массив;
	Если Ложь Тогда ИсходнаяТаблица = Новый ТаблицаЗначений КонецЕсли;

	КоллекцияСтрок = ИсходнаяТаблица;
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
		КоллекцияСтрок = ИсходнаяТаблица.НайтиСтроки(Отбор);
	КонецЕсли;

	Если не ЗначениеЗаполнено(КоллекцияСтрок) Тогда Возврат РезультирующийМассив КонецЕсли;	// Пустой массив

	ИменаКолонок = Новый Массив;
	Если ЗначениеЗаполнено(Колонки) Тогда
		ИменаКолонок = СтрРазделить(Колонки, ", ", Ложь);
	Иначе
		Для Каждого Колонка Из ИсходнаяТаблица.Колонки Цикл
			ИменаКолонок.Добавить(Колонка.Имя);
		КонецЦикла;
	КонецЕсли;

	Для Каждого ИмяКолонки из ИменаКолонок Цикл
		Для каждого СтрокаТаблицы Из КоллекцияСтрок Цикл
			Значение = СтрокаТаблицы[ИмяКолонки];
			Если ТолькоЗаполненные и не ЗначениеЗаполнено(Значение) Тогда Продолжить КонецЕсли;
			Если ТолькоУникальные и РезультирующийМассив.Найти(Значение) <> Неопределено Тогда Продолжить КонецЕсли;
			РезультирующийМассив.Добавить(Значение);
		КонецЦикла;
	КонецЦикла;

	Возврат РезультирующийМассив;

КонецФункции // ЗначенияТаблицыЗначенийВМассив()

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

// Позволяет разделить данные исходной таблицы на произвольное количество частей
// Например, таблицу из трёх строк на пять частей.
//
// Параметры:
//	ДелимаяТаблица		 - ТаблицаЗначений - Разделяемая таблица.
//	КлючевойРесурс		 - Строка - Имя поля ресурса, который подвергается делению.
//		Ключевой ресурс должен быть положительным числом.
//	Делители			 - Массив - Массив значений ресурса, на которые надо разделить исходную таблицу. Элемент: Число. 
//		Каждый делитель должен быть положительным числом.
//	ВедомыеРесурсы		 - Строка - Имена колонок делимой таблицы через запятую.
//		Значения в этих колонках в новой таблице будут распределены пропорционально значению ключевого ресурса.
//	СтрокиПоДелителям	 - Массив - Содержит строки, сгруппированные по делителям. 
//		Количество и порядок элементов соответствет делителям.
//		Элемент: Массив строк результирующей таблицы
//	КорреспонденцияСтрок - Соответствие - Отображает, какая строка исходной таблицы каким строкам целевой таблицы соответствует.
//		Ключ: СтрокаТаблицыЗначений, Значение: Массив элеметов типа СтрокаТаблицыЗначений.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Результирующая таблица
//
Функция РазделитьТаблицуПоРесурсу(ДелимаяТаблица, КлючевойРесурс, Делители, Знач ВедомыеРесурсы, СтрокиПоДелителям = Неопределено, КорреспонденцияСтрок = Неопределено)
	
	Если Ложь Тогда ДелимаяТаблица = Новый ТаблицаЗначений КонецЕсли;
	Если Ложь Тогда Делители = Новый Массив КонецЕсли;
	
	#Область РезультирующаяТаблица
	
	РезультирующаяТаблица = ДелимаяТаблица.Скопировать();
	ИсходныеСтроки = Новый Соответствие;	// Для каждой строки результата содержит исходную строку
	Для Индекс = 0 По РезультирующаяТаблица.Количество() - 1 Цикл
		
		ИсходнаяСтрока = ДелимаяТаблица[Индекс];
		РезультирующаяСтрока = РезультирующаяТаблица[Индекс];
		ИсходныеСтроки.Вставить(РезультирующаяСтрока, ИсходнаяСтрока);
		
	КонецЦикла;
	
	#КонецОбласти // РезультирующаяТаблица
	
	#Область РазделениеПоКлючевомуРесурсу
	
	СтрокиПоДелителям = Новый Массив(Делители.Количество());
	Для ИндексДелителя = 0 По Делители.ВГраница() Цикл
		СтрокиПоДелителям.Установить(ИндексДелителя, Новый Массив);
	КонецЦикла; 
	
	ИндексРезультата = -1;
	МаксИндексРезультирующейТаблицы = РезультирующаяТаблица.Количество() - 1;
	ВсегоМожноРазделить	 = ДелимаяТаблица.Итог(КлючевойРесурс);
	ВсегоРазделено		 = 0;
	Для ИндексДелителя = 0 По Делители.ВГраница() Цикл
		Делитель = Делители[ИндексДелителя];
		СтрокиПоДелителю = СтрокиПоДелителям[ИндексДелителя];
		Банк = Делитель;
		Пока Банк > 0 Цикл
			Если ВсегоРазделено >= ВсегоМожноРазделить Тогда
				Прервать;
			КонецЕсли; 
			ИндексРезультата = ИндексРезультата + 1;
			СтрокаРезультата = РезультирующаяТаблица[ИндексРезультата];
			ИсходнаяСтрока = ИсходныеСтроки[СтрокаРезультата];
			Делимое = СтрокаРезультата[КлючевойРесурс];
			Транш = Мин(Банк, Делимое);
			РазделятьИсходнуюСтроку = (Транш < Делимое);
			Если РазделятьИсходнуюСтроку Тогда
				НоваяСтрокаРезультата = РезультирующаяТаблица.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаРезультата, СтрокаРезультата);
				НоваяСтрокаРезультата[КлючевойРесурс] = НоваяСтрокаРезультата[КлючевойРесурс] - Транш;
				СтрокаРезультата[КлючевойРесурс] = Транш;
				РезультирующаяТаблица.Сдвинуть(НоваяСтрокаРезультата, ИндексРезультата - РезультирующаяТаблица.Индекс(НоваяСтрокаРезультата) + 1);
				
				ИсходныеСтроки.Вставить(НоваяСтрокаРезультата, ИсходнаяСтрока);			// Запоминаем в исходную строку
				
				МаксИндексРезультирующейТаблицы = МаксИндексРезультирующейТаблицы + 1;
			КонецЕсли;
			СтрокиПоДелителю.Добавить(СтрокаРезультата);
			ВсегоРазделено = ВсегоРазделено + Транш;
			Банк = Банк - Транш;
		КонецЦикла;
		Если ИндексРезультата >= МаксИндексРезультирующейТаблицы Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Подготовим не попадающие строки результата к удалению
	УдаляемыеСтрокиРезультата = Новый Массив;
	Для ИндексРезультата = (ИндексРезультата + 1) По МаксИндексРезультирующейТаблицы Цикл
		УдаляемыеСтрокиРезультата.Добавить(РезультирующаяТаблица[ИндексРезультата]);
	КонецЦикла; 
	
	#КонецОбласти // РазделениеПоКлючевомуРесурсу
	
	#Область ВедомыеРесурсы
	
	ВедомыеРесурсыМассив = СтрРазделить(ВедомыеРесурсы, ", ", Ложь);
	
	РаспределятьВедомыеРесурсы = ЗначениеЗаполнено(ВедомыеРесурсы);
	
	Если РаспределятьВедомыеРесурсы Тогда
		
		#Область КорреспонденцияСтрок
		КорреспонденцияСтрок = Новый Соответствие; // {СтрокаТаблицыЗначений; Массив{СтрокаТаблицыЗначений}} - исходные строки и получившиеся в результате разделения строки
		Для каждого Элемент Из ИсходныеСтроки Цикл
			ИсходнаяСтрока		 = Элемент.Значение;
			РезультирующаяСтрока = Элемент.Ключ;
			СтрокиРезультата = КорреспонденцияСтрок[Элемент.Значение];
			Если СтрокиРезультата = Неопределено Тогда
				СтрокиРезультата = Новый Массив;
				КорреспонденцияСтрок.Вставить(ИсходнаяСтрока, СтрокиРезультата);
			КонецЕсли; 
			СтрокиРезультата.Добавить(РезультирующаяСтрока);
		КонецЦикла; 
		#КонецОбласти // КорреспонденцияСтрок 
		
		Для каждого ЭлементКорреспонденции Из КорреспонденцияСтрок Цикл
			
			ИсходнаяСтрока	 = ЭлементКорреспонденции.Ключ;
			СтрокиРезультата = ЭлементКорреспонденции.Значение;
			
			Если СтрокиРезультата.Количество() = 1 Тогда Продолжить КонецЕсли; 
			
			Для каждого ВедомыйРесурс Из ВедомыеРесурсыМассив Цикл
				
				// Подготовим распределение:
				РаспределяемаяСумма = ИсходнаяСтрока[ВедомыйРесурс];
				Коэффициенты = Новый Массив;
				Для каждого СтрокаРезультата Из СтрокиРезультата Цикл
					Коэффициенты.Добавить(СтрокаРезультата[КлючевойРесурс]);
				КонецЦикла; 
				Точность = РезультирующаяТаблица.Колонки[ВедомыйРесурс].ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти;
				
				// Распределение, аналогичное БСП.РаспределитьСуммуПропорциональноКоэффициентам()
				#Область РаспределениеПропорционально
			
				ИндексМаксимальногоКоэффициента = 0;
				МаксимальныйКоэффициент = 0;
				РаспределеннаяСумма = 0;
				СуммаКоэффициентов  = 0;
		
				Для Индекс = 0 По Коэффициенты.Количество() - 1 Цикл
					Коэффициент = Коэффициенты[Индекс];
					
					АбсолютноеЗначениеКоэффициента = ?(Коэффициент > 0, Коэффициент, - Коэффициент);
					Если МаксимальныйКоэффициент < АбсолютноеЗначениеКоэффициента Тогда
						МаксимальныйКоэффициент = АбсолютноеЗначениеКоэффициента;
						ИндексМаксимальногоКоэффициента = Индекс;
					КонецЕсли;
					
					СуммаКоэффициентов = СуммаКоэффициентов + Коэффициент;
				КонецЦикла;
		
				РезультатРаспределения = Новый Массив(Коэффициенты.Количество());
				
				Если СуммаКоэффициентов <> 0 Тогда
				
					Для Индекс = 0 По Коэффициенты.Количество() - 1 Цикл
						РезультатРаспределения[Индекс] = Окр(РаспределяемаяСумма * Коэффициенты[Индекс] / СуммаКоэффициентов, Точность, 1);
						РаспределеннаяСумма = РаспределеннаяСумма + РезультатРаспределения[Индекс];
					КонецЦикла;
				
					// Погрешности округления отнесем на коэффициент с максимальным весом.
					Если Не РаспределеннаяСумма = РаспределяемаяСумма Тогда
						РезультатРаспределения[ИндексМаксимальногоКоэффициента] = РезультатРаспределения[ИндексМаксимальногоКоэффициента] + РаспределяемаяСумма - РаспределеннаяСумма;
					КонецЕсли;
					
				Иначе
					
					Для Индекс = 0 по РезультатРаспределения.ВГраница() Цикл
						РезультатРаспределения.Вставить(Индекс, 0);						
					КонецЦикла; 
					
				КонецЕсли; 

				#КонецОбласти // РаспределениеПропорционально 			
				
				// Применяем результаты распределения:
				Для Индекс = 0 По Коэффициенты.ВГраница() Цикл
					СтрокиРезультата[Индекс][ВедомыйРесурс] = РезультатРаспределения[Индекс];
				КонецЦикла;  
				
			КонецЦикла; 
		
		КонецЦикла; 				
	
	КонецЕсли;	// РаспределятьВедомыеРесурсы
	
	#КонецОбласти // ВедомыеРесурсы
	
	// Удалим лишние строки результата:
	Для каждого Строка Из УдаляемыеСтрокиРезультата Цикл
		РезультирующаяТаблица.Удалить(Строка);
	КонецЦикла; 
	
	Возврат РезультирующаяТаблица;
	
КонецФункции // РазделитьТаблицуПоРесурсу()


