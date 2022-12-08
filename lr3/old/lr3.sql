/*1a*/

SELECT bop._name, bop.wholesale_price, bop.count_of_pieces, v._name AS vendor_name
FROM bundleofproduct bop INNER JOIN vendor v ON v._id = bop.id_vendor
WHERE bop.count_of_pieces > 500;

/*1b*/

SELECT eml._name, eml._midname, eml._surname, sdl._date, sdl.begin_of_workday,sdl.end_of_workday, pos._name AS position_name 
FROM employee eml INNER JOIN schedule sdl ON sdl.id_employee = eml._id INNER JOIN _position  pos ON pos._id = eml._id 
WHERE EXTRACT(MONTH FROM sdl._date) = 12 and EXTRACT(YEAR FROM sdl._date) = 2020;

/*2a*/

SELECT bof._name, (bof.wholesale_price/bof.count_of_pieces)*(1+bof.margin/100) AS price, top._name AS category_name
FROM bundleofproduct bof INNER JOIN product prod ON prod._id = bof.id_vendor
INNER JOIN typeofproduct top ON top._id = prod.id_of_typeofproduct;

/*2b*/

SELECT eml._name, eml._midname, eml._surname, pos._name AS position_name, sdl._date,
-((EXTRACT(MINUTE FROM sdl.begin_of_workday) - EXTRACT(MINUTE FROM sdl.end_of_workday))/60 + 
(EXTRACT(HOUR FROM sdl.begin_of_workday) - EXTRACT(HOUR FROM sdl.end_of_workday)))*eml.hourly_pay AS salary
FROM employee eml INNER JOIN schedule sdl ON sdl.id_employee = eml._id INNER JOIN _position  pos ON pos._id = eml._id 
WHERE EXTRACT(MONTH FROM sdl._date) = 12 and EXTRACT(YEAR FROM sdl._date) = 2020;

/*3a*/

SELECT COUNT(*)
FROM product prod
WHERE prod.id_of_check = NULL;
/*3b*/

SELECT bop._name, v._name AS vendor_name , 
trim(to_char(bop.wholesale_price/bop.count_of_pieces,'99999999999999999D99')) AS price 
FROM bundleofproduct bop 
INNER JOIN vendor v ON bop.id_vendor = v._id
WHERE bop.wholesale_price/bop.count_of_pieces > 
(SELECT AVG(bof.wholesale_price/bof.count_of_pieces)
FROM bundleofproduct bof)

/*4a*/

SELECT eml._id, eml._name, eml._midname, eml._surname,
SUM(-((EXTRACT(MINUTE FROM sdl.begin_of_workday) - EXTRACT(MINUTE FROM sdl.end_of_workday))/60 + 
(EXTRACT(HOUR FROM sdl.begin_of_workday) - EXTRACT(HOUR FROM sdl.end_of_workday)))*eml.hourly_pay) AS salary
FROM employee eml 
INNER JOIN schedule sdl ON sdl.id_employee = eml._id 
INNER JOIN _position  pos ON pos._id = eml._id 
WHERE EXTRACT(MONTH FROM sdl._date) = 12 and EXTRACT(YEAR FROM sdl._date) = 2020
GROUP BY eml._id, eml._name, eml._midname, eml._surname;

/*4b*/

SELECT pos._name AS position_name, COUNT(emp._id) AS employee_count
FROM _position pos 
INNER JOIN employee emp ON pos._id = emp.id_position
GROUP BY pos._name;

/*5a*/


SELECT top._name AS category_name, SUM(wholesale_price/bof.count_of_pieces*(1+bof.margin/100)) AS general_value
FROM BundleOfProduct bof
INNER JOIN Product prod ON prod.id_of_bundle = bof._id
INNER JOIN TypeOfProduct top ON prod.id_of_typeofproduct = top._id
GROUP BY top._name HAVING top._name = 'Бакалія';
/*5b*/

SELECT eml._id, eml._name, eml._midname, eml._surname,
SUM(-((EXTRACT(MINUTE FROM sdl.begin_of_workday) - EXTRACT(MINUTE FROM sdl.end_of_workday))/60 + 
(EXTRACT(HOUR FROM sdl.begin_of_workday) - EXTRACT(HOUR FROM sdl.end_of_workday)))*eml.hourly_pay) AS salary
FROM employee eml 
INNER JOIN schedule sdl ON sdl.id_employee = eml._id 
INNER JOIN _position  pos ON pos._id = eml._id 
WHERE EXTRACT(MONTH FROM sdl._date) = 12 and EXTRACT(YEAR FROM sdl._date) = 2020
GROUP BY eml._id HAVING SUM(-((EXTRACT(MINUTE FROM sdl.begin_of_workday) - EXTRACT(MINUTE FROM sdl.end_of_workday))/60 + 
(EXTRACT(HOUR FROM sdl.begin_of_workday) - EXTRACT(HOUR FROM sdl.end_of_workday)))*eml.hourly_pay) < 6500;

/*6a*/

SELECT top._name AS category_name, SUM(wholesale_price/bof.count_of_pieces*(1+bof.margin/100)) 
AS general_value 
FROM BundleOfProduct bof
INNER JOIN Product prod ON prod.id_of_bundle = bof._id
INNER JOIN TypeOfProduct top ON prod.id_of_typeofproduct = top._id
GROUP BY top._name ORDER BY general_value DESC;

/*6b*/

SELECT eml._id, eml._name, eml._midname, eml._surname,
SUM(-((EXTRACT(MINUTE FROM sdl.begin_of_workday) - EXTRACT(MINUTE FROM sdl.end_of_workday))/60 + 
(EXTRACT(HOUR FROM sdl.begin_of_workday) - EXTRACT(HOUR FROM sdl.end_of_workday)))*eml.hourly_pay) AS salary
FROM employee eml 
INNER JOIN schedule sdl ON sdl.id_employee = eml._id 
INNER JOIN _position  pos ON pos._id = eml._id 
WHERE EXTRACT(MONTH FROM sdl._date) = 12 and EXTRACT(YEAR FROM sdl._date) = 2020
GROUP BY eml._id ORDER BY salary;


/*7a*/

SELECT  chk._id, chk.date_of_purchase, chk.time_of_purchase, SUM(bop.wholesale_price / bop.count_of_pieces * (1+bop.margin/100)) AS check_sum
FROM _Check chk 
INNER JOIN Product ON chk._id = Product.id_of_check
INNER JOIN BundleOfProduct bop ON Product.id_of_bundle = bop._id
GROUP BY chk._id HAVING EXTRACT(YEAR FROM chk.date_of_purchase) = 2020 ORDER BY chk.date_of_purchase DESC;
/*7b*/

SELECT emp._name, emp._midname, emp._surname, pos._name AS position_name , COUNT(chk._id) As count_of_sales
FROM _position pos
INNER JOIN employee emp ON emp.id_position = pos._id
LEFT OUTER JOIN _check chk ON chk.id_of_cashier = emp._id
GROUP BY emp._name, emp._midname, emp._surname, position_name
HAVING pos._name = 'Касир'
ORDER BY count_of_sales;

/*8a*/

SELECT emp._name, emp._midname, emp._surname, pos._name, emp.hourly_pay
FROM employee emp
INNER JOIN _position pos ON pos._id = emp.id_position
WHERE emp.hourly_pay > (SELECT AVG(hourly_pay) FROM employee )

/*8b*/

SELECT bop._name, bop.producer, COUNT(prod._id) AS total_count,
trim(to_char(COUNT(prod._id)::decimal/(
SELECT COUNT(subProd._id)
FROM bundleofproduct SubBop 
INNER JOIN product subProd ON subProd.id_of_bundle = SubBop._id
)*100,'99999999999999999D99')) AS percent_of_total_sales
FROM bundleofproduct bop 
INNER JOIN product prod ON prod.id_of_bundle = bop._id
WHERE prod.id_of_check IS NOT NULL
GROUP BY bop._name, bop.producer
HAVING 0.01 < COUNT(prod._id)::decimal/(
SELECT COUNT(subProd._id)
FROM bundleofproduct SubBop 
INNER JOIN product subProd ON subProd.id_of_bundle = SubBop._id
);

/*9a*/

SELECT MAX(bop.wholesale_price/bop.count_of_pieces)
FROM bundleofproduct bop 	
INNER JOIN product prod ON prod.id_of_bundle = bop._id
WHERE prod._id IN (
SELECT subProd._id
FROM bundleofproduct subBop 	
INNER JOIN product subProd ON subProd.id_of_bundle = subBop._id
WHERE subProd.id_of_check IS NULL
ORDER BY subBop.expiration_date
LIMIT 5);

/*9b*/

SELECT MAX((bop.wholesale_price/bop.count_of_pieces)*bop.margin/100) AS max_profit
FROM bundleofproduct bop 	
INNER JOIN product prod ON prod.id_of_bundle = bop._id
WHERE prod._id IN (
SELECT subProd._id
FROM bundleofproduct subBop 	
INNER JOIN product subProd ON subProd.id_of_bundle = subBop._id
INNER JOIN typeofproduct subTop ON subProd.id_of_typeofproduct = subTop._id
WHERE subTop._name = 'Бакалія' AND subProd.id_of_check IS NOT NULL
ORDER BY subBop.expiration_date
LIMIT 5);

/*10a*/

SELECT bop._name, bop.producer, COUNT(prod._id) AS total_count
FROM bundleofproduct bop 
INNER JOIN product prod ON prod.id_of_bundle = bop._id
GROUP BY bop._name, bop.producer
HAVING 0.5 < (
SELECT COUNT(subProd._id)
FROM bundleofproduct SubBop 
INNER JOIN product subProd ON subProd.id_of_bundle = SubBop._id
WHERE bop._name = SubBop._name AND
	bop.producer = SubBop.producer AND
	subProd.id_of_check IS NOT NULL
)/COUNT(prod._id);

/*10b*/

SELECT emp._name, emp._surname, emp._midname, sch._date, sch.begin_of_workday, sch.end_of_workday
FROM employee emp
INNER JOIN schedule sch
ON sch.id_employee = emp._id
WHERE NOT EXISTS(
	SELECT chk._id
	FROM _check chk
	WHERE sch.begin_of_workday <= chk.time_of_purchase AND
	chk.time_of_purchase <= sch.end_of_workday AND
	sch._date = chk.date_of_purchase
);