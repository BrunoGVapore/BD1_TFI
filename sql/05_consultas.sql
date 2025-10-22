-- --------------------------------------------------------------------
-- Archivo: 05_consultas.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Contiene las 5 consultas complejas y útiles diseñadas
--            en la Etapa 3, que demuestran el uso de JOIN, GROUP BY,
--            HAVING, funciones de agregación (AVG, COUNT), cálculo
--            de fechas (TIMESTAMPDIFF) y subconsultas sobre el
--            modelo Empleado-Legajo. Incluye LIMIT para evitar
--            salidas excesivamente largas en algunas consultas.
-- --------------------------------------------------------------------

USE empleados;

-- -----------------------------------------
-- CONSULTAS AVANZADAS - ETAPA 3
-- -----------------------------------------

-- Consulta 1: Empleados con legajos inactivos
-- Utilidad: Identificar personal cuyo estado contractual es 'INACTIVO'. Útil para reportes de bajas o licencias.
-- Tipo: INNER JOIN (solo empleados con legajo) + Filtro (WHERE)
SELECT '-- Consulta 1: Empleados Inactivos --' AS Consulta;
SELECT
    e.id AS empleado_id,
    e.nombre,
    e.apellido,
    e.area,
    l.nroLegajo,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id -- Une empleado con su legajo correspondiente
WHERE l.estado = 'INACTIVO' -- Filtra solo aquellos cuyo legajo está inactivo
LIMIT 100; -- Limita la salida a 100 filas para facilitar la visualización

-- Consulta 2: Listado completo de empleados con datos de legajo, ordenado
-- Utilidad: Ofrecer una visión integral (datos personales + laborales), ordenada por área y categoría para reportes.
-- Tipo: INNER JOIN + Ordenación (ORDER BY)
SELECT '-- Consulta 2: Listado Completo Empleado-Legajo Ordenado --' AS Consulta;
SELECT
    e.id AS empleado_id,
    e.nombre,
    e.apellido,
    e.area,
    l.nroLegajo,
    l.categoria,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id -- Une empleado con su legajo
ORDER BY e.area, l.categoria -- Ordena los resultados primero por área, luego por categoría
LIMIT 100; -- Limita la salida

-- Consulta 3: Promedio de antigüedad (en años) por área
-- Utilidad: Analizar la retención de personal promedio en cada departamento.
-- Tipo: GROUP BY + Función de Agregación (AVG) + Cálculo de Fechas (TIMESTAMPDIFF)
SELECT '-- Consulta 3: Antigüedad Promedio por Área --' AS Consulta;
SELECT
    e.area,
    -- Calcula la diferencia en AÑOS entre la fecha de ingreso y la fecha actual (CURDATE())
    -- Luego calcula el promedio (AVG) de esas antigüedades para cada 'area'
    -- Finalmente, redondea el promedio a 2 decimales.
    ROUND(AVG(TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE())), 2) AS antiguedad_promedio_anios
FROM empleado e
WHERE e.fechaIngreso IS NOT NULL -- Importante: Excluir empleados sin fecha de ingreso para evitar errores en AVG
GROUP BY e.area -- Agrupa las filas por área para calcular el promedio de cada una
ORDER BY antiguedad_promedio_anios DESC; -- Ordena las áreas de mayor a menor antigüedad promedio

-- Consulta 4: Empleados activos en un área específica (ej. 'Ventas')
-- Utilidad: Obtener un listado del personal actualmente activo en un departamento determinado.
-- Tipo: INNER JOIN + Filtro Múltiple (WHERE ... AND ...)
SELECT '-- Consulta 4: Empleados Activos en Ventas --' AS Consulta;
SELECT
    e.nombre,
    e.apellido,
    e.area,
    l.nroLegajo,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id -- Une empleado con su legajo
WHERE l.estado = 'ACTIVO' -- Filtra solo los legajos activos
  AND e.area = 'Ventas' -- Filtra solo los empleados del área de Ventas (este valor se puede cambiar)
LIMIT 100; -- Limita la salida

-- Consulta 5: Área(s) con la mayor cantidad de empleados
-- Utilidad: Identificar el/los departamento(s) con más personal, útil para análisis de estructura organizacional.
-- Tipo: GROUP BY + HAVING + Subconsulta (para encontrar el máximo)
SELECT '-- Consulta 5: Área(s) con Más Empleados --' AS Consulta;
SELECT
    e.area,
    COUNT(*) AS cantidad_empleados -- Cuenta cuántos empleados hay por área
FROM empleado e
GROUP BY e.area -- Agrupa para poder contar por área
HAVING COUNT(*) = ( -- Filtra los grupos: solo muestra aquellos cuya cantidad sea igual al máximo
    -- Subconsulta interna: Encuentra cuál es la cantidad MÁXIMA de empleados que tiene cualquier área
    SELECT MAX(cantidad) -- Obtiene el valor máximo de la columna 'cantidad' de la subconsulta siguiente
    FROM (
        -- Subconsulta interna (derivada): Calcula la cantidad de empleados para CADA área
        SELECT COUNT(*) AS cantidad
        FROM empleado
        GROUP BY area
    ) AS sub_conteo_por_area -- Es necesario darle un alias a la tabla derivada
);

-- --------------------------------------------------------------------
-- Fin del script 05_consultas.sql
-- --------------------------------------------------------------------

