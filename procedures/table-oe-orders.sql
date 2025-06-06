CREATE TABLE PEDIDOS AS SELECT * FROM ORDERS;

-- 1) Crie uma procedure CANCEL_ORDER que receba um order_id e altere o order_status para 'Cancelled'.

CREATE OR REPLACE PROCEDURE CANCEL_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET order_status = 'Cancelled'
    WHERE order_id = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' cancelado com sucesso.');
END;

BEGIN
    CANCEL_ORDER(101);
END;

-- 2) Crie uma procedure UPDATE_ORDER_TOTAL que atualize o order_total de um pedido com base em um valor adicional, passado como parâmetro.

CREATE OR REPLACE PROCEDURE UPDATE_ORDER_TOTAL(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_additional_amount NUMBER
) AS
BEGIN
    UPDATE PEDIDOS
    SET order_total = order_total + p_additional_amount
    WHERE order_id = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Total do pedido ' || p_order_id || ' atualizado com acréscimo de ' || p_additional_amount);
END;

BEGIN
    UPDATE_ORDER_TOTAL(101, 50);
END;

-- 3) Crie uma procedure SHIP_ORDER que atualize o order_status para 'Shipped' e o order_date para a data atual, recebendo o order_id como parâmetro.

CREATE OR REPLACE PROCEDURE SHIP_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET order_status = 'Shipped',
        order_date = SYSDATE
    WHERE order_id = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' enviado com sucesso.');
END;

BEGIN
    SHIP_ORDER(101);
END;

-- 4) Crie uma procedure LIST_ORDERS_BY_CUSTOMER que receba um customer_id e exiba todos os pedidos realizados por esse cliente, com order_id, order_status e order_total.

CREATE OR REPLACE PROCEDURE LIST_ORDERS_BY_CUSTOMER(
    p_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) AS
BEGIN
    FOR rec IN (
        SELECT order_id, order_status, order_total
        FROM PEDIDOS
        WHERE customer_id = p_customer_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Pedido: ' || rec.order_id || ', Status: ' || rec.order_status || ', Total: ' || rec.order_total);
    END LOOP;
END;

BEGIN
    LIST_ORDERS_BY_CUSTOMER(200);
END;

-- 5) Crie uma procedure DELETE_ORDER que exclua um pedido da tabela com base no order_id. Antes de excluir, imprima o order_status e order_total do pedido.

CREATE OR REPLACE PROCEDURE DELETE_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
    v_order_status PEDIDOS.ORDER_STATUS%TYPE;
    v_order_total PEDIDOS.ORDER_TOTAL%TYPE;
BEGIN
    SELECT order_status, order_total INTO v_order_status, v_order_total
    FROM PEDIDOS
    WHERE order_id = p_order_id;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' será excluído. Status: ' || v_order_status || ', Total: ' || v_order_total);
    
    DELETE FROM PEDIDOS
    WHERE order_id = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' excluído com sucesso.');
END;

BEGIN
    DELETE_ORDER(101);
END;

-- 6) Crie uma procedure UPDATE_ORDER_STATUS que permita atualizar o order_status de um pedido, recebendo o order_id e o novo status como parâmetros.

CREATE OR REPLACE PROCEDURE UPDATE_ORDER_STATUS(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_new_status PEDIDOS.ORDER_STATUS%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET order_status = p_new_status
    WHERE order_id = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Status do pedido ' || p_order_id || ' atualizado para ' || p_new_status);
END;

BEGIN
    UPDATE_ORDER_STATUS(101, 'Processing');
END;

-- 7) Crie uma procedure ORDER_SUMMARY que receba um order_id e imprima o resumo do pedido: customer_id, order_date, order_total e order_status.

CREATE OR REPLACE PROCEDURE ORDER_SUMMARY(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
    v_customer_id PEDIDOS.CUSTOMER_ID%TYPE;
    v_order_date PEDIDOS.ORDER_DATE%TYPE;
    v_order_total PEDIDOS.ORDER_TOTAL%TYPE;
    v_order_status PEDIDOS.ORDER_STATUS%TYPE;
BEGIN
    SELECT customer_id, order_date, order_total, order_status
    INTO v_customer_id, v_order_date, v_order_total, v_order_status
    FROM PEDIDOS
    WHERE order_id = p_order_id;
    
    DBMS_OUTPUT.PUT_LINE('Resumo do Pedido ' || p_order_id || ': Cliente: ' || v_customer_id || ', Data: ' || v_order_date || ', Total: ' || v_order_total || ', Status: ' || v_order_status);
END;

BEGIN
    ORDER_SUMMARY(101);
END;

-- 8) Crie uma procedure LIST_PENDING_ORDERS que liste todos os pedidos com order_status igual a 'Pending'.

CREATE OR REPLACE PROCEDURE LIST_PENDING_ORDERS AS
BEGIN
    FOR rec IN (
        SELECT order_id, customer_id, order_total
        FROM PEDIDOS
        WHERE order_status = 'Pending'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Pedido: ' || rec.order_id || ', Cliente: ' || rec.customer_id || ', Total: ' || rec.order_total);
    END LOOP;
END;

BEGIN
    LIST_PENDING_ORDERS;
END;

-- 9) Crie uma procedure INCREASE_ORDER_TOTAL_PERCENT que aumente o order_total de todos os pedidos feitos em um determinado mês/ano (passados como parâmetros) por uma determinada porcentagem.

CREATE OR REPLACE PROCEDURE INCREASE_ORDER_TOTAL_PERCENT(
    p_month NUMBER,
    p_year NUMBER,
    p_percent NUMBER
) AS
BEGIN
    UPDATE PEDIDOS
    SET order_total = order_total + (order_total * p_percent / 100)
    WHERE EXTRACT(MONTH FROM order_date) = p_month
      AND EXTRACT(YEAR FROM order_date) = p_year;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Total dos pedidos de ' || p_month || '/' || p_year || ' aumentado em ' || p_percent || '%');
END;

BEGIN
    INCREASE_ORDER_TOTAL_PERCENT(6, 2025, 10);
END;

-- 10) Crie uma procedure REASSIGN_ORDER_CUSTOMER que mude o customer_id de um pedido, recebendo como parâmetros o order_id e o novo customer_id.

CREATE OR REPLACE PROCEDURE REASSIGN_ORDER_CUSTOMER(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_new_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET customer_id = p_new_customer_id
    WHERE order_id = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' agora pertence ao cliente ' || p_new_customer_id);
END;

BEGIN
    REASSIGN_ORDER_CUSTOMER(101, 300);
END;
