
DROP TABLE MedicalExamination CASCADE;
DROP TABLE Schedule CASCADE;
DROP TABLE CheckItem CASCADE;
DROP TABLE _Check CASCADE;
DROP TABLE Supply CASCADE;
DROP TABLE CompositionItem CASCADE;
DROP TABLE Product CASCADE;
DROP TABLE Vendor CASCADE;
DROP TABLE _Address CASCADE;
DROP TABLE Street CASCADE;
DROP TABLE City CASCADE;
DROP TABLE Country CASCADE;
DROP TABLE TypeOfPurchase CASCADE;
DROP TABLE Cashier CASCADE;
DROP TABLE Ingredient CASCADE;
DROP TABLE TypeOfProduct CASCADE;
DROP TABLE Licence CASCADE;
DROP TABLE Producer CASCADE;


CREATE TABLE Producer (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(80) NOT NULL
);
CREATE TABLE Licence (
	_id SERIAL PRIMARY KEY NOT NULL,
	_text TEXT NOT NULL
);
CREATE TABLE TypeOfProduct (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(60) NOT NULL
);
CREATE TABLE Country (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(80) NOT NULL
);
CREATE TABLE City (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_country INTEGER NOT NULL,
	_name VARCHAR(80) NOT NULL,
	FOREIGN KEY (id_country) REFERENCES Country(_id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE Street (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_city INTEGER NOT NULL,
	_name VARCHAR(80) NOT NULL,
	FOREIGN KEY (id_city) REFERENCES City(_id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE _Address (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_street INTEGER NOT NULL,
	_number VARCHAR(5) NOT NULL,
	FOREIGN KEY (id_street) REFERENCES Street(_id) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Vendor (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(80) NOT NULL,
	contract_phone VARCHAR(13) NOT NULL,
	place_of_registration INTEGER NOT NULL,
	CHECK(contract_phone SIMILAR TO '\+380[0-9]{9}'),
	FOREIGN KEY (place_of_registration) REFERENCES _Address(_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Product (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(80) NOT NULL,
	producer INTEGER NOT NULL,
	expiration_date INTEGER NOT NULL,
	min_temperature INTEGER NOT NULL,
	amplitude_temperature INTEGER NOT NULL CHECK (amplitude_temperature > 0),
	margin FLOAT NOT NULL,
	id_of_licence INTEGER NOT NULL,
	id_of_typeOfProduct INTEGER NOT NULL,
	address_producing INTEGER NOT NULL,
	FOREIGN KEY (producer) REFERENCES Producer(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (id_of_licence) REFERENCES Licence(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (id_of_typeOfProduct) REFERENCES TypeOfProduct(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (address_producing) REFERENCES _Address(_id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE Ingredient (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(80) NOT NULL,
	min_age INTEGER NOT NULL
);
CREATE TABLE CompositionItem (
	_id SERIAL PRIMARY KEY NOT NULL,
	product_id INTEGER NOT NULL,
	ingrident_id INTEGER NOT NULL,
	_weight INTEGER NOT NULL,
	FOREIGN KEY (product_id) REFERENCES Product(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (ingrident_id) REFERENCES Ingredient(_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Supply (
	_id SERIAL PRIMARY KEY NOT NULL,
	wholesale_price REAL NOT NULL,
	count_of_pieces INTEGER NOT NULL CHECK (count_of_pieces > 0),
	date_of_producing DATE NOT NULL,
	id_vendor INTEGER NOT NULL,
	id_product INTEGER NOT NULL,
	FOREIGN KEY (id_vendor) REFERENCES Vendor(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (id_product) REFERENCES Product(_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE TypeOfPurchase (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(50) NOT NULL
);

CREATE TABLE Cashier (
	_id SERIAL PRIMARY KEY NOT NULL,
	_name VARCHAR(50) NOT NULL,
	_surname VARCHAR(50) NOT NULL,
	_midname VARCHAR(50) NOT NULL,
	date_of_employment DATE NOT NULL,
	hourly_pay REAL NOT NULL,
	margin REAL NOT NULL
);
CREATE TABLE _Check (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_of_cashier INTEGER NOT NULL,
	date_of_purchase DATE NOT NULL,
	time_of_purchase TIME NOT NULL,
	id_typeOfPurchase INTEGER NOT NULL,
	card_number VARCHAR(16) NULL,
	FOREIGN KEY (id_of_cashier) REFERENCES Cashier(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (id_typeOfPurchase) REFERENCES TypeOfPurchase(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	CHECK(card_number IS NULL OR card_number SIMILAR TO '[0-9]{16}')
);
CREATE TABLE CheckItem (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_check INTEGER NOT NULL,
	id_supply INTEGER NOT NULL,
	_count FLOAT NOT NULL,
	FOREIGN KEY (id_check) REFERENCES _Check(_id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (id_supply) REFERENCES Supply(_id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE Schedule (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_employee INTEGER NOT NULL,
	_date DATE NOT NULL,
	begin_of_workday TIME NOT NULL,
	end_of_workday TIME NOT NULL CHECK(begin_of_workday < end_of_workday),
	FOREIGN KEY (id_employee) REFERENCES Cashier(_id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE MedicalExamination (
	_id SERIAL PRIMARY KEY NOT NULL,
	id_employee INTEGER NOT NULL,
	_date DATE NOT NULL,
	result BOOLEAN NOT NULL,
	result_explanation TEXT NOT NULL,
	FOREIGN KEY (id_employee) REFERENCES Cashier(_id) ON DELETE SET NULL ON UPDATE CASCADE
);



COPY Producer (
	_name)
FROM 'C:\Users\Public\data\Producer.csv'
DELIMITER ','
CSV HEADER;

COPY Licence (
	_text)
FROM 'C:\Users\Public\data\Licence.csv'
DELIMITER ','
CSV HEADER;

COPY TypeOfProduct (
	_name)
FROM 'C:\Users\Public\data\TypeOfProduct.csv'
DELIMITER ','
CSV HEADER;

COPY Country (
	_name)
FROM 'C:\Users\Public\data\Country.csv'
DELIMITER ','
CSV HEADER;

COPY City (
	_name,
	id_country
	)
FROM 'C:\Users\Public\data\City.csv'
DELIMITER ','
CSV HEADER;

COPY Street (
	id_city,
	_name
	)
FROM 'C:\Users\Public\data\Street.csv'
DELIMITER ','
CSV HEADER;

COPY _Address (
	_number,
	id_street
	)
FROM 'C:\Users\Public\data\Address.csv'
DELIMITER ','
CSV HEADER;

COPY Vendor (
	_name,
	contract_phone,
	place_of_registration
	)
FROM 'C:\Users\Public\data\Vendor.csv'
DELIMITER ','
CSV HEADER;

COPY Product (
	_name,
	producer,
	expiration_date,
	min_temperature,
	amplitude_temperature,
	margin,
	id_of_licence,
	id_of_typeOfProduct,
	address_producing
	)
FROM 'C:\Users\Public\data\Product.csv'
DELIMITER ','
CSV HEADER;

COPY Ingredient (
	_name,
	min_age
	)
FROM 'C:\Users\Public\data\Ingredient.csv'
DELIMITER ','
CSV HEADER;

COPY CompositionItem (
	product_id,
	ingrident_id,
	_weight
	)
FROM 'C:\Users\Public\data\CompositionItem.csv'
DELIMITER ','
CSV HEADER;

COPY Supply (
	wholesale_price,
	count_of_pieces,
	date_of_producing,
	id_vendor,
	id_product
	)
FROM 'C:\Users\Public\data\Supply.csv'
DELIMITER ','
CSV HEADER;

COPY TypeOfPurchase (
	_name
	)
FROM 'C:\Users\Public\data\TypeOfPurchase.csv'
DELIMITER ','
CSV HEADER;

COPY Cashier (
	_name,
	_surname,
	_midname,
	date_of_employment,
	hourly_pay,
	margin
	)
FROM 'C:\Users\Public\data\Cashier.csv'
DELIMITER ','
CSV HEADER;

COPY _Check (
	id_of_cashier,
	date_of_purchase,
	time_of_purchase,
	id_typeOfPurchase,
	card_number
	)
FROM 'C:\Users\Public\data\Check.csv'
DELIMITER ','
CSV HEADER;

COPY CheckItem (
	id_check,
	id_supply,
	_count
	)
FROM 'C:\Users\Public\data\CheckItems.csv'
DELIMITER ','
CSV HEADER;

COPY Schedule (
	id_employee,
	_date,
	begin_of_workday,
	end_of_workday
	)
FROM 'C:\Users\Public\data\Schedule.csv'
DELIMITER ','
CSV HEADER;

COPY MedicalExamination (
	id_employee,
	_date,
	result,
	result_explanation
	)
FROM 'C:\Users\Public\data\MedicalExamination.csv'
DELIMITER ','
CSV HEADER;
