--consultas

--El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número de películas filmadas) son también directores de las películas en las que participaron. Basados en esta información, inserten, utilizando una subquery los valores correspondientes en la tabla `directors`.
CREATE TABLE directors(Nombre VARCHAR(20), Apellido VARCHAR(20) , NoPel INT);
--Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a si el cliente es "premium" o no. Por defecto ningún cliente será premium.
 ALTER TABLE customer ADD COLUMN premium_customer ENUM('T','F') DEFAULT 'F';
--Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de los 10 clientes con mayor dinero gastado en la plataforma.
UPDATE customer SET customer.premium_customer = 'T'WHERE customer.customer_id IN (
SELECT * FROM (SELECT p.customer_id FROM payment p GROUP BY customer_id ORDER BY SUM(p.amount) DESC LIMIT 10) AS total_spent_table);
--Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings de las películas existentes (Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc).

Select rating, count(film_id) "cantidad de peliculas" from film group by rating order by count(film_id) DESC;

--Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el nombre del mes de una fecha).
Select monthname(payment_date),round(avg(amount),3) from payment group by month(payment_date);

--¿Cuáles fueron la primera y última fecha donde hubo pagos?

Select payment_date from payment order by payment_date ASC limit 1) UNION (select payment_date q from payment order by q DESC LIMIT 1);
--Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total de alquileres).

