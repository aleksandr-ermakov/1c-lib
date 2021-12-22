
// Производит поиск элемента формы с заданными свойствами
//
// Параметры:
//  ОбластьПоиска	 - ФормаКлиентскогоПриложения, ГруппаФормы, ТаблицаФормы
//  ОтборПоТипам	 - Тип,	Массив из Тип, ОписаниеТипов		 - Типы искомых элементов
//  ОтборПоСвойствам - Структура - Значения свойств элемента
//  Рекурсивно		 - Булево	 - Будет выполнен поиск в подчиненных элементах вложенных групп и таблиц.
// 
// Возвращаемое значение:
//  Массив - Найденные элементы формы      
//
// Примеры:
//	НайтиЭлементыФормы(ФормаКлиентскогоПриложения, Тип("ПолеФормы"), Новый Структура("ПутьКДанным", "Реквизит")); // Будут найдены поля формы, отображающие указанный реквизит.
//
Функция НайтиЭлементыФормы(
	ОбластьПоиска, 
	ОтборПоТипам = Неопределено, 
	ОтборПоСвойствам = Неопределено, 
	Рекурсивно = Истина) Экспорт

	НайденныеЭлементы = Новый Массив; 
	
	ЕстьОтборПоТипам = ОтборПоТипам <> Неопределено;
	Если ЕстьОтборПоТипам Тогда
		Если ТипЗнч(ОтборПоТипам) = Тип("Тип") Тогда
			ОтбираемыеТипы = Новый Массив;
			ОтбираемыеТипы.Добавить(ОтборПоТипам);
			ОтбираемыеТипы = Новый ОписаниеТипов(ОтбираемыеТипы);
		ИначеЕсли ТипЗнч(ОтборПоТипам) = Тип("Массив") Тогда
			ОтбираемыеТипы = Новый ОписаниеТипов(ОтборПоТипам);
		ИначеЕсли ТипЗнч(ОтборПоТипам) = Тип("ОписаниеТипов") Тогда 
			ОтбираемыеТипы = ОтборПоТипам;
		Иначе
			ВызватьИсключение "Параметр ОтборПоТипам: Непредвиденное значение";
		КонецЕсли;
	КонецЕсли;
	
	ЕстьОтборПоСвойствам = ТипЗнч(ОтборПоСвойствам) = Тип("Структура");
	Если ЕстьОтборПоСвойствам Тогда
		ОтборПоСвойствамШум = Новый Структура;
		Для каждого КлючЗначение Из ОтборПоСвойствам Цикл
			ОтборПоСвойствамШум.Вставить(КлючЗначение.Ключ, Новый УникальныйИдентификатор);
		КонецЦикла; 
		ОтборПоСвойствамШум = Новый ФиксированнаяСтруктура(ОтборПоСвойствамШум);
	КонецЕсли;      
	
	Для каждого ТекущийЭлементФормы Из ОбластьПоиска.ПодчиненныеЭлементы Цикл

		ЭлементПодходит = Истина;     
		ТипЭлементаФормы = ТипЗнч(ТекущийЭлементФормы);
		
		Если ЕстьОтборПоТипам
			И Не ОтбираемыеТипы.СодержитТип(ТипЭлементаФормы) Тогда
			ЭлементПодходит = Ложь;
		КонецЕсли;
		
		Если ЭлементПодходит И ЕстьОтборПоСвойствам Тогда
			СвойстваЭлемента = Новый Структура(ОтборПоСвойствамШум);
			ЗаполнитьЗначенияСвойств(СвойстваЭлемента, ТекущийЭлементФормы);
			Для каждого СвойствоЭлемента Из СвойстваЭлемента Цикл
				Ключ = СвойствоЭлемента.Ключ;
				Если СвойстваЭлемента[Ключ] <> ОтборПоСвойствам[Ключ]
					И СвойстваЭлемента[Ключ] <> ОтборПоСвойствамШум[Ключ] Тогда
					ЭлементПодходит = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла; 
		КонецЕсли;
		
		Если ЭлементПодходит Тогда
			НайденныеЭлементы.Добавить(ТекущийЭлементФормы);
		КонецЕсли;
		
		ЭтоГруппаЕстьПодчиненныеЭлементы = (ТипЭлементаФормы = Тип("ГруппаФормы")
			Или ТипЭлементаФормы = Тип("ТаблицаФормы"))
			И ЗначениеЗаполнено(ТекущийЭлементФормы.ПодчиненныеЭлементы);
		Если ЭтоГруппаЕстьПодчиненныеЭлементы И Рекурсивно Тогда
			НайденныеПодчиненныеЭлементы = НайтиЭлементыФормы(
				ТекущийЭлементФормы, 
				ОтбираемыеТипы, 
				ОтборПоСвойствам, 
				Рекурсивно
			);
			Для каждого ПодчиненныйЭлемент Из НайденныеПодчиненныеЭлементы Цикл
				НайденныеЭлементы.Добавить(ПодчиненныйЭлемент);
			КонецЦикла; 
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат НайденныеЭлементы;	

КонецФункции // НайтиЭлементыФормы()

// Получает полный путь формы того же объекта, что и указанный,
// но в указанными именем.
//
// Параметры:
//	ОпорнаяФорма - УправляемаяФорма	 - Форма, в контексте которой получается имя дочерней формы
//  ИмяСоседнейФормы	 - Строка	 - Имя формы, для которой нужно получить полное имя
// 
// Возвращаемое значение:
//  Строка - Полное имя формы
//
// Пример:
//	ПолноеИмяСоседнейФормы(ЭтаФорма, "ПроизвольнаяФорма") - Может возвратить "ВнешнийОтчет.ТекущийОтчет.ПроизвольнаяФорма"
//
Функция ПолноеИмяСоседнейФормы(Знач ОпорнаяФорма, ИмяСоседнейФормы) Экспорт

	ПозицияПоследнейТочки = СтрНайти(ОпорнаяФорма.ИмяФормы, ".", НаправлениеПоиска.СКонца);
	ПутьФормыСТочкой = Лев(ОпорнаяФорма.ИмяФормы, ПозицияПоследнейТочки);
    Возврат ПутьФормыСТочкой + ИмяСоседнейФормы;

КонецФункции // ПолноеИмяСоседнейФормы()

