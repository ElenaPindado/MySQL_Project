
# OPTIMIZACIÓN DE RENDIMIENTO 

# 1.Optimizamos una consulta para devuelva los detalles de los pedidos con sus compras para un rango específico.

SELECT o.idFactura AS num_pedido,
COUNT(o.idFactura) AS total_productos,
SUM(i.cantidad) AS cantidad_pedida,
SUM(cantidad*precioUnitario) AS ventas
FROM factura o
INNER JOIN detalle_factura i
ON o.idFactura=i.idFactura
WHERE fecha BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY o.idFactura;


# 2.Identificamos y eliminamos uniones innecesarias en una consulta que devuelva los detalles del producto y su respectivas categorías.

SELECT c.nombre AS categoria ,
COUNT(f.idFactura) AS total_productos,
SUM(d.cantidad) AS cantidad_pedida,
SUM(cantidad*d.precioUnitario) AS ventas
FROM factura f
INNER JOIN detalle_factura d
ON f.idFactura=d.idFactura
INNER JOIN producto p
ON d.idProducto=p.idProducto
INNER JOIN categoria c
ON p.idCategoria=c.idCategoria
GROUP BY categoria;


# 3. Reescribimos una subquery como una join en una query que devuelva los detalles de los pedidos y los clientes.

SELECT CONCAT(nombre,' ', apellido) AS cliente,
COUNT(o.idFactura) AS total_productos,
SUM(i.cantidad) AS cantidad_pedida
FROM factura o
INNER JOIN detalle_factura i
ON o.idFactura=i.idFactura
INNER JOIN cliente c
ON c.idCliente=o.idCliente
GROUP BY 1;


# 4.Optimizamos una consulta que calcula la media de cada producto usando índices.

-- Crear índices en los campos relevantes
CREATE INDEX idx_idProducto ON producto (idProducto);
CREATE INDEX idx_precio ON producto (precioUnitario);

-- Ejemplo de consulta optimizada
SELECT idProducto, AVG(precioUnitario) AS media_precio
FROM producto
GROUP BY idProducto;

 
 # 5.Identificamos y eliminamos redundancias en joins en una consulta que devuelva empleados y sus departamentos.

 SELECT CONCAT( e.nombre, ' ', apellido) AS empleado,
 d.nombre AS departamento 
 FROM empleado e
 INNER JOIN departamento d
 ON e.idDepartamento=d.idDepartamento;
 
 # 6. Reescribimos una subquery como una join en una consulta que devuelva los nombres de los clientes quienes tienen al menos dos pedidos.
 
SELECT CONCAT(nombre,' ', apellido) AS cliente,
COUNT(idFactura) AS pedidos
FROM cliente c
INNER JOIN factura o
ON c.idCliente=o.idCliente
GROUP BY 1
HAVING COUNT(idFactura) >= 2;


# 7. Optimizamos una consulta que calcula el total de ventas de cada mes.

SELECT MONTH(fecha), 
COUNT(f.idFactura) AS total_pedidos,
SUM(d.cantidad) AS cantidad_pedida,
SUM(cantidad*d.precioUnitario) AS ventas
FROM factura f
INNER JOIN detalle_factura d
ON f.idFactura=d.idFactura
GROUP BY 1;

-- Otra forma de hacerlo:
SELECT DATE_FORMAT(fecha, '%M %Y') AS mes_anio, # para extraer mes y año de la fecha 
COUNT(f.idFactura) AS total_pedidos,
SUM(d.cantidad) AS cantidad_pedida,
SUM(d.cantidad*d.precioUnitario) AS ventas
FROM factura f
INNER JOIN detalle_factura d
ON f.idFactura=d.idFactura
GROUP BY mes_anio;


# 8. Rescribimos una subconsulta como una join que devuleva los nombres de los clientes quienes tienen pedidos en los últimos 30 días.

SELECT CONCAT(nombre,' ' ,apellido) AS cliente,
fecha
FROM cliente c
INNER JOIN factura f
ON c.idCliente=f.idCliente
WHERE fecha >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY); # CURRENT_DATE() devuelve la fecha actual y DATE_SUB resta 30 días. 


# 9. Optimizamos una consulta que devuelva el top de los 5 productos con mayores ventas.

SELECT p.nombre AS producto,
SUM(d.cantidad*d.precioUnitario) AS total_ventas
FROM producto p
INNER JOIN detalle_factura d 
ON p.idProducto=d.idProducto
GROUP BY 1
ORDER BY 1 desc
LIMIT 5;
