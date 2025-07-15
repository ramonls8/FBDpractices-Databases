SELECT p1.codpie
FROM pieza p1, pieza p2
WHERE p2.codpie='P3' AND p1.peso > p2.peso;

SELECT p1.codpie
FROM pieza p1
WHERE p1.peso > ANY(SELECT peso FROM pieza WHERE ciudad LIKE 'L%');


SELECT *
FROM proveedor
WHERE NOT EXISTS (SELECT * FROM ventas WHERE ventas.codpro=proveedor.codpro AND cantidad > 1500);

SELECT codpro
FROM ventas NATURAL JOIN proveedor;

SELECT COUNT(cantidad)
FROM ventas;

--No permite buscar proveedor si el mínimo no es de grupos y es solo uno
SELECT codpro, min(cantidad)
FROM ventas;

SELECT codpro
FROM ventas
WHERE cantidad=(SELECT min(cantidad) FROM ventas);

SELECT codpro, nompro, min(cantidad)
FROM ventas NATURAL JOIN proveedor
GROUP BY codpro, nompro;

--Se calcula el mín una vez se han filtrado por cantidad>200
SELECT codpro, min(cantidad)
FROM ventas
WHERE cantidad>200
GROUP BY codpro, codpie;

SELECT codpro, min(cantidad)
FROM ventas
WHERE cantidad>200
GROUP BY codpro, codpie
HAVING min(cantidad)>1000;


SELECT codpro, min(cantidad)
FROM ventas
GROUP BY codpro, codpie
HAVING max(cantidad)>500;

SELECT max(min(cantidad))
FROM ventas
GROUP BY codpro;