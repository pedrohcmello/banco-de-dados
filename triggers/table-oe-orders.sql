CREATE TABLE PEDIDOS AS SELECT * FROM OE.ORDERS;

-- 1) Crie a trigger BI_OE_ORDERS_DEFAULT_STATUS que defina o order_status como 'Pending' ao inserir um novo pedido com esse campo NULL.

CREATE OR REPLACE TRIGGER BI_OE_ORDERS_DEFAULT_STATUS
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
BEGIN
  IF :NEW.order_status IS NULL THEN
    :NEW.order_status := 'Pending';
  END IF;
END;

BEGIN
  INSERT INTO PEDIDOS (order_id, customer_id, order_total, order_date)
  VALUES (1001, 101, 150, SYSDATE);
END;

-- 2) Crie a trigger BI_OE_ORDERS_MIN_TOTAL que impeça a inserção de um pedido com order_total inferior a 100.

CREATE OR REPLACE TRIGGER BI_OE_ORDERS_MIN_TOTAL
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
BEGIN
  IF :NEW.order_total < 100 THEN
    RAISE_APPLICATION_ERROR(-20020, 'O valor total do pedido deve ser de no mínimo 100.');
  END IF;
END;

BEGIN
  INSERT INTO PEDIDOS (order_id, customer_id, order_total, order_date)
  VALUES (1002, 102, 50, SYSDATE);
END;

-- 3) Crie a trigger BU_OE_ORDERS_STATUS_VALIDATION que impeça a alteração do order_status de 'Shipped' para 'Pending'.

CREATE OR REPLACE TRIGGER BU_OE_ORDERS_STATUS_VALIDATION
BEFORE UPDATE OF order_status ON PEDIDOS
FOR EACH ROW
BEGIN
  IF :OLD.order_status = 'Shipped' AND :NEW.order_status = 'Pending' THEN
    RAISE_APPLICATION_ERROR(-20021, 'Não é permitido alterar de Shipped para Pending.');
  END IF;
END;

BEGIN
  UPDATE PEDIDOS
  SET order_status = 'Pending'
  WHERE order_id = 1001;
END;

-- 4) Crie a trigger AI_OE_ORDERS_LOG_INSERT que registre em uma tabela de log (ORDERS_LOG) o order_id, customer_id e order_date após a inserção de um pedido.

CREATE TABLE ORDERS_LOG (
  order_id NUMBER,
  customer_id NUMBER,
  order_date DATE
);

CREATE OR REPLACE TRIGGER AI_OE_ORDERS_LOG_INSERT
AFTER INSERT ON PEDIDOS
FOR EACH ROW
BEGIN
  INSERT INTO ORDERS_LOG(order_id, customer_id, order_date)
  VALUES(:NEW.order_id, :NEW.customer_id, :NEW.order_date);
END;

BEGIN
  INSERT INTO PEDIDOS (order_id, customer_id, order_total, order_date)
  VALUES (1003, 103, 200, SYSDATE);
END;

-- 5) Crie a trigger BD_OE_ORDERS_LOG_DELETE que registre em uma tabela (ORDERS_DELETE_LOG) as informações do pedido antes de sua exclusão.

CREATE TABLE ORDERS_DELETE_LOG (
  order_id NUMBER,
  customer_id NUMBER,
  order_date DATE
);

CREATE OR REPLACE TRIGGER BD_OE_ORDERS_LOG_DELETE
BEFORE DELETE ON PEDIDOS
FOR EACH ROW
BEGIN
  INSERT INTO ORDERS_DELETE_LOG(order_id, customer_id, order_date)
  VALUES(:OLD.order_id, :OLD.customer_id, :OLD.order_date);
END;

BEGIN
  DELETE FROM PEDIDOS WHERE order_id = 1003;
END;

-- 6) Crie a trigger BU_OE_ORDERS_UPDATE_MODIFIED_DATE que atualize automaticamente o campo last_modified_date com SYSDATE toda vez que um pedido for alterado.

CREATE OR REPLACE TRIGGER BU_OE_ORDERS_UPDATE_MODIFIED_DATE
BEFORE UPDATE ON PEDIDOS
FOR EACH ROW
BEGIN
  :NEW.last_modified_date := SYSDATE;
END;

BEGIN
  UPDATE PEDIDOS
  SET order_total = 250
  WHERE order_id = 1001;
END;

-- 7) Crie a trigger BIU_OE_ORDERS_STATUS_UPPER que transforme o order_status para letras maiúsculas ao inserir ou atualizar um pedido.

CREATE OR REPLACE TRIGGER BIU_OE_ORDERS_STATUS_UPPER
BEFORE INSERT OR UPDATE OF order_status ON PEDIDOS
FOR EACH ROW
BEGIN
  :NEW.order_status := UPPER(:NEW.order_status);
END;

BEGIN
  UPDATE PEDIDOS
  SET order_status = 'pending'
  WHERE order_id = 1001;
END;

-- 8) Crie a trigger BD_OE_ORDERS_PROTECT_SHIPPED que impeça a exclusão de pedidos cujo order_status seja 'Shipped'.

CREATE OR REPLACE TRIGGER BD_OE_ORDERS_PROTECT_SHIPPED
BEFORE DELETE ON PEDIDOS
FOR EACH ROW
BEGIN
  IF :OLD.order_status = 'Shipped' THEN
    RAISE_APPLICATION_ERROR(-20022, 'Não é permitido excluir pedidos com status Shipped.');
  END IF;
END;

BEGIN
  DELETE FROM PEDIDOS WHERE order_id = 1001;
END;

-- 9) Crie a trigger AIU_OE_ORDERS_TOTAL_CALC que atualize automaticamente o order_total com base na soma de itens (ou fixe um valor simulado) após inserção ou atualização de um pedido.

CREATE OR REPLACE TRIGGER AIU_OE_ORDERS_TOTAL_CALC
AFTER INSERT OR UPDATE ON PEDIDOS
FOR EACH ROW
BEGIN
  UPDATE PEDIDOS
  SET order_total = 500
  WHERE order_id = :NEW.order_id;
END;

BEGIN
  INSERT INTO PEDIDOS (order_id, customer_id, order_total, order_date)
  VALUES (1004, 104, 0, SYSDATE);
END;

-- 10) Crie a trigger BU_OE_ORDERS_NO_NULL_CUSTOMER que impeça que o customer_id de um pedido seja atualizado para NULL, lançando um erro personalizado.

CREATE OR REPLACE TRIGGER BU_OE_ORDERS_NO_NULL_CUSTOMER
BEFORE UPDATE OF customer_id ON PEDIDOS
FOR EACH ROW
BEGIN
  IF :NEW.customer_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20023, 'O campo customer_id não pode ser NULL.');
  END IF;
END;

BEGIN
  UPDATE PEDIDOS
  SET customer_id = NULL
  WHERE order_id = 1001;
END;
