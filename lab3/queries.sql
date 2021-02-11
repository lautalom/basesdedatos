\! echo Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.
SELECT C.Name, Ct.Name FROM city Ct JOIN country C ON C.Code = Ct.CountryCode WHERE C.population < 10000;

\! echo Listar todas aquellas ciudades cuya población sea mayor que la población promedio entre todas las ciudades.
SELECT Ct.Name FROM city Ct WHERE Ct.population > (Select AVG(population) from city);        

\! echo Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la población total de algún país de Asia
SELECT ci.Name as 'City Name',ci.Population as 'City Population' FROM city ci JOIN country co ON ci.CountryCode = co.Code WHERE co.Continent != 'Asia' AND ci.Population >= ANY(SELECT co.population FROM country co WHERE continent ='Asia');

\! echo Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje de hablantes a todos los idiomas oficiales del país.

--listamos todos los que tienen 2 idiomas...
 SELECT country.name FROM country JOIN countrylanguage ON countrycode = code WHERE isofficial = 't' GROUP BY country.name HAVING COUNT(*) >= 2;
--no idea

SELECT Name,nonofficials FROM country JOIN (
	Select * from (   
		SELECT countrycode,sum(case when isofficial = 'T' then Percentage else 0 end) as officials,sum(case when isofficial = 'F' then Percentage else 0 end) as nonofficials   FROM countrylanguage GROUP BY countrycode) X where nonofficials > officials) B 
	ON B.countrycode=country.code;
--72
SELECT co.name as "Country Name", SUM(cl.percentage) as "Non official language" FROM country co INNER JOIN countrylanguage cl ON cl.countrycode=co.code WHERE cl.isofficial='F' > ALL(SELECT cl2.percentage FROM countrylanguage cl2 WHERE cl2.countrycode=co.code AND cl2.isofficial='T') GROUP BY co.name;
--58

\! echo Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas).
SELECT c.Region, c.Name FROM country c WHERE c.SurfaceArea < 1000 AND c.Code IN ( SELECT countrycode from city where population  > 100000 );  

 SELECT Region from country c INNER JOIN (SELECT countrycode from city WHERE population>100000) B ON B.countrycode=code WHERE c.Surfacearea<1000 GROUP BY Region;

\! echo  Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).
SELECT c.name,max(ct.population) from country c join city ct ON c.code=ct.countrycode GROUP BY c.name;

\! echo Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor al promedio de hablantes de los lenguajes oficiales.
SELECT c.name, z.language FROM country c INNER JOIN (
	SELECT cl2.language,cl2.countrycode FROM countrylanguage cl2 JOIN (
		SELECT cl.countrycode,AVG(cl.percentage) as avgoff FROM countrylanguage cl where cl.isofficial='T' GROUP BY countrycode) b on cl2.countrycode=b.countrycode WHERE cl2.percentage > b.avgoff AND cl2.isofficial='F') z ON c.code=z.countrycode;
\! echo Listar la cantidad de habitantes por continente ordenado en forma descendiente.
 SELECT population,continent from country group by continent order by population DESC; 
\! echo Resultado: 7 valores.
\! echo Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una esperanza de vida entre 40 y 70 años.
SELECT avg(lifeexpectancy) as expLE,continent from country group by continent HAVING expLE >=40 AND expLE <=70;  


\! echo Resultado: 3 valores.
\! echo Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.
SELECT max(population) MAXPOP, sum(population) SUMPOP,min(population) MINPOP, continent from country group by continent;   









