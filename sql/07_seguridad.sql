-- --------------------------------------------------------------------
-- Archivo: 07_seguridad.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Implementa las tareas de la Etapa 4: Seguridad e Integridad.
--            1. Crea un usuario ('tpi_bd') con privilegios mínimos necesarios
--               para operar con empleados y legajos (SELECT, INSERT, UPDATE).
--            2. Otorga permisos específicos sobre tablas y vistas.
--            3. Crea un procedimiento almacenado ('sp_buscar_empleado')
--               seguro contra SQL Injection para buscar empleados por DNI.
--            4. Incluye (comentadas) las consultas de prueba para verificar
--               los permisos, la integridad y la protección anti-inyección.

-- Ejecución: Este script debe ejecutarse con un usuario con privilegios
--            administrativos (ej. 'root'). Las pruebas comentadas deben
--            ejecutarse por separado, conectándose como 'tpi_bd' o 'root'
--            según se indique.
-- --------------------------------------------------------------------

USE empleados;

-- -----------------------------------------
-- 1. CREACIÓN DE USUARIO Y ASIGNACIÓN DE PRIVILEGIOS MÍNIMOS
-- -----------------------------------------

-- Crear el usuario 'tpi_bd' si no existe. Solo puede conectarse desde localhost.
-- Contraseña '1234' solo para fines del TFI. ¡Usar una segura en producción!
CREATE USER IF NOT EXISTS 'tpi_bd'@'localhost' IDENTIFIED BY '1234';

-- Otorgar el permiso básico 'USAGE' sobre la base de datos 'empleados'.
-- Esto permite al usuario conectarse y ejecutar 'USE empleados;'.
GRANT USAGE ON empleados.* TO 'tpi_bd'@'localhost';

-- Otorgar permisos específicos sobre las tablas principales:
-- SELECT: Permite leer datos.
-- INSERT: Permite agregar nuevos registros.
-- UPDATE: Permite modificar registros existentes.
-- (Se omite DELETE siguiendo el principio de mínimos privilegios discutido).
GRANT SELECT, INSERT, UPDATE ON empleados.empleado TO 'tpi_bd'@'localhost';
GRANT SELECT, INSERT, UPDATE ON empleados.legajo TO 'tpi_bd'@'localhost';

-- Otorgar permiso de solo lectura (SELECT) sobre las vistas seguras
-- creadas en 06_vistas.sql.
GRANT SELECT ON empleados.vista_empleados_publica TO 'tpi_bd'@'localhost';
GRANT SELECT ON empleados.vista_legajos_activos TO 'tpi_bd'@'localhost';

-- Otorgar permiso para EJECUTAR el procedimiento almacenado que se creará más adelante.
-- Es importante dar este permiso explícitamente.
GRANT EXECUTE ON PROCEDURE empleados.sp_buscar_empleado TO 'tpi_bd'@'localhost';

-- Para verificar los permisos otorgados (ejecutar como root):
-- SHOW GRANTS FOR 'tpi_bd'@'localhost';


-- -----------------------------------------
-- 2. PROCEDIMIENTO ALMACENADO SEGURO (ANTI-SQL INJECTION)
-- -----------------------------------------

-- Eliminar el procedimiento si ya existe para permitir re-ejecución
DROP PROCEDURE IF EXISTS sp_buscar_empleado;

-- Crear el procedimiento almacenado 'sp_buscar_empleado'
-- (No se usa DELIMITER aquí asumiendo ejecución en cliente gráfico como DBeaver/Workbench)
CREATE PROCEDURE sp_buscar_empleado(
    IN dni_param VARCHAR(15) -- Parámetro de entrada para el DNI a buscar
)
COMMENT='Busca un empleado por DNI de forma segura (previene SQL Injection), excluyendo eliminados.'
BEGIN
   -- La consulta usa el parámetro 'dni_param' de forma segura. MySQL trata
   -- el valor de 'dni_param' siempre como datos, nunca como código SQL ejecutable.
   SELECT *
   FROM empleado
   WHERE dni = dni_param -- Compara la columna 'dni' con el valor del parámetro
   AND eliminado = FALSE; -- Excluye empleados marcados como eliminados lógicamente
END;
-- El punto y coma final es importante al ejecutar como bloque/script en DBeaver.


-- Otorgar permiso de ejecución nuevamente por si se recreó (no da error si ya existe)
GRANT EXECUTE ON PROCEDURE empleados.sp_buscar_empleado TO 'tpi_bd'@'localhost';


-- -----------------------------------------
-- 3. CONSULTAS DE PRUEBA (Comentadas para ejecución completa del script)
-- -----------------------------------------

-- == PRUEBAS DE ACCESO RESTRINGIDO (Ejecutar conectándose como 'tpi_bd') ==

-- Prueba 3.1 (Éxito - SELECT en tabla permitida): Debe funcionar.
-- USE empleados;
-- SELECT * FROM empleado LIMIT 10;

-- Prueba 3.2 (Fallo - DROP, permiso no otorgado): Debe fallar con Error 1142 (DROP command denied).
-- USE empleados;
-- DROP TABLE legajo;

-- Prueba 3.3 (Fallo - Acceso a DB no permitida): Debe fallar con Error 1142 (SELECT command denied).
-- SELECT * FROM mysql.user;

-- Prueba 3.4 (Éxito - SELECT en vista permitida): Debe funcionar.
-- USE empleados;
-- SELECT * FROM vista_empleados_publica LIMIT 5;


-- == PRUEBAS DE INTEGRIDAD (Ejecutar como 'tpi_bd' o 'root') ==
-- Diseñadas para FALLAR y demostrar que las restricciones funcionan.

-- Prueba 3.5: Violación de UNIQUE (Intentar insertar DNI duplicado)
-- (Reemplazar 'DNI_EXISTENTE' con un DNI real de la tabla 'empleado')
-- Debe fallar con ERROR 1062 (Duplicate entry):
-- INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area) VALUES ('Intento', 'Duplicado', 'DNI_EXISTENTE', 'duplicado@test.com', CURDATE(), 'Prueba');
-- SELECT 'Prueba 3.5 (UNIQUE): Si viste ERROR 1062, la prueba fue exitosa.' AS Resultado;


-- Prueba 3.6: Violación de FOREIGN KEY (Intentar insertar legajo para empleado_id inexistente)
-- Debe fallar con ERROR 1452 (Cannot add or update a child row...):
-- INSERT INTO legajo (nroLegajo, categoria, estado, fechaAlta, observaciones, empleado_id) VALUES ('LEG-INVALIDO', 'Prueba FK', 'ACTIVO', CURDATE(), 'Este empleado no existe', 999999);
-- SELECT 'Prueba 3.6 (FK): Si viste ERROR 1452, la prueba fue exitosa.' AS Resultado;


-- == PRUEBAS ANTI-INYECCIÓN (Ejecutar como 'tpi_bd' o 'root') ==

-- Prueba 3.7: Llamada normal al procedimiento (usar DNI existente)
-- (Reemplazar 'DNI_EXISTENTE' con un DNI real y no eliminado)
-- Debe devolver la fila del empleado correspondiente.
-- CALL sp_buscar_empleado('DNI_EXISTENTE');
-- SELECT 'Prueba 3.7 (Normal): Ver si devolvió la fila correcta.' AS Resultado;


-- Prueba 3.8: Intento de SQL Injection
-- Debe ejecutarse sin error, pero devolver un CONJUNTO VACÍO.
-- CALL sp_buscar_empleado("' OR '1'='1");
-- SELECT 'Prueba 3.8 (Inyección): Si el resultado anterior fue vacío, la protección funciona.' AS Resultado;

-- --------------------------------------------------------------------
-- Fin del script 07_seguridad.sql
-- --------------------------------------------------------------------

