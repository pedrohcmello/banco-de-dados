--1) Procedure: ADD_CUSTOMER

CREATE OR REPLACE PROCEDURE add_customer (
  p_cust_first_name      IN customers.cust_first_name%TYPE,
  p_cust_last_name       IN customers.cust_last_name%TYPE,
  p_cust_gender          IN customers.cust_gender%TYPE,
  p_cust_email           IN customers.cust_email%TYPE,
  p_cust_address         IN customers.cust_street_address%TYPE,
  p_cust_postal_code     IN customers.cust_postal_code%TYPE,
  p_cust_city            IN customers.cust_city%TYPE,
  p_cust_city_id         IN customers.cust_city_id%TYPE,
  p_cust_state_province  IN customers.cust_state_province%TYPE,
  p_country_id           IN customers.country_id%TYPE
) IS
BEGIN
  INSERT INTO customers (
    cust_id, cust_first_name, cust_last_name, cust_gender,
    cust_email, cust_street_address, cust_postal_code,
    cust_city, cust_city_id, cust_state_province, country_id
  )
  VALUES (
    customers_seq.NEXTVAL, p_cust_first_name, p_cust_last_name, p_cust_gender,
    p_cust_email, p_cust_address, p_cust_postal_code,
    p_cust_city, p_cust_city_id, p_cust_state_province, p_country_id
  );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro ao adicionar cliente: ' || SQLERRM);
END;
--🔧 Observação: Substitua customers_seq.NEXTVAL pelo nome correto da sequência usada na sua base (ou gere um cust_id manualmente, se necessário).

--2) Procedure: UPDATE_PRODUCT_STATUS

CREATE OR REPLACE PROCEDURE update_product_status (
  p_prod_id IN produtos.prod_id%TYPE,
  p_status  IN VARCHAR2
) IS
BEGIN
  UPDATE produtos
  SET prod_status = p_status
  WHERE prod_id = p_prod_id;

  IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Produto não encontrado.');
  ELSE
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status atualizado com sucesso.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

--3) Function: GET_CUSTOMER_NAME

CREATE OR REPLACE FUNCTION get_customer_name (
  p_customer_id IN customers.cust_id%TYPE
) RETURN VARCHAR2 IS
  v_nome customers.cust_first_name%TYPE;
  v_sobrenome customers.cust_last_name%TYPE;
BEGIN
  SELECT cust_first_name, cust_last_name INTO v_nome, v_sobrenome
  FROM customers
  WHERE cust_id = p_customer_id;

  RETURN v_nome || ' ' || v_sobrenome;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Cliente não encontrado';
END;

--4) Procedure: GET_CUSTOMER_PER_COUNTRY

CREATE OR REPLACE PROCEDURE get_customer_per_country (
  p_country_id IN countries.country_id%TYPE
) IS
BEGIN
  FOR r IN (
    SELECT 
      cust_first_name || ' ' || cust_last_name AS nome_completo,
      cust_email,
      cust_gender,
      cust_street_address || ', ' || cust_postal_code || ', ' ||
      cust_city || ' (' || cust_city_id || '), ' || cust_state_province AS endereco
    FROM customers
    WHERE country_id = p_country_id
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Nome: ' || r.nome_completo);
    DBMS_OUTPUT.PUT_LINE('E-mail: ' || r.cust_email);
    DBMS_OUTPUT.PUT_LINE('Gênero: ' || r.cust_gender);
    DBMS_OUTPUT.PUT_LINE('Endereço: ' || r.endereco);
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
  END LOOP;
END;


--5) Procedure: SALES_REPORT

CREATE OR REPLACE PROCEDURE sales_report (
  p_data_inicio IN DATE,
  p_data_fim    IN DATE
) IS
BEGIN
  FOR r IN (
    SELECT 
      c.cust_first_name || ' ' || c.cust_last_name AS nome,
      SUM(s.amount_sold) AS total_gasto
    FROM sh.sales s
    JOIN sh.customers c ON s.cust_id = c.cust_id
    WHERE s.time_id BETWEEN p_data_inicio AND p_data_fim
    GROUP BY c.cust_first_name, c.cust_last_name
    ORDER BY total_gasto DESC
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || r.nome || ' | Total Gasto: R$' || r.total_gasto);
  END LOOP;
END;











Ferramentas



O ChatGPT pode cometer erros. Considere verificar informações importantes.