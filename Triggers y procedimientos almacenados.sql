
# TEMAS AVANZADOS: TRIGGERS Y PROCEDIMIENTOS ALMACENADOS


# 1. Creación de un 'procedimiento almacenado' llamado 'pedidos_cliente'  que tome un cliente id como input y devuelva todos los pedidos de ese cliente.

DELIMITER //

CREATE PROCEDURE pedidos_cliente(IN idCliente INT)
BEGIN
    SELECT *
    FROM factura
    WHERE idCliente = idCliente;
END //

DELIMITER ;

CALL pedidos_cliente(2); -- Esto devolverá los pedidos del cliente con cliente_id igual a 2.



# 2. Creación de un 'Trigger' llamado 'update_inventory' que automáticamente actualice la cantidad del inventario cuando se haga un pedido.

DELIMITER //
CREATE TRIGGER update_inventory_trigger
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    -- Encuentra la cantidad del producto en inventario
    DECLARE cantidad_inventario INT;
    SELECT cantidad INTO cantidad_inventario FROM inventary WHERE producto_id = NEW.producto_id;
    
    -- Actualiza la cantidad en inventario restando la cantidad del pedido
    UPDATE inventario
    SET cantidad = cantidad - NEW.cantidad
    WHERE producto_id = NEW.producto_id;
END;
//
DELIMITER ;


# Lo hacemos ahora con la tabla empleado, creamos un 'Trigger' que actualice la tabla de departamento cuando incluyamos un nuevo empleado

DELIMITER //
CREATE TRIGGER update_departments_trigger
AFTER INSERT ON empleado
FOR EACH ROW
BEGIN
    -- Incrementa la cantidad de empleados en el departamento correspondiente
    UPDATE departamento
    SET cantidad_empleados = cantidad_empleados + 1 
    # Suponiendo que en la tabla departamento tenemos una columna llamada cantidad empleados, y esto incrementará en uno cada vez que añademos uno.
    WHERE idDepartamento = NEW.idDepartamento;
END;
//
DELIMITER ;
