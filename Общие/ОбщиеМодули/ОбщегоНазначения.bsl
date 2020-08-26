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

// Формирует дерево значений по сгруппированой таблице значений
//
// Параметры:
//  ИсходнаяТаблица	 - ТаблицаЗначений		 - Исходная таблица значений
//  Группировки		 - Строка, Массив		 - Имена колонок группировок таблицы. Варианты использования:
//		* Строка - Имена полей, разделенные запятой
//		* Массив - Одна группировка может состоять из нескольких полей, разделенных запятыми. 
//  Ресурсы			 - Строка, Массив, Соответствие	 - Итоги дерева. Варианты использования:
//		* Строка		 - Имена полей итогов, разделенных запятой. Каждый итог считается как Сумма.
//		* Массив		 - Имена полей итогов. Каждый итог считается как Сумма.
//		* Соответствие	 - Ключ: Имя поля, Значение - Выражение языка компоновки данных для подсчёта ресурса. Например, "Сумма(Ресурс)"
// 
// Возвращаемое значение:
//   - ДеревоЗначений - Полученное дерево значений
//
Функция ДеревоЗначенийИзТаблицыЗначенийКомпоновкой(ИсходнаяТаблица, Группировки, Ресурсы = Неопределено)

	Если Ложь Тогда ИсходнаяТаблица = Новый ТаблицаЗначений КонецЕсли;
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СхемаКомпоновки.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя					 = "Local";
	ИсточникДанных.ТипИсточникаДанных	 = "Local";
	ИсточникДанных.СтрокаСоединения		 = "Local";
	
	#Область НаборДанных
	НаборДанныхОбъект = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанныхОбъект.ИсточникДанных = СхемаКомпоновки.ИсточникиДанных[0].Имя;
	НаборДанныхОбъект.Имя		 = "Исходная таблица";
	НаборДанныхОбъект.ИмяОбъекта = "ИсходнаяТаблица";
	ПоляНабора = НаборДанныхОбъект.Поля;
	Для каждого Колонка Из ИсходнаяТаблица.Колонки Цикл
		ПолеНабора = ПоляНабора.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеНабора.Поле			 = Колонка.Имя;
		ПолеНабора.ТипЗначения	 = Колонка.ТипЗначения;
		ПолеНабора.Заголовок	 = Колонка.Заголовок;
		ПолеНабора.ПутьКДанным	 = ПолеНабора.Поле;
	КонецЦикла; 		
	#КонецОбласти // НаборДанных 
	
	#Область Ресурсы
	Если ТипЗнч(Ресурсы) = Тип("Строка") 
		Или ТипЗнч(Ресурсы) = Тип("Массив") Тогда
		
		РесурсыМассив = ?(ТипЗнч(Ресурсы) = Тип("Строка"), СтрРазделить(Ресурсы, ", ", Ложь), Ресурсы);
		РесурсыСоответствие = Новый Соответствие;
		Для каждого Ресурс Из РесурсыМассив Цикл
			РесурсыСоответствие.Вставить(Ресурс, СтрШаблон("Сумма(%1)", Ресурс));
		КонецЦикла; 
	ИначеЕсли ТипЗнч(Ресурсы) = Тип("Соответствие") Тогда
		РесурсыСоответствие = Ресурсы;
	Иначе
		РесурсыСоответствие = Новый Соответствие;
	КонецЕсли; 
	
	ПоляИтогаСхемы = СхемаКомпоновки.ПоляИтога;
	Для каждого Элемент Из РесурсыСоответствие Цикл
		ПолеИтога = ПоляИтогаСхемы.Добавить();
		ПолеИтога.ПутьКДанным	 = Элемент.Ключ;
		ПолеИтога.Выражение		 = Элемент.Значение;
	КонецЦикла; 
	#КонецОбласти // Ресурсы 
	
	#Область Настройки
		
	#Область Структура
	ГруппировкиМассив = ?(ТипЗнч(Группировки) = Тип("Массив"), Группировки, СтрРазделить(Группировки, ", ", Ложь));
	КоллекцияЭлементовСтруктуры = СхемаКомпоновки.ВариантыНастроек[0].Настройки.Структура;
	Для каждого ГруппировкаСтрока Из ГруппировкиМассив Цикл
		Группировка = КоллекцияЭлементовСтруктуры.Добавить(Тип("ГруппировкаКомпоновкиДанных")); 
		Для каждого ИмяПоля Из СтрРазделить(ГруппировкаСтрока, ", ", Ложь) Цикл
			Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		КонецЦикла; 
		Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		КоллекцияЭлементовСтруктуры = Группировка.Структура;
	КонецЦикла;
	Группировка = КоллекцияЭлементовСтруктуры.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Группировка.ПоляГруппировки.Элементы.Добавить(Тип("АвтоПолеГруппировкиКомпоновкиДанных"));
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	#КонецОбласти // Структура 
	
	#Область ВыбранныеПоля
	ВыбранныеПоля = СхемаКомпоновки.ВариантыНастроек[0].Настройки.Выбор;
	Для каждого ПолеНабора Из НаборДанныхОбъект.Поля Цикл
		ВыбранныеПоля.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных(ПолеНабора.ПутьКДанным);		
	КонецЦикла; 
	Для каждого ВычисляемоеПоле Из СхемаКомпоновки.ВычисляемыеПоля Цикл
		ВыбранныеПоля.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных")).Поле = Новый ПолеКомпоновкиДанных(ВычисляемоеПоле.ПутьКДанным);		
	КонецЦикла; 
	#КонецОбласти // ВыбранныеПоля 
	
	#Область Параметрывывода
	СхемаКомпоновки.ВариантыНастроек[0].Настройки.ПараметрыВывода.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВертикальноеРасположениеОбщихИтогов"), РасположениеИтоговКомпоновкиДанных.Нет);
	#КонецОбласти // Параметрывывода 
	
	#КонецОбласти // Настройки 
	
	#Область КомпоновкаДанныхДляКоллекцииЗначений
	ВнешниеНаборыДанных		 = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ИсходнаяТаблица", ИсходнаяТаблица);
	ВозможностьИспользованияВнешнихФункций = Истина;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, КомпоновщикНастроек.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, , ВозможностьИспользованияВнешнихФункций);
	
	РезультатКомпоновки = Новый ДеревоЗначений;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(РезультатКомпоновки);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	#КонецОбласти // КомпоновкаДанныхДляКоллекцииЗначений 	

	Возврат РезультатКомпоновки;
	
КонецФункции // ДеревоЗначенийИзТаблицыЗначенийКомпоновкой()

Функция ТаблицаЗначенийИзСоответствия_Автотест() Экспорт
	
	ПереченьАвтотестов = Новый Массив;	// Массив структур, см. НовыйАвтотестМетода() 
	
	#Область Пример
	//ИмяМетода = "ИмяИсполняемогоМетода";
	//
	//Автотест = Автотест_ДобавитьАвтотестМетода(ПереченьАвтотестов);
	//Автотест.Описание				 = "Описание автотеста";
	//Автотест.Использование		 = Истина;
	//#Область ОписаниеАвтотеста
	//Автотест.Использование		 = Истина;
	//Автотест.ИмяМетода			 = ИмяМетода;
	//Автотест.ПараметрыВызова.Добавить("Параметр метода");
	//Автотест.ОжидаетсяЗначение	 = Ложь;
	//Автотест.ОжидаемоеЗначение	 = Неопределено;
	//Автотест.КодПроверкиРезультата = "";
	//Автотест.ОжидаетсяИсключение	 = Истина;
	//#КонецОбласти // ОписаниеАвтотеста 
	#КонецОбласти // Пример 
	
	ИмяМетода = "ТаблицаЗначенийИзСоответствия";
	
	Автотест = Автотест_ДобавитьАвтотестМетода(ПереченьАвтотестов);
	Автотест.Описание = "Исключение, если передано не соответствие";
	#Область ОписаниеАвтотеста
	Автотест.ИмяМетода = ИмяМетода;
	Автотест.ПараметрыВызова.Добавить(Неопределено);
	Автотест.ОжидаетсяЗначение	 = Ложь;
	//Автотест.ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	Автотест.ОжидаетсяИсключение = Истина;
	#КонецОбласти // ОписаниеАвтотеста 
	
	Автотест = Автотест_ДобавитьАвтотестМетода(ПереченьАвтотестов);
	Автотест.Описание = "Пустая таблица из пустого соответствия";
	#Область ОписаниеАвтотеста
	Автотест.ИмяМетода = ИмяМетода;
	Автотест.ПараметрыВызова.Добавить(Новый Соответствие);
	Автотест.ОжидаетсяЗначение	 = Истина;
	ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	ОжидаемоеЗначение.Колонки.Добавить("Ключ");
	ОжидаемоеЗначение.Колонки.Добавить("Значение");
	Автотест.ОжидаемоеЗначение = ОжидаемоеЗначение;
	//Автотест.ОжидаетсяИсключение = Истина;
	#КонецОбласти // ОписаниеАвтотеста 
	
	Автотест = Автотест_ДобавитьАвтотестМетода(ПереченьАвтотестов);
	Автотест.Описание = "Шаблонная таблица при вызове без имён колонок";
	#Область ОписаниеАвтотеста
	Автотест.ИмяМетода = ИмяМетода;
	Автотест.ПараметрыВызова.Добавить(Новый Соответствие);
	Автотест.ОжидаетсяЗначение	 = Истина;
	ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	ОжидаемоеЗначение.Колонки.Добавить("Ключ");
	ОжидаемоеЗначение.Колонки.Добавить("Значение");
	Автотест.ОжидаемоеЗначение = ОжидаемоеЗначение;
	//Автотест.ОжидаетсяИсключение = Истина;
	#КонецОбласти // ОписаниеАвтотеста 
		
	Автотест = Автотест_ДобавитьАвтотестМетода(ПереченьАвтотестов);
	Автотест.Описание = "Простая таблица";
	#Область ОписаниеАвтотеста
	Автотест.ИмяМетода = ИмяМетода;
	Соответствие = Новый Соответствие;
	Соответствие[123] = "АБВ";
	Соответствие[456] = "ГДЕ";
	Автотест.ПараметрыВызова.Добавить(Соответствие);
	Автотест.ПараметрыВызова.Добавить("Цифры, Буквы");
	Автотест.ОжидаетсяЗначение	 = Истина;
	ОжидаемоеЗначение	 = Новый ТаблицаЗначений;
	//ОжидаемоеЗначение.Колонки.Добавить("Цифры",	 Новый ОписаниеТипов("Число"));
	//ОжидаемоеЗначение.Колонки.Добавить("Буквы", Новый ОписаниеТипов("Строка"));
	ОжидаемоеЗначение.Колонки.Добавить("Цифры",	 Новый ОписаниеТипов("Число"));
	ОжидаемоеЗначение.Колонки.Добавить("Буквы", Новый ОписаниеТипов("Строка"));
	Для каждого ЭлементСответствия Из Соответствие Цикл
		Строка = ОжидаемоеЗначение.Добавить();
		Строка[0] = ЭлементСответствия.Ключ;
		Строка[1] = ЭлементСответствия.Значение;
	КонецЦикла; 
	Автотест.ОжидаемоеЗначение = ОжидаемоеЗначение;
	//Автотест.ОжидаетсяИсключение = Истина;
	#КонецОбласти // ОписаниеАвтотеста 
		
	Автотест(ПереченьАвтотестов);
	
КонецФункции

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

#КонецОбласти // ПреобразованиеЗначений

// Проверяет существование ссылки в ИБ.
//	Функция - аналог БСП.СсылкаСуществует()
//
// Параметры:
//  Ссылка - ЛюбаяСсылка - значение любой ссылки информационной базы данных
// 
// Возвращаемое значение:
//	Булево - Истина, если ссылка физически существует
//
Функция СсылкаСуществует(Ссылка) Экспорт
	
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
//	УникальныйИдентификатор	 - УникальныйИдентификатор	 - Уникальный идентификатор объекта из навигационной ссылки
//  ИмяРеквизита			 - Строка					 - Имя реквизита объекта или колонки табличной части, если указано в навигационной ссылке.
//  ИмяТабличнойЧасти		 - Строка					 - Имя табличной части, если указано в навигационной ссылке.
//  ИндексТабЧасти			 - Число					 - Индекс в табличной части, если указан в навигационной ссылке.
// 
// Возвращаемое значение:
//  Ссылка - Если определить ссылку не удалось - возвращается Неопределено.
//
Функция СсылкаНаОбъектНавигационнойСсылки(НавигационнаяСсылка, ИмяРеквизита = Неопределено, ИмяТабличнойЧасти = Неопределено, ИндексТабЧасти = Неопределено)
	
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
	
КонецФункции // СсылкаНаОбъектНавигационнойСсылки()

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


