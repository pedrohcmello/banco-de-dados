--🔧 Etapa 1: Criar cópia das tabelas do HR

CREATE TABLE funcionarios AS SELECT * FROM hr.employees;
CREATE TABLE departamentos AS SELECT * FROM hr.departments;

--📦 Etapa 2: Criar o pacote pckFuncionarios
--Especificação (spec)

CREATE OR REPLACE PACKAGE pckFuncionarios IS
  FUNCTION obter_nome_funcionario(p_employee_id IN funcionarios.employee_id%TYPE) 
    RETURN VARCHAR2;

  FUNCTION obter_salario(p_employee_id IN funcionarios.employee_id%TYPE) 
    RETURN funcionarios.salary%TYPE;

  PROCEDURE funcionarios_por_departamento(p_department_id IN departamentos.department_id%TYPE);

  FUNCTION total_folha_pagamento RETURN NUMBER;

  PROCEDURE aplicar_aumento_salario(p_department_id IN departamentos.department_id%TYPE);

  PROCEDURE listar_funcionarios;
END pckFuncionarios;
Corpo (body)

CREATE OR REPLACE PACKAGE BODY pckFuncionarios IS

  -- Função: Nome completo do funcionário
  FUNCTION obter_nome_funcionario(p_employee_id IN funcionarios.employee_id%TYPE) 
    RETURN VARCHAR2 IS
    v_nome funcionarios.first_name%TYPE;
    v_sobrenome funcionarios.last_name%TYPE;
  BEGIN
    SELECT first_name, last_name INTO v_nome, v_sobrenome
    FROM funcionarios
    WHERE employee_id = p_employee_id;
    
    RETURN v_nome || ' ' || v_sobrenome;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Funcionário não encontrado';
  END;

  -- Função: Salário do funcionário
  FUNCTION obter_salario(p_employee_id IN funcionarios.employee_id%TYPE) 
    RETURN funcionarios.salary%TYPE IS
    v_salario funcionarios.salary%TYPE;
  BEGIN
    SELECT salary INTO v_salario
    FROM funcionarios
    WHERE employee_id = p_employee_id;
    
    RETURN v_salario;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END;

  -- Procedimento: Funcionários por departamento
  PROCEDURE funcionarios_por_departamento(p_department_id IN departamentos.department_id%TYPE) IS
  BEGIN
    FOR r IN (
      SELECT 
        f.first_name || ' ' || f.last_name AS nome_funcionario,
        d.department_name AS nome_departamento
      FROM funcionarios f
      JOIN departamentos d ON f.department_id = d.department_id
      WHERE f.department_id = p_department_id
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Funcionário: ' || r.nome_funcionario);
      DBMS_OUTPUT.PUT_LINE('Departamento: ' || r.nome_departamento);
      DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
  END;

  -- Função: Total da folha de pagamento
  FUNCTION total_folha_pagamento RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT SUM(salary) INTO v_total FROM funcionarios;
    RETURN v_total;
  END;

  -- Procedimento: Aumentar salário em 10% no departamento
  PROCEDURE aplicar_aumento_salario(p_department_id IN departamentos.department_id%TYPE) IS
  BEGIN
    UPDATE funcionarios
    SET salary = salary * 1.10
    WHERE department_id = p_department_id;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' funcionário(s) tiveram aumento.');
    COMMIT;
  END;

  -- Procedimento: Listagem de funcionários completa
  PROCEDURE listar_funcionarios IS
  BEGIN
    FOR r IN (
      SELECT 
        f.first_name || ' ' || f.last_name AS nome_funcionario,
        f.hire_date,
        f.phone_number,
        f.email,
        NVL(m.first_name || ' ' || m.last_name, 'Sem gerente') AS nome_gerente,
        d.department_name,
        f.salary,
        NVL(f.commission_pct, 0) AS comissao
      FROM funcionarios f
      LEFT JOIN funcionarios m ON f.manager_id = m.employee_id
      LEFT JOIN departamentos d ON f.department_id = d.department_id
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('Nome: ' || r.nome_funcionario);
      DBMS_OUTPUT.PUT_LINE('Contratação: ' || r.hire_date);
      DBMS_OUTPUT.PUT_LINE('Telefone: ' || r.phone_number);
      DBMS_OUTPUT.PUT_LINE('Email: ' || r.email);
      DBMS_OUTPUT.PUT_LINE('Gerente: ' || r.nome_gerente);
      DBMS_OUTPUT.PUT_LINE('Departamento: ' || r.department_name);
      DBMS_OUTPUT.PUT_LINE('Salário: R$' || r.salary);
      DBMS_OUTPUT.PUT_LINE('Comissão: ' || r.comissao);
      DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
  END;

END pckFuncionarios;
