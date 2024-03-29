-- 1)Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
--   Н_ТИПЫ_ВЕДОМОСТЕЙ, Н_ВЕДОМОСТИ.
--   Вывести атрибуты: Н_ТИПЫ_ВЕДОМОСТЕЙ.ИД, Н_ВЕДОМОСТИ.ЧЛВК_ИД.
--   Фильтры (AND):
--   a) Н_ТИПЫ_ВЕДОМОСТЕЙ.ИД < 1.
--   b) Н_ВЕДОМОСТИ.ЧЛВК_ИД = 163249.
--   Вид соединения: INNER JOIN.
SELECT Н_ТИПЫ_ВЕДОМОСТЕЙ.ИД, Н_ВЕДОМОСТИ.ЧЛВК_ИД 
FROM Н_ВЕДОМОСТИ
INNER JOIN Н_ТИПЫ_ВЕДОМОСТЕЙ ON Н_ВЕДОМОСТИ.ТВ_ИД = Н_ТИПЫ_ВЕДОМОСТЕЙ.ИД 
WHERE 
    Н_ТИПЫ_ВЕДОМОСТЕЙ.ИД < 1 AND Н_ВЕДОМОСТИ.ЧЛВК_ИД = 163249;

--2)Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
--   Таблицы: Н_ЛЮДИ, Н_ВЕДОМОСТИ, Н_СЕССИЯ.
--   Вывести атрибуты: Н_ЛЮДИ.ФАМИЛИЯ, Н_ВЕДОМОСТИ.ИД, Н_СЕССИЯ.УЧГОД.
--   Фильтры (AND):
--   a) Н_ЛЮДИ.ИД > 100012.
--   b) Н_ВЕДОМОСТИ.ИД < 1250972.
--   c) Н_СЕССИЯ.ДАТА < 2012-01-25.
--   Вид соединения: RIGHT JOIN.
SELECT Н_ЛЮДИ.ФАМИЛИЯ, Н_ВЕДОМОСТИ.ИД, Н_СЕССИЯ.УЧГОД
FROM Н_ЛЮДИ                                                      
RIGHT JOIN Н_СЕССИЯ ON Н_ЛЮДИ.ИД = Н_СЕССИЯ.ЧЛВК_ИД
RIGHT JOIN Н_ВЕДОМОСТИ ON Н_ЛЮДИ.ИД = Н_ВЕДОМОСТИ.ЧЛВК_ИД
WHERE 
    Н_ЛЮДИ.ИД > 100012 AND Н_ВЕДОМОСТИ.ИД < 1250972 AND Н_СЕССИЯ.ДАТА < '2012-01-25';

--3)Вывести число рождений без учета повторений.
--  При составлении запроса нельзя использовать DISTINCT.
SELECT COUNT(*) FROM (
    SELECT ДАТА_РОЖДЕНИЯ FROM Н_ЛЮДИ    
    GROUP BY ДАТА_РОЖДЕНИЯ
    ) AS Н_ДАТА;


--4)В таблице Н_ГРУППЫ_ПЛАНОВ найти номера планов, по которым обучается (обучалось) более 2 групп ФКТИУ.
--  Для реализации использовать подзапрос.

SELECT Н_ПЛАНЫ_КТиУ.КОЛИЧЕСТВО, Н_ПЛАНЫ_КТиУ.ПЛАН_ИД 
FROM (
    SELECT Н_ГРУППЫ_ПЛАНОВ.ПЛАН_ИД, COUNT(Н_ГРУППЫ_ПЛАНОВ.ГРУППА) AS КОЛИЧЕСТВО FROM Н_ПЛАНЫ 
        JOIN Н_ОТДЕЛЫ ON Н_ПЛАНЫ.ОТД_ИД = Н_ОТДЕЛЫ.ИД 
                  AND Н_ОТДЕЛЫ.КОРОТКОЕ_ИМЯ = 'КТиУ' 
                  AND Н_ПЛАНЫ.ПЛАН_ИД > 0
        JOIN Н_ГРУППЫ_ПЛАНОВ ON Н_ГРУППЫ_ПЛАНОВ.ПЛАН_ИД = Н_ПЛАНЫ.ПЛАН_ИД
    GROUP BY Н_ГРУППЫ_ПЛАНОВ.ПЛАН_ИД
    ) AS Н_ПЛАНЫ_КТиУ 
WHERE Н_ПЛАНЫ_КТиУ.КОЛИЧЕСТВО > 2;

--5)Выведите таблицу со средними оценками студентов группы 4100 (Номер, ФИО, Ср_оценка), у которых средняя оценка меньше средней оценк(е|и) в группе 1101.

SELECT Н_УЧЕНИКИ.ГРУППА, Н_ЛЮДИ.ФАМИЛИЯ, Н_ЛЮДИ.ИМЯ, Н_ЛЮДИ.ОТЧЕСТВО, Н_СРЕДНЯЯ.СРЕДНЯЯ FROM (
    SELECT Н_ВЕДОМОСТИ.ЧЛВК_ИД, avg(CAST(Н_ВЕДОМОСТИ.ОЦЕНКА AS float)) AS СРЕДНЯЯ FROM Н_ВЕДОМОСТИ
    WHERE Н_ВЕДОМОСТИ.ОЦЕНКА <> 'зачет' 
      AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'незач'
      AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'осв'
      AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'неявка'
      AND Н_ВЕДОМОСТИ.ОЦЕНКА <> '99'
      GROUP BY Н_ВЕДОМОСТИ.ЧЛВК_ИД
      ) AS Н_СРЕДНЯЯ
    JOIN Н_УЧЕНИКИ ON Н_УЧЕНИКИ.ЧЛВК_ИД = Н_СРЕДНЯЯ.ЧЛВК_ИД AND Н_УЧЕНИКИ.ГРУППА = '4100'
    JOIN Н_ЛЮДИ ON Н_ЛЮДИ.ИД = Н_СРЕДНЯЯ.ЧЛВК_ИД
    WHERE Н_СРЕДНЯЯ.СРЕДНЯЯ < (
        SELECT avg (CAST(ОЦЕНКА AS float)) AS СРЕДНЯЯ_1101 FROM (
            SELECT Н_ВЕДОМОСТИ.ОЦЕНКА FROM Н_ВЕДОМОСТИ JOIN Н_УЧЕНИКИ ON Н_УЧЕНИКИ.ЧЛВК_ИД = Н_ВЕДОМОСТИ.ЧЛВК_ИД AND Н_УЧЕНИКИ.ГРУППА = '1101' 
            AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'зачет' 
            AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'незач'
            AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'осв'
            AND Н_ВЕДОМОСТИ.ОЦЕНКА <> 'неявка'
        AND Н_ВЕДОМОСТИ.ОЦЕНКА <> '99'
        ) AS foo);

--6)Получить список студентов, отчисленных после первого сентября 2012 года с очной или заочной формы обучения (специальность: Программная инженерия). В результат включить:
--  номер группы;
--  номер, фамилию, имя и отчество студента;
--  номер пункта приказа;
--  Для реализации использовать соединение таблиц.

SELECT Н_УЧЕНИКИ.ГРУППА, Н_ЛЮДИ.ФАМИЛИЯ, Н_ЛЮДИ.ИМЯ, Н_ЛЮДИ.ОТЧЕСТВО, Н_ЛЮДИ.П_ПРКОК_ИД FROM Н_УЧЕНИКИ 
JOIN Н_ЛЮДИ ON Н_ЛЮДИ.ИД = Н_УЧЕНИКИ.ЧЛВК_ИД
JOIN Н_ФОРМЫ_ОБУЧЕНИЯ ON Н_ФОРМЫ_ОБУЧЕНИЯ.ИД = Н_УЧЕНИКИ.ВИД_ОБУЧ_ИД
JOIN Н_ПЛАНЫ ON Н_ПЛАНЫ.ПЛАН_ИД = Н_УЧЕНИКИ.ПЛАН_ИД
JOIN Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ ON Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ.ИД = Н_ПЛАНЫ.НАПС_ИД 
JOIN Н_НАПР_СПЕЦ ON Н_НАПР_СПЕЦ.ИД = Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ.НС_ИД
               -- AND Н_НАПР_СПЕЦ.НАИМЕНОВАНИЕ = 'Программная инженерия'
               -- AND Н_НАПР_СПЕЦ.НАИМЕНОВАНИЕ = 'Прикладная математика и информатика'
WHERE (Н_ФОРМЫ_ОБУЧЕНИЯ.НАИМЕНОВАНИЕ = 'Очная' OR Н_ФОРМЫ_ОБУЧЕНИЯ.НАИМЕНОВАНИЕ = 'Заочная')
   AND Н_УЧЕНИКИ.СОСТОЯНИЕ = 'утвержден'
   AND Н_УЧЕНИКИ.ПРИЗНАК = 'отчисл' 
   AND Н_УЧЕНИКИ.КОНЕЦ > DATE('2012-09-01');

--7)Вывести список студентов, имеющих одинаковые имена, но не совпадающие даты рождения.

SELECT Н_ЛЮДИ.ИД, Н_УЧЕНИКИ.ГРУППА, Н_ЛЮДИ.ФАМИЛИЯ, Н_ЛЮДИ.ИМЯ, Н_ЛЮДИ.ОТЧЕСТВО, Н_ЛЮДИ.ДАТА_РОЖДЕНИЯ FROM Н_УЧЕНИКИ
JOIN Н_ЛЮДИ ON Н_ЛЮДИ.ИД = Н_УЧЕНИКИ.ЧЛВК_ИД
WHERE Н_ЛЮДИ.ИМЯ IN (
    SELECT ИМЯ FROM Н_ЛЮДИ
    GROUP BY ИМЯ
    HAVING COUNT(*)>1 AND MIN(ДАТА_РОЖДЕНИЯ) <> MAX(ДАТА_РОЖДЕНИЯ)
);