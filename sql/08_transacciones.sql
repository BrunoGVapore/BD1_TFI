-- --------------------------------------------------------------------
-- Archivo: 08_transacciones.sql
-- TFI - Bases de Datos I

-- Propósito: Este script, perteneciente a la Etapa 5, crea una tabla de registro de errores y un procedimiento llamado
--            "transferir_area" el cual contiene una transacción y dos HANDLERS de errores, uno para Deadlocks y otro general.
--            También contiene una simulación de un error general, para el error de Deadlock ver 09_concurrencia_guiada.sql
-- --------------------------------------------------------------------

USE empleados;

-- Tabla de registro de errores
CREATE TABLE IF NOT EXISTS registro_errores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mensaje VARCHAR(200)
);

DELIMITER $$

CREATE PROCEDURE transferir_area(
    IN transferir_empleado_id INT,
    IN nueva_area VARCHAR(30),
    IN observacion VARCHAR(200)
)
BEGIN
    DECLARE intentos INT DEFAULT 0;
    DECLARE max_intentos INT DEFAULT 2;
    DECLARE continuar INT DEFAULT 1;

    -- Handler para DEADLOCK (1213)
    DECLARE CONTINUE HANDLER FOR 1213
    BEGIN
        ROLLBACK;
        SET autocommit = 1;
        INSERT INTO registro_errores (mensaje)
        VALUES ('Error de Deadlock (1213)');
        SET autocommit = 0;
        SET intentos = intentos + 1;
        DO SLEEP(1 + RAND());
    END;

    -- Handler para cualquier otro error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET autocommit = 1;
        INSERT INTO registro_errores (mensaje)
        VALUES ('Error General');
        SET autocommit = 0;
        SET continuar = 0;
    END;

    -- Bucle de reintentos
    bucle_intentos: WHILE intentos <= max_intentos AND continuar = 1 DO
        START TRANSACTION;

        UPDATE empleado
        SET area = nueva_area
        WHERE id = transferir_empleado_id;

        UPDATE legajo
        SET observaciones = CONCAT(IFNULL(observaciones, ''), ' | ', observacion)
        WHERE empleado_id = transferir_empleado_id;

        COMMIT;

        SET continuar = 0;
    END WHILE bucle_intentos;

END$$

DELIMITER ;

-- Llamamos al procedimiento de la siguiente manera:
CALL transferir_area(1234, 'Tecnologia', 'El empleado se transfiere de área, actualizar salario');

-- Simulación de un error general en el procedimiento para el registro:
RENAME TABLE legajo TO legajo_temp;
CALL transferir_area(1234, 'Finanzas', 'Cambio de prueba');
RENAME TABLE legajo_temp TO legajo;

-- Para ver el listado de errores generados en orden descendente por fecha usamos:
SELECT * FROM registro_errores ORDER BY fecha DESC;





