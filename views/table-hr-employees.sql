CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

-- 1) Crie uma view EMPLOYEE_BASIC_INFO que exiba apenas o employee_id, first_name, last_name e email da tabela HR.EMPLOYEES.

CREATE OR REPLACE VIEW EMPLOYEE_BASIC_INFO AS
SELECT employee_id, first_name, last_name, email
FROM FUNCIONARIOS;

SELECT * FROM EMPLOYEE_BASIC_INFO WHERE employee_id = 100;

-- 2) Crie uma view EMPLOYEE_SALARY_VIEW que exiba employee_id, first_name, last_name e salary de todos os funcionários que ganham mais de 5000.

CREATE OR REPLACE VIEW EMPLOYEE_SALARY_VIEW AS
SELECT employee_id, first_name, last_name, salary
FROM FUNCIONARIOS
WHERE salary > 5000;

SELECT * FROM EMPLOYEE_SALARY_VIEW;

-- 3) Crie uma view MANAGERS_VIEW que mostre o employee_id, first_name, last_name e manager_id apenas dos funcionários que são gerentes (ou seja, que possuem manager_id igual a algum employee_id).

CREATE OR REPLACE VIEW MANAGERS_VIEW AS
SELECT employee_id, first_name, last_name, manager_id
FROM FUNCIONARIOS
WHERE manager_id IN (SELECT employee_id FROM FUNCIONARIOS);

SELECT * FROM MANAGERS_VIEW;

-- 4) Crie uma view EMPLOYEE_JOB_VIEW que combine o nome e o sobrenome (first_name e last_name) em um único campo chamado full_name e também mostre o job_id.

CREATE OR REPLACE VIEW EMPLOYEE_JOB_VIEW AS
SELECT first_name || ' ' || last_name AS full_name, job_id
FROM FUNCIONARIOS;

SELECT * FROM EMPLOYEE_JOB_VIEW WHERE job_id = 'IT_PROG';

-- 5) Crie uma view DEPARTMENT_EMPLOYEES que exiba o department_id e o número total de funcionários por departamento, utilizando GROUP BY.

CREATE OR REPLACE VIEW DEPARTMENT_EMPLOYEES AS
SELECT department_id, COUNT(*) AS total_employees
FROM FUNCIONARIOS
GROUP BY department_id;

SELECT * FROM DEPARTMENT_EMPLOYEES;

-- 6) Crie uma view EMPLOYEES_HIRED_AFTER_2005 que exiba todos os dados dos funcionários contratados após o ano de 2005.

CREATE OR REPLACE VIEW EMPLOYEES_HIRED_AFTER_2005 AS
SELECT *
FROM FUNCIONARIOS
WHERE hire_date > TO_DATE('2005-12-31', 'YYYY-MM-DD');

SELECT employee_id, first_name, hire_date FROM EMPLOYEES_HIRED_AFTER_2005;

-- 7) Crie uma view EMPLOYEE_CONTACT_VIEW que exiba o first_name, last_name, phone_number e email apenas dos funcionários do departamento 90.

CREATE OR REPLACE VIEW EMPLOYEE_CONTACT_VIEW AS
SELECT first_name, last_name, phone_number, email
FROM FUNCIONARIOS
WHERE department_id = 90;

SELECT * FROM EMPLOYEE_CONTACT_VIEW;

-- 8) Crie uma view EMPLOYEE_SALARY_WITH_TAX que exiba o employee_id, salary e um campo calculado salary_with_tax que seja o salary multiplicado por 0.8 (considerando um imposto de 20%).

CREATE OR REPLACE VIEW EMPLOYEE_SALARY_WITH_TAX AS
SELECT employee_id, salary, salary * 0.8 AS salary_with_tax
FROM FUNCIONARIOS;

SELECT * FROM EMPLOYEE_SALARY_WITH_TAX WHERE employee_id = 100;

-- 9) Crie uma view EMPLOYEES_BY_JOB que mostre o job_id e a quantidade de funcionários que ocupam cada cargo, ordenado pela quantidade de funcionários em ordem decrescente.

CREATE OR REPLACE VIEW EMPLOYEES_BY_JOB AS
SELECT job_id, COUNT(*) AS total_employees
FROM FUNCIONARIOS
GROUP BY job_id
ORDER BY total_employees DESC;

SELECT * FROM EMPLOYEES_BY_JOB;

-- 10) Crie uma view chamada EMPLOYEE_EXPERIENCE_VIEW que exiba o employee_id, first_name, last_name e o número de anos de experiência de cada funcionário, considerando que a experiência é calculada como a diferença entre a data atual (SYSDATE) e a data de contratação (hire_date), convertida para anos inteiros.

CREATE OR REPLACE VIEW EMPLOYEE_EXPERIENCE_VIEW AS
SELECT employee_id, first_name, last_name, 
       FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS years_of_experience
FROM FUNCIONARIOS;

SELECT * FROM EMPLOYEE_EXPERIENCE_VIEW WHERE years_of_experience > 10;
