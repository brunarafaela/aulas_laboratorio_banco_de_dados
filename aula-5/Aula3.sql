/**************************
Aula 3 - SQL - DDL e DML
***************************/

/*****************************************************************
Tipos de Select
******************************************************************/

--1 - Select simples que mostra todas as colunas e todas as linhas de uma tabela
SELECT * FROM ALUNO;

--2 - Descriminando as colunas e colocando condicao/filtro
SELECT nome_curso, carga_hora_curso, id_cert
FROM curso
WHERE duracao_aula >=50 AND NOTA_CORTE_CURSO <= 80;
 
 --sintaxe mais comum de um select
SELECT COLUNA1, COLUNA2, COLUNAN
FROM TABELA1, TABELA2, TABELA3
WHERE CONDICAO1 AND CONDICAO2 AND CONDICAOP
OR CONDICAOQ;

--3 - Funcoes de formatacao de caracteres - UPPER, LOWER, INITCAP
SELECT UPPER(nome_aluno) AS Maiusculo, LOWER(end_aluno) AS MINUSCULO,
INITCAP(email_aluno) AS "PRIMEIRA MAI RESTO MIN"
FROM ALUNO
WHERE sexo_aluno !='M';

--4- Operador de concatenacao - Pipe duplo ||
SELECT nome_aluno||' reside em '||end_aluno||' e nasceu em '||dt_nascto_aluno AS "DADOS DO ALUNO"
FROM ALUNO
WHERE sexo_aluno = 'M' OR sexo_aluno !='F';

--5 -Operador LIKE - busca nao exata
SELECT nome_aluno, end_aluno
FROM ALUNO
WHERE UPPER(end_aluno) LIKE '%IPIRANGA%';

SELECT nome_aluno, end_aluno
FROM ALUNO
WHERE UPPER(end_aluno) LIKE 'RUA%';

SELECT nome_aluno, end_aluno
FROM ALUNO
WHERE UPPER(end_aluno) NOT LIKE '%S_A PAULO%';

SELECT nome_aluno, end_aluno
FROM ALUNO
WHERE UPPER(nome_aluno) LIKE 'JOSE%';

SELECT nome_aluno, end_aluno
FROM ALUNO
WHERE UPPER(nome_aluno) LIKE 'JOS_%';


--6 -Funcao de data
select * 
from aluno
where dt_nascto_aluno >= '01/01/1992';

SELECT * FROM TURMA 
WHERE dt_inicio BETWEEN '15/08/2020' AND current_date;

SELECT * FROM TURMA 
WHERE dt_inicio BETWEEN '15/08/2020' AND current_date - 15;

--7 - Funcoes de data e hora mais comuns
SELECT * FROM DUAL ;
SELECT current_date FROM DUAL ;
SELECT SYSDATE FROM DUAL ;
SELECT current_timestamp FROM DUAL ;
SELECT systimestamp FROM DUAL ;


--8 - Funcao EXTRACT - extrai um pedaco da data
SELECT EXTRACT(DAY FROM current_date) FROM DUAL;
SELECT EXTRACT(MONTH FROM current_date) FROM DUAL;
SELECT EXTRACT(YEAR FROM current_date) FROM DUAL;
SELECT EXTRACT(HOUR FROM current_timestamp) FROM DUAL;
SELECT EXTRACT(SECOND FROM current_timestamp) FROM DUAL;
SELECT EXTRACT(MINUTE FROM current_timestamp) FROM DUAL;


--aluno que nasceu depois de 1993
SELECT nome_aluno, dt_nascto_aluno
FROM aluno
WHERE EXTRACT(YEAR FROM dt_nascto_aluno) > 1993;

--turmas que iniciaram mês passado
SELECT *
FROM TURMA
WHERE EXTRACT(MONTH FROM dt_inicio) = EXTRACT(MONTH FROM current_date) -1

--alunos que nao nasceram entre março e junho
SELECT nome_aluno, dt_nascto_aluno, sexo_aluno
FROM aluno
WHERE EXTRACT(MONTH FROM dt_nascto_aluno) NOT BETWEEN 3 AND 6;

-- Outra forma usando TO CHAR
SELECT TO_CHAR(current_date, 'DD-MON-YYYY') FROM DUAL;
SELECT nome_aluno, dt_nascto_aluno, sexo_aluno
FROM ALUNO
WHERE TO_CHAR(dt_nascto_aluno, 'MON') NOT BETWEEN 'MAR' AND 'SET';

--9- Operador INTERVAL em data

--Intervalo de dias
SELECT current_date + interval '5' day from dual;

--Intervalo de horas
select current_timestamp + interval '12' hour - interval '15' minute from dual;

--alunos maiores de 18 anos
SELECT nome_aluno, dt_nascto_aluno, sexo_aluno
FROM ALUNO
WHERE dt_nascto_aluno + INTERVAL '18' YEAR <= current_date;

SELECT nome_aluno, dt_nascto_aluno, sexo_aluno
FROM ALUNO
WHERE dt_nascto_aluno <= current_date - INTERVAL '28' YEAR;

--10 - Calculando idade dos alunos
SELECT nome_aluno, (current_date - dt_nascto_aluno) AS Dias
FROM ALUNO;

SELECT nome_aluno, ROUND((current_date - dt_nascto_aluno)/365.25,2) AS Idade
FROM ALUNO;

SELECT nome_aluno, ROUND(MONTHS_BETWEEN(current_date - dt_nascto_aluno)/12,2) AS Idade
FROM ALUNO; ---ERRO 



/*****************************************************************
       Join
******************************************************************/

--INNER JOIN --

--11 - Nome do curso e da certificacao
SELECT curso.nome_curso AS Curso, curso.id_cert AS FK, certificacao.id_cert AS PK, certificacao.nome_cert AS Certificacao
FROM curso, certificacao
WHERE curso.id_cert = curso.id_cert;

--12 - Idem ao 12 apelidando tabelas
SELECT c.nome_curso, c.duracao_aula, ce.nome_cert, ce.carga_hora_cert
FROM curso c, certificacao ce
WHERE c.id_cert = ce.id_cert;

--13 - Usando inner Join
SELECT c.nome_curso, c.duracao_aula, ce.nome_cert, ce.carga_hora_cert
FROM curso c inner join certificacao ce
  on (c.id_cert = ce.id_cert) --coluna de juncao
WHERE ce.carga_hora_cert > 200; 

--14- Juncao com 3 tabelas
SELECT t.num_turma, t.dt_inicio, t.horario_aula, c.nome_curso, ce.nome_cert
FROM turma t INNER JOIN curso c
    ON (t.id_curso = c.id_curso)
    INNER JOIN certificacao ce
    ON (c.id_cert = ce.id_cert)
WHERE EXTRACT(MONTH FROM t.dt_inicio) BETWEEN 8 AND 9
AND UPPER(ce.nome_cert) LIKE '%ORACLE%';

--15- Juncao com 4 tabelas - aula com conteudo que tenha a palavra conceito
--aula, curso, certificacao, empresa certificadora
SELECT a.num_aula, a.conteudo_previsto, c.nome_curso, ce.nome_cert, ec.nome_empresa
FROM aula a, curso c, certificacao ce, empresa_certificacao ec
WHERE
c.id_cert = ce.id_cert --curso x certificacao
AND a.id_curso = c.id_curso -- aula x curso
AND ce.id_empresa_cert = ec.id_empresa --certificacao x empresa certificacao
AND UPPER(a.conteudo_previsto) LIKE '%CONCEITO%'
ORDER BY a.num_aula;

--16 Idem ao 15 com INNER JOIN
SELECT a.num_aula, a.conteudo_previsto, c.nome_curso, ce.nome_cert, ec.nome_empresa
FROM empresa_certificacao ec INNER JOIN certificacao ce
ON (ce.id_empresa_cert = ec.id_empresa)
INNER JOIN curso c
ON (c.id_cert = ce.id_cert)
INNER JOIN aula a
ON (a.id_curso = c.id_curso)
WHERE UPPER(a.conteudo_previsto) LIKE '%CONCEITO%'
ORDER BY a.num_aula;


/*******
Atividade 03: Com a instrução SELECT responda às seguintes consultas :
1- Mostrar os dados dos cursos no formato : 'Fundamentos de Redes tem carga horária de 120 horas'  **/
SELECT c.nome_curso||' tem carga horaria de '||TO_CHAR(c.carga_hora_curso)||' horas' AS "Dados Curso"
FROM curso c 
ORDER BY c.nome_curso ;

/* 2- Mostrar o nome e carga horária das certificações que tem 'PROFESSIONAL' ou 'INSTRUCTOR'
no nome e tem nota de corte superior a 85 */
SELECT ce.nome_cert, ce.carga_hora_cert, ce.nota_corte
FROM certificacao ce
WHERE ( UPPER(ce.nome_cert) LIKE '%PROFESSIONAL%' 
          OR UPPER(ce.nome_cert) LIKE '%INSTRUCTOR%' )
AND ce.nota_corte >= 85 ;

/* 3' Mostrar os dados das alunas que NÃO tem as letras k,w e y no login e que tem mais de 22 anos : 
Nome Aluna-Idade-login */
SELECT a.nome_aluno AS Aluna, ROUND((current_date-a.dt_nascto_aluno)/365.25,0) AS Idade, a.login
FROM aluno a
WHERE ROUND((current_date-a.dt_nascto_aluno)/365.25,0) > 22
AND a.sexo_aluno = 'F'
AND UPPER(a.login) NOT LIKE '%K%' 
          AND UPPER(a.login) NOT LIKE '%Y%' 
          AND UPPER(a.login) NOT LIKE '%W%' ; 

/* 4- Mostrar os dados das turmas que tem entre 30 e 40 vagas e valor entre R$ 450 e R$ 550 
que ainda não começaram :
Número da Turma ' Data Início ' Valor ' Quantidade de vagas */
SELECT t.num_turma, TO_CHAR(t.dt_inicio, 'DD/MM/YYYY') AS Data_Inicio, t.vl_curso, t.vagas
FROM turma t
WHERE t.vagas BETWEEN 30 AND 50
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR( t.dt_inicio, 'DD/MM/YYYY'))  > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYYY'))  ;

SELECT current_timestamp FROM dual ;

/* 5- Repetir a consulta 4 acima, usando a sintaxe do INNER JOIN e adicionando os seguintes critérios : 
para cursos com carga horária inferiores a 200 horas, no formato : 
Nome do Curso- Carga Horária- Número da Turma ' Data Início ' Valor ' Quantidade de vagas */
SELECT c.nome_curso, c.carga_hora_curso, t.num_turma, t.dt_inicio, t.vl_curso, t.vagas
FROM turma t INNER JOIN curso c
                           ON ( t.id_curso = c.id_curso) 
WHERE t.vagas BETWEEN 30 AND 40
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR( t.dt_inicio, 'DD/MM/YYYY'))  > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYYY'))
AND c.carga_hora_curso < 200 ;

/* 6- Mostrar os softwares utilizados em certificações da Oracle que tem pré-requisitos : 
Nome do Software-Versão-Id Certificação Pré-Requisito */
INSERT INTO uso_softwares_curso VALUES ( 'SQL', 'SQLDEV' ) ;
INSERT INTO uso_softwares_curso VALUES ( 'CCNA1', 'PKTRAC' ) ;
SELECT * FROM uso_softwares_curso ;

SELECT s.nome_softw, s.versao_softw, ce.id_cert_pre_req
FROM software s, uso_softwares_curso swc , curso c, certificacao ce, empresa_certificacao ec
WHERE s.id_softw = swc.id_software -- software x uso softw
AND swc.id_curso = c.id_curso  -- uso softw x curso
AND c.id_cert = ce.id_cert  -- curso x cert 
AND ce.id_empresa_cert = ec.id_empresa -- cert x empresa certificacao
AND UPPER(ec.nome_empresa) LIKE '%ORACLE%'
AND ce.id_cert_pre_req IS NOT NULL ;

SELECT * FROM certificacao ;

/* 7- Mostrar o nome dos alunos que fizeram matrícula hoje entre 10 e 14 horas: 
Número da Matrícula-Data e Hora-Valor Pago-Turma-Nome Curso */
SELECT a.nome_aluno, mt.num_matricula, mt.dt_hora_matr, mt.vl_pago, t.num_turma, c.nome_curso
FROM aluno a, matricula mt, turma t , curso c
WHERE a.id_aluno = mt.id_aluno -- aluno x matricula
AND (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
AND t.id_curso = c.id_curso -- turma x curso
AND TO_CHAR(mt.dt_hora_matr, 'DD/MM/YYYY') = TO_CHAR(current_timestamp, 'DD/MM/YYYY') 
AND EXTRACT ( HOUR FROM mt.dt_hora_matr) BETWEEN 10 AND 14 ;

SELECT * FROM matricula ;
SELECT current_timestamp FROM dual ;

/* 8- Mostrar os alunos que cancelaram matrícula em turmas que terminam 
no próximo mês em certificações oferecidas pela Cisco no formato - usando a sintaxe do INNER JOIN :
Número Matrícula ' Data Hora Matrícula ' Nome do Aluno- Sexo- Turma ' Horário Aula-
Data Início-Data Término- Nome do Curso ' Nome da Certificação */
SELECT mt.num_matricula, mt.dt_hora_matr, a.nome_aluno, a.sexo_aluno, t.num_turma,
t.horario_aula, t.dt_inicio, t.dt_termino, c.nome_curso, ce.nome_cert
FROM aluno a INNER JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                           INNER JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                           INNER JOIN curso c ON ( t.id_curso = c.id_curso)
                           INNER JOIN certificacao ce ON ( c.id_cert = ce.id_cert) 
                           INNER JOIN empresa_certificacao ec ON ( ce.id_empresa_cert = ec.id_empresa)
WHERE EXTRACT ( MONTH FROM t.dt_termino) = EXTRACT(MONTH FROM Current_date ) + 1
AND UPPER(ec.nome_empresa) LIKE '%CISCO%' ;
