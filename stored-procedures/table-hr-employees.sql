CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

-- 1) Crie uma stored procedure ADD_EMPLOYEE que insira um novo funcionário na tabela HR.EMPLOYEES, recebendo como parâmetros: first_name, last_name, email, hire_date, job_id, salary e department_id.

CREATE OR REPLACE PROCEDURE ADD_EMPLOYEE(
    p_first_name FUNCIONARIOS.FIRST_NAME%TYPE,
    p_last_name FUNCIONARIOS.LAST_NAME%TYPE,
    p_email FUNCIONARIOS.EMAIL%TYPE,
    p_hire_date FUNCIONARIOS.HIRE_DATE%TYPE,
    p_job_id FUNCIONARIOS.JOB_ID%TYPE,
    p_salary FUNCIONARIOS.SALARY%TYPE,
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
BEGIN
    INSERT INTO FUNCIONARIOS (
        EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID, SALARY, DEPARTMENT_ID
    ) VALUES (
        (SELECT MAX(EMPLOYEE_ID) + 1 FROM FUNCIONARIOS),
        p_first_name, p_last_name, p_email, p_hire_date, p_job_id, p_salary, p_department_id
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funcionário adicionado com sucesso.');
END;

BEGIN
    ADD_EMPLOYEE('JOHN', 'DOE', 'JDOE@EMAIL.COM', SYSDATE, 'IT_PROG', 5000, 60);
END;

-- 2) Crie uma stored procedure REMOVE_EMPLOYEE que exclua um funcionário com base no employee_id, após confirmar que ele não é um gerente de outro funcionário.

CREATE OR REPLACE PROCEDURE REMOVE_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM FUNCIONARIOS WHERE MANAGER_ID = p_employee_id;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Não é possível remover: funcionário é gerente.');
    ELSE
        DELETE FROM FUNCIONARIOS WHERE EMPLOYEE_ID = p_employee_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Funcionário removido com sucesso.');
    END IF;
END;

BEGIN
    REMOVE_EMPLOYEE(100);
END;

-- 3) Crie uma stored procedure ADJUST_SALARY que receba um employee_id e um valor percentual, e ajuste o salário do funcionário conforme o percentual informado.

CREATE OR REPLACE PROCEDURE ADJUST_SALARY(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_percent NUMBER
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET SALARY = SALARY + (SALARY * p_percent / 100)
    WHERE EMPLOYEE_ID = p_employee_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salário ajustado para o funcionário ' || p_employee_id);
END;

BEGIN
    ADJUST_SALARY(101, 10);
END;

-- 4) Crie uma stored procedure CHANGE_JOB que atualize o job_id de um funcionário com base no employee_id, recebendo também o novo job_id como parâmetro.

CREATE OR REPLACE PROCEDURE CHANGE_JOB(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_new_job_id FUNCIONARIOS.JOB_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET JOB_ID = p_new_job_id
    WHERE EMPLOYEE_ID = p_employee_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Cargo alterado para o funcionário ' || p_employee_id);
END;

BEGIN
    CHANGE_JOB(102, 'SA_REP');
END;

-- 5) Crie uma stored procedure TRANSFER_TO_DEPARTMENT que mova um funcionário de um departamento para outro, recebendo employee_id e o novo department_id como parâmetros.

CREATE OR REPLACE PROCEDURE TRANSFER_TO_DEPARTMENT(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_new_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET DEPARTMENT_ID = p_new_department_id
    WHERE EMPLOYEE_ID = p_employee_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funcionário ' || p_employee_id || ' transferido para o departamento ' || p_new_department_id);
END;

BEGIN
    TRANSFER_TO_DEPARTMENT(103, 80);
END;

-- 6) Crie uma stored procedure PROMOTE_TO_MANAGER que promova um funcionário para gerente, alterando seu job_id para 'MANAGER' e ajustando seu salário em 20%.

CREATE OR REPLACE PROCEDURE PROMOTE_TO_MANAGER(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET JOB_ID = 'MANAGER',
        SALARY = SALARY * 1.2
    WHERE EMPLOYEE_ID = p_employee_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funcionário ' || p_employee_id || ' promovido a gerente.');
END;

BEGIN
    PROMOTE_TO_MANAGER(104);
END;

-- 7) Crie uma stored procedure LIST_DEPARTMENT_EMPLOYEES que liste no console (DBMS_OUTPUT.PUT_LINE) todos os funcionários de um determinado department_id, mostrando employee_id, first_name, last_name e salary.

CREATE OR REPLACE PROCEDURE LIST_DEPARTMENT_EMPLOYEES(
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
BEGIN
    FOR rec IN (SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY FROM FUNCIONARIOS WHERE DEPARTMENT_ID = p_department_id) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.EMPLOYEE_ID || ' - ' || rec.FIRST_NAME || ' ' || rec.LAST_NAME || ', Salário: ' || rec.SALARY);
    END LOOP;
END;

BEGIN
    LIST_DEPARTMENT_EMPLOYEES(90);
END;

-- 8) Crie uma stored procedure SHOW_EMPLOYEE_DETAILS que exiba no console (DBMS_OUTPUT.PUT_LINE) os detalhes completos de um funcionário com base no employee_id.

CREATE OR REPLACE PROCEDURE SHOW_EMPLOYEE_DETAILS(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_emp FUNCIONARIOS%ROWTYPE;
BEGIN
    SELECT * INTO v_emp FROM FUNCIONARIOS WHERE EMPLOYEE_ID = p_employee_id;

    DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.EMPLOYEE_ID);
    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_emp.FIRST_NAME || ' ' || v_emp.LAST_NAME);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_emp.EMAIL);
    DBMS_OUTPUT.PUT_LINE('Data de Admissão: ' || v_emp.HIRE_DATE);
    DBMS_OUTPUT.PUT_LINE('Cargo: ' || v_emp.JOB_ID);
    DBMS_OUTPUT.PUT_LINE('Salário: ' || v_emp.SALARY);
    DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_emp.DEPARTMENT_ID);
END;

BEGIN
    SHOW_EMPLOYEE_DETAILS(105);
END;

-- 9) Crie uma stored procedure INCREASE_SALARY_BY_DEPARTMENT que aumente o salário de todos os funcionários de um determinado departamento, recebido como parâmetro, em uma porcentagem também passada como parâmetro.

CREATE OR REPLACE PROCEDURE INCREASE_SALARY_BY_DEPARTMENT(
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE,
    p_percent NUMBER
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET SALARY = SALARY + (SALARY * p_percent / 100)
    WHERE DEPARTMENT_ID = p_department_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salários aumentados no departamento ' || p_department_id);
END;

BEGIN
    INCREASE_SALARY_BY_DEPARTMENT(100, 5);
END;

-- 10) Crie uma stored procedure FIRE_EMPLOYEES_BELOW_SALARY que exclua todos os funcionários cujo salário seja menor do que um valor mínimo informado como parâmetro.

CREATE OR REPLACE PROCEDURE FIRE_EMPLOYEES_BELOW_SALARY(
    p_min_salary FUNCIONARIOS.SALARY%TYPE
) AS
BEGIN
    DELETE FROM FUNCIONARIOS WHERE SALARY < p_min_salary;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funcionários com salário abaixo de ' || p_min_salary || ' foram demitidos.');
END;

BEGIN
    FIRE_EMPLOYEES_BELOW_SALARY(3000);
END;
