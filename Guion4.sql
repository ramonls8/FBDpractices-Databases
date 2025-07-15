-------------------------------------------
--Ver vistas creadas
SELECT * FROM all_views WHERE owner='X0889466';

--Ejemplo 4.1
CREATE OR REPLACE VIEW VentasParis (codpro,codpie,codpj,cantidad,fecha) AS
    SELECT codpro,codpie,codpj,cantidad,fecha
    FROM ventas
    WHERE (codpro,codpie,codpj) IN
        (SELECT codpro,codpie,codpj
        FROM proveedor,pieza,proyecto
        WHERE proveedor.ciudad='Paris' AND
            pieza.ciudad='Paris' AND
            proyecto.ciudad='Paris');




--Ejercicio 4.1
CREATE OR REPLACE VIEW ProveedoresLondres (codpro, nompro, status, ciudad) AS
    SELECT codpro, nompro, status, ciudad
    FROM proveedor
    WHERE proveedor.ciudad='Londres';

INSERT INTO ProveedoresLondres (codpro, nompro, status, ciudad)
    VALUES ('S8','Jose Suarez',3,'Granada');

SELECT * FROM proveedoresLondres;
SELECT * FROM proveedor;
        --El valor se inserta en la tabla original, no en la vista

CREATE OR REPLACE VIEW ProveedoresLondres (codpro, nompro, status, ciudad) AS
    SELECT codpro, nompro, status, ciudad
    FROM proveedor
    WHERE proveedor.ciudad='Londres'
WITH CHECK OPTION;

INSERT INTO ProveedoresLondres (codpro, nompro, status, ciudad)
    VALUES ('S8','Jose Suarez',3,'Granada');
        --With check option no permite insertar tuplas que no cumplan la
        --condición de la vista




--Ejercicoi 4.2
CREATE OR REPLACE VIEW ProveedorCiudad (codpro, ciudad) AS
    SELECT codpro, ciudad
    FROM proveedor;

INSERT INTO proveedorciudad(codpro, ciudad) VALUES ('S9', 'Huelva');
DESCRIBE proveedor;
        --Nompro debe ser not null, así que no podemos insertar una tupla
        --sin especificar nompro


--Ejercicio 4.3
CREATE OR REPLACE VIEW ProvProyConPiezaGris (codpro, nompro, codpj) AS
    SELECT codpro, nompro, codpj
    FROM proveedor NATURAL JOIN ventas
    WHERE codpie IN
        (SELECT codpie
        FROM pieza
        WHERE color='Gris');

SELECT * FROM provproyconpiezagris;
INSERT INTO provproyconpiezagris (codpro, nompro, codpj) VALUES ('S0','Pepe','J0');
        --No se puede insertar porque la vista se ha construido a partir de
        --varias tablas y faltan atributos de la clave primaria de ventas,
        --además de que estos deben ser no nulos