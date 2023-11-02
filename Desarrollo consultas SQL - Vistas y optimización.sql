
# CONCEPTOS AVANZADOS DE UNA BASE DE DATOS: VISTAS Y OPTIMIZACIÓN DE CONSULTAS

/* CONTEXTO: 

DATABASE: Tienda 

TABLAS:

     1.Producto
     
| ID | Producto        | Cantidad | Precio |
|----|-----------------|----------|--------|
| 1  | Avena           | 2        | 2.00   |
| 2  | Queso           | 4        | 6.00   |
| 3  | Kiwi            | 5        | 0.50   |
| 4  | Coco            | 2        | 2.30   |
| 5  | Leche           | 4        | 2.35   |
| 6  | Agua            | 3        | 1.50   |
| 7  | Jugo de Naranja | 3        | 1.80   |
| 8  | Manzanas        | 5        | 0.50   |
| 9  | Peras           | 5        | 1.18   |
| 10 | Uvas            | 5        | 3.50   |
| 11 | Jugo de Manzana | 3        | 1.60   |
| 12 | Arroz           | 2        | 4.00   |
| 13 | Ciruela         | 5        | 2.00   |
| 14 | Kaki            | 8        | 4.00   |
--------------------------------------------

     2.Categoría
     
     
| ID | Categoría        | Descripción                                  |
|----|------------------|----------------------------------------------|
| 1  | Panadería        | Productos de panadería y pastelería          |
| 2  | Cereales         | Productos como maíz, trigo, avena, arroz, etc|
| 3  | Bebidas          | Bebidas gaseosas y naturales                 |
| 4  | Lácteos          | Leches y quesos                              |
| 5  | Frutas           | Frutas naturales                             |
| 6  | Carnes           | Carnes blancas y carnes rojas                |
| 7  | Otros            | Otros productos                              |
| 8  | Frutas Exóticas  | Frutas de otros países                       |
------------------------------------------------------------------------   
     
     3.Cliente
     
     
| ID | Nombre | Apellido | Teléfono    | Correo               | Ciudad      | País            |
|----|--------|----------|------------ |----------------------|-------------|-----------------|
| 1  | Jordi  | Peña     | (216)390596 | jordi@test.es        | Brasilia    | Brasil          |
| 2  | Álvaro | Gutierrez| (884)639106 | alvarog@test.com     | Dublín      | Irlanda         |
| 3  | Lara   | Gomez    | (121)907333 | lgomez@test.net      | Bogotá      | Colombia        |
| 4  | Adriana| Garrido  | (120)217209 | adrianag@test.com    | Tegucigalpa | Honduras        |
| 5  | Isabel | Mora     | (167)281764 | luismora@test.es     | Brucelas    | Bélgica         |
| 6  | Óscar  | Flores   | (574)181598 | oflores@test.net     | Dallas      | Estados Unidos  |
| 7  | Darío  | Moya     | (708)179745 | morad@test.com       | Quebec      | Canadá          |
| 8  | Carlos | Carmona  | (225)417374 | ccarmona@test.net    | Santigo     | Chile           |
| 9  | Natalia| Gallego  | (940)689766 | natig@test.com       | Budapest    | Hungría         |
| 10 | Laura  | Solis    | (152)685846 | lsolis@test.com      | Madrid      | España          |
| 11 | Alonso | Ortiz    | (158)785844 | alonsortiz@test.com  | París       | Francia         |
| 12 | Pedro  | Rojas    |            | pedrorojas@test.com   | Quebec      | Canadá          |
| 13 | Audrey | Mora     |            | audreymora@test.com   | Brucelas    | Bélgica         |
| 14 | Nancy  | Monge    | (131)785823 |                      | Santigo     | Chile           |
| 15 | Joseph | Philips  | 789023454  | josep@test.com        | London      | Reino Unido     |
| 16 | Juan   | Pérez    | 123456789  | juan@example.com      | Madrid      | España          |
-----------------------------------------------------------------------------------------------
     
     4.Empleado
     
     
| ID | Nombre | Apellido | Fecha de Contratación | Fecha de Nacimiento | Género | Correo Electrónico       | Teléfono     | Salario | Departamento ID |
|----|--------|----------|---------------------- |---------------------|--------|--------------------------|--------------|---------|-----------------|
| 1  | John   | Turner   | 2018-01-20            | 1971-08-21          | hombre | johnturner@ejemplo.com   | 410-944-0947 | 500.00  | 1               |
| 2  | Hilda  | Ulloa    | 2019-05-05            | 1950-07-03          | mujer  | hildaulloa@ejemplo.com   | 761 910 312  | 650.00  | 2               |
| 3  | Alice  | Morales  | 2018-04-26            | 1991-04-22          | mujer  | alicemorales@ejemplo.com | 617 177 211  | 735.00  | 4               |
| 4  | Anna   | Cunha    | 2019-02-15            | 1980-01-27          | mujer  | annacunha@ejemplo.com    | 619 571 031  | 512.00  | 1               |
| 5  | Thiago | Pereira  | 2018-11-03            | 1983-10-08          | hombre | thiagopereira@ejemplo.com| 757 579 534  | 360.00  | 2               |
| 6  | Bryan  | King     | 2019-10-10            | 1981-08-15          | hombre | bryanking@ejemplo.com    | 699 542 841  | 465.00  | 3               |
-------------------------------------------------------------------------------------------------------------------------------------------------------

     5.Departamento
     
     
| ID | Nombre    | 
|----|-----------|
| 1  | Frutas    | 
| 2  | Carnes    | 
| 3  | General   | 
| 4  | Direccion |
------------------

     6.Factura
     
     
idFactura | fecha                | idCliente | idEmpleado |
--------- | -------------------- | --------- | -----------|
1         | 2016-10-16 00:00:00  | 6         | 2          |
2         | 2016-11-29 00:00:00  | 5         | 3          | 
3         | 2017-01-22 00:00:00  | 10        | 3          |
4         | 2017-02-20 00:00:00  | 3         | 1          |
5         | 2017-03-07 00:00:00  | 7         | 3          |
6         | 2017-03-16 00:00:00  | 9         | 2          |
7         | 2017-09-06 00:00:00  | 11        | 4          |
8         | 2017-11-09 00:00:00  | 1         | 2          |
9         | 2017-11-09 00:00:00  | 7         | 3          |
10        | 2017-12-05 00:00:00  | 9         | 3          |
11        | 2018-07-18 00:00:00  | 3         | 5          |
12        | 2018-08-01 00:00:00  | 4         | 1          |
13        | 2018-08-03 00:00:00  | 4         | 4          |
14        | 2019-01-17 00:00:00  | 1         | 3          |
15        | 2019-01-22 00:00:00  | 7         | 3          |
16        | 2019-02-08 00:00:00  | 9         | 4          |
17        | 2019-03-29 00:00:00  | 3         | 4          |
18        | 2019-06-14 00:00:00  | 6         | 4          |
19        | 2019-07-14 00:00:00  | 1         | 5          |
20        | 2019-07-17 00:00:00  | 9         | 1          |
-----------------------------------------------------------
     
     7.Detalle_factura
     
     
| idDetalle | idFactura | idProducto | precioUnitario | cantidad |
|---------- |---------- |----------- |----------------|----------|
| 1         | 1         | 5          | 2.20           | 1        |
| 2         | 1         | 2          | 6.00           | 1        |
| 3         | 1         | 4          | 2.30           | 4        |
| 4         | 1         | 9          | 1.18           | 2        |
| 5         | 2         | 5          | 2.20           | 1        |
| 6         | 2         | 3          | 0.50           | 1        |
| 7         | 2         | 8          | 0.50           | 4        |
| 8         | 3         | 10         | 3.50           | 1        |
| 9         | 3         | 2          | 6.00           | 2        |
| 10        | 3         | 6          | 1.50           | 3        |
| 11        | 4         | 7          | 1.80           | 1        |
| 12        | 5         | 5          | 2.20           | 1        |
| 13        | 5         | 10         | 3.50           | 4        |
| 14        | 5         | 9          | 1.18           | 4        |
| 15        | 5         | 11         | 1.60           | 2        |
| 16        | 5         | 1          | 2.00           | 1        |
| 17        | 6         | 7          | 1.80           | 3        |
| 18        | 6         | 5          | 2.20           | 4        |
| 19        | 6         | 6          | 1.50           | 4        |
| 20        | 6         | 8          | 0.50           | 4        |
------------------------------------------------------------------
   
*/


# ANÁLISIS 


# 1. Creación de una vista para devolver una lista de productos y sus cantidades en stock.

CREATE VIEW V_productos_categoria AS 

SELECT p.idCategoria, 
p.nombre AS producto,
c.nombre AS categoria
FROM producto p
INNER JOIN categroia c
ON p.idCategoria=c.idCategoria;


# 2.Creación de una Cte para ver el total de ventas. 

WITH pedidos AS 
(
SELECT idProducto,
count(idFactura) AS total_pedidos
FROM detalle_factura 
GROUP BY idProducto)

SELECT p.idProducto, 
total_pedidos,
total_pedidos * precioUnitario AS ventas€
FROM pedidos p
INNER JOIN producto pp
ON p.idProducto=pp.idProducto;


# 3. Optimizamos una consulta que devuelva los detalles de los pedidos de un cliente especídico, ordenados por fecha en orden descendente.

SELECT CONCAT (c.nombre, ' ',apellido) AS cliente,
fecha,
GROUP_CONCAT(p.nombre) AS productos_pedidos,
SUM(d.cantidad) AS cantidad_productos
FROM cliente c
INNER JOIN factura f
ON c.idCliente=f.idCliente
INNER JOIN detalle_factura d
ON f.idFactura=d.idFactura
INNER JOIN producto p
ON d.idProducto=p.idProducto
WHERE c.idCliente=1
GROUP BY c.nombre, c.apellido, fecha
ORDER BY fecha DESC;


# 4. Creación de una vista para devolver la media del precio y el número de pedidos de cada producto.


CREATE VIEW V_Productos_info AS

WITH media_pedidos AS(

SELECT p.nombre AS producto,
avg(d.cantidad) AS media_pedidos_realizados
FROM detalle_factura d
INNER JOIN producto p
ON d.idProducto=p.idProducto
group by  nombre),

media_precios AS(

SELECT p.nombre AS producto,
avg(d.cantidad*d.precioUnitario) AS precio_medio_pedidos
FROM detalle_factura d
INNER JOIN producto p
ON d.idProducto=p.idProducto
GROUP BY  nombre)

SELECT p.producto,
media_pedidos_realizados,
precio_medio_pedidos
FROM media_pedidos p
INNER JOIN media_precios pp
ON p.producto=pp.producto;


# 5. Optimizamos una consulta que devuelva los 10 clientes con más pedidos.

SELECT c.nombre, 
COUNT(f.idFactura) AS total_pedidos
FROM cliente c
JOIN factura f
ON c.idCliente = f.idCliente
GROUP BY c.idCliente
ORDER BY total_pedidos DESC
LIMIT 10; 


# 6. Creamos un índice para la columna 'fecha' de la tabla 'factura' y analizamos su rendimiento en un rango específico.

CREATE INDEX idx_fecha ON pedidos (fecha);


# Esto nos dará información sobre cómo se está ejecutando la consulta y si se está utilizando el índice que hemos creado:
EXPLAIN SELECT *
FROM factura
WHERE fecha BETWEEN '2019-01-01' AND '2019-08-31';


# 7. Creación de una vista para la media del salario de cada departamento.

CREATE VIEW v_media_salario AS

SELECT d.nombre AS departamento,
AVG (salario) AS media_salario
FROM empleado e 
INNER JOIN departamento d
ON e.idDepartamento=d.idDepartamento
GROUP BY departamento;

# 8. Optimizamos una consulta que devuelva una lista de productos con sus respectivas categorias, filtrando por una categoria específica.

WITH categoria_producto AS 
(
SELECT p.nombre AS producto,
c.nombre AS categoria 
FROM producto p 
INNER JOIN categoria c
ON p.idCategoria=c.idCategoria)

SELECT producto
FROM categoria_producto
WHERE categoria = 'Frutas' ;


# también podríamos hacerlo así:

SELECT p.nombre as producto, 
c.nombre as categoria 
FROM producto p 
INNER JOIN categoria c 
ON p.idCategoria=c.idCategoria
WHERE c.nombre = 'Frutas';


# 9. Creación de una vista que devuelva el total de pedidos de cada cliente

CREATE VIEW v_pedidos AS

SELECT CONCAT (nombre, ' ', apellido) AS cliente,
COUNT(idFactura) AS total_pedidos
FROM cliente c
INNER JOIN factura f
ON c.idCliente=f.idCliente
GROUP BY cliente;