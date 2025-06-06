CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

CREATE OR REPLACE PACKAGE EMPLOYEE_UTILS AS
    -- 1) Crie um package EMPLOYEE_UTILS que contenha uma procedure GET_EMPLOYEE_NAME que exiba o first_name e last_name de um funcionário a partir do employee_id informado.
    PROCEDURE GET_EMPLOYEE_NAME(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE);
    
    -- 2) Adicione ao package EMPLOYEE_UTILS uma function GET_EMPLOYEE_SALARY que retorne o salary de um funcionário com base no employee_id.
    FUNCTION GET_EMPLOYEE_SALARY(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) RETURN NUMBER;
    
    -- 3) Inclua no package EMPLOYEE_UTILS uma procedure INCREASE_SALARY que aumente o salário de um funcionário em uma porcentagem informada.
    PROCEDURE INCREASE_SALARY(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE, p_percent NUMBER);
    
    -- 4) Adicione ao package EMPLOYEE_UTILS uma procedure TRANSFER_EMPLOYEE que altere o department_id de um funcionário para um departamento informado.
    PROCEDURE TRANSFER_EMPLOYEE(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE, p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE);
    
    -- 5) No package EMPLOYEE_UTILS, crie uma function IS_MANAGER que retorne TRUE se o employee_id for gerente de alguém, ou FALSE caso contrário.
    FUNCTION IS_MANAGER(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) RETURN BOOLEAN;
    
    -- 9) No package EMPLOYEE_UTILS, crie uma exception customizada employee_not_found e levante-a na procedure GET_EMPLOYEE_NAME caso o employee_id não exista.
    employee_not_found EXCEPTION;
    
    -- 10) Inclua no package EMPLOYEE_UTILS uma procedure DELETE_EMPLOYEE que exclua um funcionário com base no employee_id. Antes da exclusão, verifique se ele é gerente e, se for, levante uma exceção customizada.
    PROCEDURE DELETE_EMPLOYEE(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE);
END EMPLOYEE_UTILS;

CREATE OR REPLACE PACKAGE BODY EMPLOYEE_UTILS AS

    -- 1) GET_EMPLOYEE_NAME
    PROCEDURE GET_EMPLOYEE_NAME(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) AS
        v_first_name FUNCIONARIOS.FIRST_NAME%TYPE;
        v_last_name FUNCIONARIOS.LAST_NAME%TYPE;
    BEGIN
        SELECT first_name, last_name INTO v_first_name, v_last_name
        FROM FUNCIONARIOS
        WHERE employee_id = p_employee_id;

        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_first_name || ' ' || v_last_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE employee_not_found;
    END;

    -- 2) GET_EMPLOYEE_SALARY
    FUNCTION GET_EMPLOYEE_SALARY(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) RETURN NUMBER AS
        v_salary FUNCIONARIOS.SALARY%TYPE;
    BEGIN
        SELECT salary INTO v_salary
        FROM FUNCIONARIOS
        WHERE employee_id = p_employee_id;

        RETURN v_salary;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
            RETURN NULL;
    END;

    -- 3) INCREASE_SALARY
    PROCEDURE INCREASE_SALARY(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE, p_percent NUMBER) AS
    BEGIN
        UPDATE FUNCIONARIOS
        SET salary = salary + (salary * p_percent / 100)
        WHERE employee_id = p_employee_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Salário atualizado para o funcionário ' || p_employee_id);
    END;

    -- 4) TRANSFER_EMPLOYEE
    PROCEDURE TRANSFER_EMPLOYEE(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE, p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE) AS
    BEGIN
        UPDATE FUNCIONARIOS
        SET department_id = p_department_id
        WHERE employee_id = p_employee_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Funcionário ' || p_employee_id || ' transferido para o departamento ' || p_department_id);
    END;

    -- 5) IS_MANAGER
    FUNCTION IS_MANAGER(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) RETURN BOOLEAN AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM FUNCIONARIOS
        WHERE manager_id = p_employee_id;

        RETURN v_count > 0;
    END;

    -- 10) DELETE_EMPLOYEE
    PROCEDURE DELETE_EMPLOYEE(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) AS
        v_is_manager BOOLEAN;
        manager_delete_ex EXCEPTION;
    BEGIN
        v_is_manager := IS_MANAGER(p_employee_id);

        IF v_is_manager THEN
            RAISE manager_delete_ex;
        ELSE
            DELETE FROM FUNCIONARIOS
            WHERE employee_id = p_employee_id;

            COMMIT;

            DBMS_OUTPUT.PUT_LINE('Funcionário excluído: ' || p_employee_id);
        END IF;

    EXCEPTION
        WHEN manager_delete_ex THEN
            DBMS_OUTPUT.PUT_LINE('Não é permitido excluir um gerente.');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    END;

END EMPLOYEE_UTILS;

CREATE OR REPLACE PACKAGE EMPLOYEE_REPORTS AS
    -- 6) Crie um package EMPLOYEE_REPORTS que contenha uma procedure LIST_DEPARTMENT_EMPLOYEES que exiba todos os funcionários de um department_id informado.
    PROCEDURE LIST_DEPARTMENT_EMPLOYEES(p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE);
    
    -- 7) Inclua no package EMPLOYEE_REPORTS uma function GET_EMPLOYEE_COUNT_BY_JOB que retorne a quantidade de funcionários para um job_id informado.
    FUNCTION GET_EMPLOYEE_COUNT_BY_JOB(p_job_id FUNCIONARIOS.JOB_ID%TYPE) RETURN NUMBER;
    
    -- 8) Adicione ao package EMPLOYEE_REPORTS uma procedure PRINT_HIRE_DATE que exiba a hire_date de um funcionário com base no employee_id.
    PROCEDURE PRINT_HIRE_DATE(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE);
END EMPLOYEE_REPORTS;

CREATE OR REPLACE PACKAGE BODY EMPLOYEE_REPORTS AS

    -- 6) LIST_DEPARTMENT_EMPLOYEES
    PROCEDURE LIST_DEPARTMENT_EMPLOYEES(p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE) AS
        CURSOR c_emps IS
            SELECT employee_id, first_name, last_name
            FROM FUNCIONARIOS
            WHERE department_id = p_department_id;
        v_emp c_emps%ROWTYPE;
    BEGIN
        OPEN c_emps;
        LOOP
            FETCH c_emps INTO v_emp;
            EXIT WHEN c_emps%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.employee_id || ' Nome: ' || v_emp.first_name || ' ' || v_emp.last_name);
        END LOOP;
        CLOSE c_emps;
    END;

    -- 7) GET_EMPLOYEE_COUNT_BY_JOB
    FUNCTION GET_EMPLOYEE_COUNT_BY_JOB(p_job_id FUNCIONARIOS.JOB_ID%TYPE) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM FUNCIONARIOS
        WHERE job_id = p_job_id;

        RETURN v_count;
    END;

    -- 8) PRINT_HIRE_DATE
    PROCEDURE PRINT_HIRE_DATE(p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE) AS
        v_hire_date FUNCIONARIOS.HIRE_DATE%TYPE;
    BEGIN
        SELECT hire_date INTO v_hire_date
        FROM FUNCIONARIOS
        WHERE employee_id = p_employee_id;

        DBMS_OUTPUT.PUT_LINE('Data de contratação: ' || TO_CHAR(v_hire_date, 'DD/MM/YYYY'));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    END;

END EMPLOYEE_REPORTS;

BEGIN
    -- 1) GET_EMPLOYEE_NAME
    EMPLOYEE_UTILS.GET_EMPLOYEE_NAME(100);
    EXCEPTION
        WHEN EMPLOYEE_UTILS.employee_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
END;

DECLARE
    -- 2) GET_EMPLOYEE_SALARY
    v_salary NUMBER;
BEGIN
    v_salary := EMPLOYEE_UTILS.GET_EMPLOYEE_SALARY(100);
    IF v_salary IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Salário: ' || v_salary);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    END IF;
END;

BEGIN
    -- 3) INCREASE_SALARY
    EMPLOYEE_UTILS.INCREASE_SALARY(100, 10);
END;

BEGIN
    -- 4) TRANSFER_EMPLOYEE
    EMPLOYEE_UTILS.TRANSFER_EMPLOYEE(100, 50);
END;

BEGIN
    -- 5) IS_MANAGER
    IF EMPLOYEE_UTILS.IS_MANAGER(100) THEN
        DBMS_OUTPUT.PUT_LINE('É gerente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Não é gerente.');
    END IF;
END;

BEGIN
    -- 6) LIST_DEPARTMENT_EMPLOYEES
    EMPLOYEE_REPORTS.LIST_DEPARTMENT_EMPLOYEES(50);
END;

BEGIN
    -- 7) GET_EMPLOYEE_COUNT_BY_JOB
    DBMS_OUTPUT.PUT_LINE('Quantidade: ' || EMPLOYEE_REPORTS.GET_EMPLOYEE_COUNT_BY_JOB('SA_REP'));
END;

DECLARE
    -- 8) PRINT_HIRE_DATE
    v_count NUMBER;
BEGIN
    v_count := EMPLOYEE_REPORTS.GET_EMPLOYEE_COUNT_BY_JOB('IT_PROG');
    DBMS_OUTPUT.PUT_LINE('Quantidade de funcionários: ' || v_count);
END;

BEGIN
    -- 9) Testando a exception customizada
    BEGIN
        EMPLOYEE_UTILS.GET_EMPLOYEE_NAME(-1);
    EXCEPTION
        WHEN EMPLOYEE_UTILS.employee_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Exceção: Funcionário não encontrado.');
    END;
END;

BEGIN
    -- 10) DELETE_EMPLOYEE
    EMPLOYEE_UTILS.DELETE_EMPLOYEE(100);
        DBMS_OUTPUT.PUT_LINE('Pedido excluído.');
    EXCEPTION
        WHEN ORDER_UTILS.ORDER_NOT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pedido não encontrado, não foi possível excluir.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
