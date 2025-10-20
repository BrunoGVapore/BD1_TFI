Inserción Válida N°1:

INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area) 
VALUES ('Carlos', 'Sanchez', '30123456', 'carlos.sanchez@empresa.com', '2022-05-10', 'Tecnología');

-- Asumiendo que el ID del empleado anterior es 1
INSERT INTO legajo (nroLegajo, categoria, estado, fechaAlta, empleado_id) 
VALUES ('L001', 'Desarrollador Semi-Senior', 'ACTIVO', '2022-05-10', 1);

Inserción Válida N°2:

INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area) 
VALUES ('Ana', 'Rodriguez', '32987654', 'ana.rodriguez@empresa.com', '2023-01-20', 'Administración');

-- Asumiendo que el ID del empleado anterior es 2
INSERT INTO legajo (nroLegajo, categoria, estado, fechaAlta, empleado_id) 
VALUES ('L002', 'Asistente Administrativa', 'ACTIVO', '2023-01-20', 2);


Inserción Errónea N°1: Violación de Restricción UNIQUE: Intentamos insertar un nuevo empleado con un DNI que ya existe (30123456). Esto debería activar el error de clave única.

INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area) 
VALUES ('Laura', 'Gomez', '30123456', 'laura.gomez@empresa.com', '2024-02-15', 'Ventas');

SQL Error [1062] [23000]: (conn=16) Duplicate entry '30123456' for key 'dni'


Inserción Errónea N°2: Violación de Restricción CHECK: Ahora, intentamos insertar un empleado con un formato de email incorrecto (le falta el @). Esto debería activar el error de la restricción CHECK.

INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area) 
VALUES ('Jorge', 'Martinez', '35111222', 'jorge.martinez.empresa.com', '2024-03-01', 'Soporte');

Mensaje de error esperado (MySQL): Check constraint 'chk_email_formato' is violated.

SQL Error [4025] [23000]: (conn=16) CONSTRAINT `chk_email_formato` failed for `empleados`.`empleado`

