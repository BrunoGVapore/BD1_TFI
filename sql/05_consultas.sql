-- --------------------------------------------------------------------
-- Archivo: 05_consultas.sql
-- TFI - Bases de Datos I
--
-- Propósito: Contiene las consultas complejas y útiles diseñadas
--            en la Etapa 3.
-- --------------------------------------------------------------------

USE empleados;

-- Consulta 1: Muestra empleados con legajos inactivos
-- Utilidad: Identificar personal desvinculado o en licencia prolongada.
SELECT
    e.id,
    e.nombre,
    e.apellido,
    e.area,
    l.nroLegajo,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'INACTIVO';

-- Consulta 2: Muestra los empleados junto con su legajo, categoría y estado
-- Utilidad: Ofrecer una visión integral del empleado (datos personales + laborales).
SELECT
    e.id,
    e.nombre,
    e.apellido,
    e.area,
    l.nroLegajo,
    l.categoria,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
ORDER BY e.area, l.categoria;

-- Consulta 3: Promedio de antigüedad (años) por área
-- Utilidad: Analizar la retención de personal por departamento.
SELECT
    e.area,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE())), 2) AS antiguedad_promedio
FROM empleado e
GROUP BY e.area
ORDER BY antiguedad_promedio DESC;

-- Consulta 4: Lista empleados activos (según legajo) que trabajan en un área específica
-- Utilidad: Controlar la dotación de personal vigente por área (ej. 'Ventas').
SELECT
    e.nombre,
    e.apellido,
    e.area,
    l.nroLegajo,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'ACTIVO'
  AND e.area = 'Ventas'; 
  

-- Consulta 5: Área con más personal
-- Utilidad: Identificar el área con mayor concentración de empleados.
SELECT e.area, COUNT(*) AS cantidad_empleados
FROM empleado e
GROUP BY e.area
HAVING COUNT(*) = (    
    SELECT MAX(cantidad)
    FROM (
        SELECT COUNT(*) AS cantidad
        FROM empleado
        GROUP BY area
    ) AS sub_conteo_por_area
);