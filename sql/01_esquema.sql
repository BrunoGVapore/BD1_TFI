CREATE DATABASE IF NOT EXISTS empleados;
USE empleados;

DROP TABLE IF EXISTS legajo; 
DROP TABLE IF EXISTS empleado;

CREATE TABLE empleado (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    eliminado BOOLEAN DEFAULT FALSE,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    dni VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(150),
    CONSTRAINT chk_email_formato CHECK (email LIKE '%@%.%' OR email IS NULL),
    fechaIngreso DATE,
    area VARCHAR(50)
);


CREATE TABLE legajo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    eliminado BOOLEAN DEFAULT FALSE,
    nroLegajo VARCHAR(20) NOT NULL UNIQUE,
    categoria VARCHAR(30),
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL,
    fechaAlta DATE,
    observaciones VARCHAR(255),
    empleado_id BIGINT UNIQUE NOT NULL,  
    FOREIGN KEY (empleado_id) REFERENCES empleado(id) ON DELETE CASCADE
);
