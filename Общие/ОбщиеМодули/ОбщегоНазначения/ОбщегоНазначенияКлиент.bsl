
#Область БуферОбмена

// Копирует текст в буфер обмена
// Начиная с версии платформы 8.3.24 см. СредстваБуфераОбмена
//
// Параметры:
//	Текст - Строка - Копируемый текст
//
Процедура ПоместитьТекстВБуферОбмена(Текст) Экспорт

	БуферОбмена = Новый COMОбъект("htmlfile");
	БуферОбмена.ParentWindow.ClipboardData.Setdata("Text", Текст);

КонецПроцедуры // ПоместитьТекстВБуферОбмена()
 
// Получает текст из буфера обмена
// Начиная с версии платформы 8.3.24 см. СредстваБуфераОбмена
//
// Параметры:
//	Текст - Строка - Получаемый текст
//
Функция ПолучитьТекстИзБуфераОбмена() Экспорт

	БуферОбмена = Новый COMОбъект("htmlfile");
	Возврат БуферОбмена.ParentWindow.ClipboardData.Getdata("Text");

КонецФункции // ПолучитьТекстИзБуфераОбмена()

#КонецОбласти // БуферОбмена 
