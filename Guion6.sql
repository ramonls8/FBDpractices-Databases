-------------------------------------------
--Ejemplo 6.1
CREATE INDEX indice_proveedores ON proveedor(nompro);
--Ejemplo 6.2
SELECT * FROM user_indexes WHERE index_name = 'INDICE_PROVEEDORES';
--
DROP INDEX indice_proveedores;

--6.1.6 Clave invertida
CREATE INDEX indice_prov_rev ON proveedor(nompro, codpro) REVERSE;
SELECT * FROM user_indexes WHERE index_name = 'INDICE_PROV_REV';
DROP INDEX indice_prov_rev;




--BITMAT
CREATE TABLE Prueba_Bit (color Varchar2(10));
--Copiar en Oracle0 para ejecutar, aquí da errores
/*
BEGIN
    FOR i IN 1..50000 LOOP
        INSERT INTO Prueba_bit (
            SELECT decode(round(dbms_random.value(1,4)),1,'Rojo',2,'Verde',
            3,'Amarillo',4,'Azul') FROM dual);
    END LOOP;
END;
*/

CREATE INDEX Prueba_IDX ON Prueba_Bit(color);
SELECT count(*) FROM Prueba_Bit WHERE color='Amarillo' OR color='Azul';
--Tiempo: 0,014 seg
DROP INDEX Prueba_IDX;

CREATE BITMAP INDEX Prueba_BITMAT_IDX ON Prueba_Bit(color);
SELECT count(*) FROM Prueba_Bit WHERE color='Amarillo' OR color='Azul';
--Tiempo: 0,004 seg
DROP INDEX Prueba_BITMAT_IDX;

DROP TABLE Prueba_Bit;





--Tablas organizadas por Índice (IOT)
CREATE TABLE Prueba_IOT (id NUMBER PRIMARY KEY) ORGANIZATION INDEX;
SELECT id FROM Prueba_IOT;
DROP TABLE Prueba_IOT;



--6.2.2 Cluster indizado
CREATE CLUSTER cluster_codpro(codpro VARCHAR2(3));

CREATE TABLE proveedor2(
    codpro VARCHAR2(3) PRIMARY KEY,
    nompro VARCHAR2(30) NOT NULL,
    status NUMBER(2) CHECK(status>=1 AND status<=10),
    ciudad VARCHAR2(15))
CLUSTER cluster_codpro(codpro);

CREATE TABLE ventas2(
    codpro VARCHAR2(3) REFERENCES proveedor2(codpro),
    codpie REFERENCES pieza(codpie),
    codpj REFERENCES proyecto(codpj),
    cantidad NUMBER(4),
    fecha DATE,
    PRIMARY KEY (codpro,codpie,codpj))
CLUSTER cluster_codpro(codpro);

CREATE INDEX indice_cluster ON CLUSTER cluster_codpro;

--Ejercicio 6.1
INSERT INTO proveedor2 (SELECT * FROM proveedor);
INSERT INTO ventas2 (SELECT * FROM ventas);

--Ejercicio 6.2
SELECT * FROM proveedor2 NATURAL JOIN ventas2;

--Ejercicio 6.3
SELECT * FROM user_tables WHERE cluster_name = 'CLUSTER_CODPRO';

SELECT * FROM user_objects WHERE object_name = 'CLUSTER_CODPRO';




--Cluster Hash
--Ejemplo 6.5
CREATE CLUSTER cluster_codpro_hash(codpro VARCHAR2(3)) SIZE 610 HASHKEYS 50;

--Ejemplo 6.6
CREATE CLUSTER cluster_codpro_single_hash(codpro VARCHAR2(3))
SIZE 50 SINGLE TABLE HASHKEYS 100;

CREATE TABLE proveedor_hash(
    codpro VARCHAR2(3) PRIMARY KEY,
    nompro VARCHAR2(30) NOT NULL,
    status NUMBER(2) CHECK(status>=1 AND status<=10),
    ciudad VARCHAR2(15))
CLUSTER cluster_codpro_single_hash(codpro);

--6.2.7 Eliminación cluster
DROP CLUSTER cluster_codpro_single_hash INCLUDING TABLES CASCADE CONSTRAINTS;
DROP CLUSTER cluster_codpro_hash INCLUDING TABLES CASCADE CONSTRAINTS;
DROP CLUSTER cluster_codpro INCLUDING TABLES CASCADE CONSTRAINTS;

