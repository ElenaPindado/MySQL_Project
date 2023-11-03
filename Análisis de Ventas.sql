
# ANÁLISIS DE VENTAS 

# Vemos los distintos productos que tenemos:

SELECT distinct producto 
FROM v_ventasfinales ;


# Total beneficios por producto: 

SELECT  producto, 
SUM(beneficios) AS total_beneficios 
FROM v_ventasfinales 
GROUP BY producto 
ORDER BY total_beneficios DESC;


# Qué producto obtiene más ganancias?

SELECT producto, 
SUM(beneficios) AS total_beneficios 
FROM v_ventasfinales 
GROUP BY producto 
ORDER BY total_beneficios DESC 
LIMIT 1;


# Qué producto es el más caro?

SELECT producto, 
MAX(precio) AS precio  
FROM v_ventasfinales 
GROUP BY producto 
ORDER BY precio DESC
LIMIT 1;


# Qué producto tiene más beneficios?

SELECT producto, 
SUM(beneficios) AS total_beneficios
FROM v_ventasfinales
GROUP BY producto
ORDER BY total_beneficios DESC
LIMIT 1;


# Beneficios en ventas por cada producto:

SELECT idProducto, 
cantidad * precioUnitario AS beneficios 
FROM detalle_factura; 


# Añadimos el nombre del producto , para lo que necesitamos unir con la tabla 'producto'

WITH ventas AS 
(SELECT idProducto, 
cantidad * precioUnitario AS beneficios 
FROM detalle_factura)

SELECT distinct nombre, 
precioUnitario AS precio, 
beneficios
FROM producto 
INNER JOIN ventas 
ON producto.idProducto=ventas.idProducto;

# Creamos una vista con la tabla resultante :

CREATE VIEW V_ventasfinales AS

WITH ventas AS
(SELECT idProducto, 
cantidad * precioUnitario AS beneficios 
FROM detalle_factura)

SELECT distinct 
nombre AS producto,  
precioUnitario AS precio, 
beneficios 
FROM producto 
INNER JOIN ventas 
ON producto.idProducto=ventas.idProducto;


# Productos cuyo precio es menor que un euro: 

SELECT nombre, 
precioUnitario 
FROM tienda.producto
WHERE precioUnitario < 1.00;




