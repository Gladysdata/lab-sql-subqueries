USE sakila ;

#How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT i.film_id, f.title, count(f.title)
FROM inventory i
JOIN film f
ON i.film_id = f.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY i.film_id
ORDER BY count(f.title) ;

#List all films whose length is longer than the average of all the films
SELECT * FROM film_actor ;
SELECT * FROM actor ;
SELECT * FROM film ;

SELECT first_name, last_name, actor_id FROM actor JOIN
(SELECT actor_id FROM film_actor
WHERE film_id =
(SELECT film_id FROM film
WHERE title = 'Alone Trip')) sub USING(actor_id) ;

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films
SELECT film.title, category.name FROM film
JOIN film_category ON
film.film_id = film_category.film_id
JOIN category ON
film_category.category_id = category.category_id
WHERE category.name IN('Family')
ORDER BY film.title ;

#Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information
SELECT customer.first_name, customer.last_name, customer.email FROM customer
JOIN address ON
customer.address_id = address.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
WHERE country.country IN ('Canada') ;

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred
SELECT film.title, actor.first_name, actor.last_name FROM film
JOIN film_actor ON
film.film_id = film_actor.film_id
JOIN actor ON
film_actor.actor_id = actor.actor_id
WHERE film_actor.actor_id = (SELECT film_actor.actor_id FROM film_actor 
GROUP BY film_actor.actor_id
ORDER BY COUNT(film_actor.film_id) DESC
LIMIT 1)
ORDER BY film.title ;

#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT * FROM payment ;
SELECT * FROM customer ;
SELECT customer_id , sum(amount) OVER (PARTITION BY customer_id) FROM payment ;

SELECT customer_id, first_name, last_name FROM customer 
WHERE customer_id=
(SELECT customer_id FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1) ;

#Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client
SELECT customer.customer_id, SUM(payment.amount) AS 'Total spent by customer' FROM customer
JOIN payment ON
customer.customer_id = payment.customer_id
WHERE payment.amount > (SELECT AVG(payment.amount) FROM payment)
GROUP BY customer.customer_id ;