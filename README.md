
# Oracle Live SQL - Projeto de PL/SQL com HR.EMPLOYEES e OE.ORDERS

Este repositório contém a implementação de diversas questões resolvidas sobre PL/SQL, utilizando as tabelas HR.EMPLOYEES e OE.ORDERS no ambiente Oracle Live SQL. O foco foi demonstrar habilidades práticas em vários recursos da linguagem.

## Descrição do Projeto

O projeto abrange a criação e manipulação de:

- **Views:** consultas reutilizáveis para simplificar e padronizar o acesso aos dados.
- **Triggers:** automação de processos e garantias de integridade nas operações de dados.
- **Procedures:** encapsulamento de blocos de código para operações específicas.
- **Functions:** funções reutilizáveis que retornam valores a partir de parâmetros.
- **Packages:** agrupamento lógico de procedures e functions, promovendo organização e segurança.
- **Stored Procedures:** procedimentos armazenados diretamente no banco de dados.
- **Exceptions:** tratamento robusto de erros para garantir a confiabilidade das operações.

## Tabelas Utilizadas

### HR.EMPLOYEES
- Foco em manipulação de dados de funcionários
- Validações de integridade
- Auditoria de alterações
- Automatização de processos

### OE.ORDERS
- Gerenciamento de pedidos
- Atualização automática de status e datas
- Regras de negócio e validação de integridade
- Controle de operações críticas

## Estrutura do Repositório

/banco-de-dados/
- exceptions/
- functions/
- packages/
- procedures/
- stored-procedures/
- triggers/
- views/

Cada pasta contém as soluções para as questões propostas, organizadas por tipo de recurso e por tabela.

## Como Executar

1. Acesse o ambiente Oracle Live SQL: https://livesql.oracle.com/
2. Copie os scripts desejados do repositório.
3. Execute cada script conforme as instruções e sequência indicadas nos arquivos.
4. Valide os resultados executando consultas ou operações associadas.

## Tecnologias

- Oracle Database
- PL/SQL
- SQL
- Git e GitHub

## Contato

Este projeto foi desenvolvido para fins de estudo, prática e composição de portfólio. Fique à vontade para contribuir com sugestões ou melhorias.

## License

MIT License

Copyright (c) 2025 Pedro Henrique

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
