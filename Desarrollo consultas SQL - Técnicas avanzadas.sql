
# TÉCNICAS AVANZADAS DE SQL


# 1. Usamos una cte para calcular el total de ventas de cada producto.

WITH ventas AS ( 
  SELECT idProducto, 
  SUM(precioUnitario * cantidad) AS ventas_totales
  FROM detalle_factura
  GROUP BY 1
)
SELECT p.idProducto, 
p.nombre, 
v.ventas_totales
FROM producto p
JOIN ventas v
 ON p.idProducto =v.idProducto;


# 2 .Aplicamos una 'window function' para calcular los promedios de los precios de ventas de producto.

WITH ventas AS ( 
  SELECT idProducto, 
  SUM(precioUnitario * cantidad) AS ventas_totales,
  AVG(precioUnitario) AS precio_medio
  FROM detalle_factura
  GROUP BY idProducto
)
SELECT p.idProducto, 
       p.nombre, 
       v.ventas_totales,
       v.precio_medio
FROM producto p
JOIN ventas v
ON p.idProducto = v.idProducto;


# 3. Escribimos una consulta recursiva para encontrar las categorias y sus subcategorías en una tabla jerárquica.

WITH RECURSIVE CTE AS (
  SELECT id, nombre, categoria_padre, nombre AS ruta
  FROM categoria
  WHERE categoria_padre IS NULL
  UNION ALL
  SELECT c.id, c.nombre, c.categoria_padre, CONCAT(cte.ruta, ' > ', c.nombre)
  FROM categoria c
  JOIN CTE ON c.categoria_padre = cte.id
)
SELECT * FROM CTE;

/* 
En esta consulta, categoría es la tabla que contiene la información de categorías y subcategorías. 
El CTE (Common Table Expression)se utiliza para realizar la consulta recursiva. 
La columna categoria_padre se utiliza para establecer la relación entre categorías y subcategorías. 
La consulta final selecciona todas las columnas del CTE.
*/


# 4. Usamos una cte para calcular el total de pedidos por cada cliente.

WITH pedidos AS (
  SELECT idCliente, 
  COUNT(idFactura) AS pedidos
  FROM factura 
  GROUP BY idCliente
)
SELECT p.idCliente, 
concat(nombre, ' ' , apellido) AS cliente,
pedidos
FROM cliente c
INNER JOIN pedidos p
ON c.idCliente=p.idCliente;

# 5. Aplicamos una 'window function' para calcular la media de precio y el máximo precio de cada categoría.

SELECT
c.nombre AS categoria,
MAX(precioUnitario) AS maximo_precio,
AVG(precioUnitario) AS precio_medio
FROM producto p 
INNER JOIN categoria c
ON p.idCategoria=c.idCategoria
GROUP BY categoria;

# Ejemplo con función OVER()
SELECT 
  idProducto,
  nombre,
  precioUnitario,
  AVG(precioUnitario) OVER (PARTITION BY idProducto) AS media_precio,
  MAX(precioUnitario) OVER (PARTITION BY idProducto) AS max_precio 
  # OVER se utiliza para aplicar las funciones de agregación a particiones de datos definidas por idProducto. 
FROM 
  producto;
  
  # Ejemplo anterior con función de ventana OVER()
SELECT DISTINCT c.nombre AS categoria,
MAX(precioUnitario) OVER( partition by c.nombre) AS maximo_precio,
AVG(precioUnitario) OVER( partition by c.nombre) AS precio_medio
FROM producto p 
INNER JOIN categoria c
ON p.idCategoria=c.idCategoria;


# 6. Escribimos una consulta recursiva para encontrar todos los empleados y sus jefes directos en una tabla jeráquica.
  
  WITH RECURSIVE jefes_empleados AS (
   SELECT idEmpleado,nombre,manager_id, 0 AS nivel
   FROM empleado
   WHERE manager_id IS NULL-- Encuentra el empleado superior o de nivel superior
   UNION ALL
   SELECT e.idEmpleado,e.nombre, e.manager_id,j.nivel +1
   FROM empleado e 
   JOIN jefes_empleados j
   ON e.manager_id=j.idEmpleado 
   )
   SELECT * FROM jefes_empleados;
   

# 7. Aplicamos una 'window function' para calcular el mínimo y el máximo de las cantidades pedidas de cada mes.
  
SELECT DISTINCT MONTH (fecha) AS mes,
       MIN(cantidad) OVER(PARTITION BY MONTH (fecha)) AS minimo_cantidad_pedida,
       MAX(cantidad) OVER(PARTITION BY MONTH (fecha)) AS maximo_cantidad_pedida
FROM factura o
INNER JOIN detalle_factura i
ON o.idFactura=i.idFactura;


# 8. Escribimos una consulta recursiva para encontrar todos los empleados anteriores de un empleado específico en una tabla jerárquica.

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, nombre, manager_id
    FROM empelado
    WHERE employee_id = <ID del empleado específico>

    UNION ALL

    SELECT e.employee_id, e.name, e.manager_id
    FROM empleado e
    JOIN EmployeeHierarchy eh ON e.employee_id = eh.manager_id
)

SELECT *
FROM EmployeeHierarchy;


# 9. Aplicamos una 'función de ventana' para calcular el ranking de ventas de cada producto.

# función RANK()

WITH ventas AS(

SELECT p.idProducto,
  p.nombre AS producto,
  SUM(i.cantidad) AS cantidad_vendida
FROM producto p
INNER JOIN detalle_factura i
ON p.idProducto=i.idProducto
GROUP BY 1,2)

SELECT idProducto
producto,
RANK() OVER (ORDER BY cantidad_vendida DESC) AS sales_rank
FROM ventas;


# 10. Escribimos una consulta recursiva para encontrar todas los empleados que estén bajo un manager.

WITH RECURSIVE EmployeeUnderManager AS (
  SELECT * FROM Employees WHERE manager_id = 'manager_id_value'
  UNION ALL
  SELECT e.* FROM Employees e
  JOIN EmployeeUnderManager em ON e.manager_id = em.employee_id
)
SELECT * FROM EmployeeUnderManager;

