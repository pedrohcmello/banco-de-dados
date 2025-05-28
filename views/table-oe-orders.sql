CREATE TABLE PEDIDOS AS SELECT * FROM OE.ORDERS;

-- 1) Crie uma view ORDER_BASIC_INFO que exiba apenas order_id, order_date, customer_id e order_status da tabela OE.ORDERS.

CREATE OR REPLACE VIEW ORDER_BASIC_INFO AS
SELECT order_id, order_date, customer_id, order_status
FROM PEDIDOS;

SELECT * FROM ORDER_BASIC_INFO WHERE customer_id = 100;

-- 2) Crie uma view PENDING_ORDERS que exiba os pedidos (order_id, order_date, customer_id) cujo order_status seja 'Pending'.

CREATE OR REPLACE VIEW PENDING_ORDERS AS
SELECT order_id, order_date, customer_id
FROM PEDIDOS
WHERE order_status = 'Pending';

SELECT * FROM PENDING_ORDERS;

-- 3) Crie uma view ORDER_TOTAL_BY_CUSTOMER que exiba o customer_id e a soma do order_total de todos os pedidos de cada cliente.

CREATE OR REPLACE VIEW ORDER_TOTAL_BY_CUSTOMER AS
SELECT customer_id, SUM(order_total) AS total_orders
FROM PEDIDOS
GROUP BY customer_id;

SELECT * FROM ORDER_TOTAL_BY_CUSTOMER WHERE total_orders > 5000;

-- 4) Crie uma view ORDERS_IN_2020 que exiba todos os dados dos pedidos realizados no ano de 2020.

CREATE OR REPLACE VIEW ORDERS_IN_2020 AS
SELECT *
FROM PEDIDOS
WHERE EXTRACT(YEAR FROM order_date) = 2020;

SELECT * FROM ORDERS_IN_2020;

-- 5) Crie uma view HIGH_VALUE_ORDERS que exiba os pedidos com order_total acima de 10.000.

CREATE OR REPLACE VIEW HIGH_VALUE_ORDERS AS
SELECT *
FROM PEDIDOS
WHERE order_total > 10000;

SELECT * FROM HIGH_VALUE_ORDERS;

-- 6) Crie uma view ORDER_SHIPPING_STATUS que exiba order_id, order_status e uma coluna calculada shipped_flag que mostre 'YES' se o order_status for 'Shipped', e 'NO' caso contrário.

CREATE OR REPLACE VIEW ORDER_SHIPPING_STATUS AS
SELECT order_id, order_status,
       CASE WHEN order_status = 'Shipped' THEN 'YES' ELSE 'NO' END AS shipped_flag
FROM PEDIDOS;

SELECT * FROM ORDER_SHIPPING_STATUS WHERE shipped_flag = 'NO';

-- 7) Crie uma view ORDERS_BY_MONTH que exiba o mês e o número de pedidos feitos em cada mês, utilizando TO_CHAR(order_date, 'MM') e GROUP BY.

CREATE OR REPLACE VIEW ORDERS_BY_MONTH AS
SELECT TO_CHAR(order_date, 'MM') AS month, COUNT(*) AS order_count
FROM PEDIDOS
GROUP BY TO_CHAR(order_date, 'MM');

SELECT * FROM ORDERS_BY_MONTH ORDER BY order_count DESC;

-- 8) Crie uma view CUSTOMER_PENDING_ORDERS que exiba o customer_id e a quantidade de pedidos pendentes (order_status = 'Pending') para cada cliente.

CREATE OR REPLACE VIEW CUSTOMER_PENDING_ORDERS AS
SELECT customer_id, COUNT(*) AS pending_orders
FROM PEDIDOS
WHERE order_status = 'Pending'
GROUP BY customer_id;

SELECT * FROM CUSTOMER_PENDING_ORDERS WHERE pending_orders > 2;

-- 9) Crie uma view ORDERS_WITH_DISCOUNT que exiba order_id, order_total e uma coluna discounted_total com 10% de desconto aplicado.

CREATE OR REPLACE VIEW ORDERS_WITH_DISCOUNT AS
SELECT order_id, order_total, order_total * 0.9 AS discounted_total
FROM PEDIDOS;

SELECT * FROM ORDERS_WITH_DISCOUNT WHERE discounted_total > 9000;

-- 10) Crie uma view CUSTOMER_ORDER_SUMMARY que exiba o customer_id, a quantidade total de pedidos (order_count) e a média do valor total dos pedidos (avg_order_total) para cada cliente.

CREATE OR REPLACE VIEW CUSTOMER_ORDER_SUMMARY AS
SELECT customer_id,
       COUNT(*) AS order_count,
       AVG(order_total) AS avg_order_total
FROM PEDIDOS
GROUP BY customer_id;

SELECT * FROM CUSTOMER_ORDER_SUMMARY WHERE order_count > 3;
