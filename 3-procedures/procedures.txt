-- Questão 1)
CREATE OR REPLACE PROCEDURE obter_nome_pessoa(
  p_id IN NUMBER,
  p_nome OUT VARCHAR2
)
IS
BEGIN
  SELECT nome INTO p_nome
  FROM pessoa
  WHERE id = p_id;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_nome := 'Pessoa não encontrada';
END;
/

-- Execução:
DECLARE
  v_nome VARCHAR2(120);
BEGIN
  obter_nome_pessoa(2, v_nome);
  DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_nome);
END;
/

-- Questão 2)
CREATE OR REPLACE PROCEDURE tabuada(p_numero IN NUMBER)
IS
BEGIN
  FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(p_numero || ' x ' || i || ' = ' || (p_numero * i));
  END LOOP;
END;
/

-- Execução:
BEGIN
  tabuada(7);
END;
/


-- Questão 3)
CREATE OR REPLACE PROCEDURE anos_bissextos
IS
BEGIN
  FOR ano IN 2000..2100 LOOP
    IF (MOD(ano, 4) = 0 AND MOD(ano, 100) != 0) OR (MOD(ano, 400) = 0) THEN
      DBMS_OUTPUT.PUT_LINE('Ano bissexto: ' || ano);
    END IF;
  END LOOP;
END;
/

-- Execução:
BEGIN
  anos_bissextos;
END;
/


-- Questão 4)
CREATE OR REPLACE PROCEDURE inserir_aluno_com_resultado(
  p_matricula IN NUMBER,
  p_nome IN VARCHAR2,
  p_a1 IN NUMBER,
  p_a2 IN NUMBER,
  p_a3 IN NUMBER,
  p_a4 IN NUMBER
)
IS
  v_media NUMBER(5,2);
  v_resultado VARCHAR2(30);
BEGIN
  v_media := (p_a1 + p_a2 + p_a3 + p_a4) / 4;

  IF v_media >= 6 THEN
    v_resultado := 'APROVADO';
  ELSE
    v_resultado := 'REPROVADO';
  END IF;

  INSERT INTO aluno (nr_matricula, nome, a1, a2, a3, a4, media, resultado)
  VALUES (p_matricula, p_nome, p_a1, p_a2, p_a3, p_a4, v_media, v_resultado);
  
  DBMS_OUTPUT.PUT_LINE('Aluno inserido com média ' || v_media || ' e resultado: ' || v_resultado);
END;
/

-- Execução:
BEGIN
  inserir_aluno_com_resultado(567, 'CARLA', 9, 8.5, 7, 10);
END;
/


-- Questão 5)
CREATE OR REPLACE PROCEDURE calcular_bonus(
  p_ano IN NUMBER,
  p_matricula IN NUMBER
)
IS
  v_lucro LUCRO.VALOR%TYPE;
  v_salario SALARIO.SALARIO%TYPE;
  v_bonus NUMBER(10,2);
BEGIN
  SELECT valor INTO v_lucro
  FROM lucro
  WHERE ano = p_ano;

  SELECT salario INTO v_salario
  FROM salario
  WHERE matricula = p_matricula;

  v_bonus := v_lucro * 0.01 + v_salario * 0.05;

  DBMS_OUTPUT.PUT_LINE('Bônus do funcionário ' || p_matricula || ' no ano ' || p_ano || ': R$ ' || v_bonus);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Dados não encontrados para o ano ou matrícula informada.');
END;
/

-- Execução:
BEGIN
  calcular_bonus(2019, 1002);
END;
/
