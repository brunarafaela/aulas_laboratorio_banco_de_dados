/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;


--Drop Tables
DROP TABLE aluno CASCADE CONSTRAINTS;
DROP TABLE certificacao CASCADE CONSTRAINTS;
DROP TABLE curso CASCADE CONSTRAINTS;
DROP TABLE aula CASCADE CONSTRAINTS;

--Criando tabela Aluno
CREATE TABLE aluno (
id_aluno INTEGER PRIMARY KEY,
nome_aluno VARCHAR2(50) NOT NULL,
sexo_aluno CHAR(1) NOT NULL CHECK (sexo_aluno IN('M,F')),
dt_nascto_aluno DATE NOT NULL,
cpf_aluno NUMBER(11) NOT NULL,
end_aluno VARCHAR2(75),
email_aluno VARCHAR(32) NOT NULL,
fone_aluno NUMBER(11) NOT NULL,
login CHAR(10) NOT NULL,
senha CHAR(8) NOT NULL,
UNIQUE (cpf_aluno),
UNIQUE (login)
);

--Criando tabela Certificação
CREATE TABLE certificacao (
id_cert CHAR(6) NOT NULL,
nome_cert VARCHAR2(50) NOT NULL,
carga_hora_cert SMALLINT NOT NULL,
nota_corte NUMBER(5,2) NOT NULL,
tempo_maximo SMALLINT NOT NULL,
situacao_cert VARCHAR2(15) NOT NULL,
empresa_certificadora VARCHAR2(30) NOT NULL,
id_cert_pre_req NULL,
PRIMARY KEY (id_cert),
FOREIGN KEY (id_cert_pre_req) REFERENCES certificacao (id_cert)
);

--Criando tabela Curso
CREATE TABLE curso (
id_curso CHAR(6) PRIMARY KEY,
nome_curso VARCHAR2(50) NOT NULL,
carga_hora_curso SMALLINT NOT NULL,
qtde_aulas SMALLINT NOT NULL,
nota_corte_curso NUMBER(5,2) NOT NULL,
sequencia_curso SMALLINT NOT NULL,
situacao_curso VARCHAR2(15) NOT NULL,
id_cert CHAR(6) NOT NULL REFERENCES certificacao ON DELETE CASCADE,
id_curso_pre_req REFERENCES curso
);

--Criando tabela Aula
CREATE TABLE aula (
num_aula SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
dt_hora_aula TIMESTAMP NOT NULL,
conteudo_previsto VARCHAR2(100) NOT NULL,
conteudo_ministrado VARCHAR2(100) NULL,
atividade VARCHAR(100) NOT NULL,
material VARCHAR2(50) NOT NULL,
arquivo_material VARCHAR2(100) NOT NULL,
PRIMARY KEY (num_aula, id_curso),
FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE
);

--Criando sequencia para id_aluno
DROP SEQUENCE aluno_seq;
CREATE SEQUENCE aluno_seq START WITH 200 INCREMENT BY 1
MINVALUE 1 MAXVALUE 10000 NOCYCLE;

SELECT * FROM user_sequences;