#SPRINT 2 - Paula Tommasetta

#Nivel 1 - Ejercicio 1

CREATE DATABASE IF NOT EXISTS transactions;

USE transactions;

CREATE TABLE IF NOT EXISTS company (
	id VARCHAR(15) PRIMARY KEY,
	company_name VARCHAR(255),
	phone VARCHAR(15),
	email VARCHAR(100),
	country VARCHAR(100),
	website VARCHAR(255)
    );

CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255),
	credit_card_id VARCHAR(15) ,
	company_id VARCHAR(15), 
	user_id INT,
	lat FLOAT,
	longitude FLOAT,
	timestamp TIMESTAMP,
	amount DECIMAL(10, 2),
	declined BOOLEAN,
    PRIMARY KEY (id),
	FOREIGN KEY (company_id) REFERENCES company(id) 
    );

#Nivel 1 - Ejercicio 2

SELECT DISTINCT c.country
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0;

SELECT count(DISTINCT c.country) AS cantidad_paises_ventas
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0;

SELECT c.id, c.company_name, ROUND(avg(t.amount), 2) AS promedio_ventas
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
WHERE declined = 0
GROUP BY c.id, c.company_name
ORDER BY promedio_ventas DESC
LIMIT 1;

#Nivel 1 - Ejercicio 3

SELECT * 
FROM transaction
WHERE company_id = ANY (
	SELECT id 
    FROM company 
    WHERE country = 'Germany');
    
SELECT company_name
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE amount > (
        SELECT AVG(amount)
        FROM transaction
    )
);


#no hay ninguna empresa sin transacciones registradas
SELECT company_name
FROM company
WHERE NOT EXISTS (SELECT company_id FROM transaction);


#Nivel 1 - Ejercicio 4

CREATE TABLE IF NOT EXISTS credit_card (
  id VARCHAR(15) NOT NULL,
  iban VARCHAR(45) DEFAULT NULL,
  pan VARCHAR(20) DEFAULT NULL,
  pin INT DEFAULT NULL,
  cvv INT DEFAULT NULL,
  expiring_date date DEFAULT NULL,
  PRIMARY KEY (id)
  );
ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id); 

SELECT * FROM credit_card;

ALTER TABLE credit_card
MODIFY expiring_date VARCHAR(10);

UPDATE credit_card
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');

SELECT * FROM credit_card;


#Nivel 1 - ejercicio 5

SELECT * FROM credit_card
WHERE id = "CcU-2938";

UPDATE credit_card SET iban = 'TR323456312213576817699999' WHERE id = "CcU-2938";


#Nivel 1 - ejercicio 6

INSERT INTO transaction (id, credit_card_id ,company_id, user_id, lat, longitude, amount, declined)
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999, 829.999, -117.999, 111.11, 0);

INSERT INTO company(id)
VALUES ("b-9999");

SELECT * FROM company
WHERE id = "b-9999";

INSERT INTO credit_card(id)
VALUES ("CcU-9999");

SELECT * FROM credit_card
WHERE id = "CcU-9999";

SELECT * FROM transaction
WHERE company_id = "b-9999";

#Nivel 1 - ejercicio 7

SELECT * FROM credit_card
LIMIT 5;

ALTER TABLE credit_card 
DROP COLUMN pan;


#Nivel 1 - ejercicio 8

CREATE DATABASE IF NOT EXISTS transactionsint;

USE transactionsint;

CREATE TABLE users (
	id INT NOT NULL,
    name VARCHAR(100) DEFAULT NULL,
    surname VARCHAR(100) DEFAULT NULL,
    phone VARCHAR(100) DEFAULT NULL,
    email VARCHAR(100) DEFAULT NULL,
	birth_date DATE DEFAULT NULL,
    country VARCHAR(100) DEFAULT NULL,
    city VARCHAR(100) DEFAULT NULL,
    postal_code VARCHAR(50) DEFAULT NULL,
    address VARCHAR(100) DEFAULT NULL,
    signup_date DATE DEFAULT NULL,
    user_segment VARCHAR(100) DEFAULT NULL,
    income_band VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE companies (
  company_id VARCHAR(100) NOT NULL,
  company_name VARCHAR(255) DEFAULT NULL,
  phone VARCHAR(15) DEFAULT NULL,
  email VARCHAR(100) DEFAULT NULL,
  country VARCHAR(100) DEFAULT NULL,
  website VARCHAR(255) DEFAULT NULL,
  merchant_category VARCHAR(100) DEFAULT NULL,
  merchant_price_category VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (company_id)
);

CREATE TABLE credit_cards (
  id VARCHAR(15) NOT NULL,
  user_id INT NOT NULL,
  iban VARCHAR(45) NOT NULL,
  pan VARCHAR(45) DEFAULT NULL,
  pin INT DEFAULT NULL,
  cvv INT DEFAULT NULL,
  track1 varchar(100) DEFAULT NULL,
  track2 varchar(100) DEFAULT NULL,
  expiring_date DATE DEFAULT NULL,
  card_type VARCHAR(45) DEFAULT NULL,
  card_renewal_flag BOOLEAN DEFAULT NULL,
  PRIMARY KEY (id)
  );
  
  CREATE TABLE transactions (
	id VARCHAR(100) NOT NULL,
    card_id VARCHAR(15) DEFAULT NULL,
    business_id VARCHAR(100) DEFAULT NULL,
    timestamp TIMESTAMP DEFAULT NULL,
    amount DECIMAL(10,2) DEFAULT NULL,
    declined BOOLEAN DEFAULT NULL,
    product_ids VARCHAR(45),
    user_id INT DEFAULT NULL,
    lat FLOAT DEFAULT NULL,
    longitude FLOAT DEFAULT NULL,
    discount_amount DECIMAL(10,2) DEFAULT NULL,
    tax_amount DECIMAL(10,2) DEFAULT NULL,
    shipping_amount DECIMAL(10,2) DEFAULT NULL,
    channel VARCHAR(45) DEFAULT NULL,
    campaign_id VARCHAR(45) DEFAULT NULL,
    device_type VARCHAR(45) DEFAULT NULL,
    is_international BOOLEAN DEFAULT NULL,
    decline_reason VARCHAR(45) DEFAULT NULL,
    distance_km DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (id),
	FOREIGN KEY (card_id) REFERENCES credit_cards(id),
    FOREIGN KEY (business_id) REFERENCES companies(company_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

SHOW CREATE TABLE transactions;

SELECT * FROM users;

SET SQL_SAFE_UPDATES = 0;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\N1-Ex.8__american_users.csv'
INTO TABLE users
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, birth_date, country, city, postal_code, address, signup_date, user_segment, income_band);

ALTER TABLE users
MODIFY COLUMN birth_date VARCHAR(100);

SET lc_time_names = 'en_US';

UPDATE users
SET
  birth_date = STR_TO_DATE(birth_date, '%b %d, %Y'),
  signup_date = STR_TO_DATE(signup_date, '%Y-%b-%d');

SELECT * FROM users;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\N1-Ex.8__european_users.csv'
INTO TABLE users
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, birth_date, country, city, postal_code, address, signup_date, user_segment, income_band);  

SELECT * FROM users;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\N1-Ex.8__companies.csv'
INTO TABLE companies
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(company_id, company_name, phone, email, country, website, merchant_category, merchant_price_category);

ALTER TABLE companies
MODIFY COLUMN phone VARCHAR(100);

SELECT * FROM companies;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\N1-Ex.8__credit_cards.csv'
INTO TABLE credit_cards
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, user_id, iban, pan, pin, cvv, track1, track2, expiring_date, card_type, card_renewal_flag);

ALTER TABLE credit_cards
MODIFY COLUMN expiring_date VARCHAR(100);

UPDATE credit_cards
SET expiring_date = STR_TO_DATE(expiring_date, '%b/%d/%y');

SELECT * FROM credit_cards;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\N1-Ex.8__transactions.csv'
INTO TABLE transactions
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, card_id, business_id, timestamp, amount, declined, product_ids, user_id, lat, longitude, discount_amount, tax_amount, shipping_amount, channel, campaign_id, device_type, is_international, decline_reason, distance_km);

SELECT * FROM transactions;

SET SQL_SAFE_UPDATES = 1;


#Nivel 1 - Ejercicio 9

SELECT u.id, u.name, u.surname, (
	SELECT COUNT(t.id) 
	FROM transactions t
    WHERE t.user_id = u.id) AS cant_trans
FROM users u
WHERE (
	SELECT COUNT(t.id) 
	FROM transactions t
    WHERE t.user_id = u.id) > 80;

#Nivel 1 - Ejercicio 10

SELECT c.company_name, cc.iban, ROUND(avg(t.amount), 2) AS prom_montos
FROM companies c
INNER JOIN transactions t
	ON c.company_id = t.business_id
INNER JOIN credit_cards cc
	ON t.card_id = cc.id
WHERE c.company_name = "Donec Ltd"
GROUP BY c.company_name, cc.iban;


#Nivel 2 - Ejercicio 1

SELECT business_id, DATE(timestamp), sum(amount - discount_amount + shipping_amount) AS total_ingresos
FROM transactions
WHERE declined = 0 
GROUP BY DATE(timestamp), business_id
ORDER BY total_ingresos DESC
LIMIT 5;

SELECT DATE(timestamp), sum(amount - discount_amount + shipping_amount) AS total_ingresos
FROM transactions
WHERE declined = 0 
GROUP BY DATE(timestamp)
ORDER BY total_ingresos DESC
LIMIT 5;


#Nivel 2 - Ejercicio 2

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp), t.amount
FROM companies c
INNER JOIN transactions t
ON c.company_id = t.business_id
WHERE (t.amount BETWEEN 350 AND 400) AND DATE(t.timestamp) in ("2015-04-29", "2018-07-20", "2024-03-13")
ORDER BY amount DESC;


#Nivel 2 - Ejercicio 3

SELECT t.business_id, c.company_name,
CASE
	WHEN count(t.id) >= 400 THEN "400 o más"
    ELSE "menos de 400"
    END AS valoracion_transacciones
FROM transactions t
LEFT JOIN companies c
ON t.business_id = c.company_id
GROUP BY t.business_id;


#Nivel 2 - Ejercicio 4

SELECT * FROM transactions
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

DELETE FROM transactions
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";


#Nivel 2 - Ejercicio 5

CREATE VIEW VistaMarketing AS (
SELECT c.company_name, c.phone, c.country, ROUND(avg(t.amount), 2) AS promedio_compras
FROM companies c
INNER JOIN transactions t
	ON c.company_id = t.business_id 
GROUP BY c.company_name, c.phone, c.country
ORDER BY avg(t.amount) DESC
);

SELECT * FROM vistamarketing;


#Nivel 3 - Ejercicio 1

CREATE TABLE IF NOT EXISTS estado_tarjetas(
	id INT AUTO_INCREMENT NOT NULL,
    id_credit_card VARCHAR(15) DEFAULT NULL,
    estado VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_credit_card) REFERENCES credit_cards(id)
    );
    
SELECT * FROM estado_tarjetas;

ALTER TABLE transactions
MODIFY declined BOOLEAN;

INSERT INTO estado_tarjetas (id_credit_card, estado)
WITH ultimas_transacciones AS (
    SELECT 
        card_id, 
        declined,
        ROW_NUMBER() OVER (
            PARTITION BY card_id 
            ORDER BY timestamp DESC
        ) AS num_trans
    FROM transactions
)
SELECT card_id,
    CASE 
        WHEN SUM(declined) = 3 THEN 'inactivo'
        ELSE 'activo'
    END AS estado
FROM ultimas_transacciones
WHERE num_trans <= 3
GROUP BY card_id;

SELECT * FROM estado_tarjetas;

SELECT count(id_credit_card) AS tarjetas_activas
FROM estado_tarjetas
WHERE estado = "activo";


#Nivel 3 - Ejercicio 2

CREATE TABLE products (
	id INT NOT NULL,
	product_name VARCHAR(100) DEFAULT NULL,
    price DECIMAL(10,2) DEFAULT NULL, 
    colour VARCHAR(100) DEFAULT NULL,
    weight DECIMAL(10,2) DEFAULT NULL,
    warehouse_id VARCHAR(100) DEFAULT NULL,
    category VARCHAR(100) DEFAULT NULL,
    brand VARCHAR(100) DEFAULT NULL,
    cost DECIMAL(10,2) DEFAULT NULL, 
    lauch_date DATE DEFAULT NULL, 
    PRIMARY KEY (id)
);
SELECT * FROM products;

CREATE TABLE IF NOT EXISTS trans_products (
    id_transaction VARCHAR(100) NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (id_transaction, product_id),
    FOREIGN KEY (id_transaction) REFERENCES transactions(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
);

SELECT * FROM trans_products;

CREATE TABLE trans_products (
    id_transaction VARCHAR(100) DEFAULT NULL,
    product_id INT DEFAULT NULL,
    FOREIGN KEY (id_transaction) REFERENCES transactions(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
);

SELECT * FROM trans_products;

ALTER TABLE products
MODIFY COLUMN price VARCHAR(100);

SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET price = CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS DECIMAL(10, 2));

ALTER TABLE products
MODIFY COLUMN cost VARCHAR(100);

UPDATE products
SET cost = CAST(REPLACE(REPLACE(cost, '$', ''), ',', '') AS DECIMAL(10, 2));


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\N1-Ex.8__products.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, product_name, price, colour, weight, warehouse_id, category, brand, cost, launch_date);

ALTER TABLE products
RENAME COLUMN lauch_date TO launch_date;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM products;

INSERT INTO trans_products (id_transaction, product_id)
SELECT t.id, t2.product_ids
FROM transactions t
JOIN JSON_TABLE(
    CONCAT('[', t.product_ids, ']'),
    '$[*]' COLUMNS (product_ids int PATH '$')
) t2
WHERE t.product_ids IS NOT NULL;

SELECT * FROM trans_products;

SELECT tp.product_id, count(tp.id_transaction) AS cantidad_ventas
FROM trans_products tp
INNER JOIN transactions t
	ON tp.id_transaction = t.id
WHERE t.declined = 0
GROUP BY tp.product_id
ORDER BY tp.product_id;
