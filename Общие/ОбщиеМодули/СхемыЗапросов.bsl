// Присоединяет схему запроса к существуещей схеме.
//
// Параметры:
//  ИсходнаяСхемаЗапроса            - СхемаЗапроса  - Обобщающая схема
//  ПрисоединяемаяСхемаЗапроса      - СхемаЗапроса  - схема, которая будет добавлена к исходной
//
Процедура ПрисоединитьСхемуЗапроса(ИсходнаяСхемаЗапроса, ПрисоединяемаяСхемаЗапроса)

	Если Ложь Тогда 
		ИсходнаяСхемаЗапроса		= Новый СхемаЗапроса;
		ПрисоединяемаяСхемаЗапроса	= Новый СхемаЗапроса;
	КонецЕсли;
	
	Для каждого ЗапросСхемыПрисоединяемый Из ПрисоединяемаяСхемаЗапроса.ПакетЗапросов Цикл
		Если ИсходнаяСхемаЗапроса.ПакетЗапросов.Количество() = 1
			И ТипЗнч(ИсходнаяСхемаЗапроса.ПакетЗапросов[0]) = Тип("ЗапросВыбораСхемыЗапроса")
			И НЕ ИсходнаяСхемаЗапроса.ПакетЗапросов[0].Колонки.Количество() Тогда     // Первый запрос пакета не задан
			ЗапросСхемыПрисоединенный = ИсходнаяСхемаЗапроса.ПакетЗапросов[0];
		Иначе
			ЗапросСхемыПрисоединенный = ИсходнаяСхемаЗапроса.ПакетЗапросов.Добавить(ТипЗнч(ЗапросСхемыПрисоединяемый));
		КонецЕсли;
		Если ТипЗнч(ЗапросСхемыПрисоединяемый) = Тип("ЗапросВыбораСхемыЗапроса") Тогда
			ЗапросСхемыПрисоединенный.УстановитьТекстЗапроса(ЗапросСхемыПрисоединяемый.ПолучитьТекстЗапроса());
		ИначеЕсли ТипЗнч(ЗапросСхемыПрисоединяемый) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
			ЗапросСхемыПрисоединенный.ИмяТаблицы        = ЗапросСхемыПрисоединяемый.ИмяТаблицы;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Создаёт запросы пакета на уничтожение временных таблиц
//
// Параметры:
//  СхемаЗапроса             - СхемаЗапроса  -
//
Процедура ДобавитьУничтожениеВременныхТаблицСхемыЗапроса(СхемаЗапроса)

	Если Ложь Тогда 
		СхемаЗапроса = Новый СхемаЗапроса;
	КонецЕсли;

	СуществующиеВременныеТаблицы = Новый Массив; // Удалённые после создания схемы временные таблицы почему-то остаются среди доступных
	Для каждого ЗапросСхемы Из СхемаЗапроса.ПакетЗапросов Цикл
		Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") Тогда
			Если ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) Тогда
					СуществующиеВременныеТаблицы.Добавить(ЗапросСхемы.ТаблицаДляПомещения);
			КонецЕсли;
		Иначе  // Уничтожение
			Индекс = СуществующиеВременныеТаблицы.Найти(ЗапросСхемы.ИмяТаблицы);
			Если Индекс <> Неопределено Тогда
					СуществующиеВременныеТаблицы.Удалить(Индекс);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ЗапросСхемы = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
	ИмяВременнойТаблицыРезультата = ЗапросСхемы.ТаблицаДляПомещения;     // На случай, если результатом запроса является временная таблица

	// Уничтожим временные таблицы:
	ГруппыДоступныхТаблиц = ЗапросСхемы.ДоступныеТаблицы;
	ДоступныеТаблицы = ГруппыДоступныхТаблиц[ГруппыДоступныхТаблиц.Количество() - 1].Состав;    // Временные таблицы
	Для каждого ДоступнаяТаблица Из ДоступныеТаблицы Цикл
		Если ДоступнаяТаблица.Имя = ИмяВременнойТаблицыРезультата Тогда Продолжить КонецЕсли;
		Если СуществующиеВременныеТаблицы.Найти(ДоступнаяТаблица.Имя) = Неопределено Тогда Продолжить КонецЕсли;
		ЗапросСхемы = СхемаЗапроса.ПакетЗапросов.Добавить(Тип("ЗапросУничтоженияТаблицыСхемыЗапроса"));
		ЗапросСхемы.ИмяТаблицы = ДоступнаяТаблица.Имя;
	КонецЦикла;

КонецПроцедуры    // ДобавитьУничтожениеВременныхТаблицСхемыЗапроса()

// Добавляет источник - временную таблицу из менеджера временных таблиц
//
// Параметры:
//  ОператорСхемы			 - ОператорВыбратьСхемыЗапроса	 - Оператор, в который добавляется источник.
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц	 - Источник сведений о таблице
//  ИмяТаблицы				 - Строка	 - Имя таблицы в менеджере
//  Псевдоним				 - Строка	 - Псевдоним добавляемого источника
//
// Возвращаемое значение:
//  ИсточникСхемыЗапроса - Добавленный источник
//
Функция ДобавитьИсточникСхемыЗапросаВременнуюТаблицу(ОператорСхемы, МенеджерВременныхТаблиц, ИмяТаблицы, Псевдоним = "")

	Если Ложь Тогда СхемаЗапроса = Новый СхемаЗапроса; ОператорСхемы = СхемаЗапроса.ПакетЗапросов[0].Операторы[0] КонецЕсли;
	Если Ложь Тогда МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц КонецЕсли;

	ВременнаяТаблица = МенеджерВременныхТаблиц.Таблицы.Найти(ИмяТаблицы);
	ИсточникСхемы = ОператорСхемы.Источники.Добавить(
		Тип("ОписаниеВременнойТаблицыСхемыЗапроса"), 
		ВременнаяТаблица.ПолноеИмя, 
		?(ЗначениеЗаполнено(Псевдоним), Псевдоним, Неопределено));
	Для каждого Колонка Из ВременнаяТаблица.Колонки Цикл
		Тип = ТипЗнч(Колонка.ТипЗначения.ПривестиЗначение());
		Если Тип = Тип("Неопределено") Тогда 
			Тип = Неопределено;
		КонецЕсли;
		Если Тип = Тип("Строка") Тогда 
			Тип = Неопределено;	// Для последующей связи по строке возможны проблемы, т.к. по умолчанию это строка неограниченной длины.
		КонецЕсли;		
		ИсточникСхемы.Источник.ДоступныеПоля.Добавить(Колонка.Имя, Тип);
	КонецЦикла;
	Псевдоним = ИсточникСхемы.Источник.Псевдоним;
	Возврат ИсточникСхемы;

КонецФункции // ДобавитьИсточникСхемыЗапросаВременнуюТаблицу()

// Производит поиск временной таблицы с указанным именем
//
// Параметры:
//  СхемаЗапроса - СхемаЗапроса	 - Схема, в которой будет произведён поиск
//  ИмяТаблицы	 - Строка		 - Имя искомой таблицы
// 
// Возвращаемое значение:
//  ЗапросВыбораСхемыЗапроса, Неопределено - Найденный запрос. Если запрос отсутствует, будет возвращено Неопределено.
//
Функция НайтиВременнуюТаблицуСхемыЗапроса(СхемаЗапроса, ИмяТаблицы)
	
	Для каждого ЗапросСхемы Из СхемаЗапроса.ПакетЗапросов Цикл
		Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") 
			И ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) 
			И ЗапросСхемы.ТаблицаДляПомещения = ИмяТаблицы Тогда
			Возврат ЗапросСхемы;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции // НайтиВременнуюТаблицуСхемыЗапроса()

// Производит поиск временных таблиц с указанным именем
//
// Параметры:
//  СхемаЗапроса - СхемаЗапроса	 - Схема, в которой будет произведён поиск
//  ИмяТаблицы	 - Строка		 - Имя искомой таблицы
// 
// Возвращаемое значение:
//  Массив - Найденые таблицы. Элемент: ЗапросВыбораСхемыЗапроса
//
Функция НайтиВременныеТаблицыСхемыЗапроса(СхемаЗапроса, ИмяТаблицы)
	
	Перем ЗапросСхемы, НайденныеЗапросыСхемы;
	
	НайденныеЗапросыСхемы = Новый Массив;
	Для каждого ЗапросСхемы Из СхемаЗапроса.ПакетЗапросов Цикл
		Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") 
			И ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) 
			И ЗапросСхемы.ТаблицаДляПомещения = ИмяТаблицы Тогда
			НайденныеЗапросыСхемы.Добавить(ЗапросСхемы);
		КонецЕсли; 
	КонецЦикла;
	
	Возврат НайденныеЗапросыСхемы;

КонецФункции

// Выполняет замену запроса схемы пакетом запросов другой схемы.
// Последний запрос заменяющей схемы используется вместо заменяемого запроса.
// Следует использовать для замены запросов-болванок полноценными запросами, формируемыми отдельно.
// Из заменяемой таблицы берутся:
//  * Выбираемые поля
//  * Имя таблицы для помещения
//  * Индексы
//
// Параметры:
//  ИсходнаяСхемаЗапроса	 - СхемаЗапроса				 - Модифицируемая схема запроса
//  ЗаменяемыйЗапросСхемы	 - ЗапросВыбораСхемыЗапроса	 - Заменяемый запрос схемы
//  ЗаменяющаяСхемаЗапроса	 - СхемаЗапроса				 - Схема, запросы которой заменяют ЗаменяемыйЗапросСхемы
//  ПрефиксЗаменающихТаблиц	 - Строка					 - Префикс, который будет установлен заменяющим запросам на формирование временных таблиц
//  СоответствиеИменПолей	 - Соответствие				 - Поля соответствия последнего запроса заменяющей схемы и заменяемого запроса. 
//		Ключ: Имя поля заменяющий схемы. Значение: Целевое имя поля (заменяемого запроса).
//		Поля, присутствующие в исходном запросе, переименованы не будут.
//
Процедура ЗаменитьВременнуюТаблицуСхемойЗапроса(
	ИсходнаяСхемаЗапроса, 
	ЗаменяемыйЗапросСхемы, 
	Знач ЗаменяющаяСхемаЗапроса, 
	ПрефиксЗаменающихТаблиц = "", 
	Знач СоответствиеИменПолей = Неопределено)

	Если Ложь Тогда 
		ИсходнаяСхемаЗапроса = Новый СхемаЗапроса;
		ЗаменяемыйЗапросСхемы = ИсходнаяСхемаЗапроса.ПакетЗапросов.Добавить();
	КонецЕсли;
	
	Если СоответствиеИменПолей = Неопределено Тогда
		СоответствиеИменПолей = новый Соответствие;
	КонецЕсли; 
	
	СхемаЗапросаПрисоединяемая = Новый СхемаЗапроса;
	СхемаЗапросаПрисоединяемая.УстановитьТекстЗапроса(ЗаменяющаяСхемаЗапроса.ПолучитьТекстЗапроса());
	
	// Префиксация:
	Если ЗначениеЗаполнено(ПрефиксЗаменающихТаблиц) Тогда
		Для каждого ЗапросСхемы Из СхемаЗапросаПрисоединяемая.ПакетЗапросов Цикл
			Если ТипЗнч(ЗапросСхемы) = Тип("ЗапросВыбораСхемыЗапроса") И ЗначениеЗаполнено(ЗапросСхемы.ТаблицаДляПомещения) Тогда
				ЗапросСхемы.ТаблицаДляПомещения = ПрефиксЗаменающихТаблиц + ЗапросСхемы.ТаблицаДляПомещения;
			ИначеЕсли ТипЗнч(ЗапросСхемы) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
				ЗапросСхемы.ИмяТаблицы = ПрефиксЗаменающихТаблиц + ЗапросСхемы.ИмяТаблицы;
			КонецЕсли; 
		КонецЦикла; 	
	КонецЕсли;
	
	// Замена:
	Для каждого ПрисоединяемыйЗапрос Из СхемаЗапросаПрисоединяемая.ПакетЗапросов Цикл
		
		ЭтоПоследнийЗапросПрисоединяемойСхемы = СхемаЗапросаПрисоединяемая.ПакетЗапросов.Индекс(ПрисоединяемыйЗапрос) = (СхемаЗапросаПрисоединяемая.ПакетЗапросов.Количество() - 1);
		
		Если Не ЭтоПоследнийЗапросПрисоединяемойСхемы Тогда
			
			// Вставка до заменяемого запроса
			
			ЗапроСхемыПрисоединенный = ИсходнаяСхемаЗапроса.ПакетЗапросов.Добавить(ТипЗнч(ПрисоединяемыйЗапрос));
			Если ТипЗнч(ПрисоединяемыйЗапрос) = Тип("ЗапросВыбораСхемыЗапроса") Тогда
				ЗапроСхемыПрисоединенный.УстановитьТекстЗапроса(ПрисоединяемыйЗапрос.ПолучитьТекстЗапроса());
			ИначеЕсли ТипЗнч(ПрисоединяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
				ЗапроСхемыПрисоединенный.ИмяТаблицы = ПрисоединяемыйЗапрос.ИмяТаблицы;
			КонецЕсли;
			ИсходнаяСхемаЗапроса.ПакетЗапросов.Сдвинуть(
			ИсходнаяСхемаЗапроса.ПакетЗапросов.Индекс(ЗапроСхемыПрисоединенный),
			ИсходнаяСхемаЗапроса.ПакетЗапросов.Индекс(ЗаменяемыйЗапросСхемы));
		
		Иначе	
			
			// Замена запроса с установкой аттрибутов
			
			ЗапросСхемыИсточник = ПрисоединяемыйЗапрос;
			ЗапросСхемыПриемник = ЗаменяемыйЗапросСхемы;
			ЗапросСхемыДубликатПриемника = ИсходнаяСхемаЗапроса.ПакетЗапросов.ДобавитьКопию(
				ИсходнаяСхемаЗапроса.ПакетЗапросов.Индекс(ЗапросСхемыПриемник));	// Используется для проверки колонок и пререноса атрибутов.
			
			// Удаление лишних колонок
			УдаляемыеКолонки = Новый Массив;
			Для каждого КолонкаСхемы Из ЗапросСхемыИсточник.Колонки Цикл
				Если ЗапросСхемыДубликатПриемника.Колонки.Найти(КолонкаСхемы.Псевдоним) = Неопределено 
					и СоответствиеИменПолей.Получить(КолонкаСхемы.Псевдоним) = Неопределено  Тогда
					УдаляемыеКолонки.Добавить(КолонкаСхемы);	// Пропуск поля
				КонецЕсли; 				
			КонецЦикла;
			Для каждого УдаляемаяКолонка Из УдаляемыеКолонки Цикл
				ЗапросСхемыИсточник.Колонки.Удалить(ЗапросСхемы.Колонки.Индекс(УдаляемаяКолонка));
			КонецЦикла; 
			
			// Переименование колонок:
			Для каждого КолонкаСхемы Из ЗапросСхемыИсточник.Колонки Цикл
				Если ЗапросСхемыДубликатПриемника.Колонки.Найти(КолонкаСхемы.Псевдоним) = Неопределено 
					и СоответствиеИменПолей.Получить(КолонкаСхемы.Псевдоним) <> Неопределено  Тогда
					КолонкаСхемы.Псевдоним = СоответствиеИменПолей[КолонкаСхемы.Псевдоним];
				КонецЕсли; 
			КонецЦикла; 
			
			ЗапросСхемыИсточник.ТаблицаДляПомещения = ЗапросСхемыПриемник.ТаблицаДляПомещения;
			ЗапросСхемыПриемник.УстановитьТекстЗапроса(ЗапросСхемыИсточник.ПолучитьТекстЗапроса());
			
			Для каждого ВыражениеИндексаДубликат Из ЗапросСхемыДубликатПриемника.Индекс Цикл
				Если ТипЗнч(ВыражениеИндексаДубликат.Выражение) = Тип("КолонкаСхемыЗапроса") Тогда
					ЗапросСхемыПриемник.Индекс.Добавить(
						ЗапросСхемыПриемник.Колонки.Найти(
							ВыражениеИндексаДубликат.Выражение.Псевдоним));
				Иначе	// ВыражениеСхемыЗапроса
					// #СДЕЛАТЬ
				КонецЕсли; 
			КонецЦикла;
			
			ИсходнаяСхемаЗапроса.ПакетЗапросов.Удалить(ИсходнаяСхемаЗапроса.ПакетЗапросов.Индекс(ЗапросСхемыДубликатПриемника));
			
		КонецЕсли; 
		
	КонецЦикла;

КонецПроцедуры

// Получает параметр виртуальной таблицы по его имени, как оно указано в конструкторе запроса.
//
// Параметры:
//  ТаблицаСхемы - ТаблицаСхемыЗапроса	 - Таблица, параметры которой получаются.
//  ИмяПараметра - Строка				 - Имя искомого параметра.
//		Допустимые значения:
//
//		 Регистр сведений (срез первых и последних):
//			* Период
//			* Условие
//		
//		 Регистр накопления, остатки:
//			* Период
//			* Условие
//		
//		 Регистр накопления, обороты:
//			* НачалоПериода
//			* КонецПериода
//			* Периодичность
//			* Условие
//		
//		 Регистр накопления, остатки и обороты:
//			* НачалоПериода
//			* КонецПериода
//			* Периодичность
//			* МетодДополнения
//			* Условие
//		
//		 Регистр бухгалтерии, остатки:
//			* Период
//			* УсловиеСчета
//			* Субконто
//			* Условие
//		
//		 Регистр бухгалтерии, обороты:
//			* НачалоПериода
//			* КонецПериода
//			* Периодичность
//			* УсловиеСчета
//			* Субконто
//			* Условие
//			* УсловиеКорСчета	 - (при поддержке корреспонденции)
//			* КорСубконто		 - (при поддержке корреспонденции)
//		
//		 Регистр бухгалтерии, обороты Дт Кт:
//			* НачалоПериода
//			* КонецПериода
//			* Периодичность
//			* УсловиеСчетаДт
//			* СубконтоДт
//			* УсловиеСчетаКт
//			* СубконтоКт
//			* Условие
//		
//		 Регистр бухгалтерии, остатки и обороты: 
//			* НачалоПериода
//			* КонецПериода
//			* Периодичность
//			* МетодДополнения
//			* УсловиеСчета
//			* Субконто
//			* Условие
//		
//		 Регистр бухгалтерии, движения с субконто: 
//			* НачалоПериода
//			* КонецПериода
//			* Условие
//			* Упорядочивание
//			* Первые
//		
//		 Регистр расчета, фактический период действия:
//			* Условие
//		
//		 Регистр расчета, данные графика:
//			* Условие
//		
//		 Регистр расчета, таблица базовых данных:
//			* ИзмеренияОсновногоРегистра
//			* ИзмеренияБазовогоРегистра
//			* Разрезы
//			* Условие
//		
//		 Критерий отбора:
//			* Значение
//		
//		 Задача, задачи по исполнителю
//			* Исполнитель
//			* Условие
// 
// Возвращаемое значение:
//  - ПараметрТаблицыСхемыЗапроса - Найденный параметр. 
//	- Неопределено - Если параметр не найден.
//
Функция ПараметрВиртульнойТаблицыСхемыЗапроса(ТаблицаСхемы, ИмяПараметра)
	
	Если Ложь Тогда 
		СхемаЗапроса	 = Новый СхемаЗапроса;
		ЗапросСхемы		 = СхемаЗапроса.ПакетЗапросов[0];
		ОператорСхемы	 = ЗапросСхемы.Операторы[0];
		ТаблицаСхемы	 = ОператорСхемы.Источники[0].Источник;
	КонецЕсли;
	
	ИменаПараметров		 = Новый Массив;	// Имена параметров в порядке их следования
	
	ИмяТаблицы = ТаблицаСхемы.ИмяТаблицы;
	Если СтрНачинаетсяС(ИмяТаблицы, "РегистрСведений.")
		И (СтрЗаканчиваетсяНа(ИмяТаблицы, ".СрезПервых")
		Или СтрЗаканчиваетсяНа(ИмяТаблицы, ".СрезПоследних")) Тогда
		
		ИменаПараметров.Добавить("Период");
		ИменаПараметров.Добавить("Условие");
		
	ИначеЕсли СтрНачинаетсяС(ИмяТаблицы, "РегистрНакопления.")
		И СтрЗаканчиваетсяНа(ИмяТаблицы, ".Остатки") Тогда
		
		ИменаПараметров.Добавить("Период");
		ИменаПараметров.Добавить("Условие");
		
	ИначеЕсли СтрНачинаетсяС(ИмяТаблицы, "РегистрНакопления.")
		И СтрЗаканчиваетсяНа(ИмяТаблицы, ".ОстаткиИОбороты") Тогда
		
		ИменаПараметров.Добавить("НачалоПериода");
		ИменаПараметров.Добавить("КонецПериода");
		ИменаПараметров.Добавить("Периодичность");
		ИменаПараметров.Добавить("МетодДополнения");
		ИменаПараметров.Добавить("Условие");
		
	ИначеЕсли СтрНачинаетсяС(ИмяТаблицы, "РегистрБухгалтерии.") Тогда
		
		Если СтрЗаканчиваетсяНа(ИмяТаблицы, ".Остатки") Тогда
		
			ИменаПараметров.Добавить("Период");
			ИменаПараметров.Добавить("УсловиеСчета");
			ИменаПараметров.Добавить("Субконто");
			ИменаПараметров.Добавить("Условие");
			
		ИначеЕсли СтрЗаканчиваетсяНа(ИмяТаблицы, ".Обороты") Тогда
		
			ИменаПараметров.Добавить("НачалоПериода");
			ИменаПараметров.Добавить("КонецПериода");
			ИменаПараметров.Добавить("Периодичность");
			ИменаПараметров.Добавить("УсловиеСчета");
			ИменаПараметров.Добавить("Субконто");
			ИменаПараметров.Добавить("Условие");
			
			ЕстьКорреспонденция = ТаблицаСхемы.Параметры.Количество() > ИменаПараметров.Количество();
			Если ЕстьКорреспонденция Тогда
				ИменаПараметров.Добавить("УсловиеКорСчета");
				ИменаПараметров.Добавить("КорСубконто");
			КонецЕсли; 
			
		ИначеЕсли СтрЗаканчиваетсяНа(ИмяТаблицы, ".ОборотыДтКт") Тогда
		
			ИменаПараметров.Добавить("НачалоПериода");
			ИменаПараметров.Добавить("КонецПериода");
			ИменаПараметров.Добавить("Периодичность");
			ИменаПараметров.Добавить("УсловиеСчетаДт");
			ИменаПараметров.Добавить("СубконтоДт");
			ИменаПараметров.Добавить("УсловиеСчетаКт");
			ИменаПараметров.Добавить("СубконтоКт");
			ИменаПараметров.Добавить("Условие");
			
		ИначеЕсли СтрЗаканчиваетсяНа(ИмяТаблицы, ".ОстаткиИОбороты") Тогда
				
			ИменаПараметров.Добавить("НачалоПериода");
			ИменаПараметров.Добавить("КонецПериода");
			ИменаПараметров.Добавить("Периодичность");
			ИменаПараметров.Добавить("МетодДополнения");
			ИменаПараметров.Добавить("УсловиеСчета");
			ИменаПараметров.Добавить("Субконто");
			ИменаПараметров.Добавить("Условие");
			
		ИначеЕсли СтрЗаканчиваетсяНа(ИмяТаблицы, ".ДвиженияССубконто") Тогда
				
			ИменаПараметров.Добавить("НачалоПериода");
			ИменаПараметров.Добавить("КонецПериода");
			ИменаПараметров.Добавить("Условие");
			ИменаПараметров.Добавить("Упорядочивание");
			ИменаПараметров.Добавить("Первые");
		
		Иначе
			
			Возврат Неопределено;
		
		КонецЕсли; 
		
	ИначеЕсли СтрНачинаетсяС(ИмяТаблицы, "РегистрРасчетов.") Тогда
		
		Если СтрЗаканчиваетсяНа(ИмяТаблицы, ".ФактическийПериодДействия") 
			Тогда
			
			ИменаПараметров.Добавить("Условие");
			
		ИначеЕсли СтрЗаканчиваетсяНа(ИмяТаблицы, ".ДанныеГрафика") Тогда
			
			ИменаПараметров.Добавить("Условие");
			
		ИначеЕсли СтрНайти(ИмяТаблицы, ".База") Тогда
			
			ИменаПараметров.Добавить("ИзмеренияОсновногоРегистра");
			ИменаПараметров.Добавить("ИзмеренияБазовогоРегистра");
			ИменаПараметров.Добавить("Разрезы");
			ИменаПараметров.Добавить("Условие");
			
		Иначе
			
			Возврат Неопределено;
		
		КонецЕсли; 
				
	ИначеЕсли СтрНачинаетсяС(ИмяТаблицы, "КритерийОтбора.") Тогда
		
		ИменаПараметров.Добавить("Значение");
		
	ИначеЕсли СтрНачинаетсяС(ИмяТаблицы, "Задача")
		И СтрЗаканчиваетсяНа(ИмяТаблицы, ".ЗадачиПоИсполнителю") Тогда
		
			ИменаПараметров.Добавить("Исполнитель");
			ИменаПараметров.Добавить("Условие");
		
	Иначе
		
		Возврат Неопределено;
	
	КонецЕсли; 
	
	ИндексыПараметровВРег	 = Новый Соответствие;
	Для Индекс = 1 По ИменаПараметров.ВГраница() Цикл
		ИндексыПараметровВРег.Вставить(ВРег(ИменаПараметров[Индекс]), Индекс);
	КонецЦикла;  
	
	ИндексПараметра = ИндексыПараметровВРег[ВРег(ИмяПараметра)];
	
	Если ИндексПараметра = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Возврат ТаблицаСхемы.Параметры[ИндексПараметра];
	
КонецФункции // ПараметрВиртульнойТаблицыСхемыЗапроса()

