-- --------------------------------------------------------------------
-- Archivo: prueba_deadlock_proc_sesion2.sql
-- TFI - Bases de Datos I - Etapa 5, Tarea 2

-- GUÍA DETALLADA PARA LA SESIÓN 2 - Prueba de Deadlock con Procedimiento

-- Ejecución: Ejecutar CADA SENTENCIA SQL individualmente (marcada con '-- Ejecutar:')
--            en el orden indicado, intercalando con Sesión 1.
--            ASEGURARSE DE ESTAR EN MODO "MANUAL COMMIT".
-- --------------------------------------------------------------------

-- Preparación Inicial --
-- Ejecutar: Asegura que estamos en la base de datos correcta.
USE empleados;

-- --------------------------------------------------------------------
-- !! ESPERA AQUÍ HASTA QUE HAYAS EJECUTADO EL PASO 1 COMPLETO EN LA SESIÓN 1 !!
--    (Sesión 1 debe haber iniciado su transacción y bloqueado el legajo 3)
-- --------------------------------------------------------------------


-- -----------------------------------------
-- PASO 2: Llamar al procedimiento 'transferir_area'
-- -----------------------------------------
-- Ejecutar: Llama al procedimiento para el empleado con id=3.
--          El procedimiento hará (internamente):
--            1. START TRANSACTION;
--            2. UPDATE empleado SET area = ... WHERE id = 3; (Éxito, bloquea empleado 3)
--            3. UPDATE legajo SET observaciones = ... WHERE empleado_id = 3; (Intenta bloquear legajo 3)
--          Como la Sesión 1 ya bloqueó el legajo 3, esta llamada se quedará "COLGADA" esperando.
CALL transferir_area(3, 'Marketing Desde Proc', 'Prueba de retry en deadlock');
-- Verificar: La ejecución en DBeaver se mostrará como "ejecutando" pero no terminará. NO LA CANCELES.

-- --------------------------------------------------------------------
-- !! AHORA DETENTE AQUÍ Y VE A LA PESTAÑA DE SESIÓN 1 PARA EJECUTAR EL PASO 3 !!
--    (La Sesión 1 causará el deadlock al intentar actualizar el empleado 3)
-- --------------------------------------------------------------------

-- **QUÉ SUCEDERÁ AQUÍ (en Sesión 2) cuando la Sesión 1 cause el Deadlock:**
-- 1. MySQL detecta el deadlock.
-- 2. Sacrifica la transacción de Sesión 1 (falla con error 1213).
-- 3. La Sesión 1 libera su bloqueo sobre 'legajo'.
-- 4. El HANDLER FOR 1213 dentro de 'transferir_area' (aquí en Sesión 2) se activa.
-- 5. Hace ROLLBACK del intento fallido, registra el error 1213 en 'registro_errores'.
-- 6. Espera un poco (DO SLEEP).
-- 7. REINTENTA la transacción completa (UPDATE empleado, UPDATE legajo, COMMIT).
-- 8. Como el bloqueo de Sesión 1 ya no existe, el reintento tiene ÉXITO.
-- 9. La ejecución de este CALL que estaba "colgada" TERMINARÁ CORRECTAMENTE.
-- Verificar: DBeaver mostrará que la ejecución del CALL ha finalizado.

-- -----------------------------------------
-- PASO 4: Verificación y Limpieza de Sesión 2
-- -----------------------------------------
-- Ejecutar: Aunque el procedimiento hizo COMMIT en el reintento, ejecutamos COMMIT
--          aquí para cerrar formalmente la transacción de esta sesión.
COMMIT;
-- Verificar: Cierra la transacción principal de esta sesión.

-- Ejecutar: Verifica la tabla de errores.
SELECT * FROM registro_errores ORDER BY fecha DESC;
-- Verificar: DEBE mostrar UNA fila registrando el Deadlock (código 1213) ocurrido durante el CALL.
--           TOMA CAPTURA DE ESTA TABLA 'registro_errores'.

-- Ejecutar: Verifica los datos del empleado 3 para confirmar que el procedimiento funcionó en el reintento.
SELECT id, area FROM empleado WHERE id = 3;
-- Verificar: DEBE mostrar el área 'Marketing Desde Proc'.

-- Ejecutar: Verifica las observaciones del legajo 3.
SELECT empleado_id, observaciones FROM legajo WHERE empleado_id = 3;
-- Verificar: DEBE incluir el texto '| Prueba de retry en deadlock' añadido al final.
--            TOMA CAPTURA DE ESTOS RESULTADOS DE LOS SELECTs.

-- Ejecutar: Vuelve a poner esta pestaña de DBeaver en modo "Auto Commit".
--           (Ir al menú: Base de Datos -> Modo de transacción -> Auto)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- Asegura volver al nivel por defecto
SELECT 'PASO 4 (S2): Verificación y limpieza completas. Vuelve a modo Auto-Commit en DBeaver.' AS Estado_Final_S2;

-- --------------------------------------------------------------------
-- Fin del script Sesión 2
-- --------------------------------------------------------------------
