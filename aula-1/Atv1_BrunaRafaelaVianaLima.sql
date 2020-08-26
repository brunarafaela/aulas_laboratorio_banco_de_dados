/*** Esquema de Relacoes - Controle de Certificacoes 
ok Aluno(id_aluno(PK),nome_aluno,sexo_aluno,dt_nascto_aluno,cpf_aluno,end_aluno,email_aluno,fone_aluno,login,senha)
ok Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,situacao_cert,empresa_certificadora,id_cert_pre_req(FK))
ok Curso(id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,situacao_curso,id_cert(FK),curso_pre_req(FK))
ok Aula(num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,atividade,material,arquivo_material)
ok Turma(num_turma(PK),id_curso(PK)(FK),dt_inicio,dt_termino,vagas,horario_aula,vl_curso,instrutor,situacao_turma)
ok Software(id_softw(PK),nome_softw,versao,sistema_operacional,fabricante)
ok Matricula(num_matricula(PK),dt_hora_matr,vl_pago,situacao_matr,id_aluno(FK),num_turma(FK),id_curso(FK),prova_certificacao,aproveitamento_final,frequencia_final)
ok Realizacao_aula(num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,data_hora_entrega,aproveitamento_atividade,presenca)
ok Utilizacao_software(id_curso(PK)(FK),id_software(PK)(FK))
**/


/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;


--Drop Tables
DROP TABLE aluno CASCADE CONSTRAINTS;
DROP TABLE certificacao CASCADE CONSTRAINTS;
DROP TABLE curso CASCADE CONSTRAINTS;
DROP TABLE aula CASCADE CONSTRAINTS;
DROP TABLE turma CASCADE CONSTRAINTS;
DROP TABLE software CASCADE CONSTRAINTS;
DROP TABLE matricula CASCADE CONSTRAINTS;
DROP TABLE realizacao_aula CASCADE CONSTRAINTS;
DROP TABLE utilizacao_software CASCADE CONSTRAINTS;

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


--Criando tabela Turma
CREATE TABLE turma(
num_turma SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
PRIMARY KEY (num_turma, id_curso),
FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE,
dt_inicio DATE NOT NULL,
dt_termino DATE NOT NULL,
vagas SMALLINT NOT NULL,
horario_aula CHAR(10) NOT NULL,
vl_curso NUMBER(6,2) NOT NULL,
instrutor VARCHAR(50) NOT NULL,
situacao_turma VARCHAR(30) NOT NULL
);


--Criando tabela Matricula
CREATE TABLE matricula(
num_matricula INTEGER PRIMARY KEY,
dt_hora_matr  TIMESTAMP NOT NULL,
vl_pago NUMBER(6,2) NOT NULL,
situacao_matr VARCHAR(30) NOT NULL,
prova_certificacao NUMBER(5,2) NOT NULL,
aproveitamento_final NUMBER(5,2) NOT NULL,
frequencia_final NUMBER(5,2) NOT NULL,
id_aluno INTEGER,
num_turma SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno) ON DELETE CASCADE,
FOREIGN KEY (num_turma) REFERENCES turma(num_turma) ON DELETE CASCADE,
FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE
);

--Criando sequencia para num_matricula
DROP SEQUENCE matricula_seq;
CREATE SEQUENCE matricula_seq START WITH 2000 INCREMENT BY 1
MINVALUE 1 MAXVALUE 10000 NOCYCLE;

SELECT * FROM user_sequences;

--Criando tabela Software
CREATE TABLE software(
id_softw CHAR(6) NOT NULL PRIMARY KEY,
nome_softw VARCHAR(100) NOT NULL,
versao VARCHAR(10) NOT NULL,
sistema_operacional VARCHAR(100) NOT NULL,
fabricante VARCHAR(100) NOT NULL
);


--Criando tabela Utilizacao_software
CREATE TABLE utilizacao_software(
id_softw CHAR(6) NOT NULL,
id_curso CHAR(6) NOT NULL,
PRIMARY KEY (id_softw, id_curso),
FOREIGN KEY (id_softw) REFERENCES software(id_softw) ON DELETE CASCADE,
FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE
);


--Criando tabela Realizacao_aula
CREATE TABLE realizacao_aula(
num_aula SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
id_aluno INTEGER NOT NULL,
PRIMARY KEY (num_aula, id_curso, id_aluno),
FOREIGN KEY (num_aula) REFERENCES aula(num_aula) ON DELETE CASCADE,
FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE,
FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno) ON DELETE CASCADE,
arquivo_atividade_entregue VARCHAR(200) NOT NULL,
data_hora_entrega TIMESTAMP NOT NULL,
aproveitamento_atividade NUMBER(5,2) NOT NULL,
presenca CHAR(1) NOT NULL CHECK (presenca IN('S,N')),
);