# MySQL_Project

# ![image](https://github.com/ElenaPindado/MySQL_Project/assets/123492666/4c757e5a-1488-49f1-9f02-f2774628f71e)

 
Desarrollo y optimización de consultas en MySQL.

# Contenido Repositorio

- Código para la creación de la base de datos.
- Análisis inicial de ventas mediante consultas sencillas utilizando funciones de agregación, filtros, agrupamiento, ordenación y joins.
- Análisis más profundo mediante consultas más avanzadas utilizando Vistas, múltiples joins, subqueries, Ctes, procedimientos almacenados, funciones, window functions y consultas recursivas.
- Triggers y procedimientos almacenados.

# Contexto

Se ha creado la base de datos mediante un modelo 'entidad-relación' que conecta las diversas tablas : 

**Database**: Tienda

**Tablas**  

- Producto
- Categoría
- Cliente
- Empleado
- Departamento
- Factura
- Detalle_factura

Cada una de estas entidades tiene atributos específicos y se interrelaciona con otras entidades de manera coherente y lógica.
Por ejemplo, la tabla 'Producto' se vincula a la tabla 'Categoría', lo que nos permite clasificar los productos en categorías específicas. De manera similar, la tabla 'Cliente' se conecta a la tabla 'Factura' estableciendo una relación que refleja la relación entre los clientes y sus transacciones.

Se han utilizado 'Triggers' que permiten actualizar las tablas cuando incluyamos un nuevo registro.


# Objetivo

Almacenar los datos en esta base de datos, nos permite gestionar los mismos y realizar análisis que nos proporcionen una visión clara del rendimiento del negocio. 

Mediante el uso de consultas SQL vamos a identificar los productos más vendidos, el rendimiento de las ventas en distintos períodos y una serie de indicadores clave de rendimiento (KPI).

Este análisis profundo y detallado sirve como guía para optimizar la oferta de productos, mejorar la satisfacción del cliente y aumentar la rentabilidad general del negocio.
