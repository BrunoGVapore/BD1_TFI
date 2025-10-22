-- --------------------------------------------------------------------
-- Archivo: prueba_deadlock_proc_sesion1.sql
-- TFI - Bases de Datos I - Etapa 5, Tarea 2

-- GUÍA DETALLADA PARA LA SESIÓN 1 - Prueba de Deadlock con Procedimiento

-- Ejecución: Ejecutar CADA SENTENCIA SQL individualmente (marcada con '-- Ejecutar:')
--            en el orden indicado, intercalando con Sesión 2.
--            ASEGURARSE DE ESTAR EN MODO "MANUAL COMMIT".
-- --------------------------------------------------------------------

-- Preparación Inicial --
-- Ejecutar: Asegura que estamos en la base de datos correcta.
USE empleados;

-- Ejecutar: VERIFICACIÓN PREVIA - Asegura que el empleado con id=3 existe.
--           Si esta consulta no devuelve una fila, la prueba fallará.
--           Puedes cambiar el id=3 por uno que sí exista si es necesario.
SELECT id, nombre, apellido FROM empleado WHERE id = 3;
-- Verificar: Debe mostrar la información del empleado con id=3. Si no, ajusta el ID en todo el script.

-- Ejecutar: (Opcional) Limpia la tabla de logs antes de empezar.
TRUNCATE TABLE registro_errores;
-- Verificar: La tabla 'registro_errores' debe estar vacía.
-- SELECT * FROM registro_errores;

-- -----------------------------------------
-- PASO 1: Iniciar transacción y bloquear 'legajo' (Empleado ID=3)
-- -----------------------------------------
-- Ejecutar: Inicia la transacción en esta sesión.
START TRANSACTION;
-- Verificar: No hay salida visible, pero la transacción está abierta.

-- Ejecutar: Actualiza la tabla 'legajo' para el empleado 3.
--          Esto adquiere un bloqueo EXCLUSIVO sobre esa fila en 'legajo'.
UPDATE legajo
SET observaciones = CONCAT(IFNULL(observaciones,''), ' | Bloqueo manual S1 para prueba de retry')
WHERE empleado_id = 3;
-- Verificar: DBeaver debe indicar '1 row(s) modified'. La fila de legajo 3 está bloqueada por esta sesión.

-- --------------------------------------------------------------------
-- !! AHORA DETENTE AQUÍ Y VE A LA PESTAÑA DE SESIÓN 2 PARA EJECUTAR EL PASO 2 !!
--    (La Sesión 2 llamará al procedimiento y se quedará esperando)
-- --------------------------------------------------------------------


-- -----------------------------------------
-- PASO 3: Intentar bloquear 'empleado' (Empleado ID=3) y causar el Deadlock
--         (Ejecutar DESPUÉS de que la Sesión 2 se quede "colgada" en el PASO 2)
-- -----------------------------------------
-- Ejecutar: Intenta actualizar la tabla 'empleado' para el id=3.
--          PERO el procedimiento 'transferir_area' (en Sesión 2) ya bloqueó esta fila.
--          Esto completará el ciclo de espera y causará el DEADLOCK.
UPDATE empleado
SET area = 'Recursos Humanos Temporal Retry' -- Este cambio no se guardará porque esta sesión será la víctima.
WHERE id = 3;
-- Verificar: ESTA EJECUCIÓN DEBE FALLAR con SQL Error [1213] [40001]: Deadlock found...
--           Al fallar, esta transacción se cancela automáticamente (ROLLBACK implícito)
--           y libera el bloqueo que tenía sobre 'legajo'. Esto permite que la Sesión 2 continúe.
--           TOMA CAPTURA DE ESTE ERROR 1213.

-- -----------------------------------------
-- PASO 4: Limpieza de Sesión 1
-- -----------------------------------------
-- Ejecutar: Aunque MySQL probablemente ya hizo ROLLBACK, lo ejecutamos explícitamente por seguridad.
ROLLBACK;
-- Verificar: Cualquier cambio pendiente se deshace.

-- Ejecutar: (Opcional) Verifica que el nivel de aislamiento sigue siendo el correcto.
-- SELECT @@TRANSACTION_ISOLATION;

-- Ejecutar: Vuelve a poner esta pestaña de DBeaver en modo "Auto Commit".
--           (Ir al menú: Base de Datos -> Modo de transacción -> Auto)
SELECT 'PASO 4 (S1): Limpieza completa. Vuelve a modo Auto-Commit en DBeaver.' AS Estado_Final_S1;


-- --------------------------------------------------------------------
-- Fin del script Sesión 1
-- --------------------------------------------------------------------

