-- --------------------------------------------------------------------
-- Archivo: 05_explain.sql
-- TFI - Bases de Datos I
--
-- Propósito: Contiene los comandos EXPLAIN utilizados en la Etapa 3
--            para analizar los planes de ejecución con y sin índices.
-- --------------------------------------------------------------------

USE empleados;

-- NOTA: Ejecutar estos bloques antes y después de crear los índices en 04_indices.sql

-- 1. Consulta por igualdad (dni)
-- Sin índice:
EXPLAIN SELECT * FROM empleado WHERE dni = '30555666'; [cite_start]-- [cite: 336] Incorrect table name 'empleados' corrected to 'empleado'
-- Con índice (idx_empleado_dni):
EXPLAIN SELECT * FROM empleado WHERE dni = '30555666'; [cite_start]-- [cite: 338] Incorrect table name 'empleados' corrected to 'empleado'


-- 2. Consulta por rango (fechaIngreso)
-- Sin índice:
EXPLAIN SELECT * FROM empleado
WHERE fechaIngreso BETWEEN '2015-01-01' AND '2020-12-31'; [cite_start]-- [cite: 340, 341] Incorrect table name 'empleados' corrected to 'empleado'
-- Con índice (idx_empleado_fechaIngreso):
EXPLAIN SELECT * FROM empleado
WHERE fechaIngreso BETWEEN '2015-01-01' AND '2020-12-31'; [cite_start]-- [cite: 343, 344] Incorrect table name 'empleados' corrected to 'empleado'


-- 3. Consulta con JOIN (estado y empleado_id)
-- Sin índice:
EXPLAIN
SELECT e.nombre, e.apellido, l.categoria, l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'ACTIVO'; [cite_start]-- [cite: 346-350] Incorrect table name 'empleados' corrected to 'empleado'
-- Con índice (idx_legajo_empleado_id):
EXPLAIN
SELECT e.nombre, e.apellido, l.categoria, l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'ACTIVO'; [cite_start]-- [cite: 352-356] Incorrect table name 'empleados' corrected to 'empleado'