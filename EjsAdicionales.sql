-------------------------------------------
SELECT * FROM proveedor;
SELECT * FROM pieza;
SELECT * FROM proyecto;
SELECT * FROM ventas;

--1 a
SELECT codpro
FROM ventas
WHERE codpie='P1' and TO_CHAR(fecha, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
GROUP BY codpro
HAVING SUM(cantidad) =
    ( SELECT MAX(SUM(cantidad))
    FROM ventas
    WHERE codpie='P1' and TO_CHAR(fecha, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
    GROUP BY codpro);


--1 b
SELECT codpie, COUNT(DISTINCT codpro)
FROM pieza NATURAL JOIN ventas
WHERE color='Blanco'
GROUP BY codpie
HAVING COUNT(DISTINCT codpro) >= 3;

--1 c
SELECT codpj
FROM proyecto NATURAL JOIN ventas
WHERE TO_CHAR(fecha, 'YYYY') = '2000'
GROUP BY codpj
HAVING AVG(cantidad) > 150;

--1 d
SELECT codpro
FROM ventas NATURAL JOIN proyecto
WHERE ciudad='Londres' AND TO_CHAR(fecha, 'MM/YYYY') = '01/2000'
GROUP BY codpro
HAVING COUNT(*) =
    (SELECT MAX(COUNT(*))
    FROM ventas NATURAL JOIN proyecto
    WHERE ciudad='Londres' AND TO_CHAR(fecha, 'MM/YYYY') = '01/2000'
    GROUP BY codpro);

--1 e
SELECT codpro
FROM proveedor
WHERE NOT EXISTS(
    SELECT codpj
    FROM proyecto
    MINUS
    SELECT codpj
    FROM ventas
    WHERE ventas.codpro = proveedor.codpro
    GROUP BY codpj
    HAVING COUNT(DISTINCT codpie) < 3);


--1 f
SELECT codpie
FROM ventas
WHERE TO_CHAR(fecha, 'yyyy')='2010'
MINUS
SELECT v1.codpie
FROM ventas v1, ventas v2
WHERE TO_CHAR(v1.fecha, 'yyyy')='2010' AND TO_CHAR(v2.fecha, 'yyyy')='2010'
      AND v1.codpie=v2.codpie AND (v1.codpj!=v2.codpj OR v1.codpro!=v2.codpro);
      
SELECT codpie
FROM ventas
WHERE TO_CHAR(fecha, 'yyyy')='2010'
GROUP BY codpie
HAVING count(*) = 1;


--1 g
SELECT codpie
FROM ventas
WHERE TO_CHAR(fecha, 'mm/yyyy') = '03/2010'
MINUS
SELECT codpie
FROM ventas
WHERE TO_CHAR(fecha, 'mm/yyyy') > '03/2010';



--1 h
SELECT codpj
FROM ventas NATURAL JOIN proveedor
WHERE ciudad = 'Londres'
GROUP BY codpj
HAVING count(DISTINCT codpie) = 3;


--1 i
SELECT codpj
FROM ventas
GROUP BY codpj
HAVING count(distinct codpro)=1 AND count(*)>1;

    --Otra forma: Con varios suministros - Con varios proveedores
SELECT v1.codpj
FROM ventas v1, ventas v2
WHERE v1.codpj=v2.codpj AND v1.codpro=v2.codpro AND v1.codpie!=v2.codpie
MINUS
SELECT v1.codpj
FROM ventas v1, ventas v2
WHERE v1.codpj=v2.codpj AND v1.codpro!=v2.codpro;

--1 j
            select * from ventas where codpie ='P2'; --P2 es la única roja
SELECT codpie
FROM pieza
WHERE color='Rojo'
MINUS 
SELECT codpie
FROM ventas v1
WHERE NOT EXISTS
    (SELECT codpie
     FROM ventas v2
     WHERE v1.codpie=v2.codpie AND (v1.codpro != v2.codpro OR v1.codpj != v2.codpj)
           AND TO_CHAR(v1.fecha,'yyyy') = TO_CHAR(v2.fecha,'yyyy'));


SELECT codpie
FROM pieza
WHERE color='Rojo'
MINUS
SELECT codpie
FROM ventas NATURAL JOIN pieza
WHERE color='Rojo'
GROUP BY codpie, TO_CHAR(ventas.fecha,'yyyy')
HAVING COUNT(*) >= 2;

