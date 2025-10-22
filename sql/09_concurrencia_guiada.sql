-- --------------------------------------------------------------------
-- Archivo: 09_concurrencia_guiada.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Contiene los scripts y la guía paso a paso para realizar
--            las pruebas de la Etapa 5: Concurrencia. Incluye:
--            1. Simulación manual y guiada de un Deadlock (Error 1213)
--               usando dos sesiones SQL concurrentes.
--            2. Guía para probar el procedimiento 'transferir_area' (de 08_transacciones.sql)
--               bajo condiciones de deadlock simulado.
--            3. Comparación práctica y guiada de dos niveles de aislamiento:
--               READ UNCOMMITTED (para observar lecturas sucias) y
--               SERIALIZABLE (para observar bloqueo y consistencia).

-- Ejecución: Este script NO debe ejecutarse completo. Requiere ABRIR DOS
--            pestañas de script SQL en DBeaver, etiquetadas
--            como "Sesión 1" y "Sesión 2". SEGUIR CUIDADOSAMENTE
--            las instrucciones comentadas, ejecutando cada PASO en la sesión
--            indicada y en el orden especificado.
--            Asegurarse de estar conectado como 'root'.
-- --------------------------------------------------------------------

-- Preparación inicial (ejecutar en ambas sesiones si es necesario):
USE empleados;

-- -----------------------------------------
-- TAREA 1: SIMULACIÓN MANUAL DE DEADLOCK
-- -----------------------------------------
-- Objetivo: Provocar intencionalmente un error 1213 (Deadlock) para
--           observar el comportamiento de MySQL ante un bloqueo circular.
-- Preparación: Abrir DOS pestañas de Script SQL (Sesión 1 y Sesión 2).
--              En AMBAS, poner el modo de transacción en "Manual Commit"
--              (Menú Base de Datos -> Modo de transacción -> Manual Commit).
--              Asegurarse de que exista el empleado con id = 1.

-- == PASOS A EJECUTAR INTERCALADAMENTE ==

-- **PASO 1 (EJECUTAR EN Sesión 1):** Iniciar la transacción 1.
-- START TRANSACTION;
-- SELECT 'Paso 1 (S1): Transacción iniciada.' AS Estado;

-- **PASO 2 (EJECUTAR EN Sesión 2):** Iniciar la transacción 2.
-- START TRANSACTION;
-- SELECT 'Paso 2 (S2): Transacción iniciada.' AS Estado;

-- **PASO 3 (EJECUTAR EN Sesión 1):** Bloquear la fila del empleado con id = 1 en la tabla 'empleado'.
-- UPDATE empleado SET area = 'Ventas Temporal Deadlock' WHERE id = 1;
-- SELECT 'Paso 3 (S1): Fila en empleado (id=1) bloqueada.' AS Estado; -- Debería indicar 1 fila modificada.

-- **PASO 4 (EJECUTAR EN Sesión 2):** Bloquear la fila del legajo correspondiente (empleado_id = 1) en la tabla 'legajo'.
-- UPDATE legajo SET observaciones = 'Intento Sesion 2 Deadlock' WHERE empleado_id = 1;
-- SELECT 'Paso 4 (S2): Fila en legajo (empleado_id=1) bloqueada.' AS Estado; -- Debería indicar 1 fila modificada.

-- **PASO 5 (EJECUTAR EN Sesión 1):** Intentar bloquear la fila en 'legajo' (que ya está bloqueada por Sesión 2).
--                      Esta consulta se quedará ESPERANDO (colgada). NO LA CANCELES.
-- UPDATE legajo SET observaciones = 'Intento Sesion 1 Deadlock' WHERE empleado_id = 1;
-- SELECT 'Paso 5 (S1): Intentando bloquear legajo... (esperando)' AS Estado;

-- **PASO 6 (EJECUTAR EN Sesión 2):** Intentar bloquear la fila en 'empleado' (que ya está bloqueada por Sesión 1).
--                      Esto completará el ciclo y provocará el DEADLOCK.
-- UPDATE empleado SET area = 'Marketing Temporal Deadlock' WHERE id = 1;
-- SELECT 'Paso 6 (S2): Intentando bloquear empleado...' AS Estado;

-- **Resultado esperado:** Inmediatamente después del Paso 6, una de las sesiones
--                   (probablemente la Sesión 1, que estaba esperando) fallará con ERROR 1213.
--                   Capturar este error. La otra sesión (Sesión 2) podría completar su UPDATE.

-- **PASO 7 (LIMPIEZA - EJECUTAR EN AMBAS SESIONES):** Deshacer cambios y restaurar modo auto-commit.
-- ROLLBACK; -- Deshace los cambios realizados en cada transacción.
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- Opcional: Asegura volver al nivel por defecto.
-- SELECT 'Paso 7 (Ambas): Rollback realizado. Vuelve a modo Auto-Commit en DBeaver.' AS Estado;
-- (En DBeaver: Base de Datos -> Modo de transacción -> Auto)


-- -----------------------------------------
-- TAREA 2: PRUEBA DE DEADLOCK CON PROCEDIMIENTO 'transferir_area'
-- -----------------------------------------
-- Objetivo: Verificar que el procedimiento 'transferir_area' (creado en 08_transacciones.sql)
--           detecta un deadlock, registra el error, reintenta y completa la operación.
-- Preparación: Asegurarse de que exista el empleado con id = 3.
--              Abrir DOS sesiones, ambas en "Manual Commit".
--              Limpiar la tabla de errores: TRUNCATE TABLE registro_errores;

-- == PASOS A EJECUTAR INTERCALADAMENTE ==

-- **PASO 1 (EJECUTAR EN Sesión 1):** Iniciar transacción y bloquear la fila del 'legajo' del empleado 3.
-- START TRANSACTION;
-- UPDATE legajo SET observaciones = 'Bloqueo manual para prueba de retry' WHERE empleado_id = 3;
-- SELECT 'Paso 1 (S1): Fila en legajo (empleado_id=3) bloqueada.' AS Estado; -- Debe dar 1 row modified

-- **PASO 2 (EJECUTAR EN Sesión 2):** Llamar al procedimiento 'transferir_area' para el empleado 3.
--                     El procedimiento iniciará su transacción, actualizará 'empleado' (éxito),
--                     pero se quedará ESPERANDO al intentar actualizar 'legajo' (bloqueado por Sesión 1).
-- CALL transferir_area(3, 'Marketing Retry', 'Transferencia con posible deadlock');
-- SELECT 'Paso 2 (S2): Llamando al procedimiento... (esperando bloqueo en legajo)' AS Estado;

-- **PASO 3 (EJECUTAR EN Sesión 1):** Intentar bloquear la fila 'empleado' del id 3.
--                     Como Sesión 2 (el procedimiento) ya bloqueó esta fila al inicio de su transacción,
--                     esta acción provocará el DEADLOCK. MySQL sacrificará una transacción.
-- UPDATE empleado SET area = 'Recursos Humanos Temporal Retry' WHERE id = 3;
-- SELECT 'Paso 3 (S1): Intentando bloquear empleado... (causando deadlock)' AS Estado;

-- **Resultado esperado:** Es probable que la Sesión 1 falle con ERROR 1213.
--                   La Sesión 2 (el procedimiento) detectará el deadlock a través de su HANDLER,
--                   hará ROLLBACK interno, esperará (SLEEP), e iniciará el REINTENTO.
--                   Como la Sesión 1 falló y liberó su bloqueo sobre 'legajo', el reintento
--                   del procedimiento debería tener éxito.

-- **PASO 4 (VERIFICACIÓN Y LIMPIEZA):**
-- En Sesión 1:
-- ROLLBACK; -- Deshacer el bloqueo manual (si no falló)
-- SELECT 'Paso 4 (S1): Rollback realizado.' AS Estado;
-- En Sesión 2:
-- SELECT 'Paso 4 (S2): El procedimiento debería haber terminado (con éxito o fallo post-reintentos).' AS Estado;
-- -- Verificar la tabla de errores (debería mostrar el deadlock registrado por el handler)
-- SELECT * FROM registro_errores ORDER BY fecha DESC;
-- -- Verificar los datos del empleado 3 (deberían reflejar la transferencia exitosa del procedimiento)
-- SELECT id, area FROM empleado WHERE id = 3; -- Debería ser 'Marketing Retry'
-- SELECT empleado_id, observaciones FROM legajo WHERE empleado_id = 3; -- Debería incluir 'Transferencia con posible deadlock'
-- -- Limpieza final (ejecutar en AMBAS sesiones)
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- Poner modo transacción en "Auto" en DBeaver.


-- -----------------------------------------
-- TAREA 3: COMPARACIÓN DE NIVELES DE AISLAMIENTO
-- -----------------------------------------
-- Objetivo: Observar fenómenos como Lectura Sucia (Dirty Read) bajo diferentes
--           niveles de aislamiento para entender sus implicaciones.
-- Preparación: Abrir DOS sesiones. Asegurarse de que exista empleado id = 2.
--              Poner ambas sesiones en modo "Auto Commit" inicialmente.

-- == EJEMPLO 1: READ UNCOMMITTED (Permite Lectura Sucia) ==

-- **PASO 1 (EJECUTAR EN Sesión 1):** Establecer nivel, iniciar transacción, modificar SIN commit.
-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- SELECT @@TRANSACTION_ISOLATION AS Nivel_S1; -- Verifica que cambió
-- START TRANSACTION;
-- UPDATE empleado SET area = 'Marketing Sucio' WHERE id = 2; -- Modifica temporalmente el área
-- SELECT 'Paso 1 (S1): Área modificada a Marketing Sucio (sin commit).' AS Estado;

-- **PASO 2 (EJECUTAR EN Sesión 2):** Establecer MISMO nivel, iniciar transacción, LEER el dato.
-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- SELECT @@TRANSACTION_ISOLATION AS Nivel_S2; -- Verifica que cambió
-- START TRANSACTION;
-- SELECT id, nombre, apellido, area FROM empleado WHERE id = 2;
-- SELECT 'Paso 2 (S2): Leyendo datos...' AS Estado;
-- Resultado esperado: Debería mostrar 'Marketing Sucio' (¡Lectura Sucia!). La Sesión 2 ve un cambio no confirmado.

-- **PASO 3 (EJECUTAR EN Sesión 1):** Deshacer el cambio con ROLLBACK.
-- ROLLBACK;
-- SELECT 'Paso 3 (S1): Rollback realizado.' AS Estado;
-- -- Verificar que el valor volvió al original en Sesión 1
-- SELECT id, nombre, apellido, area FROM empleado WHERE id = 2; -- Debería mostrar el área original (ej. 'Tecnología')

-- **PASO 4 (EJECUTAR EN Sesión 2):** Volver a leer el dato.
-- SELECT id, nombre, apellido, area FROM empleado WHERE id = 2;
-- SELECT 'Paso 4 (S2): Leyendo datos de nuevo...' AS Estado;
-- Resultado esperado: Ahora muestra el área original. La lectura anterior fue "sucia" (vio un dato que nunca se confirmó).
-- ROLLBACK; -- Terminar transacción Sesión 2


-- == EJEMPLO 2: SERIALIZABLE (Máxima Consistencia, previene Lectura Sucia) ==
-- Limpieza previa (ejecutar en ambas sesiones):
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- Volver al default
-- SELECT @@TRANSACTION_ISOLATION AS Nivel_Actual;

-- **PASO 1 (EJECUTAR EN Sesión 1):** Establecer nivel, iniciar transacción, modificar SIN commit.
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SELECT @@TRANSACTION_ISOLATION AS Nivel_S1;
-- START TRANSACTION;
-- UPDATE empleado SET area = 'Marketing Serializable' WHERE id = 2;
-- SELECT 'Paso 1 (S1): Área modificada a Marketing Serializable (sin commit).' AS Estado;
-- -- Leer dentro de la misma transacción SÍ ve el cambio
-- SELECT id, nombre, apellido, area FROM empleado WHERE id = 2; -- Muestra 'Marketing Serializable'

-- **PASO 2 (EJECUTAR EN Sesión 2):** Establecer MISMO nivel, iniciar transacción, intentar LEER el dato.
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SELECT @@TRANSACTION_ISOLATION AS Nivel_S2;
-- START TRANSACTION;
-- SELECT id, nombre, apellido, area FROM empleado WHERE id = 2;
-- SELECT 'Paso 2 (S2): Intentando leer datos...' AS Estado;
-- Resultado esperado: Esta consulta SELECT podría quedarse ESPERANDO (bloqueada por el UPDATE de Sesión 1)
--                   o podría mostrar el valor ANTERIOR ('Tecnología'?), pero NUNCA mostrará 'Marketing Serializable'.
--                   SERIALIZABLE previene la lectura sucia.

-- **PASO 3 (EJECUTAR EN Sesión 1):** Terminar la transacción (confirmar o deshacer).
-- COMMIT; -- Confirmar el cambio a 'Marketing Serializable'
-- -- Opcional: ROLLBACK; -- Deshacer el cambio
-- SELECT 'Paso 3 (S1): Transacción terminada.' AS Estado;

-- **PASO 4 (EJECUTAR EN Sesión 2):** Observar el resultado del SELECT.
-- SELECT 'Paso 4 (S2): La consulta SELECT ahora debería completarse (si estaba esperando).' AS Estado;
-- Resultado esperado: Mostrará el valor que la Sesión 1 confirmó con COMMIT (o el original si hizo ROLLBACK).
-- COMMIT; -- Terminar transacción Sesión 2

-- **PASO 5 (LIMPIEZA FINAL - EJECUTAR EN AMBAS SESIONES):** Volver al nivel por defecto.
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- SELECT @@TRANSACTION_ISOLATION AS Nivel_Final;
-- SELECT 'Paso 5 (Ambas): Nivel de aislamiento restaurado a REPEATABLE READ.' AS Estado;

-- --------------------------------------------------------------------
-- Fin del script 09_concurrencia_guiada.sql
-- --------------------------------------------------------------------

