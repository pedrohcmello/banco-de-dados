CREATE TABLE PEDIDOS AS SELECT * FROM OE.ORDERS;

-- 1) Crie uma stored procedure CREATE_ORDER que insira um novo pedido na tabela OE.ORDERS, recebendo como parâmetros: order_id, order_date, order_status, order_total e customer_id.

CREATE OR REPLACE PROCEDURE CREATE_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_order_date PEDIDOS.ORDER_DATE%TYPE,
    p_order_status PEDIDOS.ORDER_STATUS%TYPE,
    p_order_total PEDIDOS.ORDER_TOTAL%TYPE,
    p_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) AS
BEGIN
    INSERT INTO PEDIDOS (ORDER_ID, ORDER_DATE, ORDER_STATUS, ORDER_TOTAL, CUSTOMER_ID)
    VALUES (p_order_id, p_order_date, p_order_status, p_order_total, p_customer_id);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' criado com sucesso.');
END;

BEGIN
    CREATE_ORDER(1001, SYSDATE, 'Pending', 500, 123);
END;

-- 2) Crie uma stored procedure CANCEL_ORDER que altere o order_status de um pedido para 'Cancelled' com base no order_id informado.

CREATE OR REPLACE PROCEDURE CANCEL_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET ORDER_STATUS = 'Cancelled'
    WHERE ORDER_ID = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' foi cancelado.');
END;

BEGIN
    CANCEL_ORDER(1001);
END;

-- 3) Crie uma stored procedure SHIP_ORDER que altere o order_status de um pedido para 'Shipped' e atualize o order_date para a data atual, com base no order_id informado.

CREATE OR REPLACE PROCEDURE SHIP_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET ORDER_STATUS = 'Shipped',
        ORDER_DATE = SYSDATE
    WHERE ORDER_ID = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' foi enviado.');
END;

BEGIN
    SHIP_ORDER(1001);
END;

-- 4) Crie uma stored procedure DELETE_ORDER que exclua um pedido com base no order_id e exiba no console (DBMS_OUTPUT.PUT_LINE) o order_total do pedido antes da exclusão.

CREATE OR REPLACE PROCEDURE DELETE_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
    v_order_total PEDIDOS.ORDER_TOTAL%TYPE;
BEGIN
    SELECT ORDER_TOTAL INTO v_order_total
    FROM PEDIDOS
    WHERE ORDER_ID = p_order_id;
    
    DELETE FROM PEDIDOS
    WHERE ORDER_ID = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' excluído. Total: ' || v_order_total);
END;

BEGIN
    DELETE_ORDER(1001);
END;

-- 5) Crie uma stored procedure LIST_ORDERS_BY_CUSTOMER que liste no console (DBMS_OUTPUT.PUT_LINE) todos os pedidos feitos por um cliente específico, recebendo customer_id como parâmetro.

CREATE OR REPLACE PROCEDURE LIST_ORDERS_BY_CUSTOMER(
    p_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) AS
BEGIN
    FOR rec IN (SELECT ORDER_ID, ORDER_DATE, ORDER_STATUS, ORDER_TOTAL 
                FROM PEDIDOS 
                WHERE CUSTOMER_ID = p_customer_id) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Pedido: ' || rec.ORDER_ID || ', Data: ' || rec.ORDER_DATE || 
                             ', Status: ' || rec.ORDER_STATUS || ', Total: ' || rec.ORDER_TOTAL);
    END LOOP;
END;

BEGIN
    LIST_ORDERS_BY_CUSTOMER(123);
END;

-- 6) Crie uma stored procedure UPDATE_ORDER_TOTAL que atualize o order_total de um pedido com base no order_id e no novo valor passado como parâmetros.

CREATE OR REPLACE PROCEDURE UPDATE_ORDER_TOTAL(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_new_total PEDIDOS.ORDER_TOTAL%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET ORDER_TOTAL = p_new_total
    WHERE ORDER_ID = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Total do pedido ' || p_order_id || ' atualizado para ' || p_new_total);
END;

BEGIN
    UPDATE_ORDER_TOTAL(1001, 750);
END;

-- 7) Crie uma stored procedure SHOW_ORDER_DETAILS que exiba no console (DBMS_OUTPUT.PUT_LINE) todos os detalhes de um pedido com base no order_id informado.

CREATE OR REPLACE PROCEDURE SHOW_ORDER_DETAILS(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
    v_order PEDIDOS%ROWTYPE;
BEGIN
    SELECT * INTO v_order FROM PEDIDOS WHERE ORDER_ID = p_order_id;
    
    DBMS_OUTPUT.PUT_LINE('Pedido: ' || v_order.ORDER_ID);
    DBMS_OUTPUT.PUT_LINE('Data: ' || v_order.ORDER_DATE);
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_order.ORDER_STATUS);
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_order.ORDER_TOTAL);
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_order.CUSTOMER_ID);
END;

BEGIN
    SHOW_ORDER_DETAILS(1001);
END;

-- 8) Crie uma stored procedure REASSIGN_ORDER_CUSTOMER que atualize o customer_id de um pedido, recebendo order_id e o novo customer_id como parâmetros.

CREATE OR REPLACE PROCEDURE REASSIGN_ORDER_CUSTOMER(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_new_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) AS
BEGIN
    UPDATE PEDIDOS
    SET CUSTOMER_ID = p_new_customer_id
    WHERE ORDER_ID = p_order_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' atribuído ao cliente ' || p_new_customer_id);
END;

BEGIN
    REASSIGN_ORDER_CUSTOMER(1001, 456);
END;

-- 9) Crie uma stored procedure LIST_PENDING_ORDERS que exiba no console (DBMS_OUTPUT.PUT_LINE) todos os pedidos que possuem order_status igual a 'Pending'.

CREATE OR REPLACE PROCEDURE LIST_PENDING_ORDERS AS
BEGIN
    FOR rec IN (SELECT ORDER_ID, ORDER_DATE, ORDER_TOTAL, CUSTOMER_ID 
                FROM PEDIDOS 
                WHERE ORDER_STATUS = 'Pending') 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Pedido: ' || rec.ORDER_ID || ', Data: ' || rec.ORDER_DATE || 
                             ', Total: ' || rec.ORDER_TOTAL || ', Cliente: ' || rec.CUSTOMER_ID);
    END LOOP;
END;

BEGIN
    LIST_PENDING_ORDERS;
END;

-- 10) Crie uma stored procedure INCREASE_ORDER_TOTALS que aumente o order_total de todos os pedidos realizados em um mês e ano específicos, ambos passados como parâmetros, aplicando também um percentual de aumento recebido como parâmetro.

CREATE OR REPLACE PROCEDURE INCREASE_ORDER_TOTALS(
    p_month NUMBER,
    p_year NUMBER,
    p_percent NUMBER
) AS
BEGIN
    UPDATE PEDIDOS
    SET ORDER_TOTAL = ORDER_TOTAL + (ORDER_TOTAL * p_percent / 100)
    WHERE EXTRACT(MONTH FROM ORDER_DATE) = p_month
      AND EXTRACT(YEAR FROM ORDER_DATE) = p_year;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Totais dos pedidos de ' || p_month || '/' || p_year || 
                         ' aumentados em ' || p_percent || '%');
END;

BEGIN
    INCREASE_ORDER_TOTALS(7, 2025, 10);
END;
