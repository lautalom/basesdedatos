
\! echo Cree una vista faculty que muestre solo la ID, el nombre y el departamento de instructores.
delete view if exists notsalary;
CREATE VIEW notsalary AS select id, name, dept_name from instructor;
select * from notsalary limit 5;
\! echo Definir un trigger que después que un estudiante se inscribe a un curso \(“takes”\) se actualice el total de créditos del estudiante. 
--drop trigger if exists tot_cred;
-- CREATE TRIGGER grade_change AFTER UPDATE on takes FOR EACH ROW BEGIN IF (OLD.grade='F' OR OLD.grade IS NULL) BEGIN SET @c=(SELECT credits FROM course WHERE course.course_id=NEW.course_id); SET @p=NEW.ID; UPDATE student SET tot_cred=tot_cred+@c WHERE student.ID=@p; END;

CREATE or replace FUNCTION get_credits(course_id INTEGER)
    RETURNS INT
    RETURN(SELECT credits FROM course 
       	WHERE co.course_id = course_id);
		    

CREATE or replace TRIGGER update_credits 
AFTER INSERT ON takes
FOR EACH ROW
    UPDATE student s 
    SET s.tot_cred = s.tot_cred+get_credits(NEW.course_id)
    WHERE s.ID = NEW.ID;

\! echo Definir triggers que considere necesarios a la hora de insertar un nuevo valor en alguna tabla de la base de datos.

\! echo Definir funciones que retornen la cantidad de inscripciones máxima y mínima de todas las secciones, teniendo en cuenta sólo las secciones que tuvieron alguna inscripción.

drop function if exists max_sec;
drop function if exists min_sec;
DELIMITER //
CREATE FUNCTION MAX_SEC(
	SEMESTER VARCHAR(6),YEAR DECIMAL(4,0)) 
	RETURNS INT
	BEGIN
	DECLARE max_insc INT DEFAULT 0;
	SELECT t1.cant INTO max_insc FROM 
		(
		SELECT count(*) AS `cant`,s.sec_id 
		FROM section s JOIN takes t ON s.sec_id = t.sec_id 				AND s.semester = t.semester AND s.year = t.year 				WHERE s.semester = SEMESTER AND s.year = YEAR
		GROUP BY sec_id ORDER BY 1 DESC LIMIT 1) t1;
		RETURN max_insc;
		END;
		//
delimiter ;
delimiter //
CREATE FUNCTION MIN_SEC(
	SEMESTER VARCHAR(6),YEAR DECIMAL(4,0))
	RETURNS INT
	BEGIN
	DECLARE min_insc INT;
	SELECT MIN(t1.cant)
	INTO min_insc FROM 
		(SELECT count(*) AS `cant`,s.sec_id
	 	FROM section s JOIN takes t ON s.sec_id = t.sec_id
		AND s.semester = t.semester AND s.year = t.year				        WHERE s.semester = SEMESTER AND s.year = YEAR
		GROUP BY s.sec_id) t1;
   		RETURN min_insc;
	END;
	//
	DELIMITER ;


\! echo Defina un procedimiento que actualice el salario de cada instructor a 1000 veces el número de secciones de cursos que han enseñado.
delimiter $$
drop procedure if exists update_salary;
create procedure update_salary(IN id varchar(5),IN c decimal(8,2))
begin
	update instructor set salary=c*1000 where id=ID;
end;
$$
delimiter ;
delimiter $$

drop procedure if exists update_all;
create procedure update_all()
begin
declare id varchar(5);
declare	sectionQty varchar(8);
declare	declare cursorElement cursor for
		select id,count(course_id) from teaches group by id; 
declare done INT default false;
declare continue handler for not found set done = TRUE;

open cursorElement;

read_loop: LOOP
	fetch cursorElement into id, sectionQty;
        call update_salary(id,sectionQty);
	if done then
		leave read_loop;
	end if;
end loop;
close cursorElement;
end;
$$
delimiter ;

\! echo Defina un procedimiento que Inserte a cada instructor como alumno, con tot_creds = 0, en el mismo departamento
\! echo Ahora defina un procedimiento que elimine todos los "estudiantes" recién agregados en el ejercicio 8. Tener en cuenta que los estudiantes ya existentes que tenían tot_creds = 0 no deberían eliminarse.
\! echo Seguramente han notado que el valor tot_creds para los estudiantes no coincide con los créditos de los cursos que han tomado. Escriba y ejecute funciones/procedimientos para actualizar tot_creds en función de los créditos aprobados, para que la base de datos vuelva a ser consistente.

