-- --------------------------------------------------------------------
-- Archivo: 03_carga_masiva_verificacion.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Contiene consultas SQL diseñadas para verificar la consistencia
--            y corrección de los datos después de ejecutar la carga masiva
--            (03_carga_masiva.sql). Cada consulta prueba una regla
--            o característica específica: conteo total, claves foráneas,
--            cardinalidad 1 a 1, distribución de datos y unicidad.

-- Ejecución: Ejecutar DESPUÉS de 03_carga_masiva.sql. Se recomienda
--            ejecutar cada bloque de consulta (delimitado por SELECT '-- ...')
--            individualmente para analizar los resultados.
-- --------------------------------------------------------------------

USE empleados;

-- -----------------------------------------
-- 1. VERIFICACIÓN DE CONTEO TOTAL
-- -----------------------------------------
-- Objetivo: Confirmar que se generaron los 400,000 registros planificados
--           en ambas tablas principales.
-- Resultado esperado: 400000 para ambas consultas.

SELECT '-- 1. CONTEO TOTAL --' AS Verificacion;
-- Contar todas las filas en la tabla 'empleado'
SELECT COUNT(*) AS total_empleados FROM empleado;
-- Contar todas las filas en la tabla 'legajo'
SELECT COUNT(*) AS total_legajos FROM legajo;


-- -----------------------------------------
-- 2. VERIFICACIÓN DE FK HUÉRFANAS (Integridad Referencial)
-- -----------------------------------------
-- Objetivo: Asegurar que cada registro en 'legajo' está correctamente
--           asociado a un registro existente en 'empleado'. No debe haber
--           legajos "huérfanos".
-- Resultado esperado: 0 (cero legajos huérfanos).

SELECT '-- 2. FK HUÉRFANAS --' AS Verificacion;
-- Busca legajos cuyo 'empleado_id' no corresponda a ningún 'id' en la tabla 'empleado'.
-- Se usa LEFT JOIN: si un legajo no encuentra su empleado correspondiente, e.id será NULL.
SELECT COUNT(*) AS legajos_huerfanos
FROM legajo l
LEFT JOIN empleado e ON l.empleado_id = e.id
WHERE e.id IS NULL; -- Filtra solo aquellos legajos que no encontraron un empleado


-- -----------------------------------------
-- 3. VERIFICACIÓN DE CARDINALIDAD 1-A-1
-- -----------------------------------------
-- Objetivo: Validar que la restricción UNIQUE en 'legajo.empleado_id' funciona
--           y que ningún empleado tiene más de un legajo asociado.
-- Resultado esperado: (Conjunto vacío) - Ninguna fila devuelta.

SELECT '-- 3. CARDINALIDAD 1-A-1 --' AS Verificacion;
-- Agrupa los legajos por 'empleado_id' y cuenta cuántos legajos tiene cada empleado.
-- Luego, filtra (HAVING) para mostrar solo aquellos empleados que tengan MÁS de 1 legajo.
SELECT
    empleado_id,
    COUNT(*) AS total_legajos_por_empleado
FROM legajo
GROUP BY empleado_id
HAVING COUNT(*) > 1;


-- -----------------------------------------
-- 4. VERIFICACIÓN DE DISTRIBUCIÓN DE DATOS (ESTADO)
-- -----------------------------------------
-- Objetivo: Validar que el sesgo aplicado en la carga masiva (90% 'ACTIVO',
--           10% 'INACTIVO') se refleja correctamente en los datos.
-- Resultado esperado: Porcentajes cercanos a 90.x% para 'ACTIVO' y 9.x% para 'INACTIVO'.

SELECT '-- 4. DISTRIBUCIÓN ESTADO --' AS Verificacion;
-- Agrupa los legajos por 'estado' y cuenta cuántos hay en cada grupo.
-- Calcula el porcentaje de cada estado respecto al total de legajos.
SELECT
    estado,
    COUNT(*) AS cantidad,
    -- Calcula el porcentaje: (cantidad_estado / total_legajos) * 100, redondeado a 2 decimales
    CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM legajo)) * 100, 2), '%') AS porcentaje
FROM legajo
GROUP BY estado;


-- -----------------------------------------
-- 5. VERIFICACIÓN DE UNICIDAD (UNIQUE Constraints)
-- -----------------------------------------
-- Objetivo: Asegurar que no se generaron valores duplicados en las columnas
--           definidas con la restricción UNIQUE ('dni', 'email', 'nroLegajo').
-- Resultado esperado: (Conjunto vacío) para todas las consultas en este bloque.

SELECT '-- 5. UNICIDAD --' AS Verificacion;
-- Buscar si existen DNI duplicados
-- Agrupa empleados por 'dni' y muestra aquellos DNI que aparecen más de una vez.
SELECT dni, COUNT(*) AS duplicados_dni
FROM empleado
GROUP BY dni
HAVING COUNT(*) > 1;

-- Buscar si existen Emails duplicados (considerando que email puede ser NULL)
-- Agrupa empleados por 'email' (ignorando los nulos) y muestra aquellos emails que aparecen más de una vez.
SELECT email, COUNT(*) AS duplicados_email
FROM empleado
WHERE email IS NOT NULL -- Excluir valores nulos de la comprobación de unicidad
GROUP BY email
HAVING COUNT(*) > 1;

-- Buscar si existen nroLegajo duplicados
-- Agrupa legajos por 'nroLegajo' y muestra aquellos que aparecen más de una vez.
SELECT nroLegajo, COUNT(*) AS duplicados_nroLegajo
FROM legajo
GROUP BY nroLegajo
HAVING COUNT(*) > 1;

-- --------------------------------------------------------------------
-- Fin del script 03_carga_masiva_verificacion.sql
-- --------------------------------------------------------------------

