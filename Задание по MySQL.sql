# В подключенном MySQL репозитории создать базу данных “Друзья человека”

USE human_friends;

#Создать таблицы с иерархией из диаграммы в БД

CREATE TABLE animal_classes
(
	Id INT AUTO_INCREMENT PRIMARY KEY, 
	Class_name VARCHAR(20)
);
INSERT INTO animal_classes (Class_name)
VALUES ('PackAnimals'),
('Pets');  

CREATE TABLE pack_animals
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Genus_name VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES animal_classes (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO pack_animals (Genus_name, Class_id)
VALUES ('Horses', 1),
('Donkeys', 1),  
('Camels', 1); 

CREATE TABLE pets
(
	  Id INT AUTO_INCREMENT PRIMARY KEY,
    Genus_name VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES animal_classes (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO pets (Genus_name, Class_id)
VALUES ('Cats', 2),
('Dogs', 2),  
('Hamsters', 2);

#Заполнить низкоуровневые таблицы именами(животных), командами которые они выполняют и датами рождения
CREATE TABLE cats 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id int,
    FOREIGN KEY (Genus_id) REFERENCES pets (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO cats (Name, Birthday, Commands, Genus_id)
VALUES ('Барсик', '2011-01-01', 'кс-кс-кс', 1),
('Белка', '2016-01-01', "бежать!", 1),  
('Шурка', '2017-01-01', "прыжок", 1);

CREATE TABLE dogs 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id int,
    FOREIGN KEY (Genus_id) REFERENCES pets (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO dogs (Name, Birthday, Commands, Genus_id)
VALUES ('Барбос', '2020-01-01', 'ко мне, лежать, лапу, голос', 2),
('Грей', '2022-06-12', "сидеть, лежать, лапу", 2),  
('Шарик', '2019-03-01', "сидеть, лежать, лапу, след, фас", 2), 
('Чернушка', '2020-05-10', "сидеть, лежать, фу, место", 2);

CREATE TABLE hamsters 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id int,
    FOREIGN KEY (Genus_id) REFERENCES pets (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO hamsters (Name, Birthday, Commands, Genus_id)
VALUES ('Миша', '2020-10-12', 'кушать', 3),
('Гриша', '2021-03-12', "играть", 3),  
('Мич', '2022-07-11', "пиф паф", 3), 
('Люся', '2022-05-10', "играть", 3);

CREATE TABLE horses 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id int,
    FOREIGN KEY (Genus_id) REFERENCES pack_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO horses (Name, Birthday, Commands, Genus_id)
VALUES ('Булат', '2020-01-12', 'бегом, шагом', 1),
('Марс', '2017-03-12', "бегом, шагом, хоп", 1),  
('Сникерс', '2016-07-12', "бегом, шагом, хоп, брр", 1), 
('Натс', '2020-11-10', "бегом, шагом, хоп", 1);

CREATE TABLE donkeys 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id int,
    FOREIGN KEY (Genus_id) REFERENCES pack_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO donkeys (Name, Birthday, Commands, Genus_id)
VALUES ('Петя', '2019-04-10', "Голос", 2),
('Вова', '2020-03-12', "Бегом", 2),  
('Пикча', '2021-07-12', "Пошли", 2), 
('Лотар', '2022-12-10', "Вези", 2);

CREATE TABLE camels 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id int,
    FOREIGN KEY (Genus_id) REFERENCES pack_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO camels (Name, Birthday, Commands, Genus_id)
VALUES ('Лохматый', '2022-04-10', 'вернись', 3),
('Лысый', '2019-03-12', "остановись", 3),  
('Бородатый', '2015-07-12', "плевок", 3), 
('Хвостатый', '2022-12-10', "улыбнись", 3);

#  Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в другой питомник на зимовку. 

SET SQL_SAFE_UPDATES = 0;
DELETE FROM camels;

# Объединить таблицы лошади, и ослы в одну таблицу.
SELECT * FROM horses
UNION
SELECT * FROM donkeys;

# Создать новую таблицу “молодые животные” в которую попадут все животные старше 1 года, но младше 3 лет и 
# в отдельном столбце с точностью до месяца подсчитать возраст животных в новой таблице

CREATE VIEW all_animals AS
SELECT * FROM horses
UNION
SELECT * FROM donkeys
UNION
SELECT * FROM dogs
UNION
SELECT * FROM cats
UNION
SELECT * FROM hamsters;

DROP TABLE IF EXISTS young_animals;
CREATE TABLE young_animals
SELECT Id, Name, Birthday, Commands, Genus_id, TIMESTAMPDIFF(MONTH, Birthday, CURDATE()) AS Age_in_monthss
FROM all_animals
WHERE Birthday BETWEEN ADDDATE(curdate(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR);
select * from young_animals;

# Объединить все таблицы в одну, при этом сохраняя поля, указывающие на прошлую принадлежность к старым таблицам

CREATE TABLE newhumanFriend (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY)

SELECT  Name, Commands, Birthday, 'cats' AS oldTable
FROM cats UNION 
SELECT  Name, Commands, Birthday, 'dogs' AS oldTable
FROM dogs UNION
SELECT  Name, Commands, Birthday, 'hamsters' AS oldTable
FROM hamsters UNION 
SELECT  Name, Commands, Birthday, 'horses' AS oldTable
FROM horses UNION 
SELECT  Name, Commands, Birthday, 'donkeys' AS oldTable
FROM donkeys;

SELECT * FROM newhumanFriend;
