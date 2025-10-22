-- --------------------------------------------------------------------
-- Archivo: 05_explain.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Contiene los comandos EXPLAIN utilizados en la Etapa 3
--            para analizar y comparar los planes de ejecución de
--            consultas representativas (igualdad, rango, JOIN)
--            ANTES y DESPUÉS de crear los índices definidos en
--            04_indices.sql. Permite observar cómo el optimizador
--            de MySQL elige (o no) usar los índices.

-- Ejecución:
--            1. Ejecutar este script COMPLETO ANTES de crear los índices
--               (ejecutar 04_indices.sql) para obtener los resultados "Sin Índice".
--               Anotar/guardar estos resultados.
--            2. Ejecutar 04_indices.sql para crear los índices.
--            3. Ejecutar este script COMPLETO DE NUEVO para obtener los resultados
--               "Con Índice". Anotar/guardar estos nuevos resultados.
--            4. Comparar ambos conjuntos de resultados en el informe para
--               documentar la mejora (o falta de ella y por qué).
-- --------------------------------------------------------------------

USE empleados;

SELECT '-- ANÁLISIS DE PLANES DE EJECUCIÓN (ANTES Y DESPUÉS DE ÍNDICES) --' AS Titulo;

-- -----------------------------------------
-- 1. CONSULTA POR IGUALDAD (dni)
-- Objetivo: Analizar búsqueda exacta usando la columna UNIQUE 'dni'.
-- Índice relevante: idx_empleado_dni
-- -----------------------------------------
SELECT '-- Consulta 1: Igualdad (dni) --' AS Consulta;

-- Plan SIN índice (o ANTES de crearlo):
-- Se espera 'type: ALL' (Full Table Scan) si el DNI existiera,
-- o 'const' si MySQL optimiza por ser UNIQUE y el valor no existe.
EXPLAIN SELECT * FROM empleado WHERE dni = '30555666'; -- Usar un DNI que NO exista facilita ver 'const'.

-- Plan CON índice (o DESPUÉS de crearlo):
-- Se espera 'type: const' (si el DNI no existe) o 'type: ref' (si existe), usando 'idx_empleado_dni'.
-- El número de 'rows' debe ser 1 (o muy bajo).
EXPLAIN SELECT * FROM empleado WHERE dni = '30555666';


-- -----------------------------------------
-- 2. CONSULTA POR RANGO (fechaIngreso)
-- Objetivo: Analizar búsqueda en un intervalo de fechas.
-- Índice relevante: idx_empleado_fechaIngreso
-- -----------------------------------------
SELECT '-- Consulta 2: Rango (fechaIngreso) --' AS Consulta;

-- Plan SIN índice:
-- Se usa un rango amplio (5 años) para asegurar que el optimizador elija 'type: ALL'.
-- Se espera 'type: ALL' y 'rows' cercano al total de la tabla.
EXPLAIN SELECT * FROM empleado
WHERE fechaIngreso BETWEEN '2015-01-01' AND '2020-12-31';

-- Plan CON índice:
-- Se usa un rango corto (1 mes) para hacerlo "selectivo" y atractivo para el índice.
-- Se espera 'type: range', 'key: idx_empleado_fechaIngreso' y 'rows' mucho menor.
EXPLAIN SELECT * FROM empleado
WHERE fechaIngreso BETWEEN '2023-01-01' AND '2023-01-31';


-- -----------------------------------------
-- 3. CONSULTA CON JOIN (filtrando por estado)
-- Objetivo: Analizar cómo los índices afectan el JOIN y el filtro.
-- Índices relevantes: idx_legajo_empleado_id (para el JOIN), idx_legajo_estado (para el WHERE)
-- -----------------------------------------
SELECT '-- Consulta 3: JOIN (filtrando por estado) --' AS Consulta;

-- Plan SIN índices (idx_legajo_empleado_id, idx_legajo_estado):
-- Se filtra por 'ACTIVO' (90% de los datos).
-- Se espera 'type: ALL' en la tabla 'legajo' porque el filtro no es selectivo y no hay índice en 'estado'.
-- Se espera 'type: eq_ref' en 'empleado' (usa la PK). 'rows' en 'legajo' será alto.
EXPLAIN
SELECT e.nombre, e.apellido, l.categoria, l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'ACTIVO';

-- Plan CON índices (idx_legajo_empleado_id, idx_legajo_estado):
-- Se filtra por 'INACTIVO' (10% de los datos) para que el índice 'idx_legajo_estado' sea selectivo.
-- Se espera 'type: ref' en 'legajo', usando 'idx_legajo_estado'. 'rows' debe ser mucho menor (~10% del total).
-- Se espera 'type: eq_ref' en 'empleado'.
EXPLAIN
SELECT e.nombre, e.apellido, l.categoria, l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'INACTIVO';

-- --------------------------------------------------------------------
-- Fin del script 05_explain.sql
-- --------------------------------------------------------------------

