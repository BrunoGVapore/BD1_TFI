USE empleados;

-- Se eliminan las tablas semilla para poder re-ejecutar el script sin errores
DROP TABLE IF EXISTS nombres_semilla;
DROP TABLE IF EXISTS apellidos_semilla;
DROP TABLE IF EXISTS areas_semilla;
DROP TABLE IF EXISTS categorias_semilla;

-- Creación y carga de la tabla de nombres
CREATE TABLE nombres_semilla (nombre VARCHAR(80));
INSERT INTO nombres_semilla (nombre) VALUES
('Juan'), ('Sofía'), ('Mateo'), ('Valentina'), ('Lucas'), ('Camila'),
('Martín'), ('Isabella'), ('Daniel'), ('Julieta'), ('Agustín'), ('Micaela');

-- Creación y carga de la tabla de apellidos
CREATE TABLE apellidos_semilla (apellido VARCHAR(80));
INSERT INTO apellidos_semilla (apellido) VALUES
('García'), ('Martínez'), ('Rodríguez'), ('López'), ('González'), ('Pérez'),
('Sánchez'), ('Romero'), ('Díaz'), ('Fernández'), ('Gómez'), ('Torres');

-- Creación y carga de la tabla de áreas
CREATE TABLE areas_semilla (area VARCHAR(50));
INSERT INTO areas_semilla (area) VALUES
('Tecnología'), ('Recursos Humanos'), ('Marketing'), ('Ventas'), ('Finanzas');

-- Creación y carga de la tabla de categorías
CREATE TABLE categorias_semilla (categoria VARCHAR(30));
INSERT INTO categorias_semilla (categoria) VALUES
('Junior'), ('Semi-Senior'), ('Senior'), ('Gerente'), ('Analista');
