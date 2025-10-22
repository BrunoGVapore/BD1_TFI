-- --------------------------------------------------------------------
-- Archivo: 04_indices.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Crea los índices necesarios para optimizar las consultas
--            analizadas en la Etapa 3 (medición de rendimiento).
--            Incluye índices para búsquedas por igualdad (dni),
--            rango (fechaIngreso), JOIN (empleado_id) y filtro (estado).
--            Es idempotente gracias a DROP INDEX IF EXISTS.

-- Ejecución: Ejecutar DESPUÉS de la carga masiva (03_carga_masiva.sql)
--            y ANTES de ejecutar las pruebas de rendimiento "con índice"
--            en 05_explain.sql.
-- --------------------------------------------------------------------

USE empleados;

-- Eliminar índices si existen para permitir una re-creación limpia
DROP INDEX IF EXISTS idx_empleado_dni ON empleado;
DROP INDEX IF EXISTS idx_empleado_fechaIngreso ON empleado;
DROP INDEX IF EXISTS idx_legajo_empleado_id ON legajo;
DROP INDEX IF EXISTS idx_legajo_estado ON legajo;

-- -----------------------------------------
-- ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
-- -----------------------------------------

-- Índice en la columna 'dni' de la tabla 'empleado'
-- Propósito: Acelera las búsquedas exactas por DNI (WHERE dni = 'valor').
-- Usado en: Prueba de igualdad de la Etapa 3.
CREATE INDEX idx_empleado_dni ON empleado(dni);

-- Índice en la columna 'fechaIngreso' de la tabla 'empleado'
-- Propósito: Acelera las búsquedas por rango de fechas (WHERE fechaIngreso BETWEEN 'fecha1' AND 'fecha2').
-- Usado en: Prueba de rango de la Etapa 3.
CREATE INDEX idx_empleado_fechaIngreso ON empleado(fechaIngreso);

-- Índice en la columna 'empleado_id' (FK) de la tabla 'legajo'
-- Propósito: Acelera la operación de JOIN entre 'legajo' y 'empleado'
--            cuando se unen por esta columna (ON e.id = l.empleado_id).
-- Usado en: Prueba de JOIN de la Etapa 3.
CREATE INDEX idx_legajo_empleado_id ON legajo(empleado_id);

-- Índice en la columna 'estado' de la tabla 'legajo'
-- Propósito: Acelera las búsquedas o filtros por el estado del legajo (WHERE l.estado = 'valor').
--            Es crucial para optimizar el JOIN cuando se filtra por 'estado'.
-- Usado en: Prueba de JOIN optimizada de la Etapa 3.
CREATE INDEX idx_legajo_estado ON legajo(estado);

-- --------------------------------------------------------------------
-- Fin del script 04_indices.sql
-- --------------------------------------------------------------------

