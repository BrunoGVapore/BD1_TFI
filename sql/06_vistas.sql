-- --------------------------------------------------------------------
-- Archivo: 06_vistas.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Crea las dos vistas ('VIEW') diseñadas en la Etapa 3:
--            1. 'vista_empleados_activos': Ofrece una visión combinada
--               y filtrada del personal actualmente activo.
--            2. 'vista_empleados_publica': Expone un conjunto limitado
--               de datos generales, ocultando información sensible.
--            Ambas vistas excluyen registros marcados como eliminados
--            lógicamente para mantener la consistencia.
--            Es idempotente gracias a CREATE OR REPLACE VIEW.

-- Ejecución: Ejecutar DESPUÉS de 01_esquema.sql.
-- --------------------------------------------------------------------

USE empleados;

-- Eliminar vistas si existen (alternativa a CREATE OR REPLACE, aunque no necesaria)
-- DROP VIEW IF EXISTS vista_empleados_activos;
-- DROP VIEW IF EXISTS vista_empleados_publica;

-- -----------------------------------------
-- VISTA 1: Empleados Activos
-- Combina datos de 'empleado' y 'legajo' para aquellos cuyo 'estado' es 'ACTIVO'.
-- -----------------------------------------
-- Utilidad: Simplifica consultas frecuentes sobre el personal en actividad,
--           evitando escribir el JOIN y el filtro repetidamente.
--           Útil para reportes de RRHH, listados operativos, etc.
CREATE OR REPLACE VIEW vista_empleados_activos AS
SELECT
    e.id AS id_empleado, -- Alias para claridad si se une con otras tablas
    e.nombre,
    e.apellido,
    e.area,
    e.fechaIngreso,
    l.nroLegajo,
    l.categoria,
    l.estado -- Esta columna siempre contendrá 'ACTIVO' debido al filtro WHERE
FROM empleado e
-- Une empleado con su legajo correspondiente usando la FK
JOIN legajo l ON e.id = l.empleado_id
WHERE
    l.estado = 'ACTIVO' -- Condición principal: solo legajos activos
    -- Filtros adicionales para excluir registros eliminados lógicamente de ambas tablas
    AND e.eliminado = FALSE
    AND l.eliminado = FALSE
COMMENT='Vista que combina empleado y legajo para personal actualmente activo (estado=ACTIVO y no eliminados).';

-- -----------------------------------------
-- VISTA 2: Empleados Públicos (sin datos sensibles)
-- Expone un subconjunto de columnas consideradas no confidenciales.
-- -----------------------------------------
-- Utilidad: Proporciona una interfaz segura para consultas generales o
--           por parte de usuarios/aplicaciones que no deben ver datos
--           privados como DNI, email, fechas exactas, observaciones.
--           Útil para directorios internos, estadísticas generales.
CREATE OR REPLACE VIEW vista_empleados_publica AS
SELECT
    -- Columnas seleccionadas (no sensibles)
    e.nombre,
    e.apellido,
    e.area,
    l.categoria,
    l.estado
FROM empleado e
-- Une empleado con su legajo
JOIN legajo l ON e.id = l.empleado_id
WHERE
    -- Excluye registros eliminados lógicamente
    e.eliminado = FALSE
    AND l.eliminado = FALSE
COMMENT='Vista simplificada de empleados para uso público o general, ocultando datos sensibles como DNI, email, etc.';

-- --------------------------------------------------------------------
-- Fin del script 06_vistas.sql
-- --------------------------------------------------------------------

