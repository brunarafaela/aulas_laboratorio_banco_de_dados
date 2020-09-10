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