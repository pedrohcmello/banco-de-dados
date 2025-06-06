CREATE TABLE PEDIDOS AS SELECT * FROM OE.ORDERS;

-- 1) Crie um bloco anônimo que busque e exiba o order_total de um order_id informado. Trate NO_DATA_FOUND para pedidos inexistentes.
DECLARE
    v_order_total PEDIDOS.ORDER_TOTAL%TYPE;
    v_order_id PEDIDOS.ORDER_ID%TYPE := 101;
BEGIN
    SELECT order_total INTO v_order_total
    FROM pedidos
    WHERE order_id = v_order_id;

    DBMS_OUTPUT.PUT_LINE('Total do pedido: ' || v_order_total);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;

-- 2) Crie uma procedure CANCEL_ORDER que atualize o order_status de um pedido para 'Cancelled'. Trate NO_DATA_FOUND se o order_id não existir.
CREATE OR REPLACE PROCEDURE CANCEL_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
BEGIN
    UPDATE pedidos
    SET order_status = 'Cancelled'
    WHERE order_id = p_order_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido cancelado: ' || p_order_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado para cancelamento.');
END;

BEGIN
    CANCEL_ORDER(102);
END;

-- 3) Crie uma função GET_ORDER_YEAR_DIVISION que divida o ano do pedido por um número informado. Trate a exceção ZERO_DIVIDE.
CREATE OR REPLACE FUNCTION GET_ORDER_YEAR_DIVISION(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_divisor NUMBER
) RETURN NUMBER IS
    v_year NUMBER;
BEGIN
    SELECT EXTRACT(YEAR FROM order_date) INTO v_year
    FROM pedidos
    WHERE order_id = p_order_id;

    RETURN v_year / p_divisor;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: divisão por zero.');
        RETURN NULL;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
        RETURN NULL;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || GET_ORDER_YEAR_DIVISION(103, 2));
END;

-- 4) Crie um bloco anônimo que exclua um pedido com base no order_id informado. Se o pedido não existir, capture a exceção NO_DATA_FOUND e exiba: 'Pedido não encontrado'.
DECLARE
    v_order_id PEDIDOS.ORDER_ID%TYPE := 104;
BEGIN
    DELETE FROM pedidos
    WHERE order_id = v_order_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido excluído: ' || v_order_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;

-- 5) Crie uma procedure SHIP_ORDER que atualize o order_status de um pedido para 'Shipped'. Se o pedido já estiver com este status, levante uma exceção customizada com RAISE_APPLICATION_ERROR.
CREATE OR REPLACE PROCEDURE SHIP_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
    v_status PEDIDOS.ORDER_STATUS%TYPE;
BEGIN
    SELECT order_status INTO v_status
    FROM pedidos
    WHERE order_id = p_order_id;

    IF v_status = 'Shipped' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Pedido já está enviado.');
    ELSE
        UPDATE pedidos
        SET order_status = 'Shipped'
        WHERE order_id = p_order_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Pedido enviado: ' || p_order_id);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;

BEGIN
    SHIP_ORDER(105);
END;

-- 6) Crie uma function GET_ORDER_TOTAL_SAFE que retorne o order_total de um order_id. Se não existir, retorne NULL e exiba uma mensagem no console.
CREATE OR REPLACE FUNCTION GET_ORDER_TOTAL_SAFE(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) RETURN NUMBER IS
    v_total PEDIDOS.ORDER_TOTAL%TYPE;
BEGIN
    SELECT order_total INTO v_total
    FROM pedidos
    WHERE order_id = p_order_id;

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
        RETURN NULL;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Total: ' || GET_ORDER_TOTAL_SAFE(106));
END;

-- 7) Crie uma procedure LIST_CUSTOMER_ORDERS que liste todos os pedidos de um customer_id. Se não houver pedidos, capture NO_DATA_FOUND e exiba: 'Nenhum pedido encontrado para este cliente'.
CREATE OR REPLACE PROCEDURE LIST_CUSTOMER_ORDERS(
    p_customer_id PEDIDOS.CUSTOMER_ID%TYPE
) AS
    CURSOR c_orders IS
        SELECT order_id, order_total
        FROM pedidos
        WHERE customer_id = p_customer_id;
    v_order c_orders%ROWTYPE;
    v_found BOOLEAN := FALSE;
BEGIN
    OPEN c_orders;
    LOOP
        FETCH c_orders INTO v_order;
        EXIT WHEN c_orders%NOTFOUND;
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE('Pedido: ' || v_order.order_id || ', Total: ' || v_order.order_total);
    END LOOP;
    CLOSE c_orders;

    IF NOT v_found THEN
        RAISE NO_DATA_FOUND;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum pedido encontrado para este cliente.');
END;

BEGIN
    LIST_CUSTOMER_ORDERS(201);
END;

-- 8) Crie um bloco anônimo que busque o customer_id de um order_id. Trate NO_DATA_FOUND e TOO_MANY_ROWS com mensagens específicas.
DECLARE
    v_customer_id PEDIDOS.CUSTOMER_ID%TYPE;
    v_order_id PEDIDOS.ORDER_ID%TYPE := 107;
BEGIN
    SELECT customer_id INTO v_customer_id
    FROM pedidos
    WHERE order_id = v_order_id;

    DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_customer_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: mais de um cliente encontrado para o pedido.');
END;

-- 9) Crie uma procedure DELETE_ORDER que exclua um pedido. Se o order_status for 'Shipped', não permita a exclusão e levante uma exceção com RAISE_APPLICATION_ERROR.
CREATE OR REPLACE PROCEDURE DELETE_ORDER(
    p_order_id PEDIDOS.ORDER_ID%TYPE
) AS
    v_status PEDIDOS.ORDER_STATUS%TYPE;
BEGIN
    SELECT order_status INTO v_status
    FROM pedidos
    WHERE order_id = p_order_id;

    IF v_status = 'Shipped' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Não é permitido excluir pedido enviado.');
    ELSE
        DELETE FROM pedidos
        WHERE order_id = p_order_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Pedido excluído: ' || p_order_id);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;

BEGIN
    DELETE_ORDER(108);
END;

-- 10) INCREASE_ORDER_TOTAL.
CREATE OR REPLACE PROCEDURE INCREASE_ORDER_TOTAL(
    p_order_id PEDIDOS.ORDER_ID%TYPE,
    p_increment NUMBER
) AS
    v_total PEDIDOS.ORDER_TOTAL%TYPE;
BEGIN
    SELECT order_total INTO v_total
    FROM pedidos
    WHERE order_id = p_order_id;

    v_total := v_total + p_increment;

    IF v_total > 10000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Valor excede o permitido.');
    ELSE
        UPDATE pedidos
        SET order_total = v_total
        WHERE order_id = p_order_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Total atualizado: ' || v_total);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;

BEGIN
    INCREASE_ORDER_TOTAL(109, 500);
END;
