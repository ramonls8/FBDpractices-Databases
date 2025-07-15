-------------------------------------------
--Ejemplo 3.1
SELECT ciudad
FROM proyecto;
--Ejercicio 3.1
SELECT DISTINCT ciudad
FROM proyecto;

--Ejercicio 3.2
SELECT codpro,codpie,codpj
from ventas;

--Ejemplo 3.3
SELECT codpro
FROM ventas
WHERE codpj='J1';

--Ejercicio 3.3
SELECT *
FROM pieza
WHERE pieza.ciudad='Madrid' AND (pieza.color='Gris' OR pieza.color='Rojo');

--Ejercicio 3.4
SELECT *
FROM ventas
WHERE cantidad BETWEEN 200 AND 300;

--Ejercicio 3.5
SELECT nompie
FROM pieza
WHERE nompie LIKE '_ornillo';

--Ejemplo 3.5
SELECT cantidad/12, round(cantidad/12,3), trunc(cantidad/12,3),
    floor(cantidad/12), ceil(cantidad/12)
FROM ventas
WHERE (cantidad/12)>10;

--Ejemplo 3.6
SELECT codpro, nompro
FROM proveedor
WHERE status IS NOT NULL;

--Ejercicio 3.6
SELECT table_name
FROM all_tables
WHERE lower(table_name) LIKE '%ventas';

SELECT table_name
FROM all_tables
WHERE table_name LIKE upper('%ventas');

--Ejercicio 3.7
SELECT ciudad
FROM proveedor
WHERE status>2
INTERSECT
(SELECT ciudad FROM proveedor
MINUS
SELECT ciudad FROM pieza WHERE codpie='P1');

--Ejercicio 3.8
SELECT codpj
FROM ventas
MINUS
SELECT codpj
FROM ventas
WHERE codpro!='S1';

--Ejercicio 3.9
SELECT ciudad FROM pieza
UNION
SELECT ciudad FROM proveedor
UNION
SELECT ciudad FROM proyecto;

--Ejercicio 3.10
SELECT ciudad FROM pieza
UNION ALL
SELECT ciudad FROM proveedor
UNION ALL
SELECT ciudad FROM proyecto;

--Ejercicio 3.11
SELECT count(*)
FROM ventas, proveedor;

--Ejercicio 3.12
SELECT codpro, codpie, codpj
FROM ventas
INTERSECT
SELECT codpro, codpie, codpj
FROM proveedor, proyecto, pieza
WHERE proveedor.ciudad=proyecto.ciudad AND proyecto.ciudad=pieza.ciudad;

--Ejercicio 3.13
SELECT *
FROM proveedor A, proveedor B
WHERE A.ciudad != B.ciudad
MINUS
SELECT *
FROM proveedor A, proveedor B
WHERE A.ciudad < B.ciudad;

--Ejercicio 3.14
SELECT codpie, peso
FROM pieza
MINUS
SELECT A.codpie, A.peso
FROM pieza A, pieza B
WHERE A.peso < B.peso;

--Ejercicio 3.15
SELECT codpie, codpro, ciudad
FROM ventas NATURAL JOIN (SELECT * FROM proveedor WHERE ciudad = 'Madrid');

--Ejercicio 3.16 (Dos formas de hacerlo)
SELECT ciudad, codpie
FROM proveedor NATURAL JOIN ventas NATURAL JOIN proyecto;

SELECT proveedor.ciudad, codpie
FROM proveedor, ventas, proyecto
WHERE proveedor.codpro=ventas.codpro AND proyecto.codpj=ventas.codpj
    AND proveedor.ciudad=proyecto.ciudad;


--Ejercicio 3.17
SELECT nompro
FROM proveedor;

--Ejercicio 3.18
SELECT *
FROM ventas
ORDER BY cantidad, fecha DESC;

--Ejercicio 3.19
SELECT DISTINCT codpie
FROM ventas NATURAL JOIN (SELECT * FROM proveedor WHERE ciudad = 'Madrid');

SELECT DISTINCT codpie
FROM ventas
WHERE codpro IN (SELECT codpro FROM proveedor WHERE ciudad='Madrid');

--Ejercicio 3.20
SELECT codpj
FROM proyecto
WHERE ciudad IN (SELECT ciudad FROM pieza);

--Ejercicio 3.21
SELECT DISTINCT codpj
FROM proyecto
WHERE codpj NOT IN
    (SELECT codpj FROM ventas, pieza, proveedor
    WHERE ventas.codpro=proveedor.codpro AND pieza.codpie=ventas.codpie
    AND color='Rojo' AND proveedor.ciudad='Londres');

SELECT DISTINCT codpj
FROM proyecto
WHERE NOT EXISTS
    (SELECT * FROM ventas, pieza, proveedor
    WHERE ventas.codpro=proveedor.codpro AND pieza.codpie=ventas.codpie
    AND color='Rojo' AND proveedor.ciudad='Londres'
    AND ventas.codpj = proyecto.codpj);

--Ejemplo 3.15
SELECT codpro, nompro
FROM proveedor
WHERE EXISTS (SELECT * FROM ventas
    WHERE ventas.codpro=proveedor.codpro AND ventas.codpie='P1');


--Ejercicio 3.22
SELECT codpie, nompie, peso
FROM pieza
WHERE peso > ALL
    (SELECT peso FROM pieza WHERE nompie LIKE 'Tornillo%');

--Ejercicio 3.23
SELECT codpie, peso FROM pieza
MINUS
SELECT A.codpie, A.peso FROM pieza A, pieza B WHERE A.peso < B.peso;

SELECT codpie, nompie, peso
FROM pieza
WHERE peso >= ALL (SELECT peso FROM pieza);


--Ejercicio 3.24
    --División AR
(SELECT codpie FROM ventas)
MINUS
(SELECT codpie
    FROM (SELECT *
          FROM (SELECT codpie FROM ventas),
            (SELECT codpj FROM proyecto WHERE ciudad='Londres')
          MINUS
          SELECT codpie, codpj
          FROM ventas));

    --División NOT EXISTS
SELECT codpie
FROM pieza
WHERE NOT EXISTS (
    SELECT codpj FROM proyecto WHERE ciudad='Londres'
    MINUS
    SELECT codpj FROM ventas WHERE pieza.codpie=ventas.codpie);


--Ejercicio 3.25
SELECT codpro
FROM proveedor
WHERE NOT EXISTS (
    SELECT ciudad FROM proyecto
    MINUS
    SELECT ciudad FROM pieza NATURAL JOIN ventas WHERE proveedor.codpro=ventas.codpro);


--Ejercicio 3.26
SELECT count(*)
FROM ventas
WHERE cantidad > 1000;
--Ejercicio 3.27
SELECT MAX(peso)
FROM pieza;
--Ejercicio 3.28
SELECT codpie, peso
FROM pieza
WHERE peso=(SELECT MAX(peso) FROM pieza);
--Ejercicio 3.29 (No lo resuelve)
SELECT codpie, MAX(peso)
FROM pieza;
--Ejercicio 3.30
SELECT DISTINCT codpro
FROM proveedor
WHERE 3 < (SELECT COUNT(*)
       FROM ventas
       WHERE ventas.codpro = proveedor.codpro);

SELECT DISTINCT codpro
FROM ventas v1
WHERE 3<(SELECT COUNT(*) FROM ventas v2 WHERE v1.codpro=v2.codpro);


--Ejercicio 3.31
SELECT nompie, AVG(cantidad)
FROM ventas NATURAL JOIN pieza
GROUP BY codpie, nompie;

    --MAL, poco eficiente
SELECT codpie, (SELECT nompie FROM pieza WHERE pieza.codpie=ventas.codpie), AVG(cantidad)
FROM ventas
GROUP BY codpie;

--Ejercicio 3.32
SELECT codpro, AVG(cantidad)
FROM ventas
WHERE codpie='P1'
GROUP BY codpro;

--Ejercicio 3.33
SELECT codpj, codpie, SUM(cantidad)
FROM ventas
GROUP BY codpj, codpie;

--Ejercicio 3.34
SELECT v.codpro, v.codpj, j.nompj, AVG(v.cantidad)
FROM ventas v, proyecto j
WHERE v.codpj=j.codpj
GROUP BY v.codpj, j.nompj, v.codpro;

--Ejercicio 3.35
SELECT nompro, SUM(cantidad)
FROM ventas NATURAL JOIN proveedor
GROUP BY nompro
HAVING SUM(cantidad) > 1000;

--Ejercicio 3.36
SELECT codpie, SUM(cantidad)
FROM ventas
GROUP BY codpie
HAVING SUM (cantidad) = (SELECT MAX(SUM(v1.cantidad))   --IMPORTANTE: Solo(creo) se puede usar agrupación MAX(SUM(... en el SELECT
                        FROM ventas v1
                        GROUP BY codpie);

--Ejercicio 3.37
SELECT * FROM ventas
WHERE fecha BETWEEN TO_DATE('01/01/2002','DD/MM/YYYY') AND
                    TO_DATE('31/12/2004','DD/MM/YYYY');
    --Efectivamente no funciona bien


--Ejercicio 3.38
SELECT TO_CHAR(fecha,'YYYY'), TO_CHAR(fecha,'MM'), AVG(cantidad)
FROM ventas
GROUP BY TO_CHAR(fecha,'YYYY'), TO_CHAR(fecha,'MM')
ORDER BY TO_CHAR(fecha,'YYYY'), TO_CHAR(fecha,'MM');



--Ejemplo 3.29
SELECT * FROM ALL_USERS;

--Ejemplo 3.30
DESCRIBE DICTIONARY;
SELECT * FROM DICTIONARY WHERE table_name LIKE '%INDEX%';
--Ejercicio 3.39
SELECT * FROM user_indexes;
SELECT * FROM all_indexes;
--Ejercicio 3.40
SELECT table_name, owner, table_owner
FROM all_indexes
WHERE LOWER(table_name)='ventas';
--Ejercicio 3.41
SELECT * FROM DICTIONARY WHERE table_name LIKE '%OBJECT%';
SELECT * FROM all_objects;