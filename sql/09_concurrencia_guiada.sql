-- --------------------------------------------------------------------
-- Archivo: 09_concurrencia_guiada.sql
-- TFI - Bases de Datos I

-- Propósito: Este script, perteneciente a la Etapa 5, muestra un paso a paso para la concurrencia de dos sesiones trabajando
--            sobre la misma base de datos. Se simula un error de Deradlock simple, un error de Deadlock mediante el procedimiento "transferir_area",
--            y la comparación de dos niveles de aislamiento.
-- --------------------------------------------------------------------

-- Se necesitan dos sesiones (dos pestañas de script en DBeaver).
-- Y asegurarse de que el 'Auto-Commit' (modo de transacción) esté desactivado en AMBAS sesiones.

-- SIMULACIÓN DE DEADLOCK

-- Sesión 1
START TRANSACTION;
UPDATE empleado SET area = 'Ventas' WHERE id = 1234; -- 1. Sesión 1 bloquea la fila del empleado con id = 1234

-- Sesión 2                   
START TRANSACTION;
UPDATE legajo SET observaciones = 'Se requiere actualizar sueldo' WHERE empleado_id = 1234; -- 2. Sesión 2 bloquea la fila del legajo para el mismo empleado

-- Sesión 1
UPDATE legajo SET observaciones = 'Se transfirió al área de Ventas' WHERE empleado_id = 1234;
		-- Se intenta actualizar el legajo, pero se queda esperando porque la Sesión 2 lo tiene bloqueado.

-- Sesión 2
UPDATE empleado SET area = 'Ventas' WHERE id = 1234;
		-- Se intenta actualizar al empleado. OCURRE EL DEADLOCK al detectar el bloqueo circular.
		-- SQL Error [1213] [40001]: Deadlock found when trying to get lock; try restarting transaction



-- SIMULACIÓN DE DEADLOCK EN EL PROCEDIMIENTO "transferir_area"

-- Sesión 1
START TRANSACTION;
UPDATE legajo SET observaciones = 'Esto es un intento de Error de Deadlock' WHERE empleado_id = 3;

-- Sesión 2
CALL transferir_area(3, 'Marketing', 'Transferencia a Marketing');

-- Sesión 1
UPDATE empleado SET area = 'Recursos Humanos' WHERE id = 3;
COMMIT;


-- COMPARACIÓN DE 2 NIVELES DE AISLAMIENTO (READ UNCOMMITTED vs SERIALIZABLE)
-- Podemos generar una lectura sucia (dirty read) modificando el nivel de aislamiento a READ UNCOMMITTED. 

-- Sesión 1
USE empleados;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE empleado SET area = 'Marketing' WHERE id = 2;

-- Sesión 2
USE empleados;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT * FROM empleado WHERE id = 2;

-- Sesión 1
ROLLBACK;
SELECT * FROM empleado WHERE id = 2;

-- Sesión 2
SELECT * FROM empleado WHERE id = 2;


-- Ahora repetimos el proceso con SERIALIZABLE:

-- Sesión 1
USE empleados;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE empleado SET area = 'Marketing' WHERE id = 2;
SELECT * FROM empleado WHERE id = 2;

-- Sesión 2
USE empleados;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM empleado WHERE id = 2;




