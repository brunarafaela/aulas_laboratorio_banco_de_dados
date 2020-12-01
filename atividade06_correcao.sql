/**********************************
Atividade 6 - Banco de Dados Objeto-Relacional  : Com as instruções SQL para tipos e tabelas tipadas no Objeto Relacional
a)	Defina um tipo para turma e a respectiva tabela tipada, com uma referência para o objeto curso.
Popule com duas linhas a tabela tipada. 
Turma(num_turma(PK), REF curso,dt_inicio,dt_termino,vagas,horario_aula,vl_curso)***/
DROP TYPE tipoturma FORCE ;
CREATE TYPE tipoturma AS OBJECT
( num_turma SMALLINT,
dt_inicio DATE,
dt_termino DATE,
vagas SMALLINT,
dias_semana CHAR(15),
horario CHAR(10),
valor_curso NUMBER(6,2),
curso REF tipocurso) ;

ALTER TYPE tipoturma ADD ATTRIBUTE situacao_turma CHAR(12)
CASCADE ;
-- tabela tipada
DROP TABLE or_turma CASCADE CONSTRAINTS;
CREATE TABLE or_turma OF tipoturma 
( PRIMARY KEY(num_turma) ,
vagas NOT NULL,
CHECK ( situacao_turma IN ( 'ATIVA', 'CANCELADA', 'ENCERRADA')),
valor_curso NOT NULL ) 
OBJECT IDENTIFIER IS SYSTEM GENERATED ;

DESC or_curso ;
INSERT INTO or_curso VALUES ( 'DBA1', 'Administracao de Banco de Dados', 40, 75, 10, 1, 
   ( SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'OCA' )       ) ;
INSERT INTO or_turma VALUES ( 1, current_date + 10, current_date + 20, 20, 'SEG-QUA', '19-22hs', 500,
   ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ), 'ATIVA' ) ;
INSERT INTO or_turma VALUES ( 2, current_date + 15, current_date + 30, 30, 'TER-QUI-SEX', '19-22hs', 500,
   ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'DBA1' ), 'ATIVA' ) ; 
   
UPDATE or_turma SET dias_semana = 'SEG-QUA-SEX' WHERE num_turma = 1 ;

/*** b)	Defina um tipo para empresa : nome e nacionalidade e a respectiva tabela tipada. 
Popule com três empresas (Ex: Oracle, Cisco e Microsoft).  ***/
-- Empresa( nome, pais, area_atuacao)
DROP TYPE tipoempresa FORCE ;
CREATE TYPE tipoempresa AS OBJECT
( nome_empresa VARCHAR2(40) ,
pais CHAR(15),
area_atuacao VARCHAR2(30) ) ;

-- tabela tipada
DROP TABLE or_empresa CASCADE CONSTRAINTS ;
CREATE TABLE or_empresa OF tipoempresa
( UNIQUE (nome_empresa) ) 
OBJECT IDENTIFIER IS SYSTEM GENERATED ;

INSERT INTO or_empresa VALUES ( 'Cisco Systems Inc', 'EUA', 'Redes Computadores') ;
INSERT INTO or_empresa VALUES (  'Oracle Corporation', 'EUA', 'Banco de dados');
INSERT INTO or_empresa VALUES (  'Microsoft Corporation', 'EUA', 'Sistema Operacional');

/*** c)	Defina um tipo para software com os mesmos atributos que o relacional 
mas agora com uma referência para o objeto Fabricante. 
Popule com uma linha para cada fabricante criado em b) para a tabela tipada de software.  
Software(id_softw(PK),nome_softw,versao,sistema_operacional, REF empresa)
***/
DROP TYPE tiposoftware FORCE ;
CREATE TYPE tiposoftware AS OBJECT
( id_softw CHAR(6),
nome_softw VARCHAR2(30),
versao CHAR(10),
sistema_operacional VARCHAR2(20),
fabricante REF tipoempresa) ;
-- tabela tipada
DROP TABLE or_software CASCADE CONSTRAINTS ;
CREATE TABLE or_software OF tiposoftware
( PRIMARY KEY ( id_softw) ,
nome_softw NOT NULL ) 
OBJECT IDENTIFIER IS SYSTEM GENERATED ;

INSERT INTO or_software VALUES ( 'SQLDEV', 'SQL Developer', '4.1.0.19', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%' ) ) ;
INSERT INTO or_software VALUES ( 'PKTRAC', 'Cisco Packet Tracer', '7.2.1', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%CISCO%' )) ;
INSERT INTO or_software VALUES ( 'ORADB', 'Oracle DBMS', '19c', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%' )) ;
INSERT INTO or_software VALUES ( 'DTMOD', 'Oracle DataModeler', '10.1', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%' )) ;
