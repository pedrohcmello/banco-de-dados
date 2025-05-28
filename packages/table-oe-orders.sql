CREATE TABLE PEDIDOS AS SELECT * FROM OE.ORDERS;

CREATE OR REPLACE PACKAGE ORDER_UTILS AS
    -- 1) Crie um package ORDER_UTILS que contenha uma procedure GET_ORDER_DETAILS que exiba o order_total e order_status de um pedido com base no order_id informado.
    PROCEDURE GET_ORDER_DETAILS(p_order_id PEDIDOS.order_id%TYPE);

    -- 2) Adicione ao package ORDER_UTILS uma function IS_ORDER_SHIPPED que retorne TRUE se o pedido estiver com o status 'Shipped', e FALSE caso contrário.
    FUNCTION IS_ORDER_SHIPPED(p_order_id PEDIDOS.order_id%TYPE) RETURN BOOLEAN;

    -- 3) Inclua no package ORDER_UTILS uma procedure CANCEL_ORDER que altere o order_status de um pedido para 'Cancelled', caso ele ainda não esteja com esse status.
    PROCEDURE CANCEL_ORDER(p_order_id PEDIDOS.order_id%TYPE);

    -- 4) No package ORDER_UTILS, crie uma procedure INCREASE_ORDER_TOTAL que aumente o order_total de um pedido em uma porcentagem informada.
    PROCEDURE INCREASE_ORDER_TOTAL(p_order_id PEDIDOS.order_id%TYPE, p_percent NUMBER);

    -- 5) Adicione ao package ORDER_UTILS uma function GET_ORDER_YEAR que retorne o ano de um pedido com base no order_date.
    FUNCTION GET_ORDER_YEAR(p_order_id PEDIDOS.order_id%TYPE) RETURN NUMBER;

    -- 9) No package ORDER_UTILS, crie uma exception customizada order_not_found e levante-a na procedure GET_ORDER_DETAILS caso o order_id não exista.
    ORDER_NOT_FOUND EXCEPTION;

    -- 10) Inclua no package ORDER_UTILS uma procedure DELETE_ORDER que exclua um pedido com base no order_id. Antes da exclusão, verifique se o pedido já foi enviado (order_status = 'Shipped'), e se for, levante uma exceção customizada.
    PROCEDURE DELETE_ORDER(p_order_id PEDIDOS.order_id%TYPE);
END ORDER_UTILS;

CREATE OR REPLACE PACKAGE BODY ORDER_UTILS AS

    -- 1) GET_ORDER_DETAILS
    PROCEDURE GET_ORDER_DETAILS(p_order_id PEDIDOS.order_id%TYPE) IS
        v_order_total PEDIDOS.order_total%TYPE;
        v_order_status PEDIDOS.order_status%TYPE;
    BEGIN
        SELECT order_total, order_status INTO v_order_total, v_order_status
        FROM PEDIDOS WHERE order_id = p_order_id;

        DBMS_OUTPUT.PUT_LINE('Total do Pedido: ' || v_order_total);
        DBMS_OUTPUT.PUT_LINE('Status do Pedido: ' || v_order_status);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RAISE ORDER_NOT_FOUND;
    END;

    -- 2) IS_ORDER_SHIPPED
    FUNCTION IS_ORDER_SHIPPED(p_order_id PEDIDOS.order_id%TYPE) RETURN BOOLEAN IS
        v_status PEDIDOS.order_status%TYPE;
    BEGIN
        SELECT order_status INTO v_status
        FROM PEDIDOS WHERE order_id = p_order_id;

        RETURN v_status = 'Shipped';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    END;

    -- 3) CANCEL_ORDER
    PROCEDURE CANCEL_ORDER(p_order_id PEDIDOS.order_id%TYPE) IS
        v_status PEDIDOS.order_status%TYPE;
    BEGIN
        SELECT order_status INTO v_status FROM PEDIDOS WHERE order_id = p_order_id;

        IF v_status != 'Cancelled' THEN
        UPDATE PEDIDOS SET order_status = 'Cancelled'
        WHERE order_id = p_order_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' cancelado.');
        ELSE
        DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' já está cancelado.');
        END IF;
    END;

    -- 4) INCREASE_ORDER_TOTAL
    PROCEDURE INCREASE_ORDER_TOTAL(p_order_id PEDIDOS.order_id%TYPE, p_percent NUMBER) IS
    BEGIN
        UPDATE PEDIDOS
        SET order_total = order_total + (order_total * p_percent / 100)
        WHERE order_id = p_order_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Total do pedido aumentado para o pedido ' || p_order_id);
    END;

    -- 5) GET_ORDER_YEAR
    FUNCTION GET_ORDER_YEAR(p_order_id PEDIDOS.order_id%TYPE) RETURN NUMBER IS
        v_order_date PEDIDOS.order_date%TYPE;
    BEGIN
        SELECT order_date INTO v_order_date
        FROM PEDIDOS WHERE order_id = p_order_id;

        RETURN EXTRACT(YEAR FROM v_order_date);
    END;

    -- 10) DELETE_ORDER
    PROCEDURE DELETE_ORDER(p_order_id PEDIDOS.order_id%TYPE) IS
        v_status PEDIDOS.order_status%TYPE;
    BEGIN
        SELECT order_status INTO v_status FROM PEDIDOS WHERE order_id = p_order_id;

        IF v_status = 'Shipped' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não é possível excluir um pedido que já foi enviado.');
        ELSE
        DELETE FROM PEDIDOS WHERE order_id = p_order_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Pedido ' || p_order_id || ' excluído.');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RAISE ORDER_NOT_FOUND;
    END;

END ORDER_UTILS;

CREATE OR REPLACE PACKAGE ORDER_REPORTS AS
    -- 6) Crie um package ORDER_REPORTS que contenha uma procedure LIST_CUSTOMER_ORDERS que exiba todos os pedidos de um customer_id informado.
    PROCEDURE LIST_CUSTOMER_ORDERS(p_customer_id PEDIDOS.customer_id%TYPE);

    -- 7) Inclua no package ORDER_REPORTS uma function GET_TOTAL_SALES_BY_CUSTOMER que retorne o total de vendas (soma de order_total) para um customer_id informado.
    FUNCTION GET_TOTAL_SALES_BY_CUSTOMER(p_customer_id PEDIDOS.customer_id%TYPE) RETURN NUMBER;

    -- 8) Adicione ao package ORDER_REPORTS uma procedure PRINT_ORDER_SUMMARY que exiba um resumo de um pedido com order_id, order_date, e order_total.
    PROCEDURE PRINT_ORDER_SUMMARY(p_order_id PEDIDOS.order_id%TYPE);
END ORDER_REPORTS;

CREATE OR REPLACE PACKAGE BODY ORDER_REPORTS AS

    -- 6) LIST_CUSTOMER_ORDERS
    PROCEDURE LIST_CUSTOMER_ORDERS(p_customer_id PEDIDOS.customer_id%TYPE) IS
        CURSOR c_orders IS
            SELECT order_id, order_total, order_status
            FROM PEDIDOS
            WHERE customer_id = p_customer_id;
    BEGIN
        FOR r_order IN c_orders LOOP
        DBMS_OUTPUT.PUT_LINE('ID do Pedido: ' || r_order.order_id ||
                     ', Total: ' || r_order.order_total ||
                     ', Status: ' || r_order.order_status);
        END LOOP;
    END;

    -- 7) GET_TOTAL_SALES_BY_CUSTOMER
    FUNCTION GET_TOTAL_SALES_BY_CUSTOMER(p_customer_id PEDIDOS.customer_id%TYPE) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT SUM(order_total) INTO v_total
        FROM PEDIDOS WHERE customer_id = p_customer_id;

        RETURN NVL(v_total, 0);
    END;

    -- 8) PRINT_ORDER_SUMMARY
    PROCEDURE PRINT_ORDER_SUMMARY(p_order_id PEDIDOS.order_id%TYPE) IS
        v_date PEDIDOS.order_date%TYPE;
        v_total PEDIDOS.order_total%TYPE;
    BEGIN
        SELECT order_date, order_total INTO v_date, v_total
        FROM PEDIDOS WHERE order_id = p_order_id;

        DBMS_OUTPUT.PUT_LINE('ID do Pedido: ' || p_order_id);
        DBMS_OUTPUT.PUT_LINE('Data do Pedido: ' || v_date);
        DBMS_OUTPUT.PUT_LINE('Total do Pedido: ' || v_total);
    END;

END ORDER_REPORTS;

BEGIN
    -- 1) GET_ORDER_DETAILS
    ORDER_UTILS.GET_ORDER_DETAILS(101);
    EXCEPTION
        WHEN ORDER_UTILS.ORDER_NOT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
END;

DECLARE
    -- 2) IS_ORDER_SHIPPED
    v_shipped BOOLEAN;
BEGIN
    v_shipped := ORDER_UTILS.IS_ORDER_SHIPPED(101);
    IF v_shipped THEN
        DBMS_OUTPUT.PUT_LINE('Pedido enviado.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pedido não enviado.');
  END IF;
END;

BEGIN
    -- 3) CANCEL_ORDER
    ORDER_UTILS.CANCEL_ORDER(101);
    DBMS_OUTPUT.PUT_LINE('Pedido cancelado.');
END;

BEGIN
    -- 4) INCREASE_ORDER_TOTAL
    ORDER_UTILS.INCREASE_ORDER_TOTAL(101, 10);
    DBMS_OUTPUT.PUT_LINE('Total do pedido aumentado.');
END;

DECLARE
    -- 5) GET_ORDER_YEAR
    v_ano NUMBER;
BEGIN
    v_ano := ORDER_UTILS.GET_ORDER_YEAR(101);
    DBMS_OUTPUT.PUT_LINE('Ano do pedido: ' || v_ano);
END;

BEGIN
    -- 6) LIST_CUSTOMER_ORDERS
    ORDER_REPORTS.LIST_CUSTOMER_ORDERS(204);
END;

DECLARE
    -- 7) GET_TOTAL_SALES_BY_CUSTOMER
    v_total NUMBER;
BEGIN
    v_total := ORDER_REPORTS.GET_TOTAL_SALES_BY_CUSTOMER(204);
    DBMS_OUTPUT.PUT_LINE('Total de vendas: ' || v_total);
END;

BEGIN
    -- 8) PRINT_ORDER_SUMMARY
    ORDER_REPORTS.PRINT_ORDER_SUMMARY(101);
END;

BEGIN
    -- 9) Testando a exception customizada
    BEGIN
        ORDER_UTILS.GET_ORDER_DETAILS(9999);
    EXCEPTION
        WHEN ORDER_UTILS.ORDER_NOT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Order not found.');
    END;
END;

BEGIN
    ORDER_UTILS.DELETE_ORDER(105);
END;

BEGIN
    -- 10) DELETE_ORDER
    ORDER_UTILS.DELETE_ORDER(105);
    DBMS_OUTPUT.PUT_LINE('Pedido excluído.');
    EXCEPTION
        WHEN ORDER_UTILS.ORDER_NOT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pedido não encontrado, não foi possível excluir.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
