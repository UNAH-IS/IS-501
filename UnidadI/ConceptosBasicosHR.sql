--Human Resources

SELECT * FROM EMPLOYEES;









--habilitar la terminal de oracle
set serveroutput on;

--PL/SQL no es case sensitive

---Tipos de bloques
--Bloques anonimos
--Procedimientos y funciones almacenadas
--Triggers
SET SERVEROUTPUT ON;

--Bloques anónimos
declare
    --declarar variables
    v_nombre EMPLOYEES.FIRST_NAME%TYPE;
    V_APELLIDO EMPLOYEES.LAST_NAME%TYPE;
    v_edad number := 25;
    V_SALARY EMPLOYEES.SALARY%TYPE;
begin
    ---NO PUEDE RETORNAR MAS DE UN REGISTRO, DE LO CONTRARIO SE DEBE USAR CURSORES
    -- EL RESULTADO SE DEBE ALMACENAR EN VARIABLES USANDO INTO
    -- SI LA CONSULTA NO RETORNA REGISTROS FALLA Y RETORNA UN ORA-01403: no data found
    SELECT FIRST_NAME, LAST_NAME, SALARY
    INTO V_NOMBRE, V_APELLIDO, V_SALARY
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 998989889;
    
    --v_nombre := 'Juan'; -- asignar
    dbms_output.put_line('HOLA ' || v_nombre || ' ' || V_APELLIDO || ' (' || V_SALARY || ')'); --doble pipe para concatenar
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- QUE HAGA ALGO CUANDO FALLE POR XXXXXX
        DBMS_OUTPUT.PUT_LINE('NO ENCONTRÓ INFORMACION');
        DBMS_OUTPUT.PUT_LINE('ERROR' || );
end;

select * from tabla
where campo = 1;

--comentario de una linea
    /*
        Comentarios
        de varias
        lineas
    */
    --null;