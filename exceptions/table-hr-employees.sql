CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

-- 1) Crie um bloco anônimo que busque e exiba o salary de um funcionário a partir do employee_id informado. Trate a exceção NO_DATA_FOUND exibindo uma mensagem apropriada.

DECLARE
    v_salary FUNCIONARIOS.SALARY%TYPE;
    v_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE := 100;
BEGIN
    SELECT SALARY INTO v_salary
    FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = v_employee_id;

    DBMS_OUTPUT.PUT_LINE('Salário do funcionário ' || v_employee_id || ': ' || v_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
END;

-- 2) Crie uma procedure GET_EMPLOYEE_INFO que exiba o first_name e last_name de um employee_id informado. Trate as exceções NO_DATA_FOUND e TOO_MANY_ROWS.

CREATE OR REPLACE PROCEDURE GET_EMPLOYEE_INFO(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_first_name FUNCIONARIOS.FIRST_NAME%TYPE;
    v_last_name FUNCIONARIOS.LAST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME INTO v_first_name, v_last_name
    FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = p_employee_id;

    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_first_name || ' ' || v_last_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: mais de um funcionário com o mesmo ID.');
END;

BEGIN
    GET_EMPLOYEE_INFO(100);
END;

-- 3) Crie uma função GET_SALARY_DIVISION que divida o salário de um funcionário por um número informado. Trate a exceção ZERO_DIVIDE quando o divisor for zero.

CREATE OR REPLACE FUNCTION GET_SALARY_DIVISION(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_divisor NUMBER
) RETURN NUMBER AS
    v_salary FUNCIONARIOS.SALARY%TYPE;
    v_result NUMBER;
BEGIN
    SELECT SALARY INTO v_salary
    FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = p_employee_id;

    v_result := v_salary / p_divisor;

    RETURN v_result;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Divisão por zero.');
        RETURN NULL;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
        RETURN NULL;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || GET_SALARY_DIVISION(100, 2));
END;

-- 4) Crie um bloco anônimo que tente excluir um funcionário a partir do employee_id informado. Se não existir, capture a exceção NO_DATA_FOUND e exiba: 'Funcionário não encontrado'.

DECLARE
    v_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE := 100;
BEGIN
    DELETE FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = v_employee_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funcionário excluído com sucesso.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
END;

-- 5) Crie uma procedure UPDATE_EMPLOYEE_JOB que atualize o job_id de um funcionário. Trate a exceção NO_DATA_FOUND caso o employee_id não exista, e exiba uma mensagem.

CREATE OR REPLACE PROCEDURE UPDATE_EMPLOYEE_JOB(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_new_job_id FUNCIONARIOS.JOB_ID%TYPE
) AS
BEGIN
    UPDATE FUNCIONARIOS
    SET JOB_ID = p_new_job_id
    WHERE EMPLOYEE_ID = p_employee_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Cargo atualizado com sucesso.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
END;

BEGIN
    UPDATE_EMPLOYEE_JOB(100, 'IT_PROG');
END;

-- 6) Crie uma procedure INCREASE_EMPLOYEE_SALARY que aumente o salário de um funcionário. Se o salário for maior que 20000, levante uma exceção customizada com RAISE_APPLICATION_ERROR.

CREATE OR REPLACE PROCEDURE INCREASE_EMPLOYEE_SALARY(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_increase NUMBER
) AS
    v_salary FUNCIONARIOS.SALARY%TYPE;
BEGIN
    SELECT SALARY INTO v_salary
    FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = p_employee_id;

    IF v_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salário acima do permitido para aumento.');
    END IF;

    UPDATE FUNCIONARIOS
    SET SALARY = SALARY + p_increase
    WHERE EMPLOYEE_ID = p_employee_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salário atualizado com sucesso.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

BEGIN
    INCREASE_EMPLOYEE_SALARY(100, 500);
END;

-- 7) Crie uma função GET_EMPLOYEE_HIRE_DATE que retorne a hire_date de um employee_id informado. Se não existir, retorne NULL e registre a ocorrência com DBMS_OUTPUT.PUT_LINE.

CREATE OR REPLACE FUNCTION GET_EMPLOYEE_HIRE_DATE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN DATE AS
    v_hire_date FUNCIONARIOS.HIRE_DATE%TYPE;
BEGIN
    SELECT HIRE_DATE INTO v_hire_date
    FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = p_employee_id;

    RETURN v_hire_date;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
        RETURN NULL;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Data de contratação: ' || GET_EMPLOYEE_HIRE_DATE(100));
END;

-- 8) Crie um bloco anônimo que busque o job_id de um funcionário a partir do employee_id. Trate NO_DATA_FOUND e TOO_MANY_ROWS, exibindo mensagens adequadas.

DECLARE
    v_job_id FUNCIONARIOS.JOB_ID%TYPE;
    v_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE := 100;
BEGIN
    SELECT JOB_ID INTO v_job_id
    FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = v_employee_id;

    DBMS_OUTPUT.PUT_LINE('Cargo: ' || v_job_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: mais de um funcionário com o mesmo ID.');
END;

-- 9) Crie uma procedure DELETE_EMPLOYEE que exclua um funcionário. Caso ele seja gerente (ou seja, esteja listado como manager_id de outro funcionário), levante uma exceção customizada.

CREATE OR REPLACE PROCEDURE DELETE_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM FUNCIONARIOS
    WHERE MANAGER_ID = p_employee_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Funcionário é gerente e não pode ser excluído.');
    END IF;

    DELETE FROM FUNCIONARIOS
    WHERE EMPLOYEE_ID = p_employee_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Funcionário excluído com sucesso.');
    END IF;
END;

BEGIN
    DELETE_EMPLOYEE(100);
END;

-- 10) Crie uma procedure TRANSFER_EMPLOYEE que transfira um funcionário de um departamento para outro. Se o department_id informado não existir, trate a exceção NO_DATA_FOUND adequadamente.

CREATE OR REPLACE PROCEDURE TRANSFER_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE,
    p_new_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) AS
    v_dep_id FUNCIONARIOS.DEPARTMENT_ID%TYPE;
BEGIN
    SELECT DEPARTMENT_ID INTO v_dep_id
    FROM HR.DEPARTMENTS
    WHERE DEPARTMENT_ID = p_new_department_id;

    UPDATE FUNCIONARIOS
    SET DEPARTMENT_ID = p_new_department_id
    WHERE EMPLOYEE_ID = p_employee_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funcionário transferido com sucesso.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário ou departamento não encontrado.');
END;

BEGIN
    TRANSFER_EMPLOYEE(100, 50);
END;
