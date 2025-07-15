-------------------------------------------
--Ejercicio 3.42
SELECT codpro, SUM(cantidad)
FROM ventas
GROUP BY codpro
HAVING SUM(cantidad) >
    (SELECT SUM(v1.cantidad) FROM ventas v1 WHERE v1.codpro='S1');

--Ejercicio 3.43
SELECT codpro, SUM(cantidad)
FROM ventas
GROUP BY codpro
MINUS
SELECT v1.codpro, s1
FROM (SELECT codpro, SUM(cantidad) s1 FROM ventas GROUP BY codpro) v1,
     (SELECT codpro, SUM(cantidad) s2 FROM ventas GROUP BY codpro) v2
WHERE s1 < s2 AND v1.codpro != v2.codpro;

    --Otra forma, se muestran todos, pero en orden
SELECT codpro, SUM(cantidad)
FROM ventas
GROUP BY codpro
ORDER BY SUM(cantidad) DESC;


--Ejercicio 3.44
SELECT DISTINCT codpro
FROM ventas
WHERE NOT EXISTS
    (SELECT ciudad
    FROM proyecto p1, ventas v1
    WHERE p1.codpj=v1.codpj AND v1.codpro='S3'
    MINUS
    SELECT ciudad
    FROM proyecto p1, ventas v1   --Venden piezas a la ciudad de la tabla proyecto
    WHERE p1.codpj=v1.codpj AND v1.codpro=ventas.codpro)
AND codpro!='S3';


SELECT DISTINCT codpro
FROM ventas
WHERE NOT EXISTS
    (SELECT ciudad
    FROM proyecto p1, ventas v1
    WHERE p1.codpj=v1.codpj AND v1.codpro='S3'
    MINUS
    SELECT ciudad
    FROM pieza p1, ventas v1    --Venden piezas a la ciudad de la tabla pieza
    WHERE p1.codpie=v1.codpie AND v1.codpro=ventas.codpro)
AND codpro!='S3';


--Ejercicio 3.45
SELECT codpro, COUNT(*)
FROM ventas
GROUP BY codpro
HAVING COUNT(*) >= 10;

--Ejercicio 3.46
SELECT DISTINCT codpro
FROM ventas
WHERE NOT EXISTS
    (SELECT codpie
    FROM ventas v1
    WHERE v1.codpro='S1'
    MINUS
    SELECT codpie
    FROM ventas v1
    WHERE v1.codpro = ventas.codpro);

--Ejercicio 3.47
SELECT codpro, SUM(cantidad)
FROM ventas
WHERE NOT EXISTS
    (SELECT codpie
    FROM ventas v1
    WHERE v1.codpro='S1'
    MINUS
    SELECT codpie
    FROM ventas v1
    WHERE v1.codpro = ventas.codpro)
GROUP BY codpro;

--Ejercicio 3.48
SELECT DISTINCT codpj
FROM proyecto
WHERE NOT EXISTS
    (SELECT codpro
    FROM ventas
    WHERE codpie='P3'
    MINUS
    SELECT codpro
    FROM ventas
    WHERE ventas.codpj=proyecto.codpj);

--Ejercicio 3.49
SELECT codpro, AVG(cantidad)
FROM ventas
WHERE codpro IN (SELECT codpro FROM ventas v1 WHERE v1.codpie='P3')
GROUP BY codpro;

--Ejercicio 3.50
SELECT index_name, table_name, table_owner FROM user_indexes;
--Ejercicio 3.51

--Ejercicio 3.52
SELECT codpro, TO_CHAR(fecha,'yyyy'), ROUND(AVG(cantidad),3)
FROM ventas
GROUP BY codpro, TO_CHAR(fecha,'yyyy')
ORDER BY codpro, TO_CHAR(fecha,'yyyy');



--Ejercicio 3.53
SELECT DISTINCT codpro
FROM ventas NATURAL JOIN pieza
WHERE color LIKE '%ojo';

--Ejercicio 3.54
SELECT DISTINCT codpro
FROM proveedor
WHERE NOT EXISTS
    (SELECT codpie
    FROM pieza
    WHERE color LIKE '%ojo'
    MINUS
    SELECT codpie
    FROM ventas
    WHERE ventas.codpro=proveedor.codpro);

--Ejercicio 3.55
SELECT DISTINCT codpro
FROM ventas
WHERE NOT EXISTS
    (SELECT *
    FROM ventas v1 NATURAL JOIN pieza
    WHERE LOWER(color)!='rojo' AND ventas.codpro=v1.codpro);

--Ejercicio 3.56
SELECT DISTINCT v1.codpro
FROM ventas v1, ventas v2
WHERE v1.codpro=v2.codpro
    AND (v1.codpie!=v2.codpie OR v1.codpj!=v2.codpj) --Clave principal distinta
    AND v1.codpie IN (SELECT codpie FROM pieza WHERE color='Rojo') --Las 2 piezas son rojas
    AND v2.codpie IN (SELECT codpie FROM pieza WHERE color='Rojo');

--Ejercicio 3.57
    --Proveedores que venden todas las piezas rojas
SELECT DISTINCT codpro
FROM proveedor
WHERE NOT EXISTS
    (SELECT codpie
    FROM pieza
    WHERE color LIKE '%ojo'
    MINUS
    SELECT codpie
    FROM ventas
    WHERE ventas.codpro=proveedor.codpro)
MINUS
    --Proveedores con alguna de sus ventas no de más de 10 unidades
SELECT codpro
FROM ventas
WHERE cantidad <= 10;


--Ejercicio 3.58
    --Se actualiza el estado de S6 Y S7
UPDATE proveedor
SET status = 1
WHERE codpro IN
    (SELECT codpro
    FROM ventas
    MINUS
    SELECT codpro
    FROM ventas
    WHERE codpie != 'P1');
    --Volvemos a los valores anteriores
ROLLBACK;





--Ejercicio 3.59
SELECT ciudad
FROM pieza
WHERE codpie IN
    --Cantidad por piezas vendidas en 08/2009
    (SELECT codpie
    FROM ventas
    WHERE codpie IN
        --Piezas no vendidas en 09/2009
        (SELECT codpie FROM pieza
        MINUS
        SELECT codpie FROM ventas WHERE fecha = TO_DATE('09/2009', 'mm/yyyy'))
    GROUP BY codpie, TO_CHAR(fecha, 'mm/yyyy')
    HAVING '08/2009' = TO_CHAR(fecha, 'mm/yyyy')
        AND SUM(cantidad) = (--Cantidad por piezas vendidas en 08/2009
                            SELECT MAX(SUM(cantidad))
                            FROM ventas
                            WHERE codpie IN
                                --Piezas no vendidas en 09/2009
                                (SELECT codpie FROM pieza
                                MINUS
                                SELECT codpie FROM ventas WHERE fecha = TO_DATE('09/2009', 'mm/yyyy'))
                            GROUP BY codpie, TO_CHAR(fecha, 'mm/yyyy')
                            HAVING '08/2009' = TO_CHAR(fecha, 'mm/yyyy'))
    );




--Ejercicio 3.60
DESCRIBE encuentros;
SELECT * FROM encuentros;

--Ejercicio 3.61
SELECT nombreE FROM equipos ORDER BY nombreE;
SELECT nombreJ FROM jugadores ORDER BY nombreJ;

--Ejercicio 3.62
SELECT codj
FROM jugadores
MINUS
SELECT codj
FROM faltas;

--Ejercicio 3.63
SELECT *
FROM jugadores
WHERE codE = (SELECT codE FROM jugadores WHERE codJ='1')
    AND codJ!='1';

--Ejercicio 3.64
SELECT codJ, nombreJ, localidad
FROM jugadores NATURAL JOIN equipos;

--Ejercicio 3.65
SELECT *
FROM (SELECT codE FROM equipos), (SELECT codE FROM equipos);

--Ejercicio 3.66
SELECT DISTINCT elocal
FROM encuentros
WHERE plocal > pvisitante;

--Ejercicio 3.67
SELECT elocal FROM encuentros WHERE plocal > pvisitante
UNION
SELECT evisitante FROM encuentros WHERE pvisitante > plocal;

--Ejercicio 3.68
SELECT elocal FROM encuentros WHERE plocal > pvisitante
MINUS
SELECT evisitante FROM encuentros WHERE pvisitante > plocal;

--Ejercicio 3.69
SELECT codE FROM equipos
MINUS
SELECT elocal FROM encuentros WHERE plocal <= pvisitante;

--Ejercicio 3.70
SELECT *
FROM (SELECT codE FROM equipos), (SELECT codE FROM equipos)
MINUS
SELECT elocal, evisitante
FROM encuentros;

--Ejercicio 3.71
SELECT *
FROM encuentros
WHERE (SELECT localidad FROM equipos WHERE equipos.code=encuentros.elocal) = 
      (SELECT localidad FROM equipos WHERE equipos.code=encuentros.evisitante);

SELECT elocal, evisitante, fecha, plocal, pvisitante
FROM encuentros, equipos L, equipos V
WHERE L.code = encuentros.elocal AND V.code = encuentros.evisitante
    AND L.localidad = V.localidad;





--Ejercicio 3.72
SELECT elocal, COUNT(elocal)
FROM encuentros
GROUP BY elocal;

--Ejercicio 3.73
SELECT elocal, evisitante, ABS(plocal-pvisitante)
FROM encuentros
MINUS
SELECT e1.elocal, e1.evisitante, ABS(e1.plocal-e1.pvisitante)
FROM encuentros e1, encuentros e2
WHERE ABS(e1.plocal-e1.pvisitante) < ABS(e2.plocal-e2.pvisitante);

--Ejercicio 3.74
SELECT codj, SUM(num)
FROM faltas
GROUP BY codj
HAVING SUM(num) <= 3;

--Ejercicio 3.75
SELECT evisitante FROM
    (SELECT elocal, evisitante
    FROM encuentros
    MINUS
    SELECT e1.elocal, e1.evisitante
    FROM encuentros e1, encuentros e2
    WHERE e1.pvisitante < e2.pvisitante);

SELECT evisitante
FROM encuentros
WHERE pvisitante =
    (SELECT MAX(pvisitante)
    FROM encuentros);

--Ejercicio 3.76
SELECT code, (SELECT COUNT(*)
              FROM encuentros
              WHERE (encuentros.elocal=equipos.code AND plocal>pvisitante)
              OR (encuentros.evisitante=equipos.code AND plocal<pvisitante)) as numVic
FROM equipos
GROUP BY code;



--Ejercicio 3.77
SELECT * FROM
    (SELECT code, (SELECT COUNT(*)
                  FROM encuentros
                  WHERE (encuentros.elocal=equipos.code AND plocal>pvisitante)
                  OR (encuentros.evisitante=equipos.code AND plocal<pvisitante)) as numVic
    FROM equipos
    GROUP BY code)
WHERE numvic = (SELECT MAX(numVic)
                FROM 
                (SELECT code, (SELECT COUNT(*)
                              FROM encuentros en
                              WHERE (en.elocal=eq.code AND en.plocal>en.pvisitante)
                              OR (en.evisitante=eq.code AND en.plocal<en.pvisitante)) as numVic
                FROM equipos eq
                GROUP BY code));

--Ejercicio 3.78
SELECT elocal, AVG(plocal)
FROM encuentros
GROUP BY elocal;

--Ejercicio 3.79
SELECT equipo, SUM(puntos) FROM (
    SELECT elocal as equipo, SUM(plocal) as puntos
    FROM encuentros
    GROUP BY elocal
    UNION
    SELECT evisitante as equipo, SUM(pvisitante) as puntos
    FROM encuentros
    GROUP BY evisitante)
GROUP BY equipo
HAVING SUM(puntos) = (SELECT MAX(sumPuntos) FROM
            (SELECT equipo, SUM(puntos) as sumPuntos FROM (
                SELECT elocal as equipo, SUM(plocal) as puntos
                FROM encuentros
                GROUP BY elocal
                UNION
                SELECT evisitante as equipo, SUM(pvisitante) as puntos
                FROM encuentros
                GROUP BY evisitante)
            GROUP BY equipo));

