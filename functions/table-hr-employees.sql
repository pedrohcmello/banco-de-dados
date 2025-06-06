CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

-- 1) Crie uma função GET_EMPLOYEE_SALARY que receba um employee_id e retorne o salário do funcionário.

CREATE OR REPLACE FUNCTION GET_EMPLOYEE_SALARY(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN FUNCIONARIOS.SALARY%TYPE IS
    v_salary FUNCIONARIOS.SALARY%TYPE;
BEGIN
    SELECT salary INTO v_salary
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    RETURN v_salary;
END;

SELECT GET_EMPLOYEE_SALARY(100) FROM dual;

-- 2) Crie uma função GET_EMPLOYEE_FULLNAME que receba um employee_id e retorne o nome completo do funcionário concatenando first_name e last_name.

CREATE OR REPLACE FUNCTION GET_EMPLOYEE_FULLNAME(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN VARCHAR2 IS
    v_fullname VARCHAR2(100);
BEGIN
    SELECT first_name || ' ' || last_name INTO v_fullname
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    RETURN v_fullname;
END;

SELECT GET_EMPLOYEE_FULLNAME(100) FROM dual;

-- 3) Crie uma função GET_DEPARTMENT_EMPLOYEE_COUNT que receba um department_id e retorne a quantidade de funcionários que trabalham nesse departamento.

CREATE OR REPLACE FUNCTION GET_DEPARTMENT_EMPLOYEE_COUNT(
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM FUNCIONARIOS
    WHERE department_id = p_department_id;
    
    RETURN v_count;
END;

SELECT GET_DEPARTMENT_EMPLOYEE_COUNT(60) FROM dual;

-- 4) Crie uma função IS_EMPLOYEE_MANAGER que receba um employee_id e retorne 'Y' se o funcionário for gerente (se estiver listado como manager_id de alguém), ou 'N' caso contrário.

CREATE OR REPLACE FUNCTION IS_EMPLOYEE_MANAGER(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN CHAR IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM FUNCIONARIOS
    WHERE manager_id = p_employee_id;
    
    IF v_count > 0 THEN
        RETURN 'Y';
    ELSE
        RETURN 'N';
    END IF;
END;

SELECT IS_EMPLOYEE_MANAGER(100) FROM dual;

-- 5) Crie uma função GET_AVERAGE_SALARY_BY_JOB que receba um job_id e retorne a média salarial de todos os funcionários com esse cargo.

CREATE OR REPLACE FUNCTION GET_AVERAGE_SALARY_BY_JOB(
    p_job_id FUNCIONARIOS.JOB_ID%TYPE
) RETURN NUMBER IS
    v_avg_salary NUMBER;
BEGIN
    SELECT AVG(salary) INTO v_avg_salary
    FROM FUNCIONARIOS
    WHERE job_id = p_job_id;
    
    RETURN v_avg_salary;
END;

SELECT GET_AVERAGE_SALARY_BY_JOB('IT_PROG') FROM dual;

-- 6) Crie uma função GET_EMPLOYEE_HIRE_YEAR que receba um employee_id e retorne apenas o ano em que o funcionário foi contratado.

CREATE OR REPLACE FUNCTION GET_EMPLOYEE_HIRE_YEAR(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN NUMBER IS
    v_year NUMBER;
BEGIN
    SELECT EXTRACT(YEAR FROM hire_date) INTO v_year
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    RETURN v_year;
END;

SELECT GET_EMPLOYEE_HIRE_YEAR(100) FROM dual;

-- 7) Crie uma função GET_EMPLOYEE_SENIORITY que receba um employee_id e retorne a quantidade de anos que o funcionário está na empresa, com base na hire_date.

CREATE OR REPLACE FUNCTION GET_EMPLOYEE_SENIORITY(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN NUMBER IS
    v_years NUMBER;
BEGIN
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) INTO v_years
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    RETURN v_years;
END;

SELECT GET_EMPLOYEE_SENIORITY(100) FROM dual;

-- 8) Crie uma função GET_TOTAL_SALARY_BY_DEPARTMENT que receba um department_id e retorne a soma dos salários de todos os funcionários deste departamento.

CREATE OR REPLACE FUNCTION GET_TOTAL_SALARY_BY_DEPARTMENT(
    p_department_id FUNCIONARIOS.DEPARTMENT_ID%TYPE
) RETURN NUMBER IS
    v_total_salary NUMBER;
BEGIN
    SELECT SUM(salary) INTO v_total_salary
    FROM FUNCIONARIOS
    WHERE department_id = p_department_id;
    
    RETURN v_total_salary;
END;

SELECT GET_TOTAL_SALARY_BY_DEPARTMENT(60) FROM dual;

-- 9) Crie uma função GET_JOB_TITLE_BY_EMPLOYEE que receba um employee_id e retorne o job_id do funcionário.

CREATE OR REPLACE FUNCTION GET_JOB_TITLE_BY_EMPLOYEE(
    p_employee_id FUNCIONARIOS.EMPLOYEE_ID%TYPE
) RETURN FUNCIONARIOS.JOB_ID%TYPE IS
    v_job_id FUNCIONARIOS.JOB_ID%TYPE;
BEGIN
    SELECT job_id INTO v_job_id
    FROM FUNCIONARIOS
    WHERE employee_id = p_employee_id;
    
    RETURN v_job_id;
END;

SELECT GET_JOB_TITLE_BY_EMPLOYEE(100) FROM dual;

-- 10) Crie uma função GET_HIGHEST_SALARY que retorne o maior salário da tabela HR.EMPLOYEES.
CREATE OR REPLACE FUNCTION GET_HIGHEST_SALARY RETURN NUMBER IS
    v_max_salary NUMBER;
BEGIN
    SELECT MAX(salary) INTO v_max_salary
    FROM FUNCIONARIOS;
    
    RETURN v_max_salary;
END;

SELECT GET_HIGHEST_SALARY FROM dual;
