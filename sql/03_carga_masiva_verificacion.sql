-- --------------------------------------------------------------------
-- Archivo: 03_carga_masiva_verificacion.sql
-- TFI - Bases de Datos I
--
-- Propósito: Verificar la consistencia de los datos después de 
--            la ejecución de la carga masiva (03_carga_masiva.sql).
-- --------------------------------------------------------------------
SELECT VERSION();
USE empleados;

-- -----------------------------------------
-- 1. VERIFICACIÓN DE CONTEO TOTAL
-- -----------------------------------------
-- Objetivo: Confirmar que se generaron los 400,000 registros planificados.
-- Resultado esperado: 400000 para ambas consultas.

-- Contar el total de empleados
SELECT COUNT(*) AS total_empleados FROM empleado;

-- Contar el total de legajos
SELECT COUNT(*) AS total_legajos FROM legajo;


-- -----------------------------------------
-- 2. VERIFICACIÓN DE FK HUÉRFANAS
-- -----------------------------------------
-- Objetivo: Asegurar que no hay legajos que apunten a empleados inexistentes.
-- Resultado esperado: 0

-- Buscar legajos cuyo 'empleado_id' no corresponda a ningún empleado existente
SELECT COUNT(*) AS legajos_huerfanos
FROM legajo l
LEFT JOIN empleado e ON l.empleado_id = e.id
WHERE e.id IS NULL;


-- -----------------------------------------
-- 3. VERIFICACIÓN DE CARDINALIDAD 1-A-1
-- -----------------------------------------
-- Objetivo: Validar que ningún empleado tenga más de un legajo asociado.
-- Resultado esperado: (Conjunto vacío)

-- Buscar si algún empleado tiene más de un legajo asociado
SELECT 
    empleado_id, 
    COUNT(*) AS total_legajos
FROM legajo
GROUP BY empleado_id
HAVING COUNT(*) > 1;


-- -----------------------------------------
-- 4. VERIFICACIÓN DE DISTRIBUCIÓN DE DATOS
-- -----------------------------------------
-- Objetivo: Validar que el sesgo 90/10 en 'estado' se aplicó correctamente.
-- Resultado esperado: ~90.x% ACTIVO, ~9.x% INACTIVO

-- Revisar el porcentaje de legajos activos e inactivos
SELECT
    estado,
    COUNT(*) AS cantidad,
    CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM legajo)) * 100, 2), '%') AS porcentaje
FROM legajo
GROUP BY estado;


-- -----------------------------------------
-- 5. VERIFICACIÓN DE UNICIDAD (UNIQUE)
-- -----------------------------------------
-- Objetivo: Asegurar que no hay valores duplicados en las columnas UNIQUE.
-- Resultado esperado: (Conjunto vacío) para todas las consultas.

-- Buscar si existen DNI duplicados
SELECT dni, COUNT(*)
FROM empleado
GROUP BY dni
HAVING COUNT(*) > 1;

-- Buscar si existen Emails duplicados (también es UNIQUE)
SELECT email, COUNT(*)
FROM empleado
GROUP BY email
HAVING COUNT(*) > 1;

-- Buscar si existen nroLegajo duplicados (también es UNIQUE)
SELECT nroLegajo, COUNT(*)
FROM legajo
GROUP BY nroLegajo
HAVING COUNT(*) > 1;