-------------------------------------------
--Ejemplo 2.1
describe prueba2;
INSERT INTO prueba2 VALUES ('aa',1);
INSERT INTO prueba2 VALUES('Aa',2);
INSERT INTO prueba2 VALUES ('aa',1);
select * from prueba2;

--Ejemplo 2.2
INSERT INTO plantilla (dni,nombre,estadocivil,fechaalta) VALUES ('12345678','Pepe','soltero', SYSDATE);
INSERT INTO plantilla (dni,nombre,estadocivil,fechaalta) VALUES ('87654321','Juan', 'casado', SYSDATE);
INSERT INTO serjefe VALUES ('87654321','12345678');
INSERT INTO plantilla (dni, estadocivil) VALUES ('11223344','soltero');

select * from plantilla;
select * from serjefe;

--Ejercicio 2.1
select * from prueba2;
select * from plantilla;
select nombre from plantilla;

--Ejemplo 2.3
UPDATE plantilla SET estadocivil = 'divorciado' WHERE nombre = 'Juan';
select * from plantilla;
--Ejercicio 2.2
UPDATE plantilla SET nombre = 'Luis' WHERE dni = '12345678';
select * from plantilla;


--Ejemplo 2.4
DELETE FROM prueba2;
select * from prueba2;
--Ejercicio 2.3
DELETE FROM plantilla; --Da error por que hay dependencias
select * from plantilla;

--Ejemplo 2.5
UPDATE plantilla SET fechaalta = fechaalta+1 WHERE nombre = 'Juan';
select * from plantilla;

--Ejemplo 2.6
SELECT TO_CHAR(fechaalta,'dd-mm-yyyy') FROM plantilla;
--Ejemplo 2.7
SELECT fechaalta FROM plantilla;


--2.2
SELECT * from proveedor;
SELECT * from medina.ventas;

describe ventas;
describe medina.ventas;
INSERT INTO proveedor SELECT * FROM medina.proveedor;
INSERT INTO pieza SELECT * FROM medina.pieza;
INSERT INTO proyecto SELECT * FROM medina.proyecto;
INSERT INTO ventas SELECT * FROM medina.ventas;

COMMIT;



--Ejercicio 2.4
  --No se encuentran las claves ya que falta un espacio al final para que tengan
  --3 carácteres y coincidan. Además, ya existe esa clave principal
INSERT INTO ventas VALUES ('S3','P1','J1',150,'24/12/05');
select * from ventas;
INSERT INTO ventas VALUES ('S3 ','P1 ','J1 ',150,'24/12/05');
  --No hay codpie, parte de la CP
INSERT INTO ventas (codpro, codpj) VALUES ('S4 ', 'J2 ');
  --Día del mes es 00, no existe J6
INSERT INTO ventas VALUES('S5 ','P3 ','J6 ',400,TO_DATE('25/12/00'));
select * from proyecto;

--Ejercicio 2.5
select * from ventas;
UPDATE ventas SET fecha = TO_DATE(2005,'yyyy') WHERE codpro='S5 ';

--Ejercicio 2.6
SELECT codpro, codpie, TO_CHAR(fecha,'"Dia" day,dd/mm/yy') FROM ventas;







--Ejercicio adicional 2.7
INSERT INTO equipos (code,nombree,localidad,entrenador,fecha_crea) VALUES ('1','E1','Granada','José',SYSDATE);
INSERT INTO equipos (code,nombree,localidad,entrenador,fecha_crea) VALUES ('2','E2','Cádiz','Antonio',SYSDATE);
INSERT INTO equipos (code,nombree,localidad,entrenador,fecha_crea) VALUES ('3','E3','Cádiz','Enrique',SYSDATE);
SELECT * FROM equipos;
INSERT INTO jugadores (codj,code,nombrej) VALUES ('1','1','Manuel');
INSERT INTO jugadores (codj,code,nombrej) VALUES ('2','1','Pedro');
INSERT INTO jugadores (codj,code,nombrej) VALUES ('6','2','Juan');
INSERT INTO jugadores (codj,code,nombrej) VALUES ('7','2','Rodrigo');
INSERT INTO jugadores (codj,code,nombrej) VALUES ('11','3','Cristiano');
INSERT INTO jugadores (codj,code,nombrej) VALUES ('12','3','Mario');
SELECT * FROM jugadores;
INSERT INTO encuentros (elocal,evisitante,fecha,plocal,pvisitante) VALUES ('1','2',TO_DATE('01/01/24','dd/mm/yy'),1,2);
INSERT INTO encuentros (elocal,evisitante,fecha) VALUES ('2','1',TO_DATE('01/02/24','dd/mm/yy'));
INSERT INTO encuentros (elocal,evisitante,fecha,plocal,pvisitante) VALUES ('1','3',TO_DATE('01/02/24','dd/mm/yy'),3,2);
INSERT INTO encuentros (elocal,evisitante,fecha,plocal,pvisitante) VALUES ('2','3',TO_DATE('02/02/24','dd/mm/yy'),1,1);
INSERT INTO encuentros (elocal,evisitante,fecha,plocal,pvisitante) VALUES ('3','2',TO_DATE('02/04/24','dd/mm/yy'),1,0);
INSERT INTO encuentros (elocal,evisitante,fecha,plocal,pvisitante) VALUES ('3','1',TO_DATE('02/04/24','dd/mm/yy'),3,0);
SELECT * FROM encuentros;

INSERT INTO faltas (codj,elocal,evisitante,num) VALUES ('1','1','2','2');
INSERT INTO faltas (codj,elocal,evisitante,num) VALUES ('1','1','3','1');
INSERT INTO faltas (codj,elocal,evisitante,num) VALUES ('1','3','1','1');
INSERT INTO faltas (codj,elocal,evisitante,num) VALUES ('6','2','3','1');
SELECT * FROM faltas;

COMMIT;









--2.3 Dejar el entorno de la BD preparado
DROP TABLE faltas;
DROP TABLE prueba2;
DROP TABLE serjefe;
DROP TABLE plantilla;
DROP TABLE jugadores;
DROP TABLE encuentros;
DROP TABLE equipos;
SELECT table_name FROM user_tables;

ROLLBACK;
select * from ventas;
--No funciona bien rollback, restauramos la tabla copiandola de nuevo
DELETE FROM ventas;
INSERT INTO ventas SELECT * FROM medina.ventas;

COMMIT;