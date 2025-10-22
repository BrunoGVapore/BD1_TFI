-- --------------------------------------------------------------------
-- Archivo: 07_seguridad.sql
-- TFI - Bases de Datos I

-- Propósito: Este script, perteneciente a la Etapa 4, configura la seguridad de la base de datos empleados,
--            creando usuarios, asignando permisos, generando vistas para
--            consultas simplificadas que ocultan datos sensibles y
--            estableciendo procedimientos almacenados para consultas seguras.
-- --------------------------------------------------------------------


-- Creación de usuario

CREATE USER 'tpi_bd'@'localhost' IDENTIFIED BY '1234';

-- Otorgando privilegios

GRANT SELECT, INSERT, UPDATE ON empleados.empleado TO 'tpi_bd'@'localhost';
GRANT SELECT, INSERT, UPDATE ON empleados.legajo TO 'tpi_bd'@'localhost';

-- Paso previo: Ingresar con el usuario creado, no con `root`

-- Prueba 1 (Debe funcionar): Intenta leer datos de empleado.

SELECT * FROM empleado LIMIT 10; -- Debería devolver datos.

-- Prueba 2 (Debe fallar): Intenta borrar (hacer DROP) la tabla legajo.

DROP TABLE legajo;

-- Debería fallar con un error como "DROP command denied to user 'tpi_bd'@'localhost' for table 'legajo'"

-- VISTAS 

-- VISTA 1: vista_empleados_publica ya creada en la etapa 3, solo le agregamos esta vez `eliminado = FALSE`

CREATE OR REPLACE VIEW vista_empleados_publica AS
SELECT 
    e.nombre,
    e.apellido,
    e.area,
    l.categoria,
    l.estado
FROM 
    empleado AS e
JOIN 
    legajo AS l ON e.id = l.empleado_id
WHERE 
    e.eliminado = FALSE 
    AND l.eliminado = FALSE;

-- VISTA 2: Vista gerencial de legajos denominada `vista_legajos_activos` 
-- (oculta "observaciones", que las entenderíamos como confidenciales)

CREATE OR REPLACE VIEW vista_legajos_activos AS
SELECT
    e.nombre,
    e.apellido,
    l.nroLegajo,
    l.categoria,
    l.estado,
    l.fechaAlta
FROM
    legajo AS l
JOIN
    empleado AS e ON l.empleado_id = e.id
WHERE
    l.estado = 'ACTIVO' 
    AND l.eliminado = FALSE
    AND e.eliminado = FALSE;


-- Permisos para que el usuario creado pueda acceder a las vistas creadas

GRANT SELECT ON empleados.vista_empleados_publica TO 'tpi_bd'@'localhost';
GRANT SELECT ON empleados.vista_legajos_activos TO 'tpi_bd'@'localhost';


-- Pruebas de Integridad

-- Prueba Nº1: UNIQUE

-- El valor en `dni` debe preexistir en la base de datos / tabla, sino debe ser insertado. 

INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area) 
VALUES 
('Juan', 'Rodríguez', '250265541', 'juan.rodriguez@dominio.com', '2024-05-10', 'Recursos Humanos');

INSERT INTO legajo (nroLegajo, categoria, estado, fechaAlta, observaciones, empleado_id)
VALUES (
   'LEG-999999',                 
   'Junior',                    
   'ACTIVO',                    
   '2021-06-19',                
   'Prueba de FK: Empleado no existe',
   999999);

-- SQL - Procedimiento almacenado - Evitando la SQL Injection

-- No se necesita delimitador

CREATE PROCEDURE sp_buscar_empleado(IN dni_param VARCHAR(15))
BEGIN
    SELECT * FROM empleado 
    WHERE dni = dni_param
    AND eliminado = FALSE;
END;

-- Prueba "de control"; buscamos el DNI mencionado (ya existente en la base de datos)

CALL sp_buscar_empleado('250265541');

-- Prueba de Inyección

CALL sp_buscar_empleado("' OR '1'='1");