Parte I
1. Função de conversão Fahrenheit → Celsius
CREATE OR REPLACE FUNCTION fahrenheit_para_celsius (f NUMBER)
RETURN NUMBER IS
BEGIN
  RETURN (f - 32) / 1.8;
END;

2. Função para retornar nome e departamento pelo número de matrícula
CREATE OR REPLACE FUNCTION obter_nome_departamento(matricula IN NUMBER)
RETURN VARCHAR2 IS
  v_nome funcionarios.first_name%TYPE;
  v_sobrenome funcionarios.last_name%TYPE;
  v_departamento departamentos.department_name%TYPE;
BEGIN
  SELECT f.first_name, f.last_name, d.department_name
  INTO v_nome, v_sobrenome, v_departamento
  FROM funcionarios f
  JOIN departamentos d ON f.department_id = d.department_id
  WHERE f.employee_id = matricula;

  RETURN v_nome || ' ' || v_sobrenome || ' - ' || v_departamento;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Funcionário não encontrado';
END;

Parte II
1. Função para obter o nome completo
CREATE OR REPLACE FUNCTION nome_completo(employee_id IN NUMBER)
RETURN VARCHAR2 IS
  v_nome funcionarios.first_name%TYPE;
  v_sobrenome funcionarios.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_nome, v_sobrenome
  FROM funcionarios
  WHERE employee_id = employee_id;

  RETURN v_nome || ' ' || v_sobrenome;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Funcionário não encontrado';
END;

2. Função para obter salário
CREATE OR REPLACE FUNCTION obter_salario(employee_id IN NUMBER)
RETURN NUMBER IS
  v_salario funcionarios.salary%TYPE;
BEGIN
  SELECT salary INTO v_salario
  FROM funcionarios
  WHERE employee_id = employee_id;

  RETURN v_salario;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;


3. Função: nome dos funcionários + nome do departamento
CREATE OR REPLACE FUNCTION nomes_por_departamento(dept_id IN NUMBER)
RETURN CLOB IS
  v_result CLOB := '';
BEGIN
  FOR r IN (
    SELECT f.first_name || ' ' || f.last_name AS nome, d.department_name
    FROM funcionarios f
    JOIN departamentos d ON f.department_id = d.department_id
    WHERE f.department_id = dept_id
  ) LOOP
    v_result := v_result || r.nome || ' - ' || r.department_name || CHR(10);
  END LOOP;

  IF v_result IS NULL THEN
    RETURN 'Nenhum funcionário encontrado.';
  END IF;

  RETURN v_result;
END;


4. Função para retornar total da folha de pagamento
CREATE OR REPLACE FUNCTION total_folha
RETURN NUMBER IS
  v_total NUMBER;
BEGIN
  SELECT SUM(salary) INTO v_total FROM funcionarios;
  RETURN v_total;
END;


5. Função para aplicar aumento de 10% e retornar novo total
CREATE OR REPLACE FUNCTION aplicar_aumento(dept_id IN NUMBER)
RETURN NUMBER IS
  v_total NUMBER := 0;
BEGIN
  UPDATE funcionarios
  SET salary = salary * 1.10
  WHERE department_id = dept_id;

  SELECT SUM(salary) INTO v_total
  FROM funcionarios
  WHERE department_id = dept_id;

  RETURN v_total;
END;


6. Procedure: Listagem dos funcionários
CREATE OR REPLACE PROCEDURE listar_funcionarios IS
BEGIN
  FOR r IN (
    SELECT f.first_name || ' ' || f.last_name AS nome,
           f.hire_date,
           f.phone_number,
           f.email,
           (SELECT m.first_name || ' ' || m.last_name
            FROM funcionarios m
            WHERE m.employee_id = f.manager_id) AS gerente,
           d.department_name,
           f.salary,
           f.commission_pct
    FROM funcionarios f
    LEFT JOIN departamentos d ON f.department_id = d.department_id
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Nome: ' || r.nome || ', Data Contratação: ' || r.hire_date ||
      ', Telefone: ' || r.phone_number || ', E-mail: ' || r.email ||
      ', Gerente: ' || NVL(r.gerente, 'Sem gerente') || 
      ', Departamento: ' || r.department_name || ', Salário: ' || r.salary ||
      ', Comissão: ' || NVL(TO_CHAR(r.commission_pct), '0')
    );
  END LOOP;
END;
