-- 1) create table for dimDate

-- CREATE TABLE dimDate
-- (
-- 	date_key integer NOT NULL PRIMARY KEY,
-- 	date date NOT NULL,
-- 	year smallint NOT NULL,
-- 	quarter smallint NOT NULL,
-- 	month smallint NOT NULL,
-- 	week smallint NOT NULL,
-- 	day smallint NOT NULL,
-- 	is_weekend boolean
-- );


--1.1) check the column and data type

-- SELECT column_name, data_type 
-- FROM information_schema.columns
-- WHERE table_name = 'dimdate'

-- 2) create table for dimCustomer

-- CREATE TABLE dimCustomer
-- (
-- 	customer_key SERIAL NOT NULL PRIMARY KEY,
-- 	customer_id smallint NOT NULL,
-- 	first_name varchar(50) NOT NULL,
-- 	last_name varchar(50) NOT NULL,
-- 	email varchar(50),
-- 	address varchar(50) NOT NULL,
-- 	address2 varchar(50),
-- 	district varchar(50) NOT NULL,
-- 	city varchar(50) NOT NULL,
-- 	country varchar(50) NOT NULL,
-- 	postcode varchar(50) NOT NULL,
-- 	create_date timestamp NOT NULL,
-- 	start_date date NOT NULL,
-- 	end_date date NOT NULL
-- );

-- 3) create table for dimMovie

-- CREATE TABLE dimMovie
-- (
-- 	movie_key SERIAL NOT NULL PRIMARY KEY,
-- 	film_id smallint NOT NULL,
-- 	title varchar(50) NOT NULL,
-- 	description varchar(500) NOT NULL,
-- 	release_year int NOT NULL,
-- 	language varchar(50) NOT NULL,
-- 	original_language varchar(50),
-- 	length varchar(50) NOT NULL,
-- 	ratings varchar(50) NOT NULL,
-- 	special_features varchar(500) NOT NULL
-- );

-- 4) create table for dimStore

-- CREATE TABLE dimStore
-- (
-- 	store_key SERIAL NOT NULL PRIMARY KEY,
-- 	store_id smallint NOT NULL,
-- 	address varchar(50) NOT NULL,
-- 	address2 varchar(50),
-- 	district varchar(50) NOT NULL,
-- 	city varchar(50) NOT NULL,
-- 	country varchar(50) NOT NULL,
-- 	postcode varchar(50) NOT NULL,
-- 	manager_first_name varchar(50) NOT NULL,
-- 	manager_last_name varchar(50) NOT NULL,
-- 	start_date date NOT NULL,
-- 	end_date date NOT NULL
-- );

-- DROP TABLE dimStore


-- 6) insert data into dimDate table

-- INSERT INTO dimDate (date_key, date, year, quarter, month, week, day, is_weekend)

-- SELECT 
-- 	DISTINCT(TO_CHAR(payment_date::DATE, 'yyyyMMDD')::integer) as date_key,
-- 	date(payment_date) AS date,
-- 	EXTRACT (year FROM payment_date) AS year,
-- 	EXTRACT (quarter FROM payment_date) AS quarter,
-- 	EXTRACT (month FROM payment_date) AS month,
-- 	EXTRACT (day FROM payment_date) AS day,
-- 	EXTRACT (week FROM payment_date) AS week,
-- 	CASE
-- 		WHEN EXTRACT(ISODOW FROM payment_date) IN (6,7) THEN true
-- 		ELSE false
-- 	END
	
-- FROM payment;

-- SELECT * 
-- FROM dimdate


-- 7) insert data into dimCustomer table

-- INSERT INTO dimCustomer 
-- (
-- 	customer_key, customer_id, first_name, last_name, email, address, 
-- 	address2, district, city, country, postcode, create_date, start_date, 
-- 	end_date
-- )

-- SELECT c.customer_id AS customer_key, c.customer_id, c.first_name, c.last_name,
-- 	c.email, a.address, a.address2, a.district, ci.city, co.country, 
-- 	a.postal_code, c.create_date, now() AS start_date, now() AS end_date

-- FROM customer c
-- JOIN address a
-- ON c.address_id = a.address_id
-- JOIN city ci
-- ON a.city_id = ci.city_id
-- JOIN country co
-- ON ci.country_id = co.country_id;

-- SELECT *
-- FROM dimCustomer

-- 8) insert data into dimMovie table

-- INSERT INTO dimMovie 
-- (
-- 	movie_key, film_id, title, description, release_year, language,
-- 	original_language, length, ratings, special_features
-- )

-- SELECT f.film_id AS movie_key, f.film_id, f.title, f.description, f.release_year,
-- 	l.language_id AS language, l.name AS original_language, f.length, f.rating,
-- 	f.special_features
	
-- FROM film f
-- JOIN language l
-- ON f.language_id = l.language_id

-- SELECT * 
-- FROM dimMovie
-- LIMIT 10;

-- 8) insert data into dimStore table (ignore it cause no rows)

-- INSERT INTO dimStore
-- (
-- 	store_key, store_id, address, address2, district, city, country, postcode,
-- 	manager_first_name, manager_last_name, start_date, end_date
-- )

-- SELECT st.store_id AS store_key, st.store_id, a.address, a.address2, a.district,
-- 	ci.city, co.country, a.postal_code, s.first_name, s.last_name,
-- 	now() AS start_date, now() AS end_date

-- FROM store st
-- JOIN address a
-- ON st.address_id = a.address_id
-- JOIN city ci
-- ON a.city_id = ci.city_id
-- JOIN country co
-- ON ci.country_id = co.country_id
-- JOIN staff s
-- ON st.address_id = s.address_id;

-- SELECT *
-- FROM dimStore;

-- 9) create factSales table

-- CREATE TABLE factSales
-- (
-- 	sales_key SERIAL PRIMARY KEY,
-- 	date_key integer REFERENCES dimDate (date_key),
-- 	customer_key integer REFERENCES dimCustomer (customer_key),
-- 	movie_key integer REFERENCES dimMovie (movie_key),
-- 	sales_amount numeric
-- );

-- 10) insert data into factSales table

-- INSERT INTO factSales
-- (
-- 	date_key, customer_key, movie_key, sales_amount
-- )

-- SELECT TO_CHAR(payment_date::DATE, 'yyyyMMDD')::integer AS date_key,
-- 	p.customer_id AS customer_key, i.film_id AS movie_key, p.amount AS sales_amount

-- FROM payment p
-- JOIN rental r 
-- ON p.rental_id = r.rental_id
-- JOIN inventory i
-- ON r.inventory_id = i.inventory_id;

SELECT dimMovie.title, dimDate.month, dimCustomer.city, sum(sales_amount) as revenue
FROM factSales
JOIN dimMovie
ON dimMovie.movie_key = factSales.movie_key
JOIN dimDate
ON dimDate.date_key = factSales.date_key
JOIN dimCustomer
ON dimCustomer.customer_key = factSales.customer_key
GROUP BY (dimMovie.title, dimDate.month, dimCustomer.city)
ORDER BY dimMovie.title, dimDate.month, dimCustomer.city, revenue DESC;