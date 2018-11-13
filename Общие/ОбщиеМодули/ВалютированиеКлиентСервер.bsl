// По комбинации курсов/кратностей рассчитывает кросс курс.
// СуммаДоллар * КроссКурс / КроссКратность = СуммаЕвро
//
// Параметры:
//  ИсходКурс			 - Число	 - Исходный курс. Курс преобразуемой валюты
//  ИсходКратность		 - Число 	 - Исходная кратность.
//  ЦелевКурс			 - Число 	 - Целевой курс
//  ЦелевКратность		 - Число 	 - Целевая кратность
//  РазрядностьКурс		 - Число 	 - Разрядность дробной части курса
//  РазрядностьКратность - Число 	 - Разрядность дробной части кратности
//
// Возвращаемое значение:
//  Структура - {Курс:Число, Кратность:Число}
//
Функция РассчитатьКроссКурсКратность(ИсходКурс = 1, ИсходКратность = 1, ЦелевКурс = 1, ЦелевКратность = 1, РазрядностьКурс = 4, РазрядностьКратность = 0) Экспорт

	КроссКурс = (ИсходКурс / ИсходКратность) / (ЦелевКурс / ЦелевКратность);
	КроссКратность = 1;
	Пока КроссКурс <> 1 и КроссКурс < 10 Цикл
		КроссКурс		 = КроссКурс * 10;
		КроссКратность	 = КроссКратность * 10;
	КонецЦикла;
	КроссКурс		 = Окр(КроссКурс, РазрядностьКурс);
	КроссКратность	 = Окр(КроссКратность, РазрядностьКратность);

	Возврат Новый Структура("Курс, Кратность", КроссКурс, КроссКратность);

КонецФункции // РассчитатьКроссКурсКратность() test
