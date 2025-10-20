-- --------------------------------------------------------------------
-- Archivo: 06_vistas.sql
-- TFI - Bases de Datos I
--
-- Propósito: Crea las vistas diseñadas en la Etapa 3 para simplificar
--            consultas frecuentes y ocultar datos sensibles.
-- --------------------------------------------------------------------

USE empleados;

-- Vista 1: Empleados Activos
-- Utilidad: Simplifica el acceso a la información completa de empleados actualmente activos.
CREATE OR REPLACE VIEW vista_empleados_activos AS
SELECT
    e.id AS id_empleado,
    e.nombre,
    e.apellido,
    e.area,
    e.fechaIngreso,
    l.nroLegajo,
    l.categoria,
    l.estado -- Siempre será 'ACTIVO' por el WHERE
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id
WHERE l.estado = 'ACTIVO'; [cite_start]-- [cite: 297-309]

-- Vista 2: Empleados Públicos (sin datos sensibles)
-- Utilidad: Expone información general para reportes, ocultando DNI, email, etc.
CREATE OR REPLACE VIEW vista_empleados_publica AS
SELECT
    e.nombre,
    e.apellido,
    e.area,
    l.categoria,
    l.estado
FROM empleado e
JOIN legajo l ON e.id = l.empleado_id; [cite_start]-- [cite: 315-323]