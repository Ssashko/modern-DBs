/*
1
Вивести всі українські адреси
*/

SELECT country._name, city._name, street._name, _address._number 
FROM country 
INNER JOIN city 
ON city.id_country = country._id
INNER JOIN street 
ON street.id_city = city._id
INNER JOIN _address 
ON _address.id_street = street._id
WHERE country._name = 'Україна'

/*
Вивести всі інгрідієнти, що входять у товари з бакалії, що можна можна вживати до 5 років
*/
SELECT ingredient.min_age, ingredient._name
FROM ingredient
INNER JOIN compositionitem
ON compositionitem.ingrident_id = ingredient._id
INNER JOIN product 
ON product._id = compositionitem.product_id
INNER JOIN typeofproduct
ON typeofproduct._id = product.id_of_typeofproduct
WHERE ingredient.min_age <= 5 AND
typeofproduct._name = 'Бакалія'


/*
2
Вивести кількість годин, що відпрацювали касири за кожен робочий день
*/

SELECT cashier._id, cashier._name, cashier._surname, 
cashier._midname, schedule._date, 
EXTRACT( HOUR FROM schedule.end_of_workday - schedule.begin_of_workday)AS hours_of_workday
FROM schedule
INNER JOIN cashier
ON schedule.id_employee = cashier._id

/*
Вивести максимально допустимі температури продуктів Бакалії
*/

SELECT product._name, typeofproduct._name AS name_type, 
(product.min_temperature + product.amplitude_temperature) AS 
max_temperature
FROM product
INNER JOIN typeofproduct
ON product.id_of_typeofproduct = typeofproduct._id
WHERE typeofproduct._name = 'Бакалія'

/*
3
Вивести суму поставок компанії Рошен
*/

SELECT SUM(supply.wholesale_price)
FROM supply INNER JOIN
vendor ON vendor._id = supply.id_vendor
WHERE vendor._name = 'Порошен';

/*
Вивести кількість товарів що були продані за 05.16.2021
*/

SELECT COUNT(checkitem._count) 
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
WHERE _check.date_of_purchase = '05.16.2021';

/*
4
Вивести суму чеків без маржі магазину 
*/

SELECT _check._id, 
SUM(checkitem._count*supply.wholesale_price/supply.count_of_pieces)
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
INNER JOIN supply
ON supply._id = checkitem.id_supply
GROUP BY _check._id

/*
Вивести суму поставок компаній
*/

SELECT vendor._name, SUM(supply.wholesale_price)
FROM supply INNER JOIN
vendor ON vendor._id = supply.id_vendor
GROUP BY vendor._name

/*
5
Вивести масу для всіх продуктів з бакалії
*/

SELECT typeofproduct._name, product._id, product._name,
SUM(compositionitem._weight) AS weight
FROM typeofproduct
INNER JOIN product
ON product.id_of_typeofproduct = typeofproduct._id
INNER JOIN compositionitem
ON compositionitem._id = product.id_of_licence
GROUP BY
typeofproduct._name, product._id, product._name
HAVING typeofproduct._name = 'Бакалія'

/*
Вивести суму чеків без маржі магазину оплачених по google pay
*/

SELECT _check._id, typeofpurchase._name,
SUM(checkitem._count*supply.wholesale_price/supply.count_of_pieces)
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
INNER JOIN supply
ON supply._id = checkitem.id_supply
INNER JOIN typeofpurchase
ON typeofpurchase._id = _check.id_typeofpurchase
GROUP BY _check._id, typeofpurchase._name
HAVING typeofpurchase._name = 'Картою'

/*
6
Вивести топ 5 чеків за сумою замовлення
*/

SELECT _check._id, 
SUM(checkitem._count*supply.wholesale_price/
supply.count_of_pieces*(1 + product.margin)) AS _sum
FROM _check 
INNER JOIN checkitem
ON checkitem.id_check = _check._id
INNER JOIN supply
ON supply._id = checkitem.id_supply
INNER JOIN product
ON product._id = supply.id_product
GROUP BY _check._id
ORDER BY _sum DESC LIMIT 5

/*
Вивести топ 3 постачальника, за вартістю поставок
*/

SELECT vendor._name, SUM(supply.wholesale_price) AS _sum
FROM supply INNER JOIN
vendor ON vendor._id = supply.id_vendor
GROUP BY vendor._name
ORDER BY _sum DESC
LIMIT 3

/*
7
Вивести всі заплати касирів без маржової надбавки за лютий місяць 2020 року в порядку зростання
*/

SELECT 
cashier._name,
cashier._midname,
cashier._surname,
EXTRACT(MONTH FROM schedule._date) AS _month,
EXTRACT(YEAR FROM schedule._date) AS _year,
SUM(EXTRACT(HOUR FROM schedule.end_of_workday - 
schedule.begin_of_workday)*cashier.hourly_pay) AS salary
FROM cashier
INNER JOIN
schedule
ON schedule.id_employee = cashier._id
GROUP BY cashier._name, cashier._midname, 
cashier._surname, _month, _year
HAVING 
EXTRACT(MONTH FROM schedule._date) = 2 AND
EXTRACT(YEAR FROM schedule._date) = 2020
ORDER BY salary

/*
Вивести кількість пройдених медичних оглядів всіх касирів в порядку зростання кількості
*/

SELECT 
cashier._id,
cashier._name,
cashier._midname,
cashier._surname,
medicalexamination.result,
COUNT(medicalexamination._id) AS _count
FROM cashier
LEFT OUTER JOIN medicalexamination
ON medicalexamination.id_employee = cashier._id
GROUP BY 
cashier._id,
cashier._name,
cashier._midname,
cashier._surname,
medicalexamination.result
HAVING 
medicalexamination.result = TRUE OR medicalexamination.result IS NULL 
ORDER BY _count


/*
8
Вивести всі товари, що мають масу більше середнього
*/

SELECT top._name, prod._id, prod._name,
SUM(ci._weight) AS _weight
FROM typeofproduct top
INNER JOIN product prod
ON prod.id_of_typeofproduct = top._id
INNER JOIN compositionitem ci
ON ci._id = prod.id_of_licence
GROUP BY
top._name, prod._id, prod._name
HAVING SUM(ci._weight) > (
	SELECT AVG(tempTable._subWeight) FROM (
		SELECT subProd._id, SUM(subCi._weight) AS _subWeight
		FROM typeofproduct subTop
		INNER JOIN product subProd
		ON subProd.id_of_typeofproduct = subTop._id
		INNER JOIN compositionitem subCi
		ON subCi._id = subProd.id_of_licence
		GROUP BY
		subProd._id
	) AS tempTable
)

/*
Вивести працівників які працювали > 10% всіх робочих днів
*/

SELECT 
c._name,
c._midname,
c._surname,
COUNT(s._id) AS count_workdays
FROM cashier c
INNER JOIN
schedule s
ON s.id_employee = c._id
GROUP BY c._name, c._midname, 
c._surname
HAVING COUNT(c._id) > 0.1*(
    SELECT COUNT(subS._id) 
    FROM schedule subS
)

/*
9
Вивести постачальників, що зареєстровані за адресою, де був виготовлений якийсь товар
*/

SELECT 
cn._name AS _country,
ct._name AS _city,
st._name AS _street,
ad._number AS _address,
ve._name AS _vendor
FROM country cn
INNER JOIN city ct
ON cn._id = ct.id_country
INNER JOIN street st
ON ct._id = st.id_city
INNER JOIN _address ad
ON st._id = ad.id_street
INNER JOIN vendor ve 
ON ve.place_of_registration = ad._id
WHERE ve.place_of_registration IN (
	SELECT product.address_producing FROM
	product
)

/*
Вивести всі виходи на роботу касирів, коли не було поставок
*/
SELECT csh._name,csh._midname,csh._surname, sch._date
FROM Cashier csh
INNER JOIN Schedule sch
ON csh._id = sch.id_employee
WHERE sch._date NOT IN (
	SELECT supply.date_of_producing
	FROM supply
)

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
)

