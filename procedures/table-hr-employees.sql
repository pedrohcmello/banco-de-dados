CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

-- 1) Crie uma procedure chamada INCREMENT_SALARY que receba o employee_id e um valor percentual, e aumente o salário do funcionário correspondente.

CREATE OR REPLACE PROCEDURE INCREMENT_SALARY(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_percent NUMBER
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET salary = salary + (salary * p_percent / 100)
    WHERE employee_id = p_employee_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Salário atualizado para o funcionário ' || p_employee_id);
END;

BEGIN
    INCREMENT_SALARY(100, 10);
END;

-- 2) Crie uma procedure UPDATE_JOB que atualize o job_id de um funcionário, recebendo como parâmetros o employee_id e o novo job_id.

CREATE OR REPLACE PROCEDURE UPDATE_JOB(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_new_job_id FUNCIONARIOS.JOB_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET job_id = p_new_job_id
    WHERE employee_id = p_employee_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Cargo atualizado para o funcionário ' || p_employee_id);
END;

BEGIN
    UPDATE_JOB(100, 'IT_PROG');
END;

-- 3) Crie uma procedure PRINT_EMPLOYEE_DETAILS que receba um employee_id e imprima no console o nome, salário e o department_id do funcionário.

CREATE OR REPLACE PROCEDURE PRINT_EMPLOYEE_DETAILS(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_first_name FUNCIONARIOS.FIRST_NAME%TYPE;
    v_salary FUNCIONARIOS.SALARY%TYPE;
    v_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE;
BEGIN
    SELECT first_name, salary, department_id
    INTO v_first_name, v_salary, v_department_id
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_first_name || ', Salário: ' || v_salary || ', Departamento: ' || v_department_id);
END;

BEGIN
    PRINT_EMPLOYEE_DETAILS(100);
END;

-- 4) Crie uma procedure TRANSFER_EMPLOYEE que transfira um funcionário de um department_id para outro, recebendo como parâmetros o employee_id e o novo department_id.

CREATE OR REPLACE PROCEDURE TRANSFER_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_new_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET department_id = p_new_department_id
    WHERE employee_id = p_employee_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Funcionário ' || p_employee_id || ' transferido para o departamento ' || p_new_department_id);
END;

BEGIN
    TRANSFER_EMPLOYEE(100, 50);
END;

-- 5) Crie uma procedure FIRE_EMPLOYEE que exclua um funcionário da tabela HR.EMPLOYEES com base no employee_id. Antes de excluir, imprima uma mensagem de confirmação com o nome do funcionário.

CREATE OR REPLACE PROCEDURE FIRE_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_first_name FUNCIONARIOS.FIRST_NAME%TYPE;
BEGIN
    SELECT first_name INTO v_first_name
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    DBMS_OUTPUT.PUT_LINE('Funcionário ' || v_first_name || ' será excluído.');
    
    DELETE FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Funcionário excluído com sucesso.');
END;

BEGIN
    FIRE_EMPLOYEE(100);
END;

-- 6) Crie uma procedure LIST_EMPLOYEES_BY_DEPT que receba um department_id e liste todos os funcionários que pertencem a este departamento, mostrando employee_id, first_name, last_name e salary.

CREATE OR REPLACE PROCEDURE LIST_EMPLOYEES_BY_DEPT(
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
BEGIN
    FOR rec IN (
        SELECT employee_id, first_name, last_name, salary
        FROM FUNCIONARIOS
        WHERE department_id = p_department_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.employee_id || ', Nome: ' || rec.first_name || ' ' || rec.last_name || ', Salário: ' || rec.salary);
    END LOOP;
END;

BEGIN
    LIST_EMPLOYEES_BY_DEPT(50);
END;

-- 7) Crie uma procedure RAISE_SALARY_ALL que aumente em 10% o salário de todos os funcionários de um departamento específico, passado como parâmetro.

CREATE OR REPLACE PROCEDURE RAISE_SALARY_ALL(
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET salary = salary * 1.10
    WHERE department_id = p_department_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Salários aumentados em 10% para o departamento ' || p_department_id);
END;

BEGIN
    RAISE_SALARY_ALL(50);
END;

-- 8) Crie uma procedure HIRE_EMPLOYEE que insira um novo funcionário na tabela, recebendo como parâmetros os campos essenciais: first_name, last_name, email, hire_date, job_id, salary, department_id.

CREATE OR REPLACE PROCEDURE HIRE_EMPLOYEE(
    p_first_name FUNCIONARIOS.FIRST_NAME%TYPE,
    p_last_name FUNCIONARIOS.LAST_NAME%TYPE,
    p_email FUNCIONARIOS.EMAIL%TYPE,
    p_hire_date FUNCIONARIOS.HIRE_DATE%TYPE,
    p_job_id FUNCIONARIOS.JOB_ID%TYPE,
    p_salary FUNCIONARIOS.SALARY%TYPE,
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
    v_new_id FUNCIONARIOS.EMPLOYEE_ID%TYPE;
BEGIN
    SELECT MAX(employee_id) + 1 INTO v_new_id FROM FUNCIONARIOS;
    
    INSERT INTO FUNCIONARIOS (employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id)
    VALUES (v_new_id, p_first_name, p_last_name, p_email, p_hire_date, p_job_id, p_salary, p_department_id);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Novo funcionário contratado com ID ' || v_new_id);
END;

BEGIN
    HIRE_EMPLOYEE('João', 'Silva', 'joao.silva@example.com', SYSDATE, 'SA_REP', 3000, 50);
END;

-- 9) Crie uma procedure EMPLOYEE_SALARY_STATUS que receba o employee_id e informe no console se o salário do funcionário está acima ou abaixo da média salarial da empresa.

CREATE OR REPLACE PROCEDURE EMPLOYEE_SALARY_STATUS(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_salary FUNCIONARIOS.SALARY%TYPE;
    v_avg_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    SELECT AVG(salary) INTO v_avg_salary FROM FUNCIONARIOS;
    
    IF v_salary > v_avg_salary THEN
        DBMS_OUTPUT.PUT_LINE('O salário do funcionário ' || p_employee_id || ' está acima da média.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O salário do funcionário ' || p_employee_id || ' está abaixo da média.');
    END IF;
END;

BEGIN
    EMPLOYEE_SALARY_STATUS(100);
END;

-- 10) Crie uma procedure PROMOTE_EMPLOYEE que, ao receber um employee_id, aumente o salário em 15% e altere o job_id para 'MANAGER'.

CREATE OR REPLACE PROCEDURE PROMOTE_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET salary = salary * 1.15,
        job_id = 'MANAGER'
    WHERE employee_id = p_employee_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Funcionário ' || p_employee_id || ' promovido a MANAGER com aumento de 15%.');
END;

BEGIN
    PROMOTE_EMPLOYEE(100);
END;
