// Добавляет декорации формы, которые отображают легенду условного оформления формы.
//
// Параметры:
//	ГруппаЭлементовЛегенды	 - ГруппаФормы		 - Группа, куда будут помещены элементы легенды
//	ОбластьОформления		 - ПолеФормы, ГруппаФормы, ТаблицаФормы, УправляемаяФорма, ДополнениеЭлементаФормы - Фильтр по затрагиваемым элементам формы
//	Форма					 - УправляемаяФорма	 - Оформляемая форма.
//
Процедура СоздатьЛегендуУсловногоОформления(ГруппаЭлементовЛегенды, 
	ОбластьОформления = Неопределено, 
	Форма = Неопределено)
	
	//Форма = ЭтаФорма;	// Раскомментируйте строку для использвания в контексте формы

	ПрефиксГруппы		 = ГруппаЭлементовЛегенды.Имя;
	ПрефиксДекорации	 = "ДекорацияЛегенды";
	
	// Чистим существующие:
	Для каждого ЭлементФормы Из ГруппаЭлементовЛегенды.ПодчиненныеЭлементы Цикл
		Если СтрНайти(ЭлементФормы.Имя, ПрефиксГруппы + ПрефиксДекорации) = 1 Тогда
			Форма.Элементы.Удалить(ЭлементФормы);
		КонецЕсли; 
	КонецЦикла; 

	ОформляемыеЭлементыФормы = Новый Массив;
	ИменаОформляемыхЭлементовФормы = Новый Массив;
	Если ОбластьОформления <> Неопределено Тогда

		ОформляемыеЭлементыФормы = Новый Массив;
		ОформляемыеЭлементыФормы.Добавить(ОбластьОформления);
		Для каждого ОформляемыйЭлементФормы Из ОформляемыеЭлементыФормы Цикл
			Если ТипЗнч(ОформляемыйЭлементФормы) = Тип("ГруппаФормы")
				Или ТипЗнч(ОформляемыйЭлементФормы) = Тип("ТаблицаФормы") 
				Или ТипЗнч(ОформляемыйЭлементФормы) = Тип("УправляемаяФорма") 
				Или ТипЗнч(ОформляемыйЭлементФормы) = Тип("ДополнениеЭлементаФормы") Тогда
				
				Для каждого ПодчиненныйЭлемент Из ОформляемыйЭлементФормы.ПодчиненныеЭлементы Цикл
					ОформляемыеЭлементыФормы.Добавить(ПодчиненныйЭлемент);
				КонецЦикла; 
				
			КонецЕсли; 
		КонецЦикла; 
		
		Для каждого Элемент Из ОформляемыеЭлементыФормы Цикл
			ИменаОформляемыхЭлементовФормы.Добавить(Элемент.Имя);
		КонецЦикла; 
		
	КонецЕсли; 
	ФильтроватьПоЭлементамФормы = ЗначениеЗаполнено(ОформляемыеЭлементыФормы);
	
	ОтображаемыеПараметрыОформления = Новый Массив;
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("Шрифт"));
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("ЦветФона"));
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("ЦветТекста"));
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("ЦветРамки"));
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("ЦветРамки"));
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("Формат"));
	ОтображаемыеПараметрыОформления.Добавить(Новый ПараметрКомпоновкиДанных("Текст"));
	
	НомерДекорации = 0;
	Для каждого ЭлементУсловногоОформления Из Форма.УсловноеОформление.Элементы Цикл
		
		НомерДекорации	 = НомерДекорации + 1;
		ИмяЭлементаФормы = ПрефиксГруппы + ПрефиксДекорации + Формат(НомерДекорации, "ЧГ=");
		
		Если не ЭлементУсловногоОформления.Использование Тогда
			Продолжить;
		КонецЕсли; 
		
		Если ФильтроватьПоЭлементамФормы Тогда
			ЕстьЗатрагивыемыеЭлементы = Ложь;
			Для каждого ОформляемоеПоле Из ЭлементУсловногоОформления.Поля.Элементы Цикл
				Если ОформляемоеПоле.Использование 
					И ИменаОформляемыхЭлементовФормы.Найти(Строка(ОформляемоеПоле.Поле)) <> Неопределено Тогда
					ЕстьЗатрагивыемыеЭлементы = Истина;	
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
			Если не ЕстьЗатрагивыемыеЭлементы Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		
		ЭлементФормы = Неопределено;
		ПредставлениеОтбора = Строка(ЭлементУсловногоОформления.Отбор);
		СоставПредставленияФормата = Новый Массив;
		ПодсказкаФормат = "";
		ПодсказкаТекст = "";
		Для каждого ЗначениеПараметра Из ЭлементУсловногоОформления.Оформление.Элементы Цикл

			Если не ЗначениеПараметра.Использование Тогда Продолжить КонецЕсли; 
			Если ОтображаемыеПараметрыОформления.Найти(ЗначениеПараметра.Параметр) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЭлементФормы = Неопределено Тогда
				ЭлементФормы = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("ДекорацияФормы"), ГруппаЭлементовЛегенды);
				Если ЗначениеЗаполнено(ЭлементУсловногоОформления.Представление) Тогда
					ЭлементФормы.Заголовок = ЭлементУсловногоОформления.Представление;
				ИначеЕсли ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
					ЭлементФормы.Заголовок = ПредставлениеОтбора;
				Иначе
					ЭлементФормы.Заголовок = "Безусловное оформление";
				КонецЕсли; 
			КонецЕсли; 
			// Оформление:
			
			Если ЗначениеПараметра.Параметр = Новый ПараметрКомпоновкиДанных("Шрифт") Тогда
				ЭлементФормы.Шрифт = ЗначениеПараметра.Значение;				
			КонецЕсли; 
			Если ЗначениеПараметра.Параметр = Новый ПараметрКомпоновкиДанных("ЦветФона") Тогда
				ЭлементФормы.ЦветФона = ЗначениеПараметра.Значение;				
			КонецЕсли; 
			Если ЗначениеПараметра.Параметр = Новый ПараметрКомпоновкиДанных("ЦветТекста") Тогда
				ЭлементФормы.ЦветТекста = ЗначениеПараметра.Значение;				
			КонецЕсли; 
			Если ЗначениеПараметра.Параметр = Новый ПараметрКомпоновкиДанных("ЦветРамки") Тогда
				ЭлементФормы.ЦветРамки = ЗначениеПараметра.Значение;				
			КонецЕсли; 
			
			Если ЗначениеПараметра.Параметр = Новый ПараметрКомпоновкиДанных("Формат") Тогда
				ТестовыеЗначения = Новый Массив;
				ТестовыеЗначения.Добавить(123456.789);
				ТестовыеЗначения.Добавить(0);
				ТестовыеЗначения.Добавить(ТекущаяДата());
				ТестовыеЗначения.Добавить('00010101');
				ТестовыеЗначения.Добавить(Истина);
				ТестовыеЗначения.Добавить(Ложь);
				Для каждого ТестовоеЗначение Из ТестовыеЗначения Цикл
					ТестовоеЗначениеСтрока = Строка(ТестовоеЗначение);
					ТестовоеЗначениеФормат = Формат(ТестовоеЗначение, ЗначениеПараметра.Значение);
					Если ТестовоеЗначениеСтрока <> ТестовоеЗначениеФормат Тогда
						ПодсказкаФормат = ?(ЗначениеЗаполнено(ПодсказкаФормат),	ПодсказкаФормат + Символы.ПС, "") 
						+ СтрШаблон("	%1	→ %2", ТестовоеЗначениеСтрока, ТестовоеЗначениеФормат);
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли;
			
			Если ЗначениеПараметра.Параметр = Новый ПараметрКомпоновкиДанных("Текст") Тогда
				ПодсказкаТекст = ЗначениеПараметра.Значение;				
			КонецЕсли; 
			
		КонецЦикла;
		
		ПодсказкаОформление = Строка(ЭлементУсловногоОформления.Оформление);
		
		ЭлементыРасширеннойПодсказки = Новый СписокЗначений;
		ЭлементыРасширеннойПодсказки.Добавить(ПредставлениеОтбора,	 "Условие");
		ЭлементыРасширеннойПодсказки.Добавить(ПодсказкаОформление,	 "Оформление");
		ЭлементыРасширеннойПодсказки.Добавить(ПодсказкаФормат,		 "Формат");
		ЭлементыРасширеннойПодсказки.Добавить(ПодсказкаТекст,		 "Текст");
		Если ЭлементФормы <> Неопределено Тогда
			СоставРасширеннойПодсказки = Новый Массив;
			Для каждого ЭлементРасширеннойПодсказки Из ЭлементыРасширеннойПодсказки Цикл
				
				Если Не ЗначениеЗаполнено(ЭлементРасширеннойПодсказки.Значение) Тогда 
					Продолжить;
				КонецЕсли;
					
				Если ЗначениеЗаполнено(СоставРасширеннойПодсказки) Тогда 
					СоставРасширеннойПодсказки.Добавить(Символы.ПС + Символы.ПС);
				КонецЕсли; 
				СоставРасширеннойПодсказки.Добавить(
					Новый ФорматированнаяСтрока(
						ЭлементРасширеннойПодсказки.Представление + ":	", 
						Новый Шрифт(, , Истина)));
				СоставРасширеннойПодсказки.Добавить(Символы.ПС);
				СоставРасширеннойПодсказки.Добавить(ЭлементРасширеннойПодсказки.Значение);

			КонецЦикла; 
			
			ЭлементФормы.РасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(СоставРасширеннойПодсказки);
			ЭлементФормы.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
			
		КонецЕсли; 
		
	КонецЦикла; 

КонецПроцедуры // СоздатьЛегендуУсловногоОформления()
