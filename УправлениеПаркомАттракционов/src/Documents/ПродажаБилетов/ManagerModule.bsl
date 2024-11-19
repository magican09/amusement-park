


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура заполняет табличный документ для печати.
//
// Параметры:
//	ТабДок - ТабличныйДокумент - табличный документ для заполнения и печати.
//	Ссылка - Произвольный - содержит ссылку на объект, для которого вызвана команда печати.
Процедура Билет(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Билет)
	Макет = Документы.ПродажаБилетов.ПолучитьМакет("Билет");
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПродажаБилетов.Номер,
		|	ПродажаБилетов.Дата,
		|	ПродажаБилетов.СуммаДокумента,
		|	ПродажаБилетов.Аттракционы.(
		|		Аттракцион,
		|		Стоимость,
		|		Кличество,
		|		Сумма)
		|ИЗ
		|	Документ.ПродажаБилетов КАК ПродажаБилетов
		|ГДЕ
		|	ПродажаБилетов.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
//	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьАттракционыШапка = Макет.ПолучитьОбласть("АттракционыШапка");
	ОбластьАттракционы = Макет.ПолучитьОбласть("Аттракционы");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПараметрыЗаголовка = Новый Структура;
		ПараметрыЗаголовка.Вставить("Дата",Формат(Выборка.Дата, "ДЛФ=D;"));
		ПараметрыЗаголовка.Вставить("Номер",УдалитьЛидирующиеНули(Выборка.Номер));
		ОбластьЗаголовок.Параметры.Заполнить(ПараметрыЗаголовка);
	
		ТабДок.Вывести(ОбластьЗаголовок);
		
	//	Шапка.Параметры.Заполнить(Выборка);
	//	ТабДок.Вывести(Шапка, Выборка.Уровень());	
		ТабДок.Вывести(ОбластьАттракционыШапка);
		ВыборкаАттракционы = Выборка.Аттракционы.Выбрать();
		Пока ВыборкаАттракционы.Следующий() Цикл
			ОбластьАттракционы.Параметры.Заполнить(ВыборкаАттракционы);
			ТабДок.Вывести(ОбластьАттракционы, ВыборкаАттракционы.Уровень());
		КонецЦикла;
		
		Подвал.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Подвал);	
		
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УдалитьЛидирующиеНули(Номер)
	Результат = Номер;
	Пока СтрНачинаетсяС(Результат,"0" ) Цикл
		Результат = Сред(Результат, 2);
	КонецЦикла;
	Возврат Результат;
КонецФункции 

#КонецОбласти

#КонецЕсли

