CREATE TABLE PEDIDOS AS SELECT * FROM OE.ORDERS;

-- 1) Crie uma função GET_ORDER_TOTAL que receba um order_id e retorne o order_total do pedido.

CREATE OR REPLACE FUNCTION GET_ORDER_TOTAL(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) RETURN PEDIDOS.ORDER_TOTAL%TYPE IS
    v_order_total PEDIDOS.ORDER_TOTAL%TYPE;
BEGIN
    SELECT order_total INTO v_order_total
    FROM PEDIDOS
    WHERE order_id = p_order_id;

    RETURN v_order_total;
END;

SELECT GET_ORDER_TOTAL(1001) FROM dual;

-- 2) Crie uma função GET_ORDER_STATUS que receba um order_id e retorne o order_status.

CREATE OR REPLACE FUNCTION GET_ORDER_STATUS(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) RETURN PEDIDOS.ORDER_STATUS%TYPE IS
    v_order_status PEDIDOS.ORDER_STATUS%TYPE;
BEGIN
    SELECT order_status INTO v_order_status
    FROM PEDIDOS
    WHERE order_id = p_order_id;

    RETURN v_order_status;
END;

SELECT GET_ORDER_STATUS(1001) FROM dual;

-- 3) Crie uma função GET_CUSTOMER_ORDER_COUNT que receba um customer_id e retorne a quantidade de pedidos feitos por este cliente.

CREATE OR REPLACE FUNCTION GET_CUSTOMER_ORDER_COUNT(
    p_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM PEDIDOS
    WHERE customer_id = p_customer_id;

    RETURN v_count;
END;

SELECT GET_CUSTOMER_ORDER_COUNT(200) FROM dual;

-- 4) Crie uma função GET_TOTAL_SALES_BY_CUSTOMER que receba um customer_id e retorne o total das vendas (soma do order_total) feitas por esse cliente.

CREATE OR REPLACE FUNCTION GET_TOTAL_SALES_BY_CUSTOMER(
    p_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) RETURN NUMBER IS
    v_total_sales NUMBER;
BEGIN
    SELECT SUM(order_total) INTO v_total_sales
    FROM PEDIDOS
    WHERE customer_id = p_customer_id;

    RETURN NVL(v_total_sales, 0);
END;

SELECT GET_TOTAL_SALES_BY_CUSTOMER(200) FROM dual;

-- 5) Crie uma função GET_PENDING_ORDER_COUNT que retorne a quantidade total de pedidos que estão com o order_status igual a 'Pending'.

CREATE OR REPLACE FUNCTION GET_PENDING_ORDER_COUNT
RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM PEDIDOS
    WHERE order_status = 'Pending';

    RETURN v_count;
END;

SELECT GET_PENDING_ORDER_COUNT FROM dual;

-- 6) Crie uma função GET_ORDER_YEAR que receba um order_id e retorne o ano em que o pedido foi realizado.

CREATE OR REPLACE FUNCTION GET_ORDER_YEAR(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) RETURN NUMBER IS
    v_year NUMBER;
BEGIN
    SELECT EXTRACT(YEAR FROM order_date) INTO v_year
    FROM PEDIDOS
    WHERE order_id = p_order_id;

    RETURN v_year;
END;

SELECT GET_ORDER_YEAR(1001) FROM dual;

-- 7) Crie uma função GET_HIGHEST_ORDER_TOTAL que retorne o maior valor de order_total registrado na tabela OE.ORDERS.

CREATE OR REPLACE FUNCTION GET_HIGHEST_ORDER_TOTAL
RETURN NUMBER IS
    v_max_total NUMBER;
BEGIN
    SELECT MAX(order_total) INTO v_max_total
    FROM PEDIDOS;

    RETURN v_max_total;
END;

SELECT GET_HIGHEST_ORDER_TOTAL FROM dual;

-- 8) Crie uma função GET_TOTAL_SALES_BY_YEAR que receba um ano como parâmetro e retorne a soma total de vendas realizadas nesse ano.

CREATE OR REPLACE FUNCTION GET_TOTAL_SALES_BY_YEAR(
    p_year NUMBER
) RETURN NUMBER IS
    v_total_sales NUMBER;
BEGIN
    SELECT SUM(order_total) INTO v_total_sales
    FROM PEDIDOS
    WHERE EXTRACT(YEAR FROM order_date) = p_year;

    RETURN NVL(v_total_sales, 0);
END;

SELECT GET_TOTAL_SALES_BY_YEAR(2024) FROM dual;

-- 9) Crie uma função IS_ORDER_SHIPPED que receba um order_id e retorne 'Y' se o order_status for 'Shipped', ou 'N' caso contrário.

CREATE OR REPLACE FUNCTION IS_ORDER_SHIPPED(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) RETURN CHAR IS
    v_status PEDIDOS.ORDER_STATUS%TYPE;
BEGIN
    SELECT order_status INTO v_status
    FROM PEDIDOS
    WHERE order_id = p_order_id;

    IF v_status = 'Shipped' THEN
        RETURN 'Y';
    ELSE
        RETURN 'N';
    END IF;
END;

SELECT IS_ORDER_SHIPPED(1001) FROM dual;

-- 10) Crie uma função GET_ORDER_CUSTOMER que receba um order_id e retorne o customer_id associado ao pedido.
CREATE OR REPLACE FUNCTION GET_ORDER_CUSTOMER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) RETURN PEDIDOS.CUSTOMER_ID%TYPE IS
    v_customer_id PEDIDOS.CUSTOMER_ID%TYPE;
BEGIN
    SELECT customer_id INTO v_customer_id
    FROM PEDIDOS
    WHERE order_id = p_order_id;

    RETURN v_customer_id;
END;

SELECT GET_ORDER_CUSTOMER(1001) FROM dual;
