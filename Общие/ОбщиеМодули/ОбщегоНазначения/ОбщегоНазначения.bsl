#Область ТаблицаЗначений
#КонецОбласти // ТаблицаЗначений

#Область ДеревоЗначений

// Получает различные значения указанных полей дерева значений.
//
// Параметры:
//  Узел	 - ДеревоЗначений	 - Дерево значений
//  Колонки	 - Строка			 - Имена получаемых полей
//  Значения - Неопределено		 - (служебный)
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Полученные значения.
//
Функция РазличныеЗначенияКолонкиДереваЗначений(Узел, ИмяКолонки, Значения = Неопределено)
	
	ЭтоНачалоРекурсии = Значения = Неопределено;

	Если ТипЗнч(Узел) = Тип("СтрокаДереваЗначений") Тогда
		
		Значения.Вставить(Узел[ИмяКолонки]);
		Для каждого Ветвь Из Узел.Строки Цикл
			РазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, Значения)
		КонецЦикла;
	
	ИначеЕсли ТипЗнч(Узел) = Тип("ДеревоЗначений") Тогда
		
		Значения = Новый Соответствие;
		
		Для каждого Ветвь Из Узел.Строки Цикл
			РазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, Значения)
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
//	ИмяКолонки	 - Строка	 - Имя колонки, содержащей перечень искодных значений
//  ТолькоЛистья - Булево	 - Если Истина - то расположение значений получается только для листьев дерева значений
// 
// Возвращаемое значение:
//  Соответствие - Тип ключа соответствует типу значений в колонке, Значение - Массив, содержащий узлы коллекции.
//
Функция РасположениеЗначенийКолонкиДереваЗначенийРекурсивно(Узел, ИмяКолонки, ТолькоЛистья = Ложь)

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

#КонецОбласти	// ДеревоЗначений

#Область ПреобразованиеЗначений


// Проверяет существование ссылки в ИБ.
//	Функция - аналог БСП.СсылкаСуществует()
//
// Параметры:
//  Ссылка - ЛюбаяСсылка - значение любой ссылки информационной базы данных
// 
// Возвращаемое значение:
//	Булево - Истина, если ссылка физически существует
//
Функция СсылкаСуществует(Ссылка)
	
    ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 1	ИСТИНА
	|ИЗ					&ИмяТаблицы
	|ГДЕ				Ссылка = &Ссылка
	|";
	
    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).ПолноеИмя());
    
    Запрос = Новый Запрос;
    Запрос.Текст = ТекстЗапроса;
    Запрос.УстановитьПараметр("Ссылка", Ссылка);
    
    УстановитьПривилегированныйРежим(Истина);
    
    Возврат НЕ Запрос.Выполнить().Пустой();
    
КонецФункции // СсылкаСуществует()

// По навигационной ссылке получает ссылку на объект.
//
// Параметры:
//  НавигационнаяСсылка		 - Строка					 - Навигационная ссылка
//	УникальныйИдентификатор	 - УникальныйИдентификатор	 - Возвращаемый. Уникальный идентификатор объекта из навигационной ссылки
//  ИмяРеквизита			 - Строка					 - Возвращаемый. Имя реквизита объекта или колонки табличной части, если указано в навигационной ссылке.
//  ИмяТабличнойЧасти		 - Строка					 - Возвращаемый. Имя табличной части, если указано в навигационной ссылке.
//  ИндексТабЧасти			 - Число					 - Возвращаемый. Индекс в табличной части, если указан в навигационной ссылке.
// 
// Возвращаемое значение:
//  Ссылка - Если определить ссылку не удалось - возвращается Неопределено.
//
Функция СсылкаИзНавигационнойСсылки(НавигационнаяСсылка, УникальныйИдентификатор = Неопределено, ИмяРеквизита = Неопределено, ИмяТабличнойЧасти = Неопределено, ИндексТабЧасти = Неопределено)
	
	// Форматы ссылок (см. https://its.1c.ru/db/v8doc):
	// e1cib/data/<путькметаданным>?ref=<идентификаторссылки>
	// e1cib/data/<путькметаданным>.<имяреквизита>?ref=<идентификаторссылки>
	// e1cib/data/<путькметаданным>.<имятабличнойчасти>.<имяреквизита>?ref=<идентификаторссылки>&index=<индексстрокитабличнойчасти>
	
	ОперандДанных	 = "e1cib/data/";
	ОперандСсылки	 = "?ref=";
	ОперандИндекса	 = "&index=";
	
	ПозицияОперандаДанных	 = СтрНайти(НавигационнаяСсылка, ОперандДанных);
	ПозицияОперандаСсылки	 = СтрНайти(НавигационнаяСсылка, ОперандСсылки);
	ПозицияОперандаИндекса	 = СтрНайти(НавигационнаяСсылка, ПозицияОперандаИНдекса);
	
	ЕстьСсылка = Булево(ПозицияОперандаДанных) и Булево(ПозицияОперандаСсылки); 		
	Если не ЕстьСсылка Тогда Возврат Неопределено КонецЕсли;
	
	ПолноеИмяМетаданныхСсылки = Сред(
	НавигационнаяСсылка, 
	ПозицияОперандаДанных + СтрДлина(ОперандДанных),
	(ПозицияОперандаСсылки - 1) - (ПозицияОперандаДанных - 1 + СтрДлина(ОперандДанных))
	);
	
	СтекИмени = СтрРазделить(ПолноеИмяМетаданныхСсылки, ".", Ложь);
	Если СтекИмени.ВГраница() < 1 Тогда Возврат Неопределено КонецЕсли; 
	
	ИмяОбъектаМетаданных = СтекИмени[1];
	ПолноеИмяМетаданного = СтекИмени[0] + "." + СтекИмени[1];	// напр. Документ.ИмяДокумента
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданного);
	Если ОбъектМетаданных = Неопределено Тогда Возврат Неопределено КонецЕсли; 
	
	УникальныйИдентификаторШестнЧисло = Сред(НавигационнаяСсылка, ПозицияОперандаСсылки + СтрДлина(ОперандСсылки), 32);
	
	УникальныйИдентификатор = УникальныйИдентификаторИзШестнадцатеричногоЧисла(УникальныйИдентификаторШестнЧисло);	// см. ОбщегоНазначенияКлиентСервер
	Если УникальныйИдентификатор = Неопределено Тогда Возврат Неопределено КонецЕсли; 
	
	Если		 Метаданные.Документы				.Содержит(ОбъектМетаданных) Тогда Ссылка = Документы				[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.Справочники				.Содержит(ОбъектМетаданных) Тогда Ссылка = Справочники				[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.ПланыВидовХарактеристик	.Содержит(ОбъектМетаданных) Тогда Ссылка = ПланыВидовХарактеристик	[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.ПланыСчетов				.Содержит(ОбъектМетаданных) Тогда Ссылка = ПланыСчетов				[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.ПланыВидовРасчета		.Содержит(ОбъектМетаданных) Тогда Ссылка = ПланыВидовРасчета		[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.ПланыОбмена				.Содержит(ОбъектМетаданных) Тогда Ссылка = ПланыОбмена				[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.Задачи					.Содержит(ОбъектМетаданных) Тогда Ссылка = Задачи					[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	ИначеЕсли	 Метаданные.БизнесПроцессы			.Содержит(ОбъектМетаданных) Тогда Ссылка = БизнесПроцессы			[ИмяОбъектаМетаданных].ПолучитьСсылку(УникальныйИдентификатор);
	Иначе Возврат Неопределено;
	КонецЕсли; 	
	
	ЕстьИмяТабличнойЧасти	 = СтекИмени.ВГраница() = 3;
	ЕстьРеквизит			 = СтекИмени.ВГраница() >= 2;

	Если ЕстьИмяТабличнойЧасти и ЕстьРеквизит Тогда	
		ИмяРеквизита		 = СтекИмени[3];
		ИмяТабличнойЧасти	 = СтекИмени[2];
		ЕстьИндекс = Булево(ПозицияОперандаИндекса);
		Если ЕстьИндекс Тогда
			ИндексТабЧастиСтрокой = Сред(НавигационнаяСсылка, ПозицияОперандаИндекса + СтрДлина(ОперандИндекса));
			Если ЗначениеЗаполнено(ИндексТабЧастиСтрокой) Тогда
				ИндексТабЧасти = Число(ИндексТабЧастиСтрокой);
			иначе
				ИндексТабЧасти = 0;
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли ЕстьРеквизит Тогда
		ИмяРеквизита = СтекИмени[2];
	КонецЕсли; 
	
	Возврат Ссылка;
	
КонецФункции // СсылкаИзНавигационнойСсылки()

// Получает ссылку на объект из навигационной ссылки
// с использованием ЗначениеВСторкуВнутр(), ЗначениеИзСтрокиВнутр(),
// без проверки на корректность.
// Методика: https://1c-bezproblem.ru/blog/v-pomoshch-1s-programmistu/1s-poluchit-ssylku-na-ob-ekt-po-navigatsionnoj-ssylke
//
// Параметры:
//  НавигационнаяСсылка	 - Строка	 - НавигационнаяСсылка
// 
// Возвращаемое значение:
//   - ЛюбаяСсылка   - Полученная ссылка
//
Функция СсылкаИзНавигационнойСсылкиВнутр(НавигационнаяСсылка)

 	// e1cib/data/<путькметаданным>?ref=<идентификаторссылки>
	
	ОперандДанных	 = "e1cib/data/";
	ОперандСсылки	 = "?ref=";
	НавигационнаяСсылкаЛокальная = Сред(НавигационнаяСсылка, СтрНайти(НавигационнаяСсылка, ОперандДанных));
	НавигационнаяСсылкаПоЧастям = СтрРазделить(НавигационнаяСсылкаЛокальная, "/?=", Ложь);
	ПолноеИмяМетаданныхСсылки = НавигационнаяСсылкаПоЧастям[2];
	ИдШестнадцатиричный = НавигационнаяСсылкаПоЧастям[4];
	
    СтрокаВнутр = ЗначениеВСтрокуВнутр(ПредопределенноеЗначение(ПолноеИмяМетаданныхСсылки + ".ПустаяСсылка"));
	ТридцатьДваНуля = "00000000000000000000000000000000";
    СтрокаВнутр = СтрЗаменить(СтрокаВнутр, ТридцатьДваНуля, ИдШестнадцатиричный);
	
	Возврат ЗначениеИзСтрокиВнутр(СтрокаВнутр);

КонецФункции // СсылкаИзНавигационнойСсылкиВнутр()

// Получает программный код для получения указанной ссылки через уникальный идентификатор
//
// Параметры:
//  СсылкаНаОбъект	 - ЛюбаяСсылка	 - Ссылка на объект.
// 
// Возвращаемое значение:
//  Строка - Команда для получения ссылки. Например: "Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор("00112233-4455-6677-8899-aabbccddeeff"))"
//
Функция ТекстМодуляПолученияСсылки(СсылкаНаОбъект)
	
	ТекстМодуля = "Неопределено";
		
	ОбъектМетаданных = СсылкаНаОбъект.Метаданные();
	
	Если		 Метаданные.Документы				.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "Документы";
	ИначеЕсли	 Метаданные.Справочники				.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "Справочники";
	ИначеЕсли	 Метаданные.ПланыВидовХарактеристик	.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "ПланыВидовХарактеристик";
	ИначеЕсли	 Метаданные.ПланыСчетов				.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "ПланыСчетов";
	ИначеЕсли	 Метаданные.ПланыВидовРасчета		.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "ПланыВидовРасчета";
	ИначеЕсли	 Метаданные.ПланыОбмена				.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "ПланыОбмена";
	ИначеЕсли	 Метаданные.Задачи					.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "Задачи";
	ИначеЕсли	 Метаданные.БизнесПроцессы			.Содержит(ОбъектМетаданных) Тогда ИмяМенеджера = "БизнесПроцессы";
	Иначе Возврат ТекстМодуля;
	КонецЕсли; 	
	
	Если Не СсылкаНаОбъект.Пустая() Тогда
		ТекстМодуля = СтрШаблон(
			"%1.%2.ПолучитьСсылку(Новый УникальныйИдентификатор(""%3""))",
			ИмяМенеджера,
			ОбъектМетаданных.Имя,
			СсылкаНаОбъект.УникальныйИдентификатор()
		);
	Иначе
		ТекстМодуля = СтрШаблон(
			"%1.%2.ПустаяСсылка()",
			ИмяМенеджера,
			ОбъектМетаданных.Имя
		);
	КонецЕсли;
	
	Возврат ТекстМодуля;

КонецФункции // ТекстМодуляПолученияСсылки()

Функция ПолучитьСсылкуПоСтрокеОбъектНеНайден(ТекстОбъектНеНайден)
	
	Разделитель = ":";
	
	Если ПустаяСтрока(ТекстОбъектНеНайден) 
		Или Не СтрНайти(ТекстОбъектНеНайден, Разделитель) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	СсылкаСырая = ТекстОбъектНеНайден;
	ПозицияСкобкиОткр = СтрНайти(СсылкаСырая, "(");
	ПозицияСкобкиЗакр = СтрНайти(СсылкаСырая, ")");
	Если ПозицияСкобкиОткр И ПозицияСкобкиЗакр Тогда
		СсылкаСырая = Сред(СсылкаСырая, ПозицияСкобкиОткр + 1, ПозицияСкобкиЗакр - ПозицияСкобкиОткр - 1);	// "123:778899aabb.."
	КонецЕсли; 
	
	ПозицияРазделитель = СтрНайти(СсылкаСырая, Разделитель);
	Если ПозицияРазделитель <= 1 Тогда	// Нет номера таблицы
		Возврат Неопределено;
	КонецЕсли; 
	
	НомерТаблицы = Лев(СсылкаСырая, ПозицияРазделитель - 1);
	ИдШестнадцатиричный = Сред(СсылкаСырая, ПозицияРазделитель + 1, 32);
	УникальныйИдентификатор = УникальныйИдентификаторИзШестнадцатеричногоЧисла(ИдШестнадцатиричный);
	
	Если УникальныйИдентификатор = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 

	РазделыМетаданных = Новый Массив;
	РазделыМетаданных.Добавить(Метаданные.Справочники);
	РазделыМетаданных.Добавить(Метаданные.Документы);
	
	// Префиксы: https://its.1c.ru/db/metod8dev/content/1798/hdoc
	РазделыМетаданныхПрефиксы = Новый ТаблицаЗначений;	// Чтобы соблюсти порядок, для производительности
	РазделыМетаданныхПрефиксы.Колонки.Добавить("РазделМетаданных");
	РазделыМетаданныхПрефиксы.Колонки.Добавить("Префикс");
	
	Таб = РазделыМетаданныхПрефиксы;
	Стр = Таб.Добавить(); Стр[0] = Метаданные.Справочники; 				 Стр[1] = "Reference";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.Документы; 				 Стр[1] = "Document";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.ПланыВидовХарактеристик; 	 Стр[1] = "Chrc";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.ПланыСчетов; 				 Стр[1] = "Acc";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.ПланыВидовРасчета; 		 Стр[1] = "CKind";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.ПланыОбмена; 				 Стр[1] = "Node";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.БизнесПроцессы; 			 Стр[1] = "BPr";
	Стр = Таб.Добавить(); Стр[0] = Метаданные.Задачи; 					 Стр[1] = "Task";
	// #СДЕЛАТЬ Перечисления? Там нет ПолучитьСсылку()	 // Enum
	// #СДЕЛАТЬ Точки маршрутов бизнес-процессов?		 // BPrPoints

	Для каждого РазделМетаданныхПрефикс Из РазделыМетаданныхПрефиксы Цикл
		
		РазделМетаданных = РазделМетаданныхПрефикс.РазделМетаданных;
		Префикс			 = РазделМетаданныхПрефикс.Префикс;
		
		ОбъектыМетаданных = Новый Массив;
		Для каждого ОбъектМетаданных Из РазделМетаданных Цикл
			ОбъектыМетаданных.Добавить(ОбъектМетаданных);
		КонецЦикла; 
		СтруктураХранения = ПолучитьСтруктуруХраненияБазыДанных(ОбъектыМетаданных, Ложь);
		СтруктураХранения = СтруктураХранения.Скопировать(Новый Структура("Назначение", "Основная"), "ИмяТаблицыХранения, Метаданные");
		СтруктураХранения.Индексы.Добавить("ИмяТаблицыХранения");
		
		ОписаниеТаблицы = СтруктураХранения.Найти(Префикс + НомерТаблицы, "ИмяТаблицыХранения");
		Если ОписаниеТаблицы = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОписаниеТаблицы.Метаданные);
		ИмяМетаданного = ОбъектМетаданных.Имя;
		Если	 РазделМетаданных = Метаданные.Справочники Тогда				Менеджер = Справочники[ИмяМетаданного];
		ИначеЕсли РазделМетаданных = Метаданные.Документы Тогда					Менеджер = Документы[ИмяМетаданного];
		ИначеЕсли РазделМетаданных = Метаданные.ПланыВидовХарактеристик Тогда	Менеджер = ПланыВидовХарактеристик[ИмяМетаданного];
		ИначеЕсли РазделМетаданных = Метаданные.ПланыСчетов Тогда				Менеджер = ПланыСчетов[ИмяМетаданного];
		ИначеЕсли РазделМетаданных = Метаданные.ПланыВидовРасчета Тогда			Менеджер = ПланыВидовРасчета[ИмяМетаданного];
		ИначеЕсли РазделМетаданных = Метаданные.БизнесПроцессы Тогда			Менеджер = БизнесПроцессы[ИмяМетаданного];
		ИначеЕсли РазделМетаданных = Метаданные.Задачи Тогда					Менеджер = Задачи[ИмяМетаданного];
			
		Иначе
			Возврат Неопределено;
			
		КонецЕсли; 
		
		Возврат Менеджер.ПолучитьСсылку(УникальныйИдентификатор);
		
	КонецЦикла; 
	
	Возврат Неопределено;

КонецФункции // ПолучитьСсылкуПоСтрокеОбъектНеНайден()

// Останавливает выполнение кода на заданное время.
// Из: http://forum.infostart.ru/forum9/topic263141/message2660525/#message2660525
//
// Параметры:
//  Секунд - Число - время ожидания в секундах.
//
Процедура Пауза(Секунд) Экспорт

    
	ИмяМодуля = "ОбщегоНазначения";	// Имя модуля, в котором расположена эта процедура

    ТекущийСеансИнформационнойБазы = ПолучитьТекущийСеансИнформационнойБазы();
    ФоновоеЗадание = ТекущийСеансИнформационнойБазы.ПолучитьФоновоеЗадание();
    
    Если ФоновоеЗадание = Неопределено Тогда
        Параметры = Новый Массив;
        Параметры.Добавить(Секунд);
        ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМодуля + ".Пауза", Параметры);
    КонецЕсли;
    
    ФоновоеЗадание.ОжидатьЗавершенияВыполнения(Секунд);
    
КонецПроцедуры // Пауза()