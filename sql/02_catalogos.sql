-- --------------------------------------------------------------------
-- Archivo: 02_catalogos.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Crea y puebla las tablas auxiliares ("semilla" o catálogos)
--            que servirán como fuente de valores aleatorios para la
--            carga masiva de datos en las tablas principales ('empleado', 'legajo').
--            Es idempotente (se puede re-ejecutar sin errores gracias a
--            DROP TABLE IF EXISTS).
-- --------------------------------------------------------------------

-- Asegura que estamos trabajando en la base de datos correcta
USE empleados;

-- Eliminar tablas semilla si existen para permitir una re-ejecución limpia del script
DROP TABLE IF EXISTS nombres_semilla;
DROP TABLE IF EXISTS apellidos_semilla;
DROP TABLE IF EXISTS areas_semilla;
DROP TABLE IF EXISTS categorias_semilla;

-- -----------------------------------------
-- Tabla 'nombres_semilla'
-- Contiene una lista de nombres comunes para asignar aleatoriamente.
-- -----------------------------------------
CREATE TABLE nombres_semilla (
    nombre VARCHAR(80) -- Columna para almacenar nombres
) COMMENT='Catálogo de nombres para generación masiva.'; -- Comentario de tabla

-- Insertar una lista inicial de nombres
INSERT INTO nombres_semilla (nombre) VALUES
('Juan'), ('Sofía'), ('Mateo'), ('Valentina'), ('Lucas'), ('Camila'),
('Martín'), ('Isabella'), ('Daniel'), ('Julieta'), ('Agustín'), ('Micaela');

-- -----------------------------------------
-- Tabla 'apellidos_semilla'
-- Contiene una lista de apellidos frecuentes para asignar aleatoriamente.
-- -----------------------------------------
CREATE TABLE apellidos_semilla (
    apellido VARCHAR(80) -- Columna para almacenar apellidos
) COMMENT='Catálogo de apellidos para generación masiva.'; -- Comentario de tabla

-- Insertar una lista inicial de apellidos
INSERT INTO apellidos_semilla (apellido) VALUES
('García'), ('Martínez'), ('Rodríguez'), ('López'), ('González'), ('Pérez'),
('Sánchez'), ('Romero'), ('Díaz'), ('Fernández'), ('Gómez'), ('Torres');

-- -----------------------------------------
-- Tabla 'areas_semilla'
-- Define las áreas funcionales válidas dentro de la empresa.
-- -----------------------------------------
CREATE TABLE areas_semilla (
    area VARCHAR(50) -- Columna para almacenar nombres de áreas
) COMMENT='Catálogo de áreas para generación masiva.'; -- Comentario de tabla

-- Insertar una lista inicial de áreas
INSERT INTO areas_semilla (area) VALUES
('Tecnología'), ('Recursos Humanos'), ('Marketing'), ('Ventas'), ('Finanzas');

-- -----------------------------------------
-- Tabla 'categorias_semilla'
-- Establece las categorías contractuales o puestos posibles.
-- -----------------------------------------
CREATE TABLE categorias_semilla (
    categoria VARCHAR(30) -- Columna para almacenar nombres de categorías
) COMMENT='Catálogo de categorías para generación masiva.'; -- Comentario de tabla

-- Insertar una lista inicial de categorías
INSERT INTO categorias_semilla (categoria) VALUES
('Junior'), ('Semi-Senior'), ('Senior'), ('Gerente'), ('Analista');

-- --------------------------------------------------------------------
-- Fin del script 02_catalogos.sql
-- --------------------------------------------------------------------

