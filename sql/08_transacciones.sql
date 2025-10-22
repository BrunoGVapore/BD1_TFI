-- --------------------------------------------------------------------
-- Archivo: 08_transacciones.sql
-- TFI - Bases de Datos I

-- Propósito: Este script, perteneciente a la Etapa 5, configura las transacciones de la base de datos empleados,
--            creando tablas para registrar transacciones, generando procedimientos almacenados para
--            registrar y consultar transacciones y estableciendo restricciones para garantizar la integridad de los datos.
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

