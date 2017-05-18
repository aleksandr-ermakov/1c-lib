// Формирует текст выражения запроса, подставляя в него преданные параметры
//
// Параметры:
//  ИмяПоля		 - Строка		 - Поле
//  Вид			 - ВидСравнения	 -
//  ИмяПервогоПараметра - Строка		 - Строка, превращается в имя параметра
//  ИмяПервогоПараметра - Строка		 - Строка, превращается в имя параметра. Используется в интервалах
//
// Возвращаемое значение:
//  Строка - Строка вида "ИмяПоля В (&ИмяПараметра)"
//
Функция ВыражениеЗапросаСравнения(ИмяПоля, Вид, ИмяПервогоПараметра, ИмяВторогоПараметра = "") Экспорт

	Шаблоны = Новый Соответствие;
	Шаблоны.Вставить(ВидСравнения.Равно,					"%1 = %2");
	Шаблоны.Вставить(ВидСравнения.НеРавно,					"%1 <> %2");
	Шаблоны.Вставить(ВидСравнения.ВСписке,					"%1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВСписке,				"НЕ %1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.ВСписке,					"%1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВСписке,				"НЕ %1 В (%2)");
	Шаблоны.Вставить(ВидСравнения.ВСпискеПоИерархии,		"%1 В ИЕРАРХИИ (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВСпискеПоИерархии,		"НЕ %1 В ИЕРАРХИИ (%2)");
	Шаблоны.Вставить(ВидСравнения.ВИерархии,				"%1 В ИЕРАРХИИ (%2)");
	Шаблоны.Вставить(ВидСравнения.НеВИерархии,				"НЕ %1 В ИЕРАРХИИ (%2)");

	Шаблоны.Вставить(ВидСравнения.Больше,					"%1 > %2");
	Шаблоны.Вставить(ВидСравнения.БольшеИлиРавно,			"%1 >= %2");
	Шаблоны.Вставить(ВидСравнения.Меньше,					"%1 < %2");
	Шаблоны.Вставить(ВидСравнения.МеньшеИлиРавно,			"%1 <= %2");
	Шаблоны.Вставить(ВидСравнения.Интервал,					"%1 > %2 И %1 < %3");
	Шаблоны.Вставить(ВидСравнения.ИнтервалВключаяНачало,	"%1 >= %2 И %1 < %3");
	Шаблоны.Вставить(ВидСравнения.ИнтервалВключаяОкончание,	"%1 > %2 И %1 <= %3");
	Шаблоны.Вставить(ВидСравнения.ИнтервалВключаяГраницы,	"%1 МЕЖДУ %2 И %3");

	Шаблоны.Вставить(ВидСравнения.Содержит,		"%1 ПОДОБНО ""%""+%2+""%""");
	Шаблоны.Вставить(ВидСравнения.НеСодержит,	"НЕ %1 ПОДОБНО ""%""+%2+""%""");

	Шаблон = Шаблоны[Вид];
	Если Найти(Шаблон, "%3") > 0 Тогда
		Возврат СтрШаблон(Шаблон, ИмяПоля, ИмяПервогоПараметра, ИмяВторогоПараметра);
	КонецЕсли;
	Возврат СтрШаблон(Шаблон, ИмяПоля, ИмяПервогоПараметра);

КонецФункции // ВыражениеЗапросаСравнения()
