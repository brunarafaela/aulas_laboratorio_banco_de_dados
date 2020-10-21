/*** Esquema de Relacoes - Controle de Certificacoes 
Aluno(id_aluno(PK),nome_aluno,sexo_aluno,dt_nascto_aluno,cpf_aluno,end_aluno,email_aluno,fone_aluno,login,senha)
Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,situacao_cert,empresa_certificadora,id_cert_pre_req(FK))
Curso(id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,situacao_curso,id_cert(FK),id_curso_pre_req(FK))
Aula(num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,atividade,material,arquivo_material)
Turma(num_turma(PK),id_curso(PK)(FK),dt_inicio,dt_termino,vagas,horario_aula,vl_curso,instrutor,situacao_turma)
Software(id_softw(PK),nome_softw,versao,sistema_operacional,fabricante)
Matricula(num_matricula(PK),dt_hora_matr,vl_pago,situacao_matr,id_aluno(FK),num_turma(FK),id_curso(FK),prova_certificacao,
aproveitamento_final,frequencia_final)
Realizacao_aula(num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,data_hora_entrega,aproveitamento_atividade,presenca)
Utilizacao_software(id_curso(PK)(FK),id_software(PK)(FK))
**/

-- novo usuario
DROP USER c##lbd20202 CASCADE ;
create user c##lbd20202 identified by ipiranga ;
grant dba to c##lbd20202 ;

/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

-- tabela aluno
-- Aluno(id_aluno(PK),nome_aluno,sexo_aluno,dt_nascto_aluno,cpf_aluno,end_aluno,
-- email_aluno,fone_aluno,login,senha)
DROP TABLE aluno CASCADE CONSTRAINTS ;
CREATE TABLE aluno ( 
id_aluno INTEGER PRIMARY KEY,
nome_aluno VARCHAR2(50) NOT NULL,
sexo_aluno CHAR(1) NOT NULL CHECK ( sexo_aluno IN ( 'M', 'F')) ,
dt_nascto_aluno DATE NOT NULL,
cpf_aluno NUMBER(11) NOT NULL,
end_aluno VARCHAR2(75),
email_aluno VARCHAR(32) NOT NULL,
fone_aluno NUMBER(11) NOT NULL,
login CHAR(10) NOT NULL,
senha CHAR(8) NOT NULL,
UNIQUE ( cpf_aluno) ,
UNIQUE (login) ) ;
-- para ver a estrutura da tabela
DESCRIBE aluno ;
-- tabela certificacao
-- Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,
-- situacao_cert,empresa_certificadora,id_cert_pre_req(FK))
DROP TABLE certificacao CASCADE CONSTRAINTS ;
CREATE TABLE certificacao
( id_cert CHAR(6) NOT NULL,
nome_cert VARCHAR2(50) NOT NULL,
carga_hora_cert SMALLINT NOT NULL ,
nota_corte NUMBER(5,2) NOT NULL, 
tempo_maximo SMALLINT NOT NULL,
situacao_cert VARCHAR2(15),
empresa_certificadora VARCHAR2(30) NOT NULL,
id_cert_pre_req NULL,
PRIMARY KEY (id_cert),
FOREIGN KEY (id_cert_pre_req) REFERENCES certificacao (id_cert) ) ;
-- tabela curso
/ * Curso(id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,situacao_curso,
id_cert(FK),id_curso_pre_req(FK)) */
DROP TABLE curso CASCADE CONSTRAINTS ;
CREATE TABLE curso (
id_curso CHAR(6) PRIMARY KEY,
nome_curso VARCHAR2(50) NOT NULL,
carga_hora_curso SMALLINT NOT NULL,
qtde_aulas SMALLINT NOT NULL,
nota_corte_curso NUMBER(5,2) NOT NULL,
sequencia_curso SMALLINT NOT NULL,
situacao_curso VARCHAR2(15) NOT NULL,
id_cert CHAR(6) NOT NULL REFERENCES certificacao ON DELETE CASCADE ,
id_curso_pre_req REFERENCES curso ) ;

-- tabela aula
/ * Aula(num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,
atividade,material,arquivo_material) */
DROP TABLE aula CASCADE CONSTRAINTS;
CREATE TABLE aula (
num_aula SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
dt_hora_aula TIMESTAMP NOT NULL,
conteudo_previsto VARCHAR2(100) NOT NULL,
conteudo_ministrado VARCHAR2(100) NULL,
atividade VARCHAR(100) NOT NULL,
material VARCHAR2(50) NOT NULL,
arquivo_material VARCHAR2(100) NOT NULL,
PRIMARY KEY ( num_aula, id_curso) ,
FOREIGN KEY (id_curso) REFERENCES curso (id_curso)  ON DELETE CASCADE ) ;
-- quais tabelas tem no meu usuario
SELECT table_name FROM user_tables ;
-- tabela aluno realizando a aula
/* Realizacao_aula(num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,
data_hora_entrega,aproveitamento_atividade,presenca) */
DROP TABLE realizacao_aula CASCADE CONSTRAINTS ;
DROP TABLE participacao_aula CASCADE CONSTRAINTS ;
CREATE TABLE participacao_aula (
num_aula SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
id_aluno INTEGER NOT NULL, 
arquivo_atividade_entregue VARCHAR2(50) NULL,
data_hora_entrega TIMESTAMP NULL,
aproveitamento_atividade NUMBER(5,2) NOT NULL,
presenca CHAR(1) NOT NULL CHECK ( presenca IN ('P', 'F') ) ,
FOREIGN KEY (id_aluno) REFERENCES aluno ON DELETE CASCADE ,
FOREIGN KEY ( num_aula, id_curso) REFERENCES aula ( num_aula, id_curso) ON DELETE CASCADE ,
PRIMARY KEY ( num_aula, id_curso, id_aluno) ) ;

-- criando sequencia para o id do aluno
DROP SEQUENCE aluno_seq ;
CREATE SEQUENCE aluno_seq START WITH 200 INCREMENT BY 1 
MINVALUE 1 MAXVALUE 10000 NOCYCLE ; 

SELECT * FROM user_sequences ;

 /*****************************
 Atividade 1  
1 Montar o script em SQL para a criacao das tabelas QUE NÃO FORAM IMPLEMENTADAS AINDA EM AULA, 
conforme o esquema de relacao gerado a partir da Atividade 0 acima, no SGBD Oracle com as seguintes caracteristicas: 
a) Codigo da matricula eh uma sequencia comecando em 2000 ;
b) Acoes referenciais ON DELETE .
 **************************/

-- tabela turma
DROP TABLE turma CASCADE CONSTRAINTS ;
CREATE TABLE turma (
 num_turma SMALLINT NOT NULL,
 id_curso CHAR(6) NOT NULL REFERENCES curso ON DELETE CASCADE,
 dt_inicio DATE NOT NULL,
 dt_termino DATE NOT NULL,
 vagas SMALLINT NOT NULL,
 horario_aula CHAR(10) NOT NULL,
 vl_curso NUMBER(6,2) NOT NULL,
 instrutor VARCHAR2(50) NOT NULL,
 situacao_turma VARCHAR2(50) NOT NULL,
 PRIMARY KEY (num_turma, id_curso) );

-- tabela matricula
DROP TABLE matricula CASCADE CONSTRAINTS ;
CREATE TABLE matricula (
 num_matricula INTEGER NOT NULL PRIMARY KEY,
 dt_hora_matr TIMESTAMP NOT NULL,
 vl_pago NUMBER(6,2) NOT NULL,
 situacao_matr VARCHAR2(50) NOT NULL,
 id_aluno INTEGER NOT NULL REFERENCES aluno ON DELETE CASCADE,
 num_turma SMALLINT NOT NULL,
 id_curso CHAR(6) NOT NULL,
 prova_certificacao NUMBER(5,2) NOT NULL,
 aproveitamento_final NUMBER(5,2) NOT NULL,
 frequencia_final NUMBER(5,2) NOT NULL,
 FOREIGN KEY ( num_turma, id_curso) REFERENCES turma ON DELETE CASCADE );
 
 DROP SEQUENCE matr_seq ;
 CREATE SEQUENCE matr_seq START WITH 2000; 

-- tabela software
DROP TABLE software CASCADE CONSTRAINTS; 
CREATE TABLE software (
 id_softw CHAR(6) NOT NULL PRIMARY KEY,
 nome_softw VARCHAR2(50) NOT NULL,
 versao VARCHAR2(50) NOT NULL,
 sistema_operacional VARCHAR2(20) NOT NULL,
 fabricante VARCHAR2(50) NOT NULL );

-- tabela utilizacao do software pelo curso
DROP TABLE utilizacao_software CASCADE CONSTRAINTS ;
CREATE TABLE utilizacao_software (
 id_curso CHAR(6) NOT NULL REFERENCES curso ON DELETE CASCADE ,
 id_software CHAR(6) NOT NULL REFERENCES software ON DELETE CASCADE , 
 PRIMARY KEY (id_curso, id_software) );

/**************************
Aula 2 - SQL - DDL e DML
***************************/

/*****************************************************************
Alteracao na estrutura das tabelas 
******************************************************************/


-- adicionando novas colunas - no oracle nao tem, é somente add --

ALTER TABLE curso ADD (
conteudo VARCHAR2(50) NOT NULL,
duracao_aula SMALLINT NOT NULL);

--mudando o tipo de dado de uma coluna -- no oracle nao tem NOTIFY 

DESC aluno;
ALTER TABLE aluno MODIFY email_aluno CHAR (32);

-- aumentando tamanho de uma coluna --
DESC curso;
ALTER TABLE curso MODIFY conteudo VARCHAR2(75);


-- definindo um valor default para uma coluna --
ALTER TABLE matricula MODIFY dt_hora_matr DEFAULT CURRENT_TIMESTAMP;

-- adicionando check - restricao de verificacao

DESC certificacao;
ALTER TABLE certificacao ADD CONSTRAINT chk_situ_cert CHECK (
situacao_cert IN (
'ATIVA', 'SUSPENSA', 'DESCONTINUADA'
));


-- renomeando uma coluna --
DESC matricula;
ALTER TABLE matricula RENAME COLUMN prova_certificacao TO aproveitamento_prova_cert;

--renomeando uma tabela
desc utilizacao_software;
ALTER TABLE utilizacao_software RENAME TO softw_uso_curso;



-- POPULAR TABELAS --

DELETE FROM aluno;
SELECT * FROM aluno;
INSERT INTO aluno VALUES (
aluno_seq.nextval, 'Jose Ricardo Junior',
'M', '01/02/1992', 12345, 'Rua Frey Joao 70, Ipiranga',
'josereicardo@gmail.com', 11987654321, 'zericardo', 1234);

INSERT INTO aluno VALUES (
aluno_seq.nextval, 'Maria Rita Soares',
'F', '22/09/1990', 54321, 'Rua Vergueiro 500, Ipiranga',
'mariarita@gmail.com', 11945004872, 'mritaso', 1234);

/*INSERT INTO aluno VALUES (
aluno_seq.nextval, 'Maria Rita Soares',
'F', current_date - INTERVAL '23' YEAR, 54321, 'Rua Vergueiro 500, Ipiranga',
'mariarita@gmail.com', 11945004872, 'mritaso', 1234);*/

SELECT * FROM user_sequences;

-- certificacao -- 
DELETE FROM certificacao;
SELECT * FROM certificacao;
DESC certificacao;
 
INSERT INTO certificacao VALUES('CCNA', 'Cisco Certificed Network Associated', 240, 75, 180, 'ATIVA', 'CISCO SYSTEMS INC', null);
INSERT INTO certificacao VALUES('CCNP', 'Cisco Certificed Network Professional', 240, 85, 180, 'ATIVA', 'CISCO SYSTEMS INC', 'CCNA');
INSERT INTO certificacao VALUES('OCA', 'Oracle Certificed Associated', 240, 75, 180, 'ATIVA', 'ORACLE CORPORATION', null);

-- curso -- 
DESC CURSO;
SELECT * FROM CURSO;
INSERT INTO CURSO VALUES(
'CCNA1', 'Fund de redes computadores', 40, 10,
75, 1, 'ATIVO', 'CCNA', null, 'Conceitos de redes', 60);

INSERT INTO CURSO VALUES(
'CCNA2', 'Conceitos e protocolos de roteamento', 60, 16,
75, 2, 'ATIVO', 'CCNA', null, 'protocolos', 60);

-- atualizando curso

UPDATE curso SET id_curso_pre_req = 'CCNA1', conteudo = 'concetos de roteamento'
WHERE id_curso = 'CCNA2';

--agora aparece o OCA

INSERT INTO curso VALUES(
'SQL', 'Fundamentos de SQL', 40, 10, 75, 1, 'ATIVO', 'OCA',
null, 'Linguagem sql', 60);


INSERT INTO curso VALUES(
'DBA1', 'Administração de banco de dados', 40, 10, 75, 1, 'ATIVO', 'OCA',
null, 'Linguagem sql', 60);


-- aula
SELECT * FROM aula;
DELETE FROM aula;
INSERT INTO aula VALUES(1, 'CCNA1', current_timestamp + 3, 'conceitos redes', null, 'Exercicios cap 1', 'Apostila CCNA Fundamentos', 'http://cisco.ccna.redes.pdf');
INSERT INTO aula VALUES(1, 'SQL', current_timestamp + 7, 'criando tableas', null, 'Exercicios cap 1', 'SQL Basico', 'http://oracle.oca/sql.pdf');

--Participacao Aula
SELECT * FROM participacao_aula;
INSERT INTO participacao_aula VALUES(1, 'CCNA1', 200, null, null, 0, 'F');
--OR outra forma de insert
INSERT INTO participacao_aula (presenca, id_curso, num_aula, id_aluno, aproveitamento_atividade) VALUES('F', 'SQL', 1, 201, 0);


--Transformar coluna em tabela auxiliar
SELECT * FROM certificacao;
DESC certificacao;
--criar nova tabela para empresa certificadora
DROP TABLE empresa_certificacao CASCADE CONSTRAINTS;
CREATE TABLE empresa_certificacao
(
    id_empresa SMALLINT NOT NULL,
    nome_empresa VARCHAR2(60) NOT NULL,
    pais_empresa VARCHAR2(20) NOT NULL,
    atuacao_principal VARCHAR2(20) NOT NULL
);
-- ADICIONAR PK
ALTER TABLE empresa_certificacao ADD CONSTRAINT pk_empr_cert
PRIMARY KEY (id_empresa);

--POPULAR empresa certificacao
SELECT * FROM empresa_certificacao;
DELETE FROM empresa_certificacao;
INSERT INTO empresa_certificacao VALUES(1, 'Cisco Systems Inc', 'EUA', 'Redes Computadores');
INSERT INTO empresa_certificacao VALUES(2, 'Oracle Corporation', 'EUA', 'Banco de Dados');

SELECT * from empresa_certificacao;

--incluir nova coluna em certificacao q vaiviar fk na empresa-certificacao

ALTER TABLE certificacao ADD id_empresa_cert SMALLINT;

UPDATE certificacao c
 SET c.id_empresa_cert = (SELECT ec.id_empresa 
 	 					FROM empresa_certificacao ec
 	 					WHERE UPPER(c.empresa_certificadora) LIKE '%'||UPPER(ec.nome_empresa)||'%');


 ALTER TABLE certificacao MODIFY id_empresa_cert nOT NULaL;

 ALTER TABLE certificacao ADD CONSTRAINT fk_empr_cert FOREIGN KEY (id_empresa_cert)
 REFERENCES empresa_certificacao (id_empresa);
 ALTER TABLE certificacao DROP COLUMN empresa_certificadora;

SELECT c.*, ec.nome_empresa
FROM certificacao c JOIN empresa_certificacao ec 
ON (c.id_empresa_cert = ec.id_empresa);



/********************************
			ATIVIDADE 2

Com o comando ALTER TABLE da linguagem SQL: 
a) Inclua uma nova coluna em turma : Certificação do Instrutor;  **/
DESC turma ;
ALTER TABLE turma ADD instrutor_certificacao CHAR(6) ;
/* b) Crie as seguintes constraints de verificação : 
		Situação em Turma: Ativa, Cancelada, Encerrada ;
		Situação em Matrícula : Cursando, Cancelada, Aprovado ou Reprovado; */
ALTER TABLE turma ADD CONSTRAINT chk_turma_situ CHECK ( situacao_turma IN ( 'ATIVA', 'CANCELADA', 'ENCERRADA')) ;  
ALTER TABLE matricula ADD CONSTRAINT chk_matr_situ CHECK ( situacao_matr 
IN ( 'CURSANDO', 'CANCELADA', 'APROVADO', 'REPROVADO')) ;  
SELECT constraint_name , search_condition FROM user_constraints 
WHERE table_name = 'MATRICULA' ;
--c) Renomeie alguma coluna;
DESC software ;
ALTER TABLE software RENAME COLUMN versao TO versao_softw ;
DESC software ;
--d) Renomeie a tabela softw_uso_curso para Uso_softwares_curso ;
ALTER TABLE softw_uso_curso RENAME TO uso_softwares_curso ;
SELECT table_name FROM user_tables ;
--e) Altere o tipo de dados de alguma coluna CHAR para VARCHAR2 e altere o tamanho ;
DESC turma ;
ALTER TABLE turma MODIFY horario_aula VARCHAR2(15) ;
--f) Coloque valores default para todas as colunas que indiquem aproveitamento e para a data e hora de entrega da atividade.
ALTER TABLE matricula MODIFY aproveitamento_prova_cert DEFAULT 0.0 ;
ALTER TABLE matricula MODIFY aproveitamento_final DEFAULT 0.0 ;
ALTER TABLE participacao_aula MODIFY aproveitamento_atividade DEFAULT 0.0 ;
DESC aula ;
ALTER TABLE aula ADD dt_hora_entrega_atv TIMESTAMP DEFAULT current_timestamp ;
--g) Insira duas linhas em cada tabela criada na atividade 1 acima;
SELECT * FROM aula ;
-- turma
DESC turma ;
SELECT * FROM turma ;
INSERT INTO turma VALUES (1, 'CCNA1', current_date - 15, current_date + 15 , 50, 'Seg-Qua-Sex 19h', 
500, 'Tobias Nascimento', 'ATIVA' , 'CCNP') ;
INSERT INTO turma VALUES (3, 'SQL', current_date , current_date + 20 , 50, 'Sabado 8h-12h', 
500, 'Jaqueline Thompson', 'ATIVA' , 'OCP') ;
-- matricula
SELECT* FROM matricula ;
SELECT * FROM aluno ;
INSERT INTO matricula VALUES ( matr_seq.nextval, DEFAULT, 500, 'CURSANDO', 200, 1, 'CCNA1',  0, 0, 0 ) ;
INSERT INTO matricula VALUES ( matr_seq.nextval, DEFAULT, 400, 'CURSANDO', 201, 3, 'SQL',  0, 0, 0 ) ;
INSERT INTO matricula VALUES ( matr_seq.nextval, DEFAULT, 425, 'CURSANDO', 202, 3, 'SQL',  0, 0, 0 ) ;
-- software
DESC software;
SELECT * FROM software ;
INSERT INTO software VALUES ( 'SQLDEV', 'SQL Developer', '4.1.0.19', 'Windows 10', 'Oracle') ;
INSERT INTO software VALUES ( 'PKTRAC', 'Cisco Packet Tracer', '7.2.1', 'Windows 10', 'Cisco') ;
-- utilizacao do software
DESC uso_softwares_curso ;
SELECT * FROM uso_softwares_curso ;
INSERT INTO uso_softwares_curso VALUES ( 'SQL', 'SQLDEV' ) ;
INSERT INTO uso_softwares_curso VALUES ( 'CCNA1', 'PKTRAC' ) ;

/* h) Depois de populada a tabela Software, transforme a coluna Fabricante em uma nova tabela ( id, nome, país ) . 
Preencha o nome com o conteúdo que existe na coluna original em Software; 
estabeleça o relacionamento incluindo o id do fabricante na tabela software e atualizando os dados. 
Posteriormente exclua a coluna fabricante.
*****************************************/
DROP SEQUENCE fabr_seq ; 
CREATE SEQUENCE fabr_seq START WITH 10 INCREMENT BY 10 ;
DROP TABLE fabricante_softw CASCADE CONSTRAINT ;
CREATE TABLE fabricante_softw
( id_fabr SMALLINT PRIMARY KEY,
nome_fabr VARCHAR2(50) NOT NULL ,
pais_fabr CHAR(20) ) ;
SELECT * FROM fabricante_softw ;
-- populando
INSERT INTO fabricante_softw VALUES ( fabr_seq.nextval , 'Oracle Corporation', 'EUA' ) ;
INSERT INTO fabricante_softw VALUES ( fabr_seq.nextval , 'Cisco Systems Inc', 'EUA' ) ;
INSERT INTO fabricante_softw VALUES ( fabr_seq.nextval , 'Microsoft Corporation', 'EUA' ) ;
SELECT * FROM FABRICANTE_SOFTW ;
-- nova coluna em software
DESC software ;
ALTER TABLE software DROP COLUMN id_fabr ;
SELECT * FROM software ;
ALTER TABLE software ADD id_fabr SMALLINT ;
-- atualizando o valor
UPDATE software s SET s.id_fabr = (  SELECT fs.id_fabr 
                                                                 FROM fabricante_softw fs
                                                                 WHERE UPPER(fs.nome_fabr) LIKE '%'||UPPER(s.fabricante)||'%') ;
SELECT * FROM software ;
-- transformando em FK
ALTER TABLE software ADD FOREIGN KEY ( id_fabr) REFERENCES fabricante_softw ;
ALTER TABLE software MODIFY id_fabr NOT NULL ;
-- excluindo a coluna texto
--ALTER TABLE software DROP COLUMN fabricante ;


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
AND UPPER(ce.nome_cert)	LIKE '%ORACLE%';

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




/**************************
Aula 4 - SQL - DDL e DML
***************************/

/*****************************************************************
INNER JOIN E Funcoes de agregacao -- Group by
******************************************************************/


select * from aluno;
select * from matricula;
select * from aula;
select * from certificacao;
select * from empresa_certificacao;
select * from fabricante_softw;
select * from turma;
select * from curso;
select * from participacao_aula;
select * from software;
select * from uso_softwares_curso;

--17- Alunos matriculados em cursos que a empresa certificadora é fabricante dos softwares usados no curso
SELECT a.nome_aluno, c.nome_curso, fsw.nome_fabr
FROM aluno a, matricula mt, turma t, curso c, certificacao ce, empresa_certificacao emp, uso_softwares_curso swc, software s, fabricante_softw fsw
WHERE a.id_aluno = mt.id_aluno -- aluno x matricula
AND (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
AND t.id_curso = c.id_curso-- turma x curso
AND c.id_cert = ce.id_cert -- curso x certificacao
AND ce.id_empresa_cert = emp.id_empresa --certificacao x empresa certificadora
AND swc.id_curso = c.id_curso --curso x uso softw
AND swc.ID_SOFTWARE	 = s.ID_SOFTW --uso sofw x softw
AND s.id_fabr = fsw.id_fabr -- softw x fabricante softw
AND UPPER(emp.nome_empresa) LIKE '%||UPPER(fsw.nome_fabr)||%';

--18- Funcoes de grupo -- agregacao
SELECT COUNT(*) FROM matricula;
SELECT * FROM CURSO;
SELECT COUNT(*) FROM CURSO;
SELECT COUNT(id_curso_pre_req) FROM CURSO;
SELECT COUNT(*) As Qtde_linhas,
	SUM(c.carga_hora_curso) as Soma,
	AVG(c.carga_hora_curso) As Media,
	MAX(c.carga_hora_curso) As Maior,
	MIN(c.carga_hora_curso) AS Menor
FROM curso c;	

--19- por certificacao
SELECT COUNT(*) FROM matricula;
SELECT * FROM CURSO;
SELECT COUNT(*) FROM CURSO;
SELECT COUNT(id_curso_pre_req) FROM CURSO;
SELECT COUNT(*) As Qtde_linhas,
	SUM(c.carga_hora_curso) as Soma,
	AVG(c.carga_hora_curso) As Media,
	MAX(c.carga_hora_curso) As Maior,
	MIN(c.carga_hora_curso) AS Menor
FROM curso c
GROUP BY c.id_cert;


--20- Mostrar para cada curso (nome) e o total arrecadado nos ultimos 12 meses (considere a data de matricula)
SELECT c.nome_curso, SUM(mt.vl_pago) AS "Valor total por curso"
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso;

--21 - IDEM, AGORA POR MES
UPDATE matricula SET dt_hora_matr = dt_hora_matr - INTERVAL '1' MONTH
WHERE MOD(num_matricula, 2) =1;

SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes,
SUM(mt.vl_pago) AS "Valor total por curso", COUNT(*) AS Matriculados
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr), c.nome_curso
ORDER BY 1,2;
--Regra do grup by: as colunas que nao tem funcao de grupo, sao as colunas que tem que aparecer na clausula group by


--22 - idem mas que tenha arrecadado mais de 750
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes,
SUM(mt.vl_pago) AS "Valor total por curso", COUNT(*) AS Matriculados
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --condicao para linha, antes do grupo by
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr), c.nome_curso
HAVING SUM(mt.vl_pago) > 750 --where ou condicao para grupo, depois do grupo by 
--HAVING COUNT(*)>1
ORDER BY 1,2;


--23- mostrar a media de idade dos alunos por sexo e curso que tem mais de 1 matriculado
SELECT c.nome_curso, a.sexo_aluno, AVG((current_date - a.dt_nascto_aluno)/365.25) AS Media_Idade
FROM aluno a join matricula mt
	ON (a.id_aluno = mt.id_aluno)
	JOIN turma t
	ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
	JOIN curso c
	ON (t.id_curso = c.id_curso)
GROUP BY c.nome_curso, a.sexo_aluno
HAVING COUNT(mt.id_aluno) >1;


--24- mostre a quantidade de alunos matriculados em cada turma
SELECT t.num_turma, t.id_curso, COUNT(mt.id_aluno) AS Matriculados
FROM turma t INNER JOIN matricula mt
	ON (t.num_turma = mt.num_turma)
	WHERE mt.situacao_matr != 'CANCELADA'
	GROUP BY t.num_turma, t.id_curso;
--somente por curso
SELECT t.id_curso, COUNT(mt.id_aluno) AS Matriculados
FROM turma t INNER JOIN matricula mt
	ON (t.num_turma = mt.num_turma)
	WHERE mt.situacao_matr != 'CANCELADA'
	GROUP BY t.id_curso;

--25 - idem com menos de 10 e para cada certificacao
SELECT  t.num_turma, t.id_curso, ce.nome_cert, COUNT(mt.id_aluno) AS Matriculados
FROM turma t INNER JOIN matricula mt
	ON (t.num_turma = mt.num_turma)
	INNER JOIN curso c
	ON  (t.id_curso = c.id_curso)
	INNER JOIN certificacao ce 
	ON (c.id_cert = ce.id_cert)
WHERE mt.situacao_matr != 'CANCELADA'
GROUP BY t.num_turma, t.id_curso, ce.nome_cert
HAVING COUNT(mt.id_aluno) < 2;




/*****************************
 Atividade 4  
 **************************/

--1) Reescrever a consulta 17 da aula com a sintaxe do INNER JOIN;
SELECT a.nome_aluno, c.nome_curso, fsw.nome_fabr
FROM aluno a INNER JOIN matricula mt
	ON(a.id_aluno = mt.id_aluno) --aluno x matricula
	INNER JOIN turma t
	ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
	INNER JOIN curso c 
	ON (t.id_curso = c.id_curso) --turma x curso
	INNER JOIN certificacao ce
	ON (c.id_cert = ce.id_cert) -- curso x certificacao
	INNER JOIN empresa_certificacao emp
	ON(ce.id_empresa_cert = emp.id_empresa) --certificacao x empresa certificadora
	INNER JOIN uso_softwares_curso swc 
	ON(swc.id_curso = c.id_curso) --curso x uso softw
	INNER JOIN software s
	ON(swc.ID_SOFTWARE = s.ID_SOFTW) --softw x fabricante softw
	INNER JOIN fabricante_softw fsw
	ON(s.id_fabr = fsw.id_fabr)
WHERE UPPER(emp.nome_empresa) LIKE '%||UPPER(fsw.nome_fabr)||%';

--2) Mostrar para cada curso a média de duração das turmas em dias;
SELECT c.nome_curso, AVG(t.dt_termino - t.dt_inicio) AS Media_duracao
FROM turma t JOIN curso c
ON (t.id_curso = c.id_curso)
WHERE t.situacao_turma !='CANCELADA'
GROUP BY c.nome_curso;

SELECT * from turma;


--3) Mostrar a quantidade de matriculados por curso, mês (use a data da matrícula) e sexo com idade superior a 21 anos;
/*Qtd por curso Curso*/

/*Qtd por idade maior de 21*/
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, a.sexo_aluno As Sexo,  COUNT(mt.id_curso) AS Matriculados
FROM aluno a INNER JOIN matricula mt
ON (a.ID_ALUNO	= mt.ID_ALUNO)
INNER JOIN turma t
ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
INNER JOIN curso c
ON(t.id_curso = c.id_curso)
WHERE a.dt_nascto_aluno <= current_date - INTERVAL '21' YEAR
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr),a.sexo_aluno
ORDER BY 1,2;


-- 4) Mostrar os cursos que utilizam mais de 3 softwares (nome do curso);

SELECT c.nome_curso, COUNT(swc.id_software) As Qtd
FROM uso_softwares_curso usw
INNER JOIN curso c
ON(c.ID_CURSO = usw.ID_CURSO)
GROUP BY c.nome_curso
HAVING COUNT(usw.id_software) >=3;


--5) Mostrar o nome do curso e a turma para os cursos da empresa Cisco que tiveram mais de R$ 2mil de arrecadação por turma.
SELECT c.nome_curso, t.num_turma, SUM(mt.vl_pago) AS Arrecadado, COUNT(*) AS Alunos
FROM aluno a INNER JOIN matricula mt
ON a.id_aluno = mt.id_aluno --aluno x matricula
INNER JOIN turma t 
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
INNER JOIN curso c
ON (t.id_curso = c.id_curso) --turma x curso
INNER JOIN certificacao ce 
ON (c.id_cert = ce.id_cert) --curso x certificacao
INNER JOIN empresa_certificacao emp 
ON (ce.id_empresa_cert = emp.id_empresa) --certificacao x empresa certificadora
WHERE UPPER(emp.nome_empresa) LIKE '%CISCO%'
GROUP BY c.nome_curso, t.num_turma
HAVING SUM(mt.vl_pago) > 2000;


--6) Mostrar para cada empresa certificadora o valor total arrecadado e a média com as matrículas nos seus cursos, para cada mês, e o número de matriculados mas desde que ultrapassem mais de 50 por mês.
SELECT emp.nome_empresa, EXTRACT(MONTH from mt.dt_hora_matr) AS Mes,
       SUM(mt.vl_pago) AS Arrecadado, AVG(mt.vl_pago) AS Media, COUNT(*) AS Alunos_Matriculados
FROM aluno a INNER JOIN  matricula mt
ON (a.id_aluno = mt.id_aluno) --aluno x matricula
INNER JOIN turma t 
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
INNER JOIN curso c 
ON (t.id_curso = c.id_curso) --turma x curso
INNER JOIN certificacao ce
ON (c.id_cert = ce.id_cert) --curso x certificacao
INNER JOIN empresa_certificacao emp
ON (ce.id_empresa_cert = emp.id_empresa) --certificacao x empresa certificadora
GROUP BY emp.nome_empresa, EXTRACT(MONTH from mt.dt_hora_matr)
HAVING COUNT (mt.id_aluno) >50
ORDER BY 1,2;

--7) Mostrar para cada aluno (nome) a quantidade de aulas cursadas em cada curso matriculado.
SELECT a.id_aluno, a.nome_aluno, c.nome_curso, COUNT(*) AS Aulas
FROM aluno a INNER JOIN matricula mt  
ON (a.id_aluno = mt.id_aluno) --aluno x matricula
INNER JOIN turma t
ON (mt.num_turma = t.num_turma AND mt.id_curso =t.id_curso) --matricula x turma
INNER JOIN curso c
ON (t.id_curso = c.id_curso) --turma x curso
JOIN aula au 
ON (au.id_curso = c.id_curso) -- curso x aula
INNER JOIN participacao_aula pa 
ON (a.id_aluno = pa.id_aluno 
	AND pa.num_aula = au.num_aula 
	AND au.id_curso = pa.id_curso) --aula x participacao aula
--WHERE pa.presenca = 'P'
GROUP BY a.nome_aluno, c.nome_curso, a.id_aluno;

SELECT * from participacao_aula;


/**************************
Aula 5 - SQL - DDL e DML
***************************/

/*****************************************************************
Subqueries, OUTER JOIN, CASE e DECODE
******************************************************************/


--26 - mostrados todos os dados do curso com a turma mais cara -- usando subconsulta - um select dentro do outro
SELECT c.*
FROM curso c INNER JOIN turma t
ON(c.id_curso = t.id_curso)
WHERE t.vl_curso = (SELECT MAX(t.vl_curso)  FROM turma t);

--27- Quem fez os mesmos cursos que Tereza Cristina (Maria Rita Soares no meu banco)
SELECT a.nome_aluno, mt.id_curso
FROM matricula mt INNER JOIN turma t
ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
INNER JOIN aluno a
ON (mt.id_aluno = a.id_aluno) --turma x aluno
	WHERE mt.id_aluno IN (
		SELECT mt.id_curso
		FROM matricula mt INNER JOIN turma t
		ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
		INNER JOIN aluno a
		ON (mt.id_aluno = a.id_aluno) --turma x aluno
		WHERE UPPER(a.nome_aluno) LIKE 'TERE_A%' AND UPPER(a.nome_aluno) LIKE '%CRISTINA%');

--JUNCAO EXTERNA - OUTER JOIN
--Relembrando o INNER JOIN
--Alunos que fizeram matricula
SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a INNER JOIN matricula mt
ON (a.id_aluno = mt.id_aluno);

--Alunos que nao fizeram matricula
--Tabela Aluno A   Tabela Matricula B 
-- => A - B ou seja, quem está no A MAS NAO ESTÁ NO B
-- A - B = B - A? NAO. SAO COISAS DIFERENTES

SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a  LEFT OUTER JOIN matricula mt
ON (a.id_aluno = mt.id_aluno);

SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a  LEFT OUTER JOIN matricula mt --aluno(PK) diferença matricula(FK) A-B
ON (a.id_aluno = mt.id_aluno)
WHERE mt.id_aluno IS NULL;

--privilegiando a FK ->nao retornada, nao existe FK que aponte para a PKa
SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a  RIGHT OUTER JOIN matricula mt --  matricula(FK) diferença aluno(PK) B-A
ON (a.id_aluno = mt.id_aluno)
WHERE a.id_aluno IS NULL;

--usando right mas privilegiando a PK
SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM matricula mt RIGHT OUTER JOIN aluno a  --aluno(PK) diferença matricula(FK) A-B
ON (a.id_aluno = mt.id_aluno)
WHERE a.id_aluno IS NULL;

--29 -forma mais intuitiva com NOT IN
SELECT a.id_aluno, a.nome_aluno FROM aluno a --todos os alunos
WHERE a.id_aluno NOT IN 
					(SELECT mt.id_aluno FROM matricula mt);

--30 usando operados de conjunto --MINUS no orace, em outros sgbds é EXCEPT
SELECT a.id_aluno FROM aluno a --todos os alunos
MINUS (SELECT DISTINCT mt.id_aluno FROM matricula mt);

--MINUS SELECT DISTINCT
SELECT a.* FROM aluno a
WHERE a.id_aluno IN
     (SELECT a.id_aluno FROM aluno a --todos os alunos
			MINUS (SELECT DISTINCT mt.id_aluno FROM matricula mt));

--31 mostrar todos os dados dos ursos que ainda nao utilizam software
SELECT * FROM uso_softwares_curso;
SELECT * from curso;

--Junção externa
SELECT c.*, usw.id_curso as Usando
FROM curso c LEFT JOIN uso_softwares_curso usw
		ON (c.id_curso = usw.id_curso)
WHERE usw.id_curso IS NULL;

--32-MINUS
SELECT c.* FROM curso c where c.id_curso IN(
SELECT c.id_curso from curso c
MINUS (SELECT usw.id_curso from uso_softwares_curso usw));


--NOT IN
SELECT c.* FROM curso c WHERE c.id_curso NOT IN(
	SELECT usw.id_curso FROM uso_softwares_curso usw);

--33 - alunos que fizeram matriculas em certificacoes da Cisco mas nao participaram da aula
SELECT a.nome_aluno, c.nome_curso, c.id_curso, pa.id_curso, pa.id_aluno
FROM aluno a JOIN matricula mt ON (a.id_aluno = mt.id_aluno) --aluno x matricula
			JOIN turma t ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
			JOIN curso c ON (c.id_curso = t.id_curso) --turma x curso
			JOIN certificacao ce ON (ce.id_cert = c.id_cert) --curso x certificacao
			JOIN empresa_certificacao emp ON (ce.id_empresa_cert = emp.id_empresa) --certificacao x empresa certificacao
			JOIN aula au on (a.id_curso = c.id_curso) --aula x curso
			LEFT JOIN   participacao_aula pa ON (au.num_aula = pa.num_aula AND pa.id_aluno = a.id_aluno AND pa.id_curso = au.id_curso)	 --aula x 
WHERE UPPER(emp.nome_empresa) LIKE '%CISCO%'
AND pa.id_aluno IS NULL;

--34 - DECODE -corresponde a um IF
SELECT a.nome_aluno, DECODE (a.sexo_aluno, 'M', 'Masculino', 'F', 'Feminino') AS Sexo
FROM aluno a
ORDER BY 1;

--35- CASE
SELECT a.nome_aluno,
	CASE a.sexo_aluno 
		WHEN 'M' THEN 'Masculino'
		WHEN 'F' THEN 'Feminino'
		ELSE '?'
	END AS Sexo
FROM aluno a
ORDER BY 1;		

--outra forma
SELECT a.nome_aluno,
	CASE 
		WHEN a.sexo_aluno  = 'M' THEN 'Masculino'
		WHEN a.sexo_aluno  = 'F' THEN 'Feminino'
		WHEN UPPER(a.email_aluno) LIKE '%FATEC%' THEN 'Fatecano'
		ELSE '?'
	END AS Informacao
FROM aluno a
ORDER BY 1;		



/*****************************
 Atividade 5  
 **************************/


--1) Mostre o nome, e-mail dos alunos, nome do curso e turma, para os alunos que fizeram cursos em que não se matricularam homens;
SELECT a.nome_aluno AS Nome_Aluno, a.email_aluno AS Email_Aluno, c.id_curso AS Id_curso, c.nome_curso AS Nome_Curso, t.num_turma AS Num_Turma
FROM aluno a 
	INNER JOIN matricula mt
		ON(a.id_aluno = mt.id_aluno) --aluno x matricula
	INNER JOIN turma t
		ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
	INNER JOIN curso c
		ON (t.id_curso = c.id_curso) --turma x curso
WHERE mt.id_curso NOT IN(
	SELECT mt.id_curso
	FROM aluno a JOIN matricula mt
	ON (a.id_aluno = mt.id_aluno)
	WHERE a.sexo_aluno = 'M');

--2) Mostre o nome dos fabricantes de software que ainda não tem softwares usados em cursos. Faça de três formas diferentes sendo uma com junção externa.
--LEFT JOIN
SELECT fsw.nome_fabr, s.id_softw AS Software, usw.id_software AS Uso
FROM fabricante_softw fsw INNER JOIN software s
ON (s.id_fabr = fsw.id_fabr)
LEFT JOIN uso_softwares_curso usw
ON (usw.id_software = s.id_softw) --uso softw x softw
WHERE usw.id_software IS NULL;

--NOT IN
SELECT fsw.nome_fabr, s.id_softw AS Software
FROM fabricante_softw fsw, software s
WHERE (s.id_fabr = fsw.id_fabr)
AND s.ID_SOFTW NOT IN(
	SELECT usw.ID_SOFTWARE FROM uso_softwares_curso usw --softwares usados
);


--MINUS
SELECT fsw.nome_fabr
FROM fabricante_softw fsw, software s
WHERE (s.id_fabr = fsw.id_fabr)
AND s.ID_SOFTW IN(
SELECT s.ID_SOFTW FROM software s --todos os softwares
MINUS
SELECT usw.ID_SOFTWARE from uso_softwares_curso usw);
--softwares usados



--3) Mostrar o nome do curso, valor do curso, turma, data de início e horário das aulas para as turmas que ainda não começaram, mas não tem ninguém matriculado. 
--Mostre por extenso o horário da aula, por exemplo : SEGUNDA,QUARTA E SEXTA-FEIRA. Use junção externa. Faça de duas formas : com DECODE e outra com CASE.
--CASE
SELECT c.nome_curso, t.vl_curso AS Valor, t.id_curso, t.num_turma, t.dt_inicio AS Inicio, t.dt_termino AS Termino, 
	CASE
	WHEN UPPER(t.horario_aula) LIKE 'SEG-QUA-SEX%' THEN 'SEGUNDA-QUARTA-SEXTA 19-22h'
	WHEN UPPER(t.horario_aula) LIKE 'TER-QUIN%' THEN  'TERCA-QUINTA 19-22h'
	ELSE '?'
	END AS Horário_Aula, mt.id_aluno AS Matriculado
FROM curso c
INNER JOIN turma t
ON (c.id_curso = t.id_curso) --curso x turma
LEFT JOIN matricula mt
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --turma x matricula
WHERE t.dt_inicio < current_date
AND mt.id_aluno  IS NULL;

--DECODE
SELECT c.nome_curso, t.vl_curso as Valor, t.num_turma, t.dt_inicio as Inicio, t.dt_termino AS Termino, 
	DECODE( UPPER(t.horario_aula), 'SEG-QUA-SEX', 'SEGUNDA-QUARTA-SEXTA-FEIRA 19-22h', 
		'TER-QUI', 'TERCA-QUINTA 19-22h') AS Horário, mt.id_aluno AS Matriculado
FROM curso c
INNER JOIN turma t
ON (c.id_curso = t.id_curso) --curso x turma
LEFT JOIN matricula mt
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --turma x matricula
WHERE t.dt_inicio > current_date
AND mt.id_aluno  IS NULL;

--4) Mostrar para os cursos de certificações ‘PROFESSIONAL’ as turmas que tem alunos matriculados mas o curso ainda não aulas programadas: Nome do curso, nome da certificação, quantidade de aulas, nome do aluno, sexo, código da turma, data de início e data prevista de término; 
SELECT c.nome_curso, ce.nome_cert, c.qtde_aulas, a.nome_aluno, a.sexo_aluno, t.num_turma, t.dt_inicio AS  Inicio, t.dt_termino AS Termino, au.id_curso AS Aula
FROM aluno a 
INNER JOIN matricula mt
	ON(a.id_aluno = mt.id_aluno) --aluno x matricula
	INNER JOIN turma t
	ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
	INNER JOIN curso c 
	ON (t.id_curso = c.id_curso) --turma x curso
	INNER JOIN certificacao ce
	ON (c.id_cert = ce.id_cert) -- curso x certificacao
	LEFT JOIN aula au
	ON (c.id_curso = au.id_curso) --curso x aula
WHERE UPPER(ce.nome_cert) LIKE '%PROFESSIONAL%'
AND au.id_curso IS NULL;


--5) Mostrar o nome do curso e a turma para os cursos que não são de certificações ‘INSTRUCTOR’ e que tiveram mais de R$ 2mil de arrecadação na turma e com mais de 90% de preenchimento de vagas.
SELECT t.id_curso, c.nome_curso, t.num_turma, SUM(mt.VL_pago) AS "Arrecadação" , COUNT(mt.id_aluno) AS "Matriculados"
FROM aluno a 
INNER JOIN matricula mt 
ON (a.id_aluno = mt.id_aluno)
INNER JOIN turma t 
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
INNER JOIN curso c
ON (c.id_curso = t.id_curso)
INNER JOIN certificacao ce
ON (ce.id_cert = c.id_cert)
WHERE UPPER(ce.nome_cert) NOT LIKE '%INSTRUCTOR%' 
GROUP BY t.id_curso, c.nome_curso, t.num_turma
HAVING SUM(mt.vl_pago) > 2000
AND COUNT(mt.id_aluno) / (SELECT MAX(t1.vagas) FROM turma t1
WHERE t1.num_turma = t.num_turma AND t1.id_curso = t.id_curso) >= 0.9;


/******
Esquema objeto-relacional BD certificações - Aula 6
******/


/*
Aluno (id_aluno(PK), nome_aluno, sexo_aluno, dt_nascto_aluno, cpf_aluno, {end_aluno}, login, senha)
Certificacao (id_cert(PK), nome_cert, carga_hora_cert, tempo_maximo, empresa_certificadora)
Curso (id_curso(PK), nome_curso, carga_hora_curso, qtde_aulas, nota_corte, sequencia, {aulas_programadas}, REF certificacao, {softwares_usados})
Aula_programada (numero, conteudo_previsto, atividade_prevista, material, arquivo_material)
continua...
*/


/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;


--vetor para fone
DROP TYPE tipofone FORCE;
CREATE OR REPLACE TYPE tipofone AS VARRAY(5) OF INTEGER;
DESC tipofone;

--definindo um tipo para endereço
DROP TYPE tipoendereco FORCE;
CREATE OR REPLACE TYPE tipoendereco AS OBJECT
(tipo_logradouro CHAR(12),
logradouro VARCHAR(40),
numero SMALLINT,
complemento CHAR(10),
bairro VARCHAR2(25),
cidade VARCHAR2(30),
UF CHAR(2),
email VARCHAR2(32),
fones tipofone)
NOT FINAL; --permite ter mais derivadas


--tipo para aluno
DROP TYPE tipoaluno FORCE;
CREATE OR REPLACE TYPE tipoaluno AS OBJECT
(id_aluno INTEGER,
nome_aluno VARCHAR2(50),
sexo_aluno CHAR(1),
dt_nascto_aluno DATE,
cpf_aluno NUMBER(11),
end_aluno tipoendereco,
login CHAR(10),
senha CHAR(6))
FINAL;


--tabela tipada para aluno
DROP TABLE or_aluno CASCADE CONSTRAINTS;
CREATE TABLE or_aluno OF tipoaluno
(PRIMARY KEY (id_aluno),
nome_aluno NOT NULL,
CHECK (sexo_aluno IN ('M', 'F')),
UNIQUE (cpf_aluno),
UNIQUE (login))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--populando aluno
INSERT INTO or_aluno VALUES (1, 'Sebastiao Malacale', 'M', current_date- INTERVAL '20' YEAR, 1234, 
	tipoendereco ('Rua', 'Vergueiro', 7000, null, 'Ipiranga', 'São Paulo', 'SP', 'macale20@gmail.com', 
	             tipofone(11912345678, 119987654321,11974638293)), 'tiaomaca', 'tiao20');

SELECT * FROM or_aluno;

SELECT a.nome_aluno, a.login, a.end_aluno.logradouro, a.end_aluno.numero
FROM or_aluno a;

SELECT a.nome_aluno, a.login, a.end_aluno.logradouro, a.end_aluno.fones
FROM or_aluno a; --erro

SELECT a.nome_aluno, a.login, a.end_aluno.logradouro, f.*
FROM or_aluno a, TABLE (a.end_aluno.fones) f; --table serve para abrira coleção, desanina o que está aninhado

--tipo para cetificação
DROP TYPE tipocertificacao FORCE;
CREATE OR REPLACE TYPE tipocertificacao AS OBJECT(
id_cert CHAR(6),
nome_cert VARCHAR2(50),
carga_hora_cert SMALLINT,
tempo_maximo SMALLINT,
empresa_certificadora VARCHAR2(40));

--tabela tipada para certificacao
DROP TABLE or_certificacao CASCADE CONSTRAINTS;
CREATE TABLE or_certificacao OF tipocertificacao
(PRIMARY KEY (id_cert),
nome_cert NOT NULL,
CHECK(carga_hora_cert > 0))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--populanco certificacao
INSERT INTO or_certificacao VALUES ('OCA', 'Oracle Certified Associated', 240, 180, 'Oracle Corporation');
--tipo para curso --falta aulas programadas e softwares usados, serao tabelas aminhadas
DROP TYPE tipocurso FORCE;
CREATE OR REPLACE TYPE tipocurso AS OBJECT
(id_curso CHAR(6),
nome_curso VARCHAR2(50),
carga_hora_curso SMALLINT,
nota_corte_curso NUMBER(4,2),
qtde_aulas SMALLINT,
sequencia SMALLINT,
certficacao REF tipocertificacao);

--tabela tipada para curso
DROP TABLE or_curso CASCADE CONSTRAINTS;
CREATE TABLE or_curso OF tipocurso
(PRIMARY KEY (id_curso),
nome_curso NOT NULL,
CHECK (nota_corte_curso >0));

--buscando o OID de um objeto
SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'OCA';

--populando curso
INSERT INTO or_curso VALUES ('SQL', 'Fundamentos de SQL', 40, 75, 10, 1, 
(SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'OCA') );

--relacionando curso e certificação
SELECT c.nome_curso, c.carga_hora_curso, c.certificacao.nome_cert
FROM or_curso c;

--tipo para aula
DROP TYPE tipoaula_programada FORCE;
CREATE OR REPLACE TYPE tipoaula_programada AS OBJECT
(numero SMALLINT,
conteudo_previsto VARCHAR2(100),
atividade_prevista VARCHAR2(50),
material VARCHAR2 (40),
arquivo_material VARCHAR2(50));



/*Atividade 6*/

--tabela tipada turma
DROP TYPE tipoturma FORCE;
CREATE TYPE tipoturma AS OBJECT
(num_turma SMALLINT,
dt_inicio DATE,
dt_termino DATE,
vagas SMALLINT,
dias_semana CHAR(15),
horario CHAR(10),
valor_curso NUMBER(6,2),
curso REF tipocuso);

ALTER TYPE tipoturma ADD ATRIBUTE situacao_turma CHAR(12) CASCADE;

--tabela tipada
DROP TABLE or_turma CASCADE CONSTRAINTS;



--empresa 
DROP TYPE tipoempresa FORCE;




/******
Esquema objeto-relacional BD certificações - Aula 7
******/


/*
Aluno (id_aluno(PK), nome_aluno, sexo_aluno, dt_nascto_aluno, cpf_aluno, {end_aluno}, login, senha)
Certificacao (id_cert(PK), nome_cert, carga_hora_cert, tempo_maximo, empresa_certificadora)
Curso (id_curso(PK), nome_curso, carga_hora_curso, qtde_aulas, nota_corte, sequencia, {aulas_programadas}, REF certificacao, {softwares_usados})
Aula_programada (numero, conteudo_previsto, atividade_prevista, material, arquivo_material)
Turma(num_turma(PK), REF curso, dt_inicio, dt_termino, vagas, horario_aula, vl_curso, {matriculas})
Empresa(nome, pais, area_atuacao)
Software(id_sftw(PK), nome_softw, versao, sistema_operacional, REF empresa)
Aula_realizada(numero, REF curso, dt_hora_aula, instrutor, conteudo_dado, arquivo_atividade, dt_hora_entrega, presenca)
Matricula (num_matricula, dt_hora_matr, valor_pago, REF aluno, prova_certificacao, aproveitamento_final, frequencia_final, situacao_matricula)	
*/


/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

--tipo para matricula
DROP TYPE tipomatricula FORCE;
CREATE OR REPLACE TYPE tipomatricula AS OBJECT
(num_matricula INTEGER,
dt_hora_matr TIMESTAMP,
valor_pago NUMBER(6,2),
aluno REF tipoaluno, 
prova_certificacao NUMBER(5,2),
aproveitamento_final NUMBER(5,2),
frequencia_final NUMBER(5,2),
situacao_matr CHAR(15));

--tabela de tipomatricula -- não é uma tabela relacional tipada -- é uma tabela coleção
DROP TYPE tab_matriculas FORCE;
CREATE OR REPLACE TYPE tab_matriculas AS TABLE OF tipomatricula;

--criar um novo atributo em turma que é uma tabela aninhada das matriculas
ALTER TYPE tipoturma ADD ATRIBUTE matriculas tab_matriculas CASCADE;

DESC or_turma;
SELECT * FROM or_turma;

--criando uma sequencia para o numero da matricula
DROP SEQUENCE matricula_seq;
CREATE SEQUENCE matricula_seq START WITH 2020;

--inserindo duas novas matriculas para a turma 1
UPDATE or_turma t SET t.matriculas =
	tab_matriculas(tipomatricula (matricula_seq.nextval, current_timestamp -1, 490,
					(SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 1), null, null, null, 'CURSANDO'),
				   tipomatricula (matricula_seq.nextval, current_timestamp, 475, 
				   	(SELECT REF(a) FROM or_aluno a where a.id_aluno = 3 ), null, null, null, 'CURSANDO')) 
WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL';

SELECT t.num_turma, t.curso.id_curso, mt.num_matricula, mt.aluno.nome_aluno
FROM or_turma t, TABLE(t.matriculas) mt;

--excluindo a segunda matrícula
DELETE FROM TABLE (SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
WHERE mt.num_matricula = 2020 AND UPPER(mt.aluno.nome_aluno) LIKE 'MARIA PAULA%'; 

--inserindo uma nova matricula para uma turma que já tem matriculados
INSERT INTO TABLE (SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
VALUES (matricula.seq.nextval, current_timestamp, 488.25,
      (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 2), null, null, null, 'CURSANDO');

--atualizando uma matricula especifica
UPDATE TABLE (SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
SET mt.valor_curso = 400
WHERE mt.num_matricula = 2021;

--inserindo uma nova turma com uma nova matricula
INSERT INTO or_turma VALUES (3, current_date + 30, current_date -60, 50, 'SABADO', '08-17hs', 600, 
	(SELECT REF(c), FROM or_curso c WHERE c.id_curso = 'SQL'), 'ATIVA',
	tab_matriculas (tipomatricula(matricula_seq.nextval, current_timestamp +3, 555,
		(SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 3), null, null, null,'CURSANDO')
	));

--dados de turma, mariculas na turma, aluno, curso e certificacao que ainda nao começarams
SELECT t.num_turma, t.dias_semana, t.curso.nome_curso AS Curso,
	   t.curso.certificacao.nome_cert AS Certificacao, mt.num_matricula,
	   mt.aluno.nome_aluno AS Aluno, mt.aluno.end_aluno.logradouro, mt.valor_pago, mt.situacao_matr
FROM or_turma t TABLE (t.matriculas) mt
WHERE t.dt_inicio > current_date;	   

--aninhando as aulas programadas na tabela curso
DROP TYPE tab_aulas_programadas FORCE;
CREATE OR REPLACE TYPE tab_aulas_programadas AS TABLE OF tipoaula_programada;

--excluir esse atributo
ALTER TYPE tipocurso DROP ATRIBUTE aulas_programadas CASCADE;
DESC tipocurso;

DESC or_aluno;

--criar novo atributo em curso
ALTER TYPE tipocurso ADD ATRIBUTE aulas_programadas CASCADE;
