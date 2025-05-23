--PROBLEMA 1
DECLARE
   a number;
   b number;
   maximo number;
   media number;

   PROCEDURE valorMaximo(x IN number, y IN number, z OUT number) IS
   BEGIN
      IF x > y THEN
         z := x;
      ELSE
         z := y;
      END IF;
   END;

   PROCEDURE valorMedio(x IN number, y IN number, z OUT number) IS
   BEGIN
      z := (x + y) / 2;
   END;

BEGIN
   a := 23;
   b := 45;

   valorMaximo(a, b, maximo);
   valorMedio(a, b, media);

   dbms_output.put_line('O valor máximo entre ' || a || ' e ' || b || ' é: ' || maximo);
   dbms_output.put_line('A média entre ' || a || ' e ' || b || ' é: ' || media);
END;



--PROBLEMA 2
EXEC SP_CIDADES(1, ‘GASPAR’, ‘SC’, ‘I’);
--RESPOSTA : 
-- Resultado: Erro de tipo. 
--Vai retornar algo como ORA-06550, 
--porque o primeiro parâmetro deveria 
--ser um número (INTEGER), e passamos uma string.

-- Correto : EXEC SP_CIDADES('um', 'GASPAR', 'SC', 'I');

--4) Tente executar o mesmo comando anterior sem informar
 --algum dado ou informando tipos de dados diferentes. 
 --Relate o que acontece.

--Resposta : 
--EXEC SP_CIDADES(2, 'FLORIANÓPOLIS', 'SC', 'X');
-- Resultado: ORA-20999: ATENÇÃO! Operação diferente de Inserção, Deleção ou Atualização.
--Ou seja, o sistema identificou 
--que o tipo de operação não é válido 
--e lançou uma exceção personalizada.


--PROBLEMA 3
create table funcionarios as select * from hr.employees;

CREATE OR REPLACE PROCEDURE detalhes_dos_funcionarios
IS
  CURSOR emp_cur IS
    SELECT first_name, last_name, salary
    FROM funcionarios;
  emp_rec emp_cur%rowtype;
BEGIN
  FOR emp_rec in emp_cur LOOP
    dbms_output.put_line('Nome do funcionário: ' || emp_rec.first_name ||
     '. Sobrenome do funcionário: ' ||emp_rec.last_name ||
     '. Salário do funcionário: ' ||emp_rec.salary);
  END LOOP;
END;


--PROBLEMA 4

CREATE OR REPLACE FUNCTION PRIMO (NUMERO NUMBER) 
RETURN VARCHAR2
IS
  VSQRT NUMBER(4);
  VDIV NUMBER(4);
  VRESULT VARCHAR(20):='É PRIMO';
  
BEGIN
      --RAIZ QUADRADA DO NUMERO
      VSQRT := SQRT(NUMERO);
      
      FOR I IN 2..VSQRT LOOP
        IF(MOD(NUMERO,I)=0 AND NUMERO<>I)THEN
          VRESULT := 'NÃO É PRIMO';
        END IF;
      END LOOP;
      RETURN VRESULT;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(PRIMO(4));
END;

--RESPOSTA : 
--Resultado: NÃO É PRIMO


--3) Consegue perceber a diferença do tipo de comando deste problema se comparado aos problemas 2 e 3? Explique. 
-- Resposta : 3) Diferença de tipo de comando
--A principal diferença aqui é que 
--no problema 4 foi usada uma função, 
--enquanto nos problemas anteriores foram usadas procedures. 
--A função é diferente porque ela retorna 
--um valor diretamente (com RETURN), 
--enquanto a procedure executa ações 
--e pode ter parâmetros de saída, 
--mas não retorna valores diretamente.




