-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT 
    first_name, last_name
FROM
    actor;
    
 -- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT 
    CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS 'Actor Name'
FROM
    actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';
    
-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT 
    last_name, first_name
FROM
    actor
WHERE
    last_name LIKE '%LI%' ORDER BY last_name, first_name; 
 
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, China
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    
-- 3a You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB`

ALTER TABLE actor ADD COLUMN  description BLOB;
-- SELECT * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;
-- SELECT * from actor;

--  4a. List the last names of actors, as well as how many actors have that last name.

SELECT 
    last_name, COUNT(*) last_name_count
FROM
    actor
GROUP BY last_name
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;

-- 4b. List last names of actors and the number of actors who have the last name, but only for the names that are shared by at least two actors

SELECT 
    last_name, COUNT(*) last_name_count
FROM
    actor
GROUP BY last_name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

SELECT REPLACE('GROUCHO WILLIAMS', 'GROUCHO', 'HARPO');


-- 4d Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

SELECT REPLACE('HARPO WILLIAMS', 'HARPO', 'GROUCHO');

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        JOIN
    address ON staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT 
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS august_2005_total
FROM
    staff
        JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE
    payment.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT 
    film.title, COUNT(film_actor.actor_id) AS actor_count
FROM
    film
        JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

-- 6d How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT 
    COUNT(*)
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible'); 

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS total_amount_paid
FROM
    customer
        JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;

-- 7a. Use subquery to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT 
    title
FROM
    film
WHERE
    language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English')
        AND (title LIKE 'K%')
        OR (title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

-- 7c Find names and email addresses for all Canadian customers. Use joins to retrieve this information

SELECT 
    customer.first_name, customer.last_name, customer.email
FROM
    customer
        JOIN
    address ON customer.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    country ON country.country_id = city.country_id
WHERE
    country = 'Canada';


-- 7d. Identify all movies categorized as family films
SELECT 
    *
FROM
    film_list
WHERE
    category = 'Family';

 -- 7e. Display the most frequently rented movies in descending order
 
SELECT 
    film.title, COUNT(rental.inventory_id) AS rental_frequency
FROM
    film
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY rental_frequency DESC;

-- 7f. Write a query to display how much business in dollars each store brought in

SELECT 
    store.store_id, SUM(amount) AS gross
FROM
    payment
        JOIN
    rental ON payment.rental_id = rental.rental_id
        JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        JOIN
    store ON store.store_id = inventory.store_id
GROUP BY store.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country

SELECT 
    store.store_id, city.city, country.country
FROM
    store
        JOIN
    address ON store.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    country ON country.country_id = city.country_id;

-- 7h. List the top 5 genres in gross revenue in descending order 

SELECT 
    category.name, SUM(payment.amount) AS gross_revenue
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    inventory ON inventory.film_id = film_category.film_id
        JOIN
    rental ON rental.inventory_id = inventory.inventory_id
        JOIN
    payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_genres AS
    SELECT 
        name, SUM(payment.amount)
    FROM
        category
            INNER JOIN
        film_category ON category.category_id = film_category.category_id
            INNER JOIN
        inventory ON film_category.film_id = inventory.film_id
            INNER JOIN
        rental ON inventory.inventory_id = rental.inventory_id
            INNER JOIN
        payment
    GROUP BY name
    LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_5_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_5_genres;


