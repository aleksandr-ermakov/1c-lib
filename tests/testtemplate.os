#Использовать asserts

Перем ЮнитТестирование;
Перем Данные;
Перем Модуль;

// основной метод для тестирования
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	Контекст = Новый Структура;
	Модуль = ЗагрузитьСценарий(
		".\testtemplate.os", 
		Контекст
	);

	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ИмяМетода_ИмяТеста");
	
	Возврат ВсеТесты;

КонецФункции

#Область ИмяМетода

Процедура ИмяМетода_ИмяТеста() Экспорт

	//Результат = Модуль.ИмяМетода();
	//Ожидаем.Что(Результат).Равно();
	
КонецПроцедуры

#КонецОбласти // ИмяМетода

