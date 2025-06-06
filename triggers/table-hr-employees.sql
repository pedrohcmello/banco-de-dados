CREATE TABLE FUNCIONARIOS AS SELECT * FROM HR.EMPLOYEES;

-- 1) Crie a trigger BI_HR_EMP_SALARY_CHECK que impeça a inserção de um funcionário com salário inferior a 1000.
CREATE OR REPLACE TRIGGER BI_HR_EMP_SALARY_CHECK
BEFORE INSERT ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  IF :NEW.salary < 1000 THEN
    RAISE_APPLICATION_ERROR(-20010, 'O salário não pode ser inferior a 1000.');
  END IF;
END;

BEGIN
  INSERT INTO FUNCIONARIOS (employee_id, first_name, last_name, salary)
  VALUES (300, 'João', 'Silva', 900);
END;

-- 2) Crie a trigger BI_HR_EMP_HIRE_DATE_DEFAULT que atribua a data atual ao campo hire_date ao inserir um funcionário, caso este seja inserido com valor NULL.
CREATE OR REPLACE TRIGGER BI_HR_EMP_HIRE_DATE_DEFAULT
BEFORE INSERT ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  IF :NEW.hire_date IS NULL THEN
    :NEW.hire_date := SYSDATE;
  END IF;
END;

BEGIN
  INSERT INTO FUNCIONARIOS (employee_id, first_name, last_name, salary)
  VALUES (301, 'Maria', 'Souza', 2000);
END;

-- 3) Crie a trigger BU_HR_EMP_SALARY_LOG que registre em uma tabela de log (EMP_SALARY_LOG) o salário antigo e o novo sempre que o salário for atualizado.
CREATE TABLE EMP_SALARY_LOG (
  employee_id NUMBER,
  old_salary NUMBER,
  new_salary NUMBER,
  change_date DATE
);

CREATE OR REPLACE TRIGGER BU_HR_EMP_SALARY_LOG
BEFORE UPDATE OF salary ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  INSERT INTO EMP_SALARY_LOG(employee_id, old_salary, new_salary, change_date)
  VALUES (:OLD.employee_id, :OLD.salary, :NEW.salary, SYSDATE);
END;

BEGIN
  UPDATE FUNCIONARIOS SET salary = 3000 WHERE employee_id = 301;
END;

-- 4) Crie a trigger BD_HR_EMP_NO_DELETE_MANAGER que impeça a exclusão de um funcionário que é gerente (ou seja, possui subordinados).
CREATE OR REPLACE TRIGGER BD_HR_EMP_NO_DELETE_MANAGER
BEFORE DELETE ON FUNCIONARIOS
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM FUNCIONARIOS
  WHERE manager_id = :OLD.employee_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20011, 'Não é permitido excluir um gerente que possui subordinados.');
  END IF;
END;

BEGIN
  DELETE FROM FUNCIONARIOS WHERE employee_id = 100;
END;

-- 5) Crie a trigger BU_HR_EMP_DEPT_AUDIT que grave o histórico de mudança de departamento de um funcionário em uma tabela de auditoria (EMP_DEPT_AUDIT).
CREATE TABLE EMP_DEPT_AUDIT (
  employee_id NUMBER,
  old_department_id NUMBER,
  new_department_id NUMBER,
  change_date DATE
);

CREATE OR REPLACE TRIGGER BU_HR_EMP_DEPT_AUDIT
BEFORE UPDATE OF department_id ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  INSERT INTO EMP_DEPT_AUDIT(employee_id, old_department_id, new_department_id, change_date)
  VALUES (:OLD.employee_id, :OLD.department_id, :NEW.department_id, SYSDATE);
END;

BEGIN
  UPDATE FUNCIONARIOS SET department_id = 50 WHERE employee_id = 301;
END;

-- 6) Crie a trigger BI_HR_EMP_DEFAULT_JOB que atribua automaticamente o cargo SA_REP ao inserir um funcionário cujo job_id for NULL.
CREATE OR REPLACE TRIGGER BI_HR_EMP_DEFAULT_JOB
BEFORE INSERT ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  IF :NEW.job_id IS NULL THEN
    :NEW.job_id := 'SA_REP';
  END IF;
END;

BEGIN
  INSERT INTO FUNCIONARIOS (employee_id, first_name, last_name, salary)
  VALUES (302, 'Carlos', 'Pereira', 2500);
END;

-- 7) Crie a trigger AI_HR_EMP_LOG_INSERT que insira um registro em uma tabela de log (EMP_LOG) sempre que um novo funcionário for inserido.
CREATE TABLE EMP_LOG (
  employee_id NUMBER,
  log_date DATE
);

CREATE OR REPLACE TRIGGER AI_HR_EMP_LOG_INSERT
AFTER INSERT ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  INSERT INTO EMP_LOG(employee_id, log_date)
  VALUES (:NEW.employee_id, SYSDATE);
END;

BEGIN
  INSERT INTO FUNCIONARIOS (employee_id, first_name, last_name, salary)
  VALUES (303, 'Ana', 'Oliveira', 2700);
END;

-- 8) Crie a trigger BU_HR_EMP_JOB_RESTRICTION que impeça a alteração do cargo (job_id) de qualquer funcionário para AD_PRES, exceto se ele já ocupar esse cargo.
CREATE OR REPLACE TRIGGER BU_HR_EMP_JOB_RESTRICTION
BEFORE UPDATE OF job_id ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  IF :NEW.job_id = 'AD_PRES' AND :OLD.job_id != 'AD_PRES' THEN
    RAISE_APPLICATION_ERROR(-20012, 'Somente quem já é AD_PRES pode permanecer nesse cargo.');
  END IF;
END;

BEGIN
  UPDATE FUNCIONARIOS SET job_id = 'AD_PRES' WHERE employee_id = 301;
END;

-- 9) Crie a trigger BD_HR_EMP_LOG_DELETE que registre em uma tabela (EMP_DELETE_LOG) os dados do funcionário antes de sua exclusão.
CREATE TABLE EMP_DELETE_LOG (
  employee_id NUMBER,
  first_name VARCHAR2(20),
  last_name VARCHAR2(25),
  delete_date DATE
);

CREATE OR REPLACE TRIGGER BD_HR_EMP_LOG_DELETE
BEFORE DELETE ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  INSERT INTO EMP_DELETE_LOG(employee_id, first_name, last_name, delete_date)
  VALUES (:OLD.employee_id, :OLD.first_name, :OLD.last_name, SYSDATE);
END;

BEGIN
  DELETE FROM FUNCIONARIOS WHERE employee_id = 303;
END;

-- 10) Crie a trigger BI_HR_EMP_DEFAULT_DEPT que defina automaticamente o departamento como 10 ao inserir um funcionário cujo department_id seja NULL.
CREATE OR REPLACE TRIGGER BI_HR_EMP_DEFAULT_DEPT
BEFORE INSERT ON FUNCIONARIOS
FOR EACH ROW
BEGIN
  IF :NEW.department_id IS NULL THEN
    :NEW.department_id := 10;
  END IF;
END;

BEGIN
  INSERT INTO FUNCIONARIOS (employee_id, first_name, last_name, salary)
  VALUES (304, 'Lucas', 'Almeida', 2800);
END;
