-- --------------------------------------------------------------------
-- Archivo: 08_transacciones.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Implementa la Tarea 2 de la Etapa 5: Transacciones con Retry.
--            1. Crea (si no existe) una tabla 'registro_errores' para logging.
--            2. Define el procedimiento almacenado 'transferir_area' que:
--               - Actualiza el área del empleado y agrega una observación
--                 al legajo de forma ATÓMICA (dentro de una transacción).
--               - Captura errores específicos de DEADLOCK (código 1213)
--                 usando un HANDLER específico.
--               - En caso de deadlock, realiza ROLLBACK, registra el error,
--                 espera un tiempo aleatorio corto (backoff) y REINTENTA
--                 la transacción hasta un máximo de 2 veces.
--               - Captura CUALQUIER OTRO error SQL usando un HANDLER general,
--                 realiza ROLLBACK y registra el error como fatal.
--            3. Incluye las consultas de prueba para verificar
--               el funcionamiento normal, el manejo de deadlocks y de errores generales.

-- Ejecución: Este script debe ejecutarse con un usuario con privilegios
--            administrativos (ej. 'root'). Las pruebas comentadas deben
--            ejecutarse por separado.
-- --------------------------------------------------------------------

USE empleados;

-- -----------------------------------------
-- 1. TABLA PARA LOGGING DE ERRORES
-- -----------------------------------------
-- Crear tabla si no existe para almacenar información sobre los errores
-- capturados dentro del procedimiento almacenado.
CREATE TABLE IF NOT EXISTS registro_errores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora exactas en que ocurrió el error',
    codigo_error INT COMMENT 'Código numérico del error SQL (ej. 1213 para Deadlock)',
    mensaje VARCHAR(255) COMMENT 'Descripción breve y clara del error o evento',
    detalle TEXT COMMENT 'Mensaje de error completo devuelto por MySQL (opcional, útil para depuración)'
) COMMENT='Tabla para registrar errores detectados en procedimientos almacenados, especialmente deadlocks.';

-- Opcional: Limpiar la tabla de errores antes de cada ejecución de prueba para empezar de cero
-- TRUNCATE TABLE registro_errores;

-- -----------------------------------------
-- 2. PROCEDIMIENTO ALMACENADO CON TRANSACCIÓN Y LÓGICA DE REINTENTOS
-- -----------------------------------------

-- Eliminar el procedimiento si ya existe para permitir re-creación limpia
DROP PROCEDURE IF EXISTS transferir_area;

-- Cambiar el delimitador de SQL de ';' a '$$' para poder usar ';' dentro del cuerpo del procedimiento
DELIMITER $$

-- Definición del procedimiento almacenado 'transferir_area'
-- CORREGIDO: Se eliminó la línea COMMENT='...' que causaba error 1064 en algunas configuraciones.
CREATE PROCEDURE transferir_area(
    IN p_empleado_id BIGINT,         -- Parámetro de entrada: ID del empleado a transferir
    IN p_nueva_area VARCHAR(50),     -- Parámetro de entrada: Nueva área a asignar
    IN p_observacion VARCHAR(255)    -- Parámetro de entrada: Observación a añadir al legajo
)
BEGIN
    -- Variables locales para controlar el bucle de reintentos
    DECLARE v_intentos INT DEFAULT 0;       -- Contador de intentos realizados (inicia en 0)
    DECLARE v_max_intentos INT DEFAULT 2;   -- Número máximo de REintentos (total 3 ejecuciones: 0, 1, 2)
    DECLARE v_es_deadlock BOOLEAN DEFAULT FALSE; -- Bandera para indicar si el error fue un deadlock

    -- === MANEJADORES DE ERRORES (HANDLERS) ===

    -- Handler específico para DEADLOCK (Código SQL 1213)
    -- Se activa automáticamente SOLO si MySQL detecta un deadlock (error 1213).
    -- Usa 'CONTINUE' para permitir que el flujo continúe en el bucle después del handler.
    DECLARE CONTINUE HANDLER FOR 1213
    BEGIN
        -- Obtener el mensaje de error específico del deadlock para el log
        DECLARE v_error_message TEXT;
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;

        -- Marcar la bandera para indicar que ocurrió un deadlock
        SET v_es_deadlock = TRUE;
        -- Registrar el deadlock en la tabla 'registro_errores'
        INSERT INTO registro_errores (codigo_error, mensaje, detalle)
        VALUES (1213, CONCAT('Deadlock detectado en intento ', v_intentos + 1), v_error_message);
        -- Deshacer los cambios de la transacción fallida por deadlock
        ROLLBACK;
        -- El flujo continúa automáticamente al bucle WHILE gracias a 'CONTINUE'
    END;

    -- Handler general para CUALQUIER OTRO error SQL (SQLEXCEPTION)
    -- Se activa si ocurre cualquier error SQL que NO sea 1213 (ej. tabla no existe, dato inválido).
    -- Usa 'EXIT' para terminar la ejecución del procedimiento después del handler.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Obtener detalles del error SQL general ocurrido
        DECLARE v_error_code INT;
        DECLARE v_error_message TEXT;
        GET DIAGNOSTICS CONDITION 1
            v_error_code = MYSQL_ERRNO,
            v_error_message = MESSAGE_TEXT;

        -- Registrar el error general en la tabla 'registro_errores'
        INSERT INTO registro_errores (codigo_error, mensaje, detalle)
        VALUES (v_error_code, 'Error general SQL detectado', v_error_message);
        -- Deshacer los cambios de la transacción fallida
        ROLLBACK;
        -- El flujo termina aquí debido a 'EXIT'
    END;

    -- === BUCLE PRINCIPAL DE REINTENTOS ===
    -- El bucle se ejecuta como máximo v_max_intentos + 1 veces.
    retry_loop: WHILE v_intentos <= v_max_intentos DO

        -- Resetear la bandera de deadlock al inicio de cada nuevo intento
        SET v_es_deadlock = FALSE;

        -- Iniciar la transacción para este intento
        START TRANSACTION;

        -- Operación 1: Actualizar el área en la tabla 'empleado'
        UPDATE empleado
        SET area = p_nueva_area
        WHERE id = p_empleado_id;

        -- Operación 2: Agregar la observación a la columna 'observaciones' en 'legajo'
        -- Se usa CONCAT con IFNULL para añadir la nueva observación sin borrar las anteriores.
        UPDATE legajo
        SET observaciones = CONCAT(IFNULL(observaciones, ''), ' | ', p_observacion)
        WHERE empleado_id = p_empleado_id;

        -- Si ambas operaciones UPDATE se completan sin que salte ningún handler de error:
        -- Confirmar los cambios de forma permanente
        COMMIT;

        -- Si el COMMIT fue exitoso, la transacción terminó bien, salimos del bucle.
        -- SELECT 'Operación completada con éxito en intento ', v_intentos + 1 AS Resultado; -- Mensaje opcional para depuración
        LEAVE retry_loop;

        -- === LÓGICA POST-TRANSACCIÓN (SI OCURRIÓ DEADLOCK) ===
        -- Este bloque solo se alcanza si el HANDLER FOR 1213 se activó (v_es_deadlock = TRUE).
        IF v_es_deadlock THEN
            -- Incrementar el contador de intentos realizados
            SET v_intentos = v_intentos + 1;

            -- Verificar si aún quedan intentos permitidos
            IF v_intentos <= v_max_intentos THEN
                -- Aplicar Backoff: esperar un tiempo corto y aleatorio antes del siguiente intento.
                -- Espera entre 0.5 y 1.5 segundos para reducir la probabilidad de otro deadlock inmediato.
                DO SLEEP(0.5 + RAND());
                -- Continuar con la siguiente iteración del bucle para reintentar la transacción
                ITERATE retry_loop;
            ELSE
                -- Si ya se superó el número máximo de intentos, salir del bucle
                LEAVE retry_loop;
            END IF;
        END IF;
        -- Si ocurrió un error general, el EXIT HANDLER ya terminó el procedimiento.

    END WHILE retry_loop;

    -- === LÓGICA POST-BUCLE ===
    -- Se ejecuta después de salir del bucle (ya sea por éxito o por superar los reintentos de deadlock).
    -- Si salimos del bucle porque se superaron los intentos debido a deadlocks repetidos:
    IF v_intentos > v_max_intentos THEN
        -- Registrar el fallo final en la tabla de logs
        INSERT INTO registro_errores (mensaje)
        VALUES (CONCAT('Fallo final al transferir área para empleado_id ', p_empleado_id, ' después de ', v_intentos, ' intentos debido a deadlocks.'));
        -- SELECT 'Operación fallida definitivamente después de reintentos por deadlock.' AS ResultadoFinal; -- Mensaje opcional
    END IF;

END$$

-- Restaurar el delimitador de SQL a ';'
DELIMITER ;

-- -----------------------------------------
-- PRUEBAS DEL PROCEDIMIENTO (Comentadas - Ejecutar por separado como 'root')
-- -----------------------------------------

-- Prueba 1: Llamada normal (debe funcionar y no registrar errores)
-- (Asegurarse de que el empleado con id=3 exista y esté activo/no eliminado)
-- CALL transferir_area(3, 'Tecnologia Avanzada', 'Transferencia de prueba exitosa.');
-- Verificar cambios visualmente:
-- SELECT id, area FROM empleado WHERE id = 3;
-- SELECT empleado_id, observaciones FROM legajo WHERE empleado_id = 3;
-- SELECT * FROM registro_errores; -- Debería estar vacía


-- Prueba 2: Simulación de Deadlock (requiere 2 sesiones, ver guía en 09_concurrencia_guiada.sql)
-- Al simular el deadlock usando el script 09, este procedimiento (llamado desde Sesión 2)
-- debería registrar el error 1213 en 'registro_errores', esperar (SLEEP), reintentar y
-- (probablemente) tener éxito en el segundo intento.
-- Verificar tabla 'registro_errores' después de la simulación:
-- SELECT * FROM registro_errores ORDER BY fecha DESC; -- Debería mostrar al menos un registro del deadlock 1213.


-- Prueba 3: Simulación de Error General (ej. tabla renombrada temporalmente)
-- (Descomentar y ejecutar estas líneas para forzar un error SQL diferente a deadlock)
-- RENAME TABLE legajo TO legajo_temp; -- Renombrar tabla para causar error 'Table ... doesn't exist' (1146)
-- CALL transferir_area(2, 'Finanzas Temporal Error', 'Prueba de error general'); -- Esta llamada fallará y será capturada por el EXIT HANDLER
-- RENAME TABLE legajo_temp TO legajo; -- Restaurar el nombre original de la tabla
-- Verificar 'registro_errores' después de la simulación:
-- SELECT * FROM registro_errores ORDER BY fecha DESC; -- Debería mostrar 'Error general SQL detectado' con código 1146.


-- --------------------------------------------------------------------
-- Fin del script 08_transacciones.sql
-- --------------------------------------------------------------------

