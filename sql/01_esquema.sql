-- --------------------------------------------------------------------
-- Archivo: 01_esquema.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Crea la base de datos 'empleados' y define la estructura
--            de las tablas principales (empleado, legajo) con sus
--            claves primarias, foráneas y restricciones de integridad
--            (UNIQUE, CHECK, ENUM, NOT NULL).
--            Establece la relación 1 a 1 entre empleado y legajo.
--            Es idempotente (se puede re-ejecutar sin errores).
-- --------------------------------------------------------------------

-- Crear la base de datos si no existe para evitar errores en ejecuciones posteriores
CREATE DATABASE IF NOT EXISTS empleados;

-- Seleccionar la base de datos 'empleados' para trabajar en ella
USE empleados;

-- Eliminar tablas en orden inverso de dependencia (primero 'legajo', luego 'empleado')
-- si existen, para permitir una re-creación limpia del esquema.
DROP TABLE IF EXISTS legajo;
DROP TABLE IF EXISTS empleado;

-- -----------------------------------------
-- Tabla 'empleado'
-- Almacena datos personales y de ingreso del empleado.
-- -----------------------------------------
CREATE TABLE empleado (
    -- Clave primaria autoincremental para identificar unívocamente cada empleado.
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único del empleado',
    -- Indicador booleano para borrado lógico. Permite ocultar registros sin eliminarlos físicamente.
    eliminado BOOLEAN DEFAULT FALSE COMMENT 'Marca de borrado lógico (TRUE si está eliminado)',
    -- Nombre del empleado, obligatorio.
    nombre VARCHAR(80) NOT NULL COMMENT 'Nombre del empleado',
    -- Apellido del empleado, obligatorio.
    apellido VARCHAR(80) NOT NULL COMMENT 'Apellido del empleado',
    -- Documento Nacional de Identidad. Es obligatorio y debe ser único en toda la tabla.
    dni VARCHAR(15) NOT NULL UNIQUE COMMENT 'Documento Nacional de Identidad, único por empleado',
    -- Correo electrónico. Es único si se proporciona, pero puede ser nulo.
    email VARCHAR(150) UNIQUE COMMENT 'Correo electrónico, único (si se provee)',
    -- Restricción CHECK para asegurar un formato básico de email (contiene '@' y '.'). Permite nulos.
    CONSTRAINT chk_email_formato CHECK (email LIKE '%@%.%' OR email IS NULL) COMMENT 'Validación básica del formato de email',
    -- Fecha en que el empleado ingresó contractualmente a la empresa.
    fechaIngreso DATE COMMENT 'Fecha de ingreso contractual del empleado a la empresa',
    -- Área o departamento funcional al que pertenece el empleado.
    area VARCHAR(50) COMMENT 'Área o departamento al que pertenece el empleado'
) COMMENT='Tabla principal que contiene los datos de los empleados.'; -- Comentario a nivel de tabla

-- -----------------------------------------
-- Tabla 'legajo'
-- Almacena datos administrativos y estado contractual del empleado.
-- Relacionada estrictamente 1 a 1 con la tabla 'empleado'.
-- -----------------------------------------
CREATE TABLE legajo (
    -- Clave primaria autoincremental para identificar unívocamente cada legajo.
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único del legajo',
    -- Indicador booleano para borrado lógico del legajo.
    eliminado BOOLEAN DEFAULT FALSE COMMENT 'Marca de borrado lógico',
    -- Número de legajo administrativo. Es obligatorio y único.
    nroLegajo VARCHAR(20) NOT NULL UNIQUE COMMENT 'Número de legajo administrativo, único',
    -- Categoría o puesto asignado al empleado.
    categoria VARCHAR(30) COMMENT 'Categoría o puesto del empleado',
    -- Estado contractual del legajo. Solo puede ser 'ACTIVO' o 'INACTIVO', y es obligatorio.
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL COMMENT 'Estado contractual actual del empleado',
    -- Fecha en que se registró administrativamente el legajo en el sistema.
    fechaAlta DATE COMMENT 'Fecha de alta administrativa del legajo en el sistema',
    -- Campo de texto libre para anotaciones o comentarios sobre el legajo.
    observaciones VARCHAR(255) COMMENT 'Campo para notas o comentarios adicionales',
    -- Clave foránea que referencia al 'id' de la tabla 'empleado'. Es obligatoria y única.
    -- La restricción UNIQUE aquí es crucial para forzar la relación 1 a 1.
    empleado_id BIGINT UNIQUE NOT NULL COMMENT 'Clave foránea que referencia al empleado asociado (UNIQUE asegura 1 a 1)',
    -- Definición de la clave foránea.
    FOREIGN KEY (empleado_id)
        REFERENCES empleado(id) -- Apunta a la clave primaria de la tabla 'empleado'.
        -- Si un registro de 'empleado' se elimina, el registro correspondiente en 'legajo'
        -- se eliminará automáticamente en cascada, manteniendo la integridad referencial.
        ON DELETE CASCADE
) COMMENT='Tabla con datos administrativos del legajo, relacionada 1:1 con empleado.'; -- Comentario a nivel de tabla

-- --------------------------------------------------------------------
-- Fin del script 01_esquema.sql
-- --------------------------------------------------------------------

