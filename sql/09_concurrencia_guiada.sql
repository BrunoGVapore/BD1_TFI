-- --------------------------------------------------------------------
-- Archivo: 09_concurrencia_guiada.sql
-- TFI - Bases de Datos I

-- Propósito: Este script, perteneciente a la Etapa 5, configura la concurrencia guiada de la base de datos empleados,
--            creando tablas para registrar concurrencia guiada, generando procedimientos almacenados para
--            registrar y consultar  esa concurrencia y simulando un Deadlock.
-- --------------------------------------------------------------------

-- Simulación del Deadlock
-- Se necesitan dos sesiones (dos pestañas de script en DBeaver).
-- Asegurarse de que el 'Auto-Commit' esté desactivado en AMBAS sesiones.


-- EN SESIÓN 1 

START TRANSACTION;

-- 1. Sesión 1 bloquea la fila del empleado con id = 1234

UPDATE empleado SET area = 'Ventas' WHERE id = 1234;

-- EN SESIÓN 2                    

START TRANSACTION;

-- 2. Sesión 2 bloquea la fila del legajo para el mismo empleado

UPDATE legajo SET observaciones = 'Se requiere actualizar sueldo' WHERE empleado_id = 1234;

-- EN SESIÓN 1
-- 
-- 3. Sesión 1 intenta actualizar el legajo, pero se queda esperando
--    porque la Sesión 2 lo tiene bloqueado.

UPDATE legajo SET observaciones = 'Se transfirió al área de Ventas' WHERE empleado_id = 1234;

-- EN SESIÓN 2
-- 
-- 4. Sesión 2 intenta actualizar al empleado. OCURRE EL DEADLOCK
--    MySQL detecta el bloqueo circular y anula una de las transacciones.

UPDATE empleado SET area = 'Ventas' WHERE id = 1234;

-- Una de las dos sesiones recibirá el error:
-- SQL Error [1213] [40001]: Deadlock found when trying to get lock; try restarting transaction