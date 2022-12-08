/*
1
Вивести всі українські адреси
*/
DROP VIEW All_Addresses;

CREATE VIEW All_Addresses AS
SELECT country._name AS country_name, 
city._name AS city_name, 
street._name AS street_name, 
_address._number AS address_name,
_address._id AS address_id
FROM country 
INNER JOIN city 
ON city.id_country = country._id
INNER JOIN street 
ON street.id_city = city._id
INNER JOIN _address 
ON _address.id_street = street._id;

SELECT *
FROM all_addresses
WHERE country_name = 'Україна';


/*
Вивести всі інгрідієнти, що входять у товари з бакалії, що можна можна вживати до 5 років
*/
DROP VIEW ingridients_min_age;

CREATE VIEW ingridients_min_age AS
SELECT ingredient.min_age AS ingredient_min_age, 
ingredient._name AS ingredient_name,
typeofproduct._name AS typeofproduct_name
FROM ingredient
INNER JOIN compositionitem
ON compositionitem.ingrident_id = ingredient._id
INNER JOIN product 
ON product._id = compositionitem.product_id
INNER JOIN typeofproduct
ON typeofproduct._id = product.id_of_typeofproduct;

SELECT * 
FROM ingridients_min_age
WHERE ingredient_min_age <= 5 AND
typeofproduct_name = 'Бакалія';


/*
2
Вивести кількість годин, що відпрацювали касири за кожен робочий день
*/

DROP TABLE comings_to_work;

CREATE VIEW comings_to_work AS
SELECT cashier._id AS cashier_id, 
cashier._name AS cashier_name, 
cashier._surname AS cashier_surname, 
cashier._midname AS cashier_midname, 
schedule._date AS schedule_date,
EXTRACT( HOUR FROM schedule.end_of_workday - schedule.begin_of_workday)AS hours_of_workday
FROM schedule
INNER JOIN cashier
ON schedule.id_employee = cashier._id;

SELECT * FROM comings_to_work;

/*
Вивести максимально допустимі температури продуктів Бакалії
*/
DROP VIEW temperatures_product;
CREATE VIEW temperatures_product AS
SELECT product._name AS product_name, 
typeofproduct._name AS name_type, 
(product.min_temperature + product.amplitude_temperature) AS max_temperature,
typeofproduct._name AS typeofproduct_name
FROM product
INNER JOIN typeofproduct
ON product.id_of_typeofproduct = typeofproduct._id;

SELECT * FROM temperatures_product 
WHERE typeofproduct_name = 'Бакалія';

/*
3
Вивести суму поставок компанії Рошен
*/
DROP VIEW supply_prices;
CREATE VIEW supply_prices AS
SELECT 
SUM(supply.wholesale_price) AS supply_wholesale_price,
vendor._name AS vendor_name
FROM supply INNER JOIN
vendor ON vendor._id = supply.id_vendor
GROUP BY vendor._name;

SELECT * FROM supply_prices
WHERE vendor_name = 'Порошен';

/*
Вивести кількість товарів що були продані за 05.16.2021
*/
DROP VIEW counts_of_item;

CREATE VIEW counts_of_item AS
SELECT COUNT(checkitem._count) AS _count, 
_check.date_of_purchase AS date_of_purchase
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
GROUP BY _check.date_of_purchase;

SELECT *
FROM counts_of_item
WHERE date_of_purchase = '05.16.2021';


/*
4
Вивести суму чеків без маржі магазину 
*/
DROP VIEW all_check_sum;

CREATE VIEW all_check_sum AS
SELECT _check._id AS check_id, 
SUM(checkitem._count*supply.wholesale_price/supply.count_of_pieces) AS sumPrice
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
INNER JOIN supply
ON supply._id = checkitem.id_supply
GROUP BY _check._id;

SELECT * FROM all_check_sum;

/*
Вивести суму поставок компаній
*/
SELECT * FROM supply_prices;

/*
5
Вивести масу для всіх продуктів з бакалії
*/
DROP VIEW weights_of_products;

CREATE VIEW weights_of_products AS
SELECT typeofproduct._name AS typeofproduct_name,
product._id AS product_id, 
product._name AS product_name,
SUM(compositionitem._weight) AS weight
FROM typeofproduct
INNER JOIN product
ON product.id_of_typeofproduct = typeofproduct._id
INNER JOIN compositionitem
ON compositionitem._id = product.id_of_licence
GROUP BY
typeofproduct._name, product._id, product._name;

SELECT * FROM weights_of_products
WHERE typeofproduct_name = 'Бакалія';

/*
Вивести суму чеків без маржі магазину оплачених по google pay
*/
DROP VIEW checks_sum_with_typeofpurchase;

CREATE VIEW checks_sum_with_typeofpurchase AS
SELECT _check._id AS check_id, 
typeofpurchase._name AS typeofpurchase_name,
SUM(checkitem._count*supply.wholesale_price/supply.count_of_pieces) AS sumPrice
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
INNER JOIN supply
ON supply._id = checkitem.id_supply
INNER JOIN typeofpurchase
ON typeofpurchase._id = _check.id_typeofpurchase
GROUP BY _check._id, typeofpurchase._name;


SELECT * 
FROM checks_sum_with_typeofpurchase
WHERE typeofpurchase_name = 'Картою';

/*
6
Вивести топ 5 чеків за сумою замовлення
*/

CREATE VIEW check_sum_with_margin AS
SELECT _check._id AS check_id, 
SUM(checkitem._count*supply.wholesale_price/
supply.count_of_pieces*(1 + product.margin)) AS sumPrice
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
INNER JOIN supply
ON supply._id = checkitem.id_supply
INNER JOIN product
ON product._id = supply.id_product
GROUP BY _check._id;


SELECT * FROM check_sum_with_margin
ORDER BY sumPrice DESC LIMIT 5;

/*
Вивести топ 3 постачальника, за вартістю поставок
*/

SELECT * 
FROM supply_prices
ORDER BY supply_wholesale_price DESC
LIMIT 3

/*
7
Вивести всі заплати касирів без маржової надбавки за лютий місяць 2020 року в порядку зростання
*/

DROP VIEW employee_salary;
CREATE VIEW employee_salary AS
SELECT cashier._name AS cashier_name,
cashier._midname AS cashier_midname,
cashier._surname AS cashier_surname,
EXTRACT(MONTH FROM schedule._date) AS _month,
EXTRACT(YEAR FROM schedule._date) AS _year,
SUM(EXTRACT(HOUR FROM schedule.end_of_workday - 
schedule.begin_of_workday)*cashier.hourly_pay) AS salary
FROM cashier
INNER JOIN
schedule
ON schedule.id_employee = cashier._id
GROUP BY cashier._name, cashier._midname, 
cashier._surname, _month, _year;

SELECT * 
FROM employee_salary
WHERE 
_month = 2 AND
_year = 2020
ORDER BY salary;

/*
Вивести кількість пройдених медичних оглядів всіх касирів в порядку зростання кількості
*/
DROP VIEW all_medicalexamination;

CREATE VIEW all_medicalexamination AS
SELECT 
cashier._id AS cashier_id,
cashier._name AS cashier_name,
cashier._midname AS cashier_midname,
cashier._surname AS cashier_surname,
medicalexamination.result AS medicalexamination_result,
COUNT(medicalexamination._id) AS _count
FROM cashier
LEFT OUTER JOIN medicalexamination
ON medicalexamination.id_employee = cashier._id
GROUP BY 
cashier._id,
cashier._name,
cashier._midname,
cashier._surname,
medicalexamination.result;

SELECT * FROM all_medicalexamination
WHERE 
medicalexamination_result = TRUE OR medicalexamination_result IS NULL 
ORDER BY _count;

/*
8
Вивести всі товари, що мають масу більше середнього
*/


SELECT * FROM weights_of_products
WHERE weight > (SELECT AVG(wop.weight) 
FROM weights_of_products wop);


/*
Вивести працівників які працювали > 10% всіх робочих днів
*/
SELECT cashier_name, cashier_surname, cashier_midname, COUNT(schedule_date) AS days_count
FROM comings_to_work
GROUP BY cashier_name, cashier_surname, cashier_midname
HAVING COUNT(schedule_date) > 0.1*(
    SELECT COUNT(subS._id) 
    FROM schedule subS
);

/*
9
Вивести постачальників, що зареєстровані за адресою, де був виготовлений якийсь товар
*/

SELECT aa.country_name, aa.city_name, aa.street_name, aa.address_name,
vendor._name AS _vendor
FROM all_addresses aa INNER JOIN vendor ON vendor._id = aa.address_id
WHERE vendor.place_of_registration IN (
	SELECT product.address_producing FROM
	product
);

/*
Вивести всі виходи на роботу касирів, коли не було поставок
*/

SELECT cashier_name,
cashier_midname,
cashier_surname, 
schedule_date
FROM comings_to_work
WHERE schedule_date NOT IN (
	SELECT supply.date_of_producing
	FROM supply
);

/*
10
Вивести поставки, що розпродані менш ніж на 50%
*/

CREATE VIEW supplices AS
SELECT 
sup._id AS sup_id, 
prod._name AS prod_name,
sup.count_of_pieces AS sup_count_of_pieces
FROM supply sup 
INNER JOIN product prod
ON prod._id = sup.id_product;

SELECT sup_id, prod_name
FROM supplices 
WHERE 0.5 > (
	SELECT SUM(subCi._count)
	FROM checkitem subCi
	WHERE subCi.id_supply = sup_id
)/sup_count_of_pieces;

/*
Вивести всі дати робочих днів, коли не було жодних продаж 
*/

SELECT sch._date
FROM schedule sch
WHERE NOT EXISTS(
	SELECT subChk._id
	FROM _check subChk
	WHERE sch.begin_of_workday <= subChk.time_of_purchase AND
	subChk.time_of_purchase <= sch.end_of_workday AND
	sch._date = subChk.date_of_purchase
);


/*

INDEX

*/

DROP INDEX ingredient_name_age_index;

CREATE INDEX ingredient_name_age_index
ON ingredient (_name, min_age);


DROP INDEX check_date_time_index;

CREATE INDEX check_date_time_index
ON _check (time_of_purchase, date_of_purchase);


DROP INDEX medicalexamination_date_index;

CREATE INDEX medicalexamination_date_index
ON medicalexamination (_date);


DROP INDEX checkitem_index;

CREATE INDEX checkitem_index
ON checkitem (id_check, id_supply);

DROP INDEX supply_index;

CREATE INDEX supply_index
ON supply (id_product, id_vendor);

/**/
DROP INDEX city_foreign_key_index;
CREATE INDEX city_foreign_key_index 
ON city(id_country);

DROP INDEX street_foreign_key_index;
CREATE INDEX street_foreign_key_index
ON street(id_city);

DROP INDEX address_foreign_key_index;
CREATE INDEX address_foreign_key_index 
ON _address(id_street);


DROP INDEX product_foreign_key_id_producer;
CREATE INDEX product_foreign_key_id_producer
ON product(producer);

DROP INDEX product_foreign_key_id_of_licence;
CREATE INDEX product_foreign_key_id_of_licence
ON product(id_of_licence);

DROP INDEX product_foreign_key_id_typeOfProduct;
CREATE INDEX product_foreign_key_id_typeOfProduct
ON product(id_of_typeOfProduct);

DROP INDEX product_foreign_key_address_producing;
CREATE INDEX product_foreign_key_address_producing
ON product(address_producing);

DROP INDEX compositionItem_foreign_key_product_id;
CREATE INDEX compositionItem_foreign_key_product_id
ON compositionItem(product_id);

DROP INDEX compositionItem_foreign_key_ingridient_id;
CREATE INDEX compositionItem_foreign_key_ingridient_id
ON compositionItem(ingrident_id);

DROP INDEX checkItem_foreign_key_id_check;
CREATE INDEX checkItem_foreign_key_id_check
ON checkItem(id_check);

DROP INDEX checkItem_foreign_key_id_supply;
CREATE INDEX checkItem_foreign_key_id_supply
ON checkItem(id_supply);

DROP INDEX check_foreign_key_id_of_cashier;
CREATE INDEX check_foreign_key_id_of_cashier
ON _check(id_of_cashier);

DROP INDEX check_foreign_key_id_of_cashier;
CREATE INDEX check_foreign_key_id_of_cashier
ON _check(id_of_cashier);

DROP INDEX check_foreign_key_id_typeOfPurchase;	
CREATE INDEX check_foreign_key_id_typeOfPurchase
ON _check(id_typeOfPurchase);

DROP INDEX schedule_foreign_key_id_employee;
CREATE INDEX schedule_foreign_key_id_employee
ON schedule(id_employee);

DROP INDEX medicalExamination_foreign_key_id_employee;
CREATE INDEX medicalExamination_foreign_key_id_employee
ON medicalExamination(id_employee);
/*

INHERITANCE
1
*/



DROP TABLE ingredient_with_alcohol;

CREATE TABLE ingredient_with_alcohol (
	volume_of_alcohol FLOAT NOT NULL 
	CHECK (volume_of_alcohol >= 0 AND volume_of_alcohol <= 1)
) INHERITS (ingredient);

INSERT INTO ingredient_with_alcohol
(_name, min_age, volume_of_alcohol) 
SELECT _name, min_age, 0.99 FROM ingredient
WHERE _name = 'Етиловий спирт';


SELECT * FROM ingredient_with_alcohol;



/*
2
*/


 
CREATE TABLE licence_with_date_of_introduction (
	_date DATE NULL
) INHERITS (licence);

INSERT INTO licence_with_date_of_introduction
(_text, _date) 
SELECT _text, NULL FROM licence;

UPDATE licence_with_date_of_introduction SET
_date = '01.10.2020' WHERE _id = 6;
UPDATE licence_with_date_of_introduction SET
_date = '07.30.2020' WHERE _id = 7;
UPDATE licence_with_date_of_introduction SET
_date = '04.28.2020' WHERE _id = 8;
UPDATE licence_with_date_of_introduction SET
_date = '06.01.2020' WHERE _id = 9;

SELECT * FROM licence_with_date_of_introduction;

/*
3
*/

DROP TABLE producer_with_place_of_registration;
CREATE TABLE producer_with_place_of_registration (
	place_of_registration INTEGER NULL,
	FOREIGN KEY (place_of_registration) REFERENCES _Address(_id) ON DELETE SET NULL ON UPDATE CASCADE
) INHERITS (producer);

INSERT INTO producer_with_place_of_registration
(_name, place_of_registration) 
SELECT _name, NULL FROM producer;

UPDATE producer_with_place_of_registration SET
place_of_registration = 6 WHERE _id = 7;
UPDATE producer_with_place_of_registration SET
place_of_registration = 9 WHERE _id = 8;
UPDATE producer_with_place_of_registration SET
place_of_registration = 12 WHERE _id = 9;
UPDATE producer_with_place_of_registration SET
place_of_registration = 66 WHERE _id = 10;
UPDATE producer_with_place_of_registration SET
place_of_registration = 61 WHERE _id = 11;
UPDATE producer_with_place_of_registration SET
place_of_registration = 90 WHERE _id = 12;



SELECT pwpor._id, pwpor._name,
aa.country_name, 
aa.city_name, 
aa.street_name, 
aa.address_name
FROM 
producer_with_place_of_registration pwpor
LEFT OUTER JOIN 
All_Addresses aa
ON pwpor.place_of_registration = aa.address_id;