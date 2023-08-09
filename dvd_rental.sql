-- SELECT p.customer_id, p.amount AS revenue, c.address_id, a.city_id, b.city, f.title
-- FROM payment p
-- JOIN customer c
-- ON p.customer_id = c.customer_id
-- JOIN address a
-- ON c.address_id = a.address_id
-- JOIN city b
-- ON a.city_id = b.city_id

-- JOIN rental r
-- ON p.rental_id = r.rental_id
-- JOIN inventory i
-- ON r.inventory_id = i.inventory_id
-- JOIN film f
-- ON i.film_id = f.film_id;

SELECT  SUM(p.amount) AS revenue, b.city AS city
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
JOIN address a
ON c.address_id = a.address_id
JOIN city b
ON a.city_id = b.city_id

JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id

GROUP BY city;


