
# FUNCIONES AVANZADAS: funciones y procedimientos almacenados.


# ANÁLISIS 


#1. Calculamos el total de ventas de cada producto usando una función.

DELIMITER //

CREATE FUNCTION calcular_ventas_producto(idProducto INT) RETURNS FLOAT DETERMINISTIC  

BEGIN
    DECLARE total_ventas FLOAT;
    SET total_ventas = 0;
    SELECT SUM(precioUnitario * cantidad) INTO total_ventas
    FROM detalle_factura
    WHERE idProducto = idProducto;
    RETURN total_ventas;
END//

DELIMITER ;

# llamamos a la funcion para obtener las ventas del producto 5:
SELECT calcular_ventas_producto(5);


# 2. Creamos un procedimiento almacenado para insertar un nuevo cliente .

DELIMITER //
CREATE PROCEDURE InsertarCliente(

    IN nombreCliente VARCHAR(255),
    IN apellidoCliente VARCHAR(255),
    IN telefonoCliente VARCHAR(20),
    IN emailCliente VARCHAR(255),
    IN ciudadCliente VARCHAR(255),
    IN paisCliente VARCHAR(255)
)
BEGIN
    INSERT INTO cliente (nombre, apellido, telefono, email, ciudad, pais)
    VALUES (nombreCliente, apellidoCliente, telefonoCliente, emailCliente, ciudadCliente, paisCliente);
END//
DELIMITER ;

 # llamar al procedimiento almacenado :
CALL InsertarCliente('Juan', 'Pérez', '123456789', 'juan@example.com', 'Madrid', 'España');


# 3. Buscamos el top de los 3 clientes y su total de pedidos y calculamos el porcentaje de cada cliente comparado con el total.

# calculamos primero el top 3 de los clientes con más pedidos
WITH pedidostabla AS (

SELECT concat(nombre, ' ',apellido) AS cliente,
COUNT(idFactura) AS pedidos
FROM cliente c
INNER JOIN factura f
ON c.idCliente=f.idCliente
GROUP BY cliente
ORDER BY pedidos DESC
LIMIT 3)

# calculamos ahora el porcentaje
SELECT cliente,
pedidos,
ROUND(pedidos / (SELECT SUM(pedidos) FROM pedidostabla)*100,2) AS porcentaje_sobretotal 
FROM pedidostabla ;


# 4.Creamos un procedimiento almacenado para actualizar el salario de un empleado y registrar el cambio en una tabla separada.

DELIMITER //

CREATE PROCEDURE update_salario(IN idEmpleado INT, IN new_salario DECIMAL(10, 2))
BEGIN
    DECLARE old_salario DECIMAL(10, 2);
    -- Obtener el salario actual del empleado
    SELECT salario INTO old_salario FROM empleado WHERE idEmpleado = idEmpleado;
    -- Actualizar el salario del empleado
    UPDATE empleado SET salario = new_salario WHERE idEmpleado = idEmpleado;
    -- Registrar el cambio en una tabla de registro
    INSERT INTO salario_change_log (idEmpleado, old_salario, new_salario, change_date)
    VALUES (idEmpleado, old_salario, new_salario, NOW());
END //

DELIMITER ;

-- Crear la tabla salario_change_log si no existe
    CREATE TABLE IF NOT EXISTS salario_change_log (
        id INT AUTO_INCREMENT PRIMARY KEY,
        idEmpleado INT,
        old_salario DECIMAL(10, 2),
        new_salario DECIMAL(10, 2),
        change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    
# llamamos al procedimiento:
CALL update_salario(4, 550.00);


# 5. Calculamos la media del precio de cada producto y asignamos un ranking basado en una función.

SELECT idProducto,
AVG(precioUnitario) AS precio_medio,
RANK() OVER (ORDER BY AVG(precioUnitario) DESC) AS price_rank 
FROM producto
GROUP BY idProducto
ORDER BY precio_medio DESC;


# 6. Implementamos un procedimiento almacenado para insertar un nuevo pedido con sus detalles.

DELIMITER //
CREATE PROCEDURE InsertarPedido( 

   IN idCliente INT,
    IN idEmpleado INT,
    IN idProducto INT,
    IN precioUnitario DECIMAL(10, 2),
    IN cantidad INT
    
)
BEGIN 

  -- Insertar en la tabla factura
   DECLARE idFactura INT;

    -- Insertar en la tabla factura
    INSERT INTO factura (fecha,idCliente, idEmpleado)
    VALUES ( CURDATE(),idCliente, idEmpleado);
    
    -- Obtener el idFactura insertado
    SET idFactura = LAST_INSERT_ID();
    
    -- Insertar en la tabla detalle_factura
    INSERT INTO detalle_factura (idFactura, idProducto, precioUnitario, cantidad)
    VALUES ( idFactura,idProducto, precioUnitario, cantidad);
END//

DELIMITER ;

 # llamar al procedimiento almacenado 
CALL InsertarPedido(1,2,14,4.00, 3);  


# 7. Buscamos el top de 5 productos y sus ventas acumuladas usando una función.

SELECT p.idProducto,
p.nombre,
COUNT(f.idFactura) as total_pedidos,
SUM(f.cantidad) as  cantidad_vendida,
RANK() OVER (ORDER BY SUM(cantidad) DESC) AS product_rank
FROM producto p
INNER JOIN detalle_factura f 
ON p.idProducto = f.idProducto
GROUP BY 1, 2
ORDER BY cantidad_vendida DESC;


 # 8. Calculamos el promedio de precio de cada producto por categoría y asignamos un ranking.
 
 SELECT AVG(precioUnitario) AS precio_medio,
 c.nombre AS categoria ,
 RANK() OVER (ORDER BY AVG(precioUnitario) DESC ) AS ranking
 FROM producto p
 INNER JOIN categoria c
 ON p.idCategoria=c.idCategoria
 GROUP BY categoria 


# 9. Creación de un procedimiento almacenado para borrar un cliente y todos sus pedidos asociados.

DELIMITER //

CREATE PROCEDURE eliminarClienteYPedidos2(IN cliente_id INT)
BEGIN
    DELETE FROM factura WHERE idCliente = cliente_id;
    DELETE FROM cliente WHERE idCliente = cliente_id;
END//

DELIMITER ;


# 10. Buscamos el top de los 3 empleados en ventas con una 'window function'.

SELECT RANK() OVER ( ORDER BY (COUNT(idFactura)) DESC) AS ranking_ventas,
CONCAT(nombre, ' ' ,apellido) AS empleado,
COUNT(idFactura) AS ventas 
FROM empleado e
INNER JOIN factura f
ON e.idEmpleado=f.idEmpleado
GROUP BY e.idEmpleado
limit 3 ;


# 12. Creación de un procedimiento almacenado para actualizar la cantidad de stock para un producto.

DELIMITER //

CREATE PROCEDURE actualizarStock(IN idProducto INT, IN nueva_cantidad INT)
BEGIN
    UPDATE producto SET stock = nueva_cantidad WHERE idProducto = idProducto;
END//

DELIMITER ;
