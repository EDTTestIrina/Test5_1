
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр Взаиморасчеты Приход
	
	Движения.Взаиморасчеты.Записать();
	
	Движения.Взаиморасчеты.Записывать = Истина;
	
	// Блокировка
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыОстатки.Партия,
	|	ВзаиморасчетыОстатки.СуммаОстаток
	|ИЗ
	|	РегистрНакопления.Взаиморасчеты.Остатки(&МоментВремени, Контрагент = &Контрагент) КАК ВзаиморасчетыОстатки
	|ГДЕ
	|	ВзаиморасчетыОстатки.СуммаОстаток < 0";
	Запрос.УстановитьПараметр("МоментВремени",МоментВремени());
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	
	ОсталосьСписать = СуммаПоДокументу;
	выборка = Запрос.Выполнить().Выбрать();
	Пока выборка.Следующий() Цикл
		
		Движение = Движения.Взаиморасчеты.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Партия = выборка.Партия;
		Движение.Сумма = МИН(выборка.СуммаОстаток,ОсталосьСписать);

		
		ОсталосьСписать = ОсталосьСписать - Движение.Сумма ;
		
	КонецЦикла;	
	
	Если   ОсталосьСписать<>0 Тогда
		
		Движение = Движения.Взаиморасчеты.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Партия = Документы.РасходнаяНакладная.ПустаяСсылка();
		Движение.Сумма = ОсталосьСписать;
		
	КонецЕсли;	
	
	
	
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
