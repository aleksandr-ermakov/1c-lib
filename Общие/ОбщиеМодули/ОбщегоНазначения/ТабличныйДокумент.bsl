
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



// Группирует строки табличного документа по значению колонки.
//
// Параметры:
//  ТабличныйДокумент 	 - ТабличныйДокумент - Документ для группировки.
//  НомерКолонки		 - Число - Номер колонки со значением группировки. Тип значения - Произвольный.
//		Строки с одниаковым значением в колонке, идущие подряд, будут сгруппированы.
//		Например, в качестве значения группировки может выступать "уровень" -- число, 
//		обозначающее уровень вложенности строки в таблице.
//	ВысотаЗаголовка		 - Число - Высота шапки таблицы, в строках. Если шапка отсутствует, указывается 0.
//		Строки шапки не попадают в расчет группировок.
//
Процедура СгруппироватьТабличныйДокументПоЗначениямКолонки(ТабличныйДокумент, НомерКолонки, ВысотаЗаголовка = 0)
	
	Если Ложь Тогда 
		ТабличныйДокумент = Новый ТабличныйДокумент;
	КонецЕсли;
	
	НомерПервойСтроки	 = ВысотаЗаголовка + 1;
	НомерПоследнейСтроки = ТабличныйДокумент.ВысотаТаблицы;
	
	СтрокиНачалаГруппировок = Новый Массив;
	ЗначенияГруппировок = Новый Массив;
	ЗначениеТекущейГруппировки = Неопределено;
	Для НомерСтроки = НомерПервойСтроки По НомерПоследнейСтроки Цикл
		
		ЯчейкаГруппировки = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
		Если ЯчейкаГруппировки.СодержитЗначение Тогда
			ЗначениеГруппировки = ЯчейкаГруппировки.Значение;
		Иначе
			ЗначениеГруппировки = ЯчейкаГруппировки.Текст;
		КонецЕсли; 
		
		Если ЗначениеГруппировки <> ЗначениеТекущейГруппировки Тогда 
			
			//Закрываем группировки до текущей:
			ИндексГруппировки = Неопределено;	// Индекс с конца массива
			Для ОбратныйИндекс = -ЗначенияГруппировок.ВГраница() По 0 Цикл
				Индекс = -ОбратныйИндекс;
				Если ЗначенияГруппировок[Индекс] = ЗначениеГруппировки Тогда
					ИндексГруппировки = Индекс;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ИндексГруппировки <> Неопределено Тогда
				Для ОбратныйИндекс = -ЗначенияГруппировок.ВГраница() По -ИндексГруппировки Цикл
					Индекс = -ОбратныйИндекс; 
					НомерСтрокиНачалаГруппировки = СтрокиНачалаГруппировок[Индекс];
					ТабличныйДокумент.Область(НомерСтрокиНачалаГруппировки, , НомерСтроки - 1).Сгруппировать();
					СтрокиНачалаГруппировок.Удалить(Индекс);
					ЗначенияГруппировок.Удалить(Индекс);
				КонецЦикла;			
			КонецЕсли;   
			
			// Стартуем текущую группировку:    
			СтрокиНачалаГруппировок.Добавить(НомерСтроки);		
			ЗначенияГруппировок.Добавить(ЗначениеГруппировки);
			ЗначениеТекущейГруппировки = ЗначениеГруппировки;
			
		КонецЕсли;  
		
	КонецЦикла; 
	
	Пока ЗначениеЗаполнено(СтрокиНачалаГруппировок) Цикл  
		Индекс = СтрокиНачалаГруппировок.ВГраница();
		НомерСтрокиНачалаГруппировки = СтрокиНачалаГруппировок[Индекс];
		ТабличныйДокумент.Область(НомерСтрокиНачалаГруппировки, , НомерПоследнейСтроки).Сгруппировать();
		СтрокиНачалаГруппировок.Удалить(Индекс);
		ЗначенияГруппировок.Удалить(Индекс);
	КонецЦикла;
	
КонецПроцедуры // СгруппироватьТабличныйДокументПоЗначениямКолонки()     
