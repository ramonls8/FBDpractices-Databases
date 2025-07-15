-------------------------------------------
--1.5
DROP TABLE prueba1;
CREATE TABLE prueba1(
    cad char(3),
    n int,
    x float
);
DROP TABLE prueba2;
CREATE TABLE prueba2(
    cad1 char(8),
    num int
);

-------------------------------------------
--Ejercicio 1.2
describe prueba1;
describe prueba2;

-------------------------------------------
--1.6.1
DROP TABLE plantilla;
CREATE TABLE plantilla(
    dni varchar2(9),
    nombre varchar2(15),
    estadocivil varchar2(10)
    CHECK (estadocivil IN ('soltero', 'casado', 'divorciado', 'viudo')),
    fechaalta date,
    PRIMARY KEY (dni)
);
DROP TABLE serjefe;
CREATE TABLE serjefe(
    dnijefe REFERENCES plantilla(dni),
    dnitrabajador REFERENCES plantilla(dni),
    PRIMARY KEY (dnitrabajador)
);

-------------------------------------------
--Ejercicio 1.5
drop table prueba1;

-------------------------------------------
--Ejercicio 1.6
ALTER TABLE plantilla ADD fechabaja date;
describe plantilla;

-------------------------------------------
--1.7
DROP TABLE proveedor;
CREATE TABLE proveedor(
    codpro VARCHAR2(3) CONSTRAINT codpro_clave_primaria PRIMARY KEY,
    nompro VARCHAR2(30) CONSTRAINT nompro_no_nulo NOT NULL,
    status NUMBER CONSTRAINT status_entre_1_y_10
    CHECK (status>=1 and status<=10),
    ciudad VARCHAR2(15)
);

DROP TABLE pieza;
CREATE TABLE pieza (
    codpie VARCHAR2(3) CONSTRAINT codpie_clave_primaria PRIMARY KEY,
    nompie VARCHAR2(10) CONSTRAINT nompie_no_nulo NOT NULL,
    color VARCHAR2(10),
    peso NUMBER(5,2)
    CONSTRAINT peso_entre_0_y_100 CHECK (peso>0 and peso<=100),
    ciudad VARCHAR2(15)
);

DROP TABLE proyecto;
CREATE TABLE proyecto(
    codpj VARCHAR2(3) CONSTRAINT codpj_clave_primaria PRIMARY KEY,
    nompj VARCHAR2(20) CONSTRAINT nompj_no_nulo NOT NULL,
    ciudad VARCHAR2(15)
);

DROP TABLE ventas;
CREATE TABLE ventas (
    codpro CONSTRAINT codpro_clave_externa_proveedor REFERENCES proveedor(codpro),
    codpie CONSTRAINT codpie_clave_externa_pieza REFERENCES pieza(codpie),
    codpj CONSTRAINT codpj_clave_externa_proyecto REFERENCES proyecto(codpj),
    cantidad NUMBER(4),
    CONSTRAINT clave_primaria PRIMARY KEY (codpro,codpie,codpj)
);

-------------------------------------------
--1.7.4 Comprobar tablas credas
select table_name from user_tables;


-------------------------------------------
--Ejercicio 1.7
ALTER TABLE ventas ADD fecha date;
describe ventas;


-------------------------------------------
--Ejercicio 1.8
DROP TABLE equipos;
CREATE TABLE equipos(
    codE VARCHAR(10) PRIMARY KEY,
    nombreE VARCHAR(30) NOT NULL UNIQUE,
    localidad VARCHAR(30) NOT NULL,
    entrenador VARCHAR(30) NOT NULL,
    fecha_crea DATE NOT NULL
);

DROP TABLE jugadores;
CREATE TABLE jugadores(
    codJ VARCHAR(10) PRIMARY KEY,
    codE VARCHAR(10) NOT NULL REFERENCES equipos(codE),
    nombreJ VARCHAR(30) NOT NULL
);

DROP TABLE encuentros;
CREATE TABLE encuentros(
    ELocal VARCHAR(10) REFERENCES equipos(codE),
    EVisitante VARCHAR(10) REFERENCES equipos(codE),
    fecha date,
    PLocal NUMERIC DEFAULT 0 CHECK (PLocal >= 0),
    PVisitante NUMERIC DEFAULT 0 CHECK (PVisitante >= 0),
    
    PRIMARY KEY(ELocal, EVisitante)
);

DROP TABLE faltas;
CREATE TABLE faltas(
    codJ VARCHAR(10) REFERENCES jugadores(codJ),
    ELocal VARCHAR(10),
    EVisitante VARCHAR(10),
    num NUMERIC DEFAULT 0 CHECK (0<=num and num<=5),
    
    PRIMARY KEY(codJ,ELocal,EVisitante),
    FOREIGN KEY(ELocal,EVisitante) REFERENCES encuentros(ELocal,EVisitante)
);