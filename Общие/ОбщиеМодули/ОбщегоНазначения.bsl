#Область ТаблицаЗначений

// Выгружает значения нескольких колонок таблицы значений в один массив.
//	Порядок следования значений в массиве соответствует порядку следования колонок.
//
// Параметры:
//	ИсходнаяТаблица		 - ТаблицаЗначений	 - Таблица, данные которой требуется выгрузить
//	Колонки				 - Строка			 - Перечисление колонок, которые слудует выгрузить. Если не указан, выгружаются все колонки.
//	Отбор				 - Структура		 - Отбор, строк таблицы для выгрузки.
//	ТолькоЗаполненные	 - Булево			 - Будут выгружены только заполненные значения. Значения проверяются функцией ЗначениеЗаполнено().
//	ТолькоУникальные	 - Булево			 - Полученный массив будет содержать только уникальные значения. Порядок следования значений в массиве - произвольный.
//
// Возвращаемое значение:
//	Массив - Значения колонок исходной таблицы.
//
Функция ЗначенияТаблицыЗначенийВМассив(ИсходнаяТаблица, Знач Колонки = "", Отбор = Неопределено, ТолькоЗаполненные = Ложь, ТолькоУникальные = Ложь)
	
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

// Разносит значения из определённой колонки таблицы в самостоятельные колонки.
//
// Параметры:
//	ИсходнаяТаблица		 - ТаблицаЗначений	 - Таблица для обработки
//	Измерения			 - Строка			 - Измерения, сохраняемые в таблице значений.
//	КолонкаПоказателя	 - Строка			 - Имя колонки, значения из которой  будут вынесены в отдельные колонки.
//	КолонкиПоказателя	 - Соответствие		 - Значения, которые будут разнесены по колонкам. В результирующей таблице будут только значения показателя, указанного в этой коллекции.
//		Ключ	 - Произвольный	 - Значение, выделяемое в колонку 
//		Значение - Строка		 - Префикс поздаваемой колонки.
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
	Для КолонкаПоказатель Из КолонкиПоказателя Цикл
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
				Для каждого ПозицияРезультат Из РезультирующаяТаблица.НайтиСтроки(СтруктураПоиска) Цикл
					Прервать;
				КонецЦикла;
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
Функция ПолучитьРазличныеЗначенияКолонкиДереваЗначений(Узел, ИмяКолонки, Значения = Неопределено)
	
	ЭтоНачалоРекурсии = Значения = Неопределено;

	Если ТипЗнч(Узел) = Тип("СтрокаДереваЗначений") Тогда
		
		Значения.Вставить(Узел[ИмяКолонки]);
		Для каждого Ветвь Из Узел.Строки Цикл
			ПолучитьРазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, Значения)
		КонецЦикла;
	
	ИначеЕсли ТипЗнч(Узел) = Тип("ДеревоЗначений") Тогда
		
		Значения = Новый Соответствие;
		
		Для каждого Ветвь Из Узел.Строки Цикл
			ПолучитьРазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, Значения)
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Узел) = Тип("Строка") и ЭтоАдресВременногоХранилища(Узел) Тогда
		
		Возврат ПолучитьРазличныеЗначенияКолонкиДереваЗначений(ПолучитьИзВременногоХранилища(Узел), ИмяКолонки);
		
	КонецЕсли; 
	
	Если ЭтоНачалоРекурсии Тогда // Формируем результирующий массив
		
		МассивЗначений = Новый Массив;
		Для каждого Элемент Из Значения Цикл
			МассивЗначений.Добавить(Элемент.Ключ);
		КонецЦикла; 
		
		Возврат МассивЗначений;
			
	КонецЕсли; 
	
	Возврат Значения;

КонецФункции // ПолучитьРазличныеЗначенияКолонкиДереваЗначений()

// Получает различные значения указанного поля дерева значений.
//
// Параметры:
//  Узел					 - Строка, ДеревоЗначений, СтрокаДереваЗначений - Дерево значений, или его адрес во временном хранилище
//  ИмяКолонки				 - Строка			 - Имена получаемой колонки
//  ПромежуточнаяКоллекция	 - Неопределено		 - (служебный)
// 
// Возвращаемое значение:
//  Массив - Полученные значения.
//
Функция ПолучитьРазличныеЗначенияКолонкиДереваЗначений(Узел, ИмяКолонки, ПромежуточнаяКоллекция = Неопределено)
	
	ЭтоНачалоРекурсии = ПромежуточнаяКоллекция = Неопределено;

	Если ТипЗнч(Узел) = Тип("СтрокаДереваЗначений") Тогда
		
		ПромежуточнаяКоллекция.Вставить(Узел[ИмяКолонки]);
		Для каждого Ветвь Из Узел.Строки Цикл
			ПолучитьРазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, ПромежуточнаяКоллекция)
		КонецЦикла;
	
	ИначеЕсли ТипЗнч(Узел) = Тип("ДеревоЗначений") Тогда
		
		ПромежуточнаяКоллекция = Новый Соответствие;
		
		Для каждого Ветвь Из Узел.Строки Цикл
			ПолучитьРазличныеЗначенияКолонкиДереваЗначений(Ветвь, ИмяКолонки, ПромежуточнаяКоллекция)
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Узел) = Тип("Строка") и ЭтоАдресВременногоХранилища(Узел) Тогда
		
		ДеревоДанных = ПолучитьИзВременногоХранилища(Узел);
		Если ТипЗнч(ДеревоДанных) = Тип("ДеревоЗначений") Тогда
			Возврат ПолучитьРазличныеЗначенияКолонкиДереваЗначений(ДеревоДанных, ИмяКолонки);
		Иначе
			Возврат Новый Массив;
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если ЭтоНачалоРекурсии и ПромежуточнаяКоллекция <> Неопределено Тогда // Формируем результирующий массив
		
		МассивЗначений = Новый Массив;
		Для каждого Элемент Из ПромежуточнаяКоллекция Цикл
			МассивЗначений.Добавить(Элемент.Ключ);
		КонецЦикла; 
		
		Возврат МассивЗначений;
			
	КонецЕсли; 
	
	Возврат ПромежуточнаяКоллекция;

КонецФункции // ПолучитьРазличныеЗначенияКолонокДереваЗначений()

#КонецОбласти	// ДеревоЗначений

