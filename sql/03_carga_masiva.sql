USE empleados;

--      POBLANDO LA TABLA `empleado`
INSERT INTO empleado (nombre, apellido, dni, email, fechaIngreso, area)
WITH seq AS (
   -- Generamos una secuencia de números que nos servirá como base para crear datos únicos.
   SELECT (ROW_NUMBER() OVER ()) AS n
   FROM information_schema.columns a, information_schema.columns b
   LIMIT 400000 -- Límite de empleados a generar
)
SELECT
   (SELECT nombre FROM nombres_semilla ORDER BY RAND() LIMIT 1),
   (SELECT apellido FROM apellidos_semilla ORDER BY RAND() LIMIT 1),
   CONCAT(CAST(FLOOR(10000000 + RAND() * 90000000) AS CHAR), s.n),
   LOWER(CONCAT(
       (SELECT nombre FROM nombres_semilla ORDER BY RAND() LIMIT 1), '.',
       (SELECT apellido FROM apellidos_semilla ORDER BY RAND() LIMIT 1), s.n,
       '@empresa.com'
   )),
   CURDATE() - INTERVAL FLOOR(RAND() * 3650) DAY,
   (SELECT area FROM areas_semilla ORDER BY RAND() LIMIT 1)
FROM
   seq s;
--      POBLANDO LA TABLA `legajo`
INSERT INTO legajo (nroLegajo, categoria, estado, fechaAlta, observaciones, empleado_id)
SELECT
   CONCAT('LEG-', LPAD(e.id, 6, '0')),
   (SELECT categoria FROM categorias_semilla ORDER BY RAND() LIMIT 1),
   IF(RAND() < 0.9, 'ACTIVO', 'INACTIVO'),
   e.fechaIngreso,
   'Legajo creado automáticamente.',
   e.id
FROM
   empleado e
WHERE
   e.eliminado = FALSE;
