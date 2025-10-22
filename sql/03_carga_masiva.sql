-- --------------------------------------------------------------------
-- Archivo: 03_carga_masiva.sql
-- TFI - Bases de Datos I
-- Grupo 10: Empleado - Legajo

-- Propósito: Utiliza los datos de los catálogos (creados en 02_catalogos.sql)
--            para poblar las tablas principales ('empleado', 'legajo') con
--            un volumen masivo de registros (400,000).
--            Genera DNI y email únicos, fechas aleatorias y aplica un sesgo
--            en el estado del legajo para simular datos más realistas.

-- IMPORTANTE: Ejecutar DESPUÉS de 01_esquema.sql y 02_catalogos.sql.
--             Asegurarse de que las tablas principales estén vacías antes
--             para evitar errores de clave duplicada (PK, UNIQUE).
-- --------------------------------------------------------------------

USE empleados;

-- -----------------------------------------
-- POBLANDO LA TABLA `empleado` (400,000 registros)
-- -----------------------------------------
-- Se utiliza una CTE (Common Table Expression) llamada 'seq' para generar una
-- secuencia de números del 1 al 400,000. Esta secuencia se usa para asegurar
-- la unicidad de DNI y email.
INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area)
WITH seq AS (
    -- Genera una secuencia de números usando ROW_NUMBER() sobre un producto cartesiano
    -- de una tabla del sistema (information_schema.columns) para obtener suficientes filas base.
    SELECT (ROW_NUMBER() OVER ()) AS n -- Asigna un número secuencial a cada fila generada
    FROM information_schema.columns a
    CROSS JOIN information_schema.columns b -- Usamos CROSS JOIN explícito para combinar filas
    LIMIT 400000 -- Limita el número total de filas (y por ende, empleados) a generar
)
SELECT
    -- Selecciona un nombre aleatorio de la tabla 'nombres_semilla'
    (SELECT nombre FROM nombres_semilla ORDER BY RAND() LIMIT 1),
    -- Selecciona un apellido aleatorio de la tabla 'apellidos_semilla'
    (SELECT apellido FROM apellidos_semilla ORDER BY RAND() LIMIT 1),
    -- Genera un DNI único concatenando un número aleatorio de 8 dígitos con el número de secuencia 'n'.
    -- Esto garantiza la unicidad incluso si la parte aleatoria se repite. El formato resultante no es estándar.
    CONCAT(CAST(FLOOR(10000000 + RAND() * 90000000) AS CHAR), s.n),
    -- Genera un email único y en minúsculas concatenando nombres/apellidos aleatorios, la secuencia 'n' y el dominio.
    LOWER(CONCAT(
        (SELECT nombre FROM nombres_semilla ORDER BY RAND() LIMIT 1), '.',
        (SELECT apellido FROM apellidos_semilla ORDER BY RAND() LIMIT 1), s.n,
        '@empresa.com'
    )),
    -- Genera una fecha de ingreso aleatoria restando un número aleatorio de días (0 a 3649) a la fecha actual.
    CURDATE() - INTERVAL FLOOR(RAND() * 3650) DAY,
    -- Selecciona un área aleatoria de la tabla 'areas_semilla'
    (SELECT area FROM areas_semilla ORDER BY RAND() LIMIT 1)
FROM
    seq s; -- Usa la secuencia generada en la CTE 'seq' como base para cada fila de empleado

-- -----------------------------------------
-- POBLANDO LA TABLA `legajo` (400,000 registros)
-- Se inserta exactamente un legajo por cada empleado creado en el paso anterior,
-- asegurando la relación 1 a 1 y la integridad referencial.
-- -----------------------------------------
INSERT INTO legajo (nroLegajo, categoria, estado, fechaAlta, observaciones, empleado_id)
SELECT
    -- Genera un número de legajo formateado (ej. 'LEG-000001') usando el ID del empleado y LPAD para rellenar con ceros.
    CONCAT('LEG-', LPAD(e.id, 6, '0')),
    -- Selecciona una categoría aleatoria de la tabla 'categorias_semilla'
    (SELECT categoria FROM categorias_semilla ORDER BY RAND() LIMIT 1),
    -- Asigna estado 'ACTIVO' con una probabilidad del 90% y 'INACTIVO' con 10%, usando IF y RAND().
    IF(RAND() < 0.9, 'ACTIVO', 'INACTIVO'),
    -- Reutiliza la fecha de ingreso del empleado como fecha de alta administrativa del legajo.
    e.fechaIngreso,
    -- Texto de observación por defecto para todos los legajos creados masivamente.
    'Legajo creado automáticamente.',
    -- Asigna el ID del empleado (e.id) como clave foránea, vinculando el legajo al empleado correcto.
    e.id
FROM
    empleado e -- Selecciona de la tabla 'empleado' recién poblada
WHERE
    e.eliminado = FALSE; -- Asegura que solo se creen legajos para empleados no marcados como eliminados lógicamente.

-- --------------------------------------------------------------------
-- Fin del script 03_carga_masiva.sql
-- --------------------------------------------------------------------

