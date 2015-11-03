﻿#Использовать tempfiles
#Использовать asserts
#Использовать logos

Перем юТест;
Перем Лог;

//{ подготовка тестов и данных для тестов

Процедура Инициализация()
	Лог = Логирование.ПолучитьЛог("oscript.app.v8files-extractor");
КонецПроцедуры

Функция ПолучитьСписокТестов(Знач Контекст) Экспорт
	
	юТест = Контекст;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("Тест_ДолженРазложитьФайлОбработкиИзЗаданнойПапки");
	ВсеТесты.Добавить("Тест_ДолженРазложитьКаталогСВложеннымиКаталогами");
	ВсеТесты.Добавить("Тест_ДолженРазобратьФайлыПоЖурналуИзмененийГит");
	ВсеТесты.Добавить("Тест_ДолженСоздатьРепозитарийГит");
	ВсеТесты.Добавить("Тест_ДолженПроверитьНастройкиРепозитарияГит");
	ВсеТесты.Добавить("Тест_ДолженОбработатьИзмененияИзГитДляКаталогаСВложеннымиКаталогами");
	
	Возврат ВсеТесты;
	
КонецФункции

Процедура ПослеЗапускаТеста() Экспорт
	ВременныеФайлы.Удалить();
КонецПроцедуры

Функция ЗагрузитьИсполнителя()
	
	ИмяКаталога = ТекущийСценарий().Каталог;
	Исполнитель = ЗагрузитьСценарий(ОбъединитьПути(ИмяКаталога,"../v8files-extractor.os"));
	Лог = Логирование.ПолучитьЛог("oscript.app.v8files-extractor");
	// Лог.УстановитьУровень(УровниЛога.Отладка);
	
	Возврат Исполнитель;
	
КонецФункции

Функция ПолучитьФайлТестовойОбработки()
	
	ИмяКаталога = ТекущийСценарий().Каталог;
	ИмяФайла = "Fixture";
	ИмяФайлаСРасширением = ИмяФайла+".epf";
	
	ПутьФайла = ОбъединитьПути(ИмяКаталога, ИмяФайлаСРасширением);
	ФайлОбработки = Новый Файл(ПутьФайла);
	Ожидаем.Что(ФайлОбработки.Существует(), "Исходный файл должен существовать").ЭтоИстина();
	
	Возврат ФайлОбработки;
	
КонецФункции

//}

//{ тесты
Процедура Тест_ДолженРазложитьФайлОбработкиИзЗаданнойПапки() Экспорт

	ФайлОбработки = ПолучитьФайлТестовойОбработки();
	
	КаталогВыгрузки = ВременныеФайлы.СоздатьКаталог();
	
	Исполнитель = ЗагрузитьИсполнителя();
	Исполнитель.РазобратьФайл(Новый Файл(ФайлОбработки.ПолноеИмя), КаталогВыгрузки, ФайлОбработки.Путь);
	
	КаталогИсходников = Новый Файл(ОбъединитьПути(КаталогВыгрузки, ФайлОбработки.ИмяБезРасширения));
	Ожидаем.Что(КаталогИсходников.Существует()).ЭтоИстина();
	Ожидаем.Что(КаталогИсходников.ЭтоКаталог(), "Должны были найти каталог с именем обработки").ЭтоИстина();
	Ожидаем.Что(КаталогСодержитИсходникиОбработки(КаталогИсходников.ПолноеИмя), "ожидаем, что КаталогСодержитИсходникиОбработки(КаталогИсходников.ПолноеИмя) это Истина").ЭтоИстина();
КонецПроцедуры

Процедура Тест_ДолженРазложитьКаталогСВложеннымиКаталогами() Экспорт

	ФайлОбработки = ПолучитьФайлТестовойОбработки();
	
	ИмяВложенногоКаталога = "1";
	
	КаталогИсходников = ВременныеФайлы.СоздатьКаталог();
	КаталогВыгрузки = ВременныеФайлы.СоздатьКаталог();

	СоздатьКаталог(ОбъединитьПути(КаталогИсходников, ИмяВложенногоКаталога));
	
	ВложенныйКаталогИсходников = ОбъединитьПути(КаталогИсходников, ИмяВложенногоКаталога);
	ПутьВложеннойОбработки = ОбъединитьПути(ВложенныйКаталогИсходников, ФайлОбработки.Имя);

	КопироватьФайл(ФайлОбработки.ПолноеИмя, ПутьВложеннойОбработки);
	
	ФайлВложеннойОбработки = Новый Файл(ПутьВложеннойОбработки);
	Ожидаем.Что(ФайлВложеннойОбработки.Существует(), "Должны были найти имя вложенной обработки").ЭтоИстина();
	Ожидаем.Что(ФайлВложеннойОбработки.ЭтоФайл(), "Должны были найти признак файла для вложенной обработки").ЭтоИстина();
	
	Исполнитель = ЗагрузитьИсполнителя();
	Исполнитель.РазобратьКаталог(Новый Файл(КаталогИсходников), КаталогВыгрузки, КаталогИсходников);
	
	ВложенныйКаталогВыгрузки = ОбъединитьПути(КаталогВыгрузки, ИмяВложенногоКаталога);
	
	ФайлВложенныйКаталогВыгрузки = Новый Файл(ВложенныйКаталогВыгрузки);
	Ожидаем.Что(ФайлВложенныйКаталогВыгрузки.Существует(), "Должны были найти имя вложенного каталога").ЭтоИстина();
	Ожидаем.Что(ФайлВложенныйКаталогВыгрузки.ЭтоКаталог(), "Должны были найти вложенный каталог").ЭтоИстина();

	ПутьКаталогаВыгрузкиДляОбработки = ОбъединитьПути(ВложенныйКаталогВыгрузки, ФайлОбработки.ИмяБезРасширения);
	Ожидаем.Что(КаталогСодержитИсходникиОбработки(ПутьКаталогаВыгрузкиДляОбработки), "ожидаем, что КаталогСодержитИсходникиОбработки(ПутьКаталогаВыгрузкиДляОбработки) это Истина").ЭтоИстина();

КонецПроцедуры

Процедура Тест_ДолженОбработатьИзмененияИзГитДляКаталогаСВложеннымиКаталогами() Экспорт
	
	КаталогПроекта = КаталогПроекта();
	
	КаталогВыгрузки = ВременныеФайлы.СоздатьКаталог();
	
	СоздатьРепозитарийГит(КаталогВыгрузки, КаталогПроекта);

	ФайлОбработки = ПолучитьФайлТестовойОбработки();
	
	ИмяВложенногоКаталога = "1";
	
	КаталогИсходников = ВременныеФайлы.СоздатьКаталог();

	ВложенныйКаталогВыгрузки = ОбъединитьПути(КаталогВыгрузки, ИмяВложенногоКаталога);
	СоздатьКаталог(ВложенныйКаталогВыгрузки);
	
	ПутьВложеннойОбработки = ОбъединитьПути(ВложенныйКаталогВыгрузки, ФайлОбработки.Имя);
	Лог.Отладка("ПутьВложеннойОбработки "+ПутьВложеннойОбработки);

	КопироватьФайл(ФайлОбработки.ПолноеИмя, ПутьВложеннойОбработки);
	
	ФайлВложеннойОбработки = Новый Файл(ПутьВложеннойОбработки);
	Ожидаем.Что(ФайлВложеннойОбработки.Существует(), "Должны были найти имя вложенной обработки").ЭтоИстина();
	Ожидаем.Что(ФайлВложеннойОбработки.ЭтоФайл(), "Должны были найти признак файла для вложенной обработки").ЭтоИстина();
	
	КомандаГит = "git add -A .";
	ВыполнитьКомандуГит(КомандаГит);

	КомандаГит = "git status";
	ВыполнитьКомандуГит(КомандаГит);

	КомандаГит = "git commit -m ""init commit""";
	ВыполнитьКомандуГит(КомандаГит);
	
	Исполнитель = ЗагрузитьИсполнителя();
	Исполнитель.ОбработатьИзмененияИзГит(".");
		
	ФайлВложенныйКаталогВыгрузки = Новый Файл(ВложенныйКаталогВыгрузки);
	Ожидаем.Что(ФайлВложенныйКаталогВыгрузки.Существует(), "Должны были найти имя вложенного каталога").ЭтоИстина();
	Ожидаем.Что(ФайлВложенныйКаталогВыгрузки.ЭтоКаталог(), "Должны были найти вложенный каталог").ЭтоИстина();

	ПутьКаталогаВыгрузкиДляОбработки = ОбъединитьПути(ВложенныйКаталогВыгрузки, ФайлОбработки.ИмяБезРасширения);
	Ожидаем.Что(КаталогСодержитИсходникиОбработки(ПутьКаталогаВыгрузкиДляОбработки), "ожидаем, что КаталогСодержитИсходникиОбработки(ПутьКаталогаВыгрузкиДляОбработки) это Истина").ЭтоИстина();

КонецПроцедуры

Процедура Тест_ДолженРазобратьФайлыПоЖурналуИзмененийГит() Экспорт
	
	ФайлОбработки = ПолучитьФайлТестовойОбработки();
	
	ЖурналИзмененийГит = "A	" + ФайлОбработки.Имя+"
		| M	" + "pref-" + ФайлОбработки.Имя;
	
	Исполнитель = ЗагрузитьИсполнителя();
	МассивИмен = Исполнитель.ПолучитьИменаИзЖурналаИзмененийГит(ЖурналИзмененийГит);
	
	Ожидаем.Что(МассивИмен, "Должны были найти измененный файл").Содержит(ФайлОбработки.Имя);
	Ожидаем.Что(МассивИмен, "Должны были найти измененный файл").Содержит("pref-" + ФайлОбработки.Имя);
КонецПроцедуры

Процедура Тест_ДолженСоздатьРепозитарийГит() Экспорт
	
	КаталогПроекта = КаталогПроекта();
	
	КаталогРепо = ВременныеФайлы.СоздатьКаталог();
	
	СоздатьРепозитарийГит(КаталогРепо, КаталогПроекта);
КонецПроцедуры

Процедура Тест_ДолженПроверитьНастройкиРепозитарияГит() Экспорт
	Перем КодВозврата;
	
	КаталогПроекта = КаталогПроекта();
	
	КаталогРепо = ВременныеФайлы.СоздатьКаталог();
	
	СоздатьРепозитарийГит(КаталогРепо, КаталогПроекта);
	
	Исполнитель = ЗагрузитьИсполнителя();
	Исполнитель.ПроверитьНастройкиРепозитарияГит();
КонецПроцедуры

//}

//{ служебные методы

Процедура СоздатьРепозитарийГит(Знач КаталогРепо, КаталогПроекта) 
	Перем КодВозврата;

	УстановитьТекущийКаталог(КаталогРепо);
	Лог.Отладка("КаталогРепо " + КаталогРепо);

	ВыполнитьКомандуГит("git init");
	ВыполнитьКомандуГит("git config --local core.quotepath false");
	
	КаталогHooks = Новый Файл(ОбъединитьПути(КаталогРепо, ".git", "hooks"));
	Ожидаем.Что(КаталогHooks.Существует(), "Должен существовать исходный каталог сервисной ИБ, а это не так").ЭтоИстина();
	
	Лог.Отладка("КаталогHooks.ПолноеИмя " + КаталогHooks.ПолноеИмя);
	
	КаталогСервиснойИБ = Новый Файл(ОбъединитьПути(КаталогПроекта, "ibService"));
	Каталог_v8Reader = Новый Файл(ОбъединитьПути(КаталогПроекта, "v8Reader"));
	Лог.Отладка("КаталогСервиснойИБ.ПолноеИмя " + КаталогСервиснойИБ.ПолноеИмя);
	
	КаталогСервиснойИБ_конечный = Новый Файл(ОбъединитьПути(КаталогHooks.ПолноеИмя, "ibService"));
	ПересоздатьКаталог(КаталогСервиснойИБ_конечный);
	Лог.Отладка("КаталогСервиснойИБ_конечный.ПолноеИмя " + КаталогСервиснойИБ_конечный.ПолноеИмя);

	КопироватьДеревоФайлов(КаталогСервиснойИБ.ПолноеИмя, КаталогСервиснойИБ_конечный.ПолноеИмя);
		Ожидаем.Что(КаталогСервиснойИБ_конечный.Существует(), "Должен существовать конечный каталог сервисной ИБ, а это не так").ЭтоИстина();
	
	ФайлСервиснойИБ = Новый Файл(ОбъединитьПути(КаталогСервиснойИБ_конечный.ПолноеИмя, "1Cv8.1CD"));
	Лог.Отладка("ФайлСервиснойИБ.ПолноеИмя " + ФайлСервиснойИБ.ПолноеИмя);
		Ожидаем.Что(ФайлСервиснойИБ.Существует(), "Должен существовать файл сервисной ИБ, а это не так").ЭтоИстина();

	Каталог_v8Reader_конечный = Новый Файл(ОбъединитьПути(КаталогHooks.ПолноеИмя, "v8Reader"));
	ПересоздатьКаталог(Каталог_v8Reader_конечный);

	Файл_v8Reader_конечный = Новый Файл(ОбъединитьПути(Каталог_v8Reader_конечный.ПолноеИмя, "V8Reader.epf"));
	КопироватьФайл(ОбъединитьПути(Каталог_v8Reader.ПолноеИмя, "V8Reader.epf"), Файл_v8Reader_конечный.ПолноеИмя);
		Ожидаем.Что(Файл_v8Reader_конечный.Существует(), "Должен существовать Файл_v8Reader_конечный, а это не так").ЭтоИстина();

	Файл_pre_commit_конечный = Новый Файл(ОбъединитьПути(КаталогHooks.ПолноеИмя, "pre-commit"));
	КопироватьФайл(ОбъединитьПути(КаталогПроекта, "pre-commit"), Файл_pre_commit_конечный.ПолноеИмя);
		Ожидаем.Что(Файл_pre_commit_конечный.Существует(), "Должен существовать Файл_pre_commit_конечный, а это не так").ЭтоИстина();

	Лог.Отладка("Файл_pre_commit_конечный.ПолноеИмя " + Файл_pre_commit_конечный);
	Файл_сценария_исходный = Новый Файл(ОбъединитьПути(КаталогПроекта, "v8files-extractor.os"));
	Файл_сценария_конечный = Новый Файл(ОбъединитьПути(КаталогHooks.ПолноеИмя, Файл_сценария_исходный.Имя));
	
	КопироватьФайл(Файл_сценария_исходный.ПолноеИмя, Файл_сценария_конечный.ПолноеИмя);
		Ожидаем.Что(Файл_сценария_конечный.Существует(), "Должен существовать Файл_сценария_конечный, а это не так").ЭтоИстина();
КонецПроцедуры

Функция КаталогСодержитИсходникиОбработки(Знач Каталог)
	ВыгруженныеФайлы = НайтиФайлы(Каталог, ПолучитьМаскуВсеФайлы());
	ИменаВыгруженныхФайлов = РазвернутьМассивФайловВИменаФайлов(ВыгруженныеФайлы);
	Ожидаем.Что(ИменаВыгруженныхФайлов, "Должны были найти выгруженный файл").Содержит("renames.txt");
	Ожидаем.Что(ИменаВыгруженныхФайлов, "Должны были найти выгруженный файл").Содержит("Form");
	Ожидаем.Что(ИменаВыгруженныхФайлов, "Должны были найти выгруженный файл").Содержит("Макеты");
	Ожидаем.Что(ИменаВыгруженныхФайлов, "Должны были найти выгруженный файл").Содержит("und");
	Возврат Истина;
КонецФункции

Процедура ПересоздатьКаталог(Каталог)
	Если Каталог.Существует() Тогда
		УдалитьФайлы(Каталог.ПолноеИмя);
	КонецЕсли;
	СоздатьКаталог(Каталог.ПолноеИмя);
КонецПроцедуры

Процедура КопироватьДеревоФайлов(Откуда, Куда)
	Лог.Отладка("	КопироватьДеревоФайлов	Откуда :"+Откуда);
	Лог.Отладка("	КопироватьДеревоФайлов	Куда :"+Куда);
	Файлы = НайтиФайлы(Откуда, ПолучитьМаскуВсеФайлы());
	Для Каждого Файл из Файлы Цикл
		Если Файл.ЭтоКаталог() Тогда
			Лог.Отладка("		Каталог.ПолноеИмя: " + Файл.ПолноеИмя);
			
			НовыйКонечныйКаталог = Новый Файл(ОбъединитьПути(Куда, Файл.Имя));
			// Лог.Отладка("		НовыйКонечныйКаталог.ПолноеИмя: " + НовыйКонечныйКаталог.ПолноеИмя);
			Если НовыйКонечныйКаталог.Существует() Тогда
				Если НовыйКонечныйКаталог.ЭтоФайл() Тогда
					УдалитьФайлы(НовыйКонечныйКаталог.ПолноеИмя);
					СоздатьКаталог(НовыйКонечныйКаталог.ПолноеИмя);
				КонецЕсли;
			Иначе
				Лог.Отладка("Создаю каталог "+НовыйКонечныйКаталог.ПолноеИмя);
				СоздатьКаталог(НовыйКонечныйКаталог.ПолноеИмя);
			КонецЕсли;
			
			КопироватьДеревоФайлов(Файл.ПолноеИмя, НовыйКонечныйКаталог.ПолноеИмя);
		Иначе
			Лог.Отладка("		Откуда Файл.ПолноеИмя: " + Файл.ПолноеИмя);
			Лог.Отладка("		Куда Файл.ПолноеИмя: " + ОбъединитьПути(Куда, Файл.Имя));
			КопироватьФайл(Файл.ПолноеИмя, ОбъединитьПути(Куда, Файл.Имя));
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ВыполнитьКомандуГит(КомандаГит, КодВозврата = Неопределено, ПроверятьНулевойКодВозврата = Истина)
	
	Лог.Информация("Запускаю "+КомандаГит);
	Вывод = ПолучитьВыводПроцесса(КомандаГит, КодВозврата);
	Лог.Информация("	Вывод команды гит: " + Вывод);
	Если ПроверятьНулевойКодВозврата Тогда
		Ожидаем.Что(КодВозврата, "Код возврата `"+КомандаГит+"` должен быть 0, а это не так").Равно(0);
	КонецЕсли;
	Возврат Вывод;
КонецФункции

Функция ПолучитьВыводПроцесса(Знач КоманднаяСтрока, КодВозврата)
	
	// Это для dev версии 1.0.11
	Процесс = СоздатьПроцесс(КоманднаяСтрока, , Истина,, КодировкаТекста.UTF8);
	Процесс.Запустить();
	Вывод = "";
	
	Процесс.ОжидатьЗавершения();
	
	Вывод = Вывод + Процесс.ПотокВывода.Прочитать();
	Вывод = Вывод + Процесс.ПотокОшибок.Прочитать();
	
	КодВозврата = Процесс.КодВозврата;
	
	// ЛогФайл = ВременныеФайлы.НовоеИмяФайла();
	// СтрокаЗапуска = "cmd /C """ + КоманднаяСтрока + " > """ + ЛогФайл + """ 2>&1""";
	// Лог.Отладка(СтрокаЗапуска);
	// ЗапуститьПриложение(СтрокаЗапуска,, Истина, КодВозврата);
	// Лог.Отладка("Код возврата: " + КодВозврата);
	// ЧтениеТекста = Новый ЧтениеТекста(ЛогФайл, "utf-8");
	// Вывод = ЧтениеТекста.Прочитать();
	// ЧтениеТекста.Закрыть();
	// ВременныеФайлы.УдалитьФайл(ЛогФайл);
	
	Возврат Вывод;
	
КонецФункции

Функция РазвернутьМассивФайловВИменаФайлов(Знач МассивОбъектовФайл)
	
	ИменаФайлов = Новый Массив;
	Для Каждого Файл Из МассивОбъектовФайл Цикл
		ИменаФайлов.Добавить(Файл.Имя);
	КонецЦикла;
	
	Возврат ИменаФайлов;
	
КонецФункции

Функция КаталогПроекта()
	ФайлИсточника = Новый Файл(ТекущийСценарий().Источник);
	Возврат ОбъединитьПути(ФайлИсточника.Путь, "..");
КонецФункции

//}

Инициализация();
