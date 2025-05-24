-- Questão 2

SELECT DBMS_RANDOM.NORMAL FROM DUAL;

DECLARE
v_num NUMBER;
BEGIN
SELECT DBMS_RANDOM.NORMAL INTO v_num FROM DUAL;
DBMS_OUTPUT.PUT_LINE('Número gerado: ' || TO_CHAR(v_num));

IF v_num = 0 THEN
    DBMS_OUTPUT.PUT_LINE('O número é zero.');
ELSIF v_num > 0 THEN
    DBMS_OUTPUT.PUT_LINE('O número é maior que zero.');
ELSE
    DBMS_OUTPUT.PUT_LINE('O número é menor que zero.');
END IF;
--END  também ?


-- Questão 3

DECLARE
v_total_antigo NUMBER := 0;
v_total_novo NUMBER := 0;
v_diferenca NUMBER;
BEGIN

SELECT SUM(salary)
INTO v_total_antigo
FROM employees;
SELECT SUM(salary * 1.09)
INTO v_total_novo
FROM employees;

v_diferenca := v_total_novo - v_total_antigo;

DBMS_OUTPUT.PUT_LINE('A empresa vai pagar R$ ' || TO_CHAR(ROUND(v_diferenca, 2)) || ' a mais por mês.');
END;
/

-- Questão 4
DECLARE
CURSOR c_funcoes IS
SELECT job_id, COUNT() AS qtd
FROM employees
GROUP BY job_id
HAVING COUNT() > 3;

v_job_id VARCHAR2(10);
v_qtd NUMBER;
BEGIN
OPEN c_funcoes;
LOOP
    FETCH c_funcoes INTO v_job_id, v_qtd;
    EXIT WHEN c_funcoes%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Função ' || v_job_id || ' = ' || v_qtd);
END LOOP;

CLOSE c_funcoes;
END;
/


-- Questão 5

DECLARE
CURSOR c_func IS
SELECT first_name, last_name, email, hire_date
FROM employees
ORDER BY first_name, last_name;

v_nome employees.first_name%TYPE;
v_sobrenome employees.last_name%TYPE;
v_email employees.email%TYPE;
v_data employees.hire_date%TYPE;

BEGIN
OPEN c_func;

LOOP
    FETCH c_func INTO v_nome, v_sobrenome, v_email, v_data;
    EXIT WHEN c_func%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(v_nome || ' ' || v_sobrenome || ', EMAIL: ' || v_email || ', DATA DE CONTRATAÇÃO: ' || TO_CHAR(v_data, 'DD-MON-YY'));
END LOOP;

CLOSE c_func;
END;
/