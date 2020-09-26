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