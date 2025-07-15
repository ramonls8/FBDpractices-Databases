-------------------------------------------
--5.1.1
SELECT table_name, tablespace_name, num_rows, avg_space
FROM user_tables;
--Ejercicio 5.1
DESCRIBE user_tables;




--Ejercicio 5.2
CREATE TABLE acceso (testigo NUMBER);
INSERT INTO acceso VALUES(1);
INSERT INTO acceso VALUES(2);

GRANT SELECT ON acceso TO usuario_derecha;
REVOKE SELECT ON acceso FROM usuario_derecha;
GRANT SELECT ON acceso TO usuario_derecha WITH GRANT OPTION;
GRANT SELECT ON usuario_izquierda.acceso TO usuario_derecha;

SELECT * FROM usuario_izquierda.acceso;
SELECT * FROM usuario_izquierda_izquierda.acceso;

REVOKE SELECT ON acceso FROM usuario_derecha;
SELECT * FROM usuario_iquierda.acceso;
SELECT * FROM usuario_izquierda_izquierda.acceso;
