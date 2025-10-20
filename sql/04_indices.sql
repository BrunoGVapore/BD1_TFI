-- --------------------------------------------------------------------
-- Archivo: 04_indices.sql
-- TFI - Bases de Datos I
--
-- Propósito: Crea los índices utilizados en la Etapa 3 para
--            la medición comparativa de rendimiento de consultas.
-- --------------------------------------------------------------------

USE empleados;

-- Índice para la consulta por igualdad en 'dni'
CREATE INDEX idx_empleado_dni ON empleado(dni); -- Incorrect table name 'empleados' corrected to 'empleado'

-- Índice para la consulta por rango en 'fechaIngreso'
CREATE INDEX idx_empleado_fechaIngreso ON empleado(fechaIngreso); -- Incorrect table name 'empleados' corrected to 'empleado'

-- Índice para la consulta con JOIN en la clave foránea 'empleado_id'
CREATE INDEX idx_legajo_empleado_id ON legajo(empleado_id); --