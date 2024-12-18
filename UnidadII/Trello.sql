---1. Mostrar todos los usuarios que no han creado ningún tablero, 
--para dichos usuarios mostrar el
---nombre completo y correo, utilizar producto cartesiano con el operador (+).
SELECT * FROM TBL_USUARIOS;
SELECT * FROM TBL_TABLERO;

SELECT NOMBRE, APELLIDO, NOMBRE_TABLERO
FROM TBL_USUARIOS A
LEFT JOIN TBL_TABLERO B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO_CREA)
WHERE B.CODIGO_USUARIO_CREA IS NULL;


SELECT  NOMBRE || ' ' || APELLIDO AS NOMBRE_COMPLETO, 
        CORREO
FROM    TBL_USUARIOS A,
        TBL_TABLERO B
WHERE A.CODIGO_USUARIO = B.CODIGO_USUARIO_CREA(+)
AND B.CODIGO_USUARIO_CREA IS NULL;



---2. Mostrar la cantidad de usuarios que se han registrado por cada red social, 
--mostrar inclusive la
---cantidad de usuarios que no están registrados con redes sociales.

SELECT  NVL(B.NOMBRE_RED_SOCIAL, 'SIN RED SOCIAL') NOMBRE_RED_SOCIAL, 
        COUNT(1) CANTIDAD_USUARIOS  
FROM TBL_USUARIOS A
LEFT JOIN TBL_REDES_SOCIALES B
ON (A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL)
GROUP BY NVL(B.NOMBRE_RED_SOCIAL, 'SIN RED SOCIAL');


---3. Consultar el usuario que ha hecho más comentarios sobre una tarjeta (
---El más prepotente), para
---este usuario mostrar el nombre completo, correo, cantidad de comentarios y 
---cantidad de
---tarjetas a las que ha comentado (pista: una posible solución para este 
---último campo es utilizar
---count(distinct campo))
WITH USUARIOS_COMENTARIOS AS (
    SELECT  B.NOMBRE, COUNT(1) CANTIDAD_COMENTARIOS, 
            COUNT(DISTINCT CODIGO_TARJETA) CANTIDAD_TARJETAS
    FROM TBL_COMENTARIOS A
    INNER JOIN TBL_USUARIOS B
    ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
    GROUP BY B.NOMBRE
)
SELECT *
FROM USUARIOS_COMENTARIOS
WHERE CANTIDAD_COMENTARIOS = (
    SELECT MAX (CANTIDAD_COMENTARIOS) 
    FROM USUARIOS_COMENTARIOS
);

---4. Mostrar TODOS los usuarios con plan FREE, 
--de dichos usuarios mostrar la siguiente información:
---• Nombre completo
---• Correo
---• Red social (En caso de estar registrado con una)
---• Cantidad de organizaciones que ha creado, mostrar 0 si no ha creado ninguna.

SELECT COUNT(*) FROM TBL_Usuarios
where codigo_plan = 1;

SELECT  NOMBRE || ' ' || APELLIDO AS NOMBRE,
        CORREO,
        NVL(B.NOMBRE_RED_SOCIAL, 'NINGUNA') AS RED_SOCIAL,
        COUNT(C.CODIGO_ORGANIZACION) AS CANTIDAD_ORGANIZACIONES
FROM TBL_USUARIOS A
LEFT JOIN TBL_REDES_SOCIALES B
ON (A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL)
LEFT JOIN TBL_ORGANIZACIONES C
ON (A.CODIGO_USUARIO = C.CODIGO_ADMINISTRADOR)
WHERE CODIGO_PLAN = 1
GROUP BY NOMBRE || ' ' || APELLIDO,
        CORREO,
        NVL(B.NOMBRE_RED_SOCIAL, 'NINGUNA');
        

        
SELECT  NOMBRE || ' ' || APELLIDO AS NOMBRE,
        CORREO,
        NVL(B.NOMBRE_RED_SOCIAL, 'NINGUNA') AS RED_SOCIAL,
        COUNT(C.CODIGO_ORGANIZACION) AS CANTIDAD_ORGANIZACIONES
FROM    TBL_USUARIOS A,
        TBL_REDES_SOCIALES B,
        TBL_ORGANIZACIONES C
WHERE A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL (+)
AND A.CODIGO_USUARIO = C.CODIGO_ADMINISTRADOR (+)
AND CODIGO_PLAN = 1
GROUP BY NOMBRE || ' ' || APELLIDO,
        CORREO,
        NVL(B.NOMBRE_RED_SOCIAL, 'NINGUNA');


SELECT * FROM TBL_PLANES;

UPDATE TBL_ORGANIZACIONES 
SET CODIGO_ADMINISTRADOR = 1
WHERE CODIGO_ORGANIZACION = 38;

COMMIT;


---5. Mostrar los usuarios que han creado más de 5 tarjetas, 
--para estos usuarios mostrar:
---Nombre completo, correo, cantidad de tarjetas creadas
SELECT NOMBRE || ' ' || APELLIDO AS NOMBRE,
    CORREO, 
    COUNT(1) AS CANTIDAD_TARJETAS
FROM TBL_USUARIOS A
INNER JOIN TBL_TARJETAS B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
GROUP BY NOMBRE || ' ' || APELLIDO,
    CORREO
HAVING COUNT(*) >= 5;
    
    
    
---6. Un usuario puede estar suscrito a tableros, listas y tarjetas, 
--de tal forma que si hay algún cambio
---se le notifica en su teléfono o por teléfono, sabiendo esto, se necesita 
--mostrar los nombres de
---todos los usuarios con la cantidad de suscripciones de cada tipo, en la 
--consulta se debe mostrar:
---• Nombre completo del usuario
---• Cantidad de tableros a los cuales está suscrito
---• Cantidad de listas a las cuales está suscrito
---• Cantidad de tarjetas a las cuales está suscrito

SELECT  B.CODIGO_USUARIO,
        B.NOMBRE || ' ' || B.APELLIDO AS NOMBRE,
        COUNT(CODIGO_LISTA) CANTIDAD_LISTAS,
        COUNT(CODIGO_TABLERO) CANTIDAD_TABLEROS,
        COUNT(CODIGO_TARJETA) CANTIDAD_TARJETAS
FROM TBL_SUSCRIPCIONES A
RIGHT JOIN TBL_USUARIOS B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
GROUP BY B.CODIGO_USUARIO, B.NOMBRE || ' ' || B.APELLIDO;

SELECT * FROM TBL_USUARIOS;
SELECT *
FROM TBL_SUSCRIPCIONES
WHERE CODIGO_USUARIO = 79;




---7. Consultar todas las organizaciones con los siguientes datos:
---• Nombre de la organización
---• Cantidad de usuarios registrados en cada organización
---• Cantidad de Tableros por cada organización
---• Cantidad de Listas asociadas a cada organización
---• Cantidad de Tarjetas asociadas a cada organización

SELECT * 
FROM tbl_tablero;

SELECT CODIGO_ORGANIZACION, COUNT(1) CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_TABLERO = C.CODIGO_TABLERO)
    GROUP BY CODIGO_ORGANIZACION;

WITH TABLEROS AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
    FROM TBL_TABLERO
    GROUP BY CODIGO_ORGANIZACION
),
USUARIOS_REGISTRADOS AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_USUARIOS
    FROM TBL_USUARIOS_X_ORGANIZACION
    GROUP BY CODIGO_ORGANIZACION
),
LISTAS AS (
    SELECT B.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_LISTAS
    FROM TBL_LISTAS A 
    INNER JOIN TBL_TABLERO B
    ON (A.CODIGO_TABLERO = B.CODIGO_TABLERO)
    GROUP BY B.CODIGO_ORGANIZACION
),
TARJETAS AS (
    SELECT CODIGO_ORGANIZACION, COUNT(1) CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_TABLERO = C.CODIGO_TABLERO)
    GROUP BY CODIGO_ORGANIZACION
)
SELECT  NOMBRE_ORGANIZACION, 
        NVL(B.CANTIDAD_USUARIOS, 0) CANTIDAD_USUARIOS,
        NVL(C.CANTIDAD_TABLEROS, 0) CANTIDAD_TABLEROS,
        NVL(D.CANTIDAD_LISTAS, 0) AS CANTIDAD_LISTAS,
        NVL(E.CANTIDAD_TARJETAS, 0) CANTIDAD_TARJETAS
FROM TBL_ORGANIZACIONES A 
LEFT JOIN USUARIOS_REGISTRADOS B
ON (A.CODIGO_ORGANIZACION = B.CODIGO_ORGANIZACION)
LEFT JOIN TABLEROS C
ON (A.CODIGO_ORGANIZACION = C.CODIGO_ORGANIZACION)
LEFT JOIN LISTAS D
ON (A.CODIGO_ORGANIZACION = D.CODIGO_ORGANIZACION)
LEFT JOIN TARJETAS E
ON (A.CODIGO_ORGANIZACION = E.CODIGO_ORGANIZACION);


SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
FROM TBL_TABLERO
GROUP BY CODIGO_ORGANIZACION;

SELECT B.CODIGO_ORGANIZACION, COUNT(*)
FROM TBL_LISTAS A 
INNER JOIN TBL_TABLERO B
ON (A.CODIGO_TABLERO = B.CODIGO_TABLERO)
GROUP BY B.CODIGO_ORGANIZACION;



--Organizacion 3	2
--Organizacion 4	2
--Organizacion 5	2
--Organizacion 49	2

SELECT * FROM --1 USUARIO REGISTRADO
TBL_USUARIOS_X_ORGANIZACION
WHERE CODIGO_ORGANIZACION = 22;

SELECT * FROM TBL_TABLERO -- 4 TABLEROS 
WHERE CODIGO_ORGANIZACION = 22;



SELECT CODIGO_ORGANIZACION, COUNT(*)
FROM TBL_USUARIOS_X_ORGANIZACION
GROUP BY CODIGO_ORGANIZACION;



--Crear una vista materializada con la información de facturación, 
--los campos a incluir son los
--siguientes:
--• Código factura
--• Nombre del plan a facturar
--• Nombre completo del usuario
--• Fecha de pago (Utilizar fecha inicio, mostrarla en formato Día-Mes-Año)
--• Año y Mes de pago (basado en la fecha inicio)
--• Monto de la factura
--• Descuento
--• Total neto

CREATE OR REPLACE VIEW VW_FACTURAS AS
SELECT  CODIGO_FACTURA, 
        NOMBRE_PLAN, 
        TO_CHAR(FECHA_INICIO, 'DD-MM-YYYY') FECHA,
        TO_CHAR(FECHA_INICIO, 'MON-YYYY') ANIO_MES,
        MONTO, 
        DESCUENTO, 
        MONTO - DESCUENTO AS TOTAL
FROM TBL_FACTURACION_PAGOS A 
INNER JOIN TBL_PLANES B
ON (A.CODIGO_PLAN = B.CODIGO_PLAN);

SELECT * FROM TBL_FACTURACION_PAGOS;



CREATE MATERIALIZED VIEW MVW_FACTURAS AS
SELECT  CODIGO_FACTURA, 
        NOMBRE_PLAN, 
        TO_CHAR(FECHA_INICIO, 'DD-MM-YYYY') FECHA,
        TO_CHAR(FECHA_INICIO, 'MON-YYYY') ANIO_MES,
        MONTO, 
        DESCUENTO, 
        MONTO - DESCUENTO AS TOTAL
FROM TBL_FACTURACION_PAGOS A 
INNER JOIN TBL_PLANES B
ON (A.CODIGO_PLAN = B.CODIGO_PLAN);


BEGIN
    DBMS_MVIEW.REFRESH ('MVW_FACTURAS');
END;



SELECT * 
FROM VW_FACTURAS;

SELECT * 
FROM MVW_FACTURAS
WHERE CODIGO_FACTURA = 194;


SELECT * FROM TBL_PLANES;


