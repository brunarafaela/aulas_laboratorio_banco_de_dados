/******
Esquema objeto-relacional BD certificações
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
