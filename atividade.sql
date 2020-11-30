/*usuario (Cod_usuario(PK), Nome_usuario, End_usuario, Fone_usuario, Sexo_usuario, CPF_usuario, RG_usuario, Dt_nascto_usuario, Situacao_usuario, email_usuario)
aluno (Cod_usuario (PFK), RA, Dt_ingresso, Dt_prevista_termino, Cod_curso(FK))
funcionario (Cod_usuario(PFK), Cod_funcional, cargo, Dt_admissao, Dt_desligamento)
professor (Cod_usuario(PFK), Cod_funcional, Titulacao, Dt_admissao, Dt_desligamento)
curso (Cod_curso(PK), Nome_curso, Tipo_curso)
emprestimo (Num_emprestimo (PK), Dt_retirada, Cod_usuario(FK), Vl_total_multa, Situacao_emprest, Num_reserva(FK))
itens_emprestimo (Num_emprestimo(PFK), Num_exemplar(PFK), ISBN(PFK), Dt_Prevista_Devolucao, Dt_Devolucao, Vl_multa_item, Situacao_item_emprest)
exemplar (Num_exemplar(PK), ISBN(PFK), Num_edicao, Idioma_exemplar, Ano_publicacao, Qtde_pags, Tipo_exemplar, Tipo_midia, Vl_exemplar, Prazo_devolucao, Tipo_aquisicao, Situacao_exemplar, Cod_editora(FK))
editora (Cod_editora(PK), Nome_edit, End_edit, Fone_edit, CNPJ_edit, contato_edit, Nacionalidade_edit)
reserva (Num_reserva(PK), Dt_reserva, Dt_limite, Situacao_reserva, Cod_usuario(FK))
Reserva_Obra (Num_reserva(PFK), ISBN(PFK), Situacao_item_reserva)
obra (ISBN(PK), Titulo_original, Idioma_original, Genero, Classificacao)
Participacao_obra(ISBN(PFK), Cod_autor(PFK), Tipo_participacao)
autor(Cod_autor(PK), Nome_autor, Nacionalidade_autor)*/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

/*CREATE TABLES*/
DROP TABLE usuario CASCADE CONSTRAINTS ;
CREATE TABLE usuario (
Cod_usuario INTEGER PRIMARY KEY,
Nome_usuario VARCHAR2(50) NOT NULL,
End_usuario VARCHAR2(75) NOT NULL, 
Fone_usuario NUMBER(11) NOT NULL,
Sexo_usuario CHAR(1) NOT NULL CHECK ( Sexo_usuario IN ( 'M', 'F')) ,
CPF_usuario NUMBER(11) NOT NULL,
RG_usuario VARCHAR2(10) NOT NULL,
Dt_nascto_usuario DATE NOT NULL,
Situacao_usuario VARCHAR2(7) NOT NULL, 
email_usuario VARCHAR2(32) NOT NULL);
DESCRIBE usuario ;


DROP TABLE curso CASCADE CONSTRAINTS ;
CREATE TABLE curso (
Cod_curso INTEGER PRIMARY KEY,
Nome_curso VARCHAR2(40) NOT NULL,
Tipo_curso VARCHAR2(12) NOT NULL);
DESCRIBE curso ;


DROP TABLE aluno CASCADE CONSTRAINTS ;
CREATE TABLE aluno ( 
Cod_usuario INTEGER PRIMARY KEY,
RA VARCHAR2(20) NOT NULL,
Dt_ingresso TIMESTAMP NOT NULL ,
Dt_prevista_termino DATE NOT NULL,
Cod_curso INTEGER NULL,
FOREIGN KEY (Cod_usuario) REFERENCES usuario (Cod_usuario) ON DELETE CASCADE,
FOREIGN KEY (Cod_curso) REFERENCES curso (Cod_curso)  ON DELETE CASCADE) ;
DESCRIBE aluno ;

DROP TABLE funcionario CASCADE CONSTRAINTS ;
CREATE TABLE funcionario (
Cod_usuario INTEGER PRIMARY KEY,
FOREIGN KEY (Cod_usuario) REFERENCES usuario (Cod_usuario) ON DELETE CASCADE,
Cod_funcional INTEGER NOT NULL,
cargo VARCHAR2(30) NOT NULL,
Dt_admissao TIMESTAMP NOT NULL,
Dt_desligamento DATE NULL);
DESCRIBE funcionario ;


DROP TABLE professor CASCADE CONSTRAINTS ;
CREATE TABLE professor (
Cod_usuario INTEGER PRIMARY KEY,
FOREIGN KEY (Cod_usuario) REFERENCES usuario (Cod_usuario) ON DELETE CASCADE,
Cod_funcional INTEGER NOT NULL,
Titulacao VARCHAR2(30) NOT NULL,
Dt_admissao TIMESTAMP NOT NULL,
Dt_desligamento DATE NULL);
DESCRIBE professor ;

DROP TABLE editora CASCADE CONSTRAINTS ;
CREATE TABLE editora (
Cod_editora INTEGER PRIMARY KEY,
Nome_edit VARCHAR2(20) NOT NULL,
End_edit VARCHAR2(75) NOT NULL, 
Fone_edit NUMBER(11) NOT NULL, 
CNPJ_edit INTEGER NOT NULL,
contato_edit VARCHAR2(32) NOT NULL,
Nacionalidade_edit VARCHAR2(20) NOT NULL);
DESCRIBE editora ;

DROP TABLE obra CASCADE CONSTRAINTS ;
CREATE TABLE obra (
ISBN INTEGER PRIMARY KEY,
Titulo_original VARCHAR2(140) NOT NULL,
Idioma_original VARCHAR2(75) NOT NULL, 
Genero VARCHAR2(50) NOT NULL,
Classificacao VARCHAR2(20) NOT NULL);
DESCRIBE obra ;


DROP TABLE autor CASCADE CONSTRAINTS ;
CREATE TABLE autor (
Cod_autor INTEGER PRIMARY KEY,
Nome_autor VARCHAR2(140) NOT NULL,
Nacionalidade_autor VARCHAR2(50) NOT NULL);
DESCRIBE autor ;

DROP TABLE Participacao_obra CASCADE CONSTRAINTS ;
CREATE TABLE Participacao_obra (
ISBN INTEGER NOT NULL,
Cod_autor INTEGER NOT NULL,
PRIMARY KEY ( ISBN, Cod_autor) ,
FOREIGN KEY (ISBN) REFERENCES obra (ISBN) ON DELETE CASCADE,
FOREIGN KEY (Cod_autor) REFERENCES autor (Cod_autor) ON DELETE CASCADE,
Tipo_participacao VARCHAR2(50) NOT NULL);
DESCRIBE Participacao_obra ;


DROP TABLE exemplar CASCADE CONSTRAINTS ;
CREATE TABLE exemplar (
Num_exemplar INTEGER NOT NULL,
ISBN INTEGER NOT NULL,
PRIMARY KEY ( ISBN, Num_exemplar) ,
FOREIGN KEY (ISBN) REFERENCES obra (ISBN) ON DELETE CASCADE,
Cod_editora INTEGER NOT NULL,
FOREIGN KEY (Cod_editora) REFERENCES editora (Cod_editora) ON DELETE CASCADE,
Num_edicao INTEGER NOT NULL,
Idioma_exemplar VARCHAR2(30) NOT NULL,
Ano_publicacao DATE NOT NULL,
Qtde_pags INTEGER NOT NULL,
Tipo_exemplar VARCHAR2(30) NOT NULL,
Tipo_midia VARCHAR2(30) NOT NULL,
Vl_exemplar  NUMBER(6,2) NOT NULL,
Prazo_devolucao VARCHAR2 (10) NOT NULL,
Tipo_aquisicao VARCHAR2(10) NOT NULL, 
Situacao_exemplar VARCHAR2(10) NOT NULL);
DESCRIBE exemplar ;


DROP TABLE reserva CASCADE CONSTRAINTS ;
CREATE TABLE reserva (
Num_reserva INTEGER PRIMARY KEY ,
Dt_reserva TIMESTAMP NOT NULL,
Dt_limite DATE NOT NULL,
Cod_usuario INTEGER NOT NULL,
FOREIGN KEY (Cod_usuario) REFERENCES professor (Cod_usuario) ON DELETE CASCADE ,
Situacao_reserva VARCHAR2(50) NOT NULL);
DESCRIBE reserva ;

DROP TABLE Reserva_Obra CASCADE CONSTRAINTS ;
CREATE TABLE Reserva_Obra (
Num_reserva INTEGER NOT NULL ,
ISBN INTEGER NOT NULL ,
PRIMARY KEY ( ISBN, Num_reserva) ,
FOREIGN KEY (ISBN) REFERENCES obra (ISBN) ON DELETE CASCADE,
FOREIGN KEY (Num_reserva) REFERENCES reserva (Num_reserva) ON DELETE CASCADE, 
Situacao_item_reserva VARCHAR2(50) NOT NULL);
DESCRIBE Reserva_Obra ;


DROP TABLE emprestimo CASCADE CONSTRAINTS ;
CREATE TABLE emprestimo (
Num_emprestimo INTEGER PRIMARY KEY ,
Dt_retirada TIMESTAMP NOT NULL,
Vl_total_multa  NUMBER(6,2)  NULL,
Cod_usuario INTEGER NOT NULL, 
Num_reserva INTEGER NOT NULL,
FOREIGN KEY (Cod_usuario) REFERENCES usuario (Cod_usuario) ON DELETE CASCADE ,
FOREIGN KEY (Num_reserva) REFERENCES reserva (Num_reserva) ON DELETE CASCADE ,
Situacao_emprest VARCHAR2(50) NOT NULL);
DESCRIBE emprestimo;


DROP TABLE itens_emprestimo CASCADE CONSTRAINTS ;
CREATE TABLE itens_emprestimo (
Num_emprestimo INTEGER NOT NULL ,
Num_exemplar INTEGER NOT NULL ,
ISBN INTEGER NOT NULL ,
Dt_Prevista_Devolucao DATE NOT NULL,
Dt_Devolucao DATE NULL,
Vl_multa_item  NUMBER(6,2)  NULL,
Situacao_item_emprest VARCHAR2(50) NOT NULL,
PRIMARY KEY ( Num_emprestimo, Num_exemplar, ISBN));
DESCRIBE itens_emprestimo ;
ALTER TABLE itens_emprestimo ADD CONSTRAINT fk_itens_emprestimo FOREIGN KEY (Num_emprestimo) REFERENCES emprestimo (Num_emprestimo) ON DELETE CASCADE;
ALTER TABLE itens_emprestimo ADD CONSTRAINT fk_itens_emprestimo_a FOREIGN KEY (Num_exemplar, ISBN) REFERENCES exemplar (Num_exemplar, ISBN) ON DELETE CASCADE;



/*SEQUENCES*/
CREATE SEQUENCE reserva_seq START WITH 800 INCREMENT BY 1;
SELECT * FROM user_sequences ;

/*ALTER TABLES*/

/*CONSTRAINTS CHECK*/
ALTER TABLE curso ADD CONSTRAINT check_tipo_curso CHECK ( Tipo_curso IN ( 'TECNOLOGIA', 'BACHARELADO', 'LICENCIATURA' ));
ALTER TABLE Participacao_obra ADD CONSTRAINT check_tipo_particiopacao CHECK ( Tipo_participacao IN ( 'PRINCIPAL', 'CO-AUTOR', 'REVISOR', 'TRADUTOR' ));
ALTER TABLE reserva ADD CONSTRAINT check_situacao_reserva CHECK ( Situacao_reserva IN ( 'ANDAMENTO', 'VENCIDO', 'EMPRESTIMO' , 'CANCELADO'));
ALTER TABLE Reserva_Obra ADD CONSTRAINT check_situacao_item_reserva CHECK ( Situacao_item_reserva IN ( 'CANCELADO', 'ANDAMENTO', 'VENCIDO' , 'EMPRESTIMO'));

/*ADD COLUMN*/
ALTER TABLE obra ADD (Palavras_chave VARCHAR2(300) NOT NULL);

/*MODIFY COLUMNS*/
ALTER TABLE usuario MODIFY Sexo_usuario VARCHAR2(1) ;
ALTER TABLE exemplar MODIFY Vl_exemplar DEFAULT 0.0 ;
ALTER TABLE reserva MODIFY Dt_reserva  DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE emprestimo MODIFY Vl_total_multa DEFAULT 0.0 ;
ALTER TABLE emprestimo MODIFY Dt_retirada DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE itens_emprestimo MODIFY Vl_multa_item DEFAULT 0.0 ;
ALTER TABLE itens_emprestimo MODIFY Dt_Devolucao DEFAULT CURRENT_TIMESTAMP;

/*RENAMES COLUMNS*/
ALTER TABLE Participacao_obra RENAME TO Participantes_obra;
ALTER TABLE professor RENAME COLUMN Titulacao TO titulo ;

/*TABELA AUXILIAR PAÍS*/
/*INSERTS AUTOR*/
INSERT INTO autor VALUES (001, 'William Stallings', 'Estados Unidos');
INSERT INTO autor VALUES (002, 'Karl Marx', 'Alemanha');

/*CREATE TABLE PAIS*/
DROP TABLE pais CASCADE CONSTRAINTS ;
CREATE TABLE pais (
cod_pais INTEGER PRIMARY KEY ,
nome_pais VARCHAR2(100) NOT NULL);
DESCRIBE pais ;

/*INSERS PAIS*/
INSERT INTO pais VALUES (001, 'ESTADOS UNIDOS');
INSERT INTO pais VALUES (002, 'ALEMANHA');

/*ALTER AUTOR*/
ALTER TABLE autor ADD cod_pais INTEGER;
select * from autor;
UPDATE autor a 
SET a.cod_pais = (SELECT p.cod_pais FROM pais p WHERE UPPER(a.Nacionalidade_autor) LIKE '%'||UPPER(p.nome_pais)||'%');
select * from autor;
ALTER TABLE autor ADD CONSTRAINT fk_pais_autor FOREIGN KEY (cod_pais) REFERENCES pais (cod_pais);
ALTER TABLE autor MODIFY cod_pais NOT NULL;
select * from autor;
ALTER TABLE autor DROP COLUMN Nacionalidade_autor;


/*INSERTS*/

INSERT INTO editora VALUES (001, 'Pearson', 'Av. Francisco Matarazzo, 1400 - Água Branca, São Paulo - SP, 05033-070', 1136721240, 01404158001838, 'elt.br@pearson.com', 'Inglaterra');
INSERT INTO editora VALUES (002, 'Veneta', 'R. Araújo, 124 - 1º andar - República, São Paulo - SP, 01220-020', 1132111233, 03323583000180, 'comercial@veneta.com.br', 'Brasil');
INSERT INTO editora VALUES (003, 'Rocco', 'Rua do Passeio, 38 – 11º andar, Centro Passeio Corporate – Torre 1 20021-290 – Rio de Janeiro – RJ', 11321192846, 42444703000159, 'comercial@rocco.com.br', 'Brasil');
INSERT INTO obra VALUES (9788576055648, 'Computer Organization and Architecture', 'Inglês', 'Informática', 'Livre', 'Computação, arquitetura, informática');
INSERT INTO obra VALUES (9788575594155, 'Das Kapital', 'Alemão', 'Economia política', 'Livre', 'O Capital, socialismo, marxismo, economia, política');
INSERT INTO obra VALUES (9788532523051, 'Harry Potter e a Pedra Filosofal', 'Inglês', 'Literatura', 'Livre', 'Literatura, infantil, fantasia');
INSERT INTO exemplar VALUES (001, 9788576055648, 001, 10, 'Português', '15/09/2017', 864,  'Didático', 'Física', 163, '7 dias', 'Doação', 'Usado');
INSERT INTO exemplar VALUES (002, 9788576055648, 001, 10, 'Inglês', '15/09/2017', 864,  'Didático', 'Digital', 163, '7 dias', 'Compra', 'Novo');
INSERT INTO exemplar VALUES (003, 9788575594155, 002, 1, 'Português', '01/01/2014', 927,  'Didático', 'Física', 95.90, '7 dias', 'Doação', 'Usado');
INSERT INTO exemplar VALUES (004, 9788575594155, 002, 1, 'Inglês', '01/01/2014', 927,  'Didático', 'Digital', 95.90, '7 dias', 'Compra', 'Novo');
INSERT INTO exemplar VALUES (005, 9788532523051, 003, 5, 'Inglês', '07/04/2000', 264,  'Didático', 'Digital', 26.91, '7 dias', 'Compra', 'Novo');
INSERT INTO participantes_obra VALUES (9788576055648, 001, 'PRINCIPAL');
INSERT INTO participantes_obra VALUES (9788575594155, 002, 'PRINCIPAL');
INSERT INTO usuario VALUES (001, 'Bruna Rafaela', 'Rua Vergueiro 2020, 04194-039, Ipiranga, São Paulo - SP', 11945002391, 'F', 01820973645, 491485592, '30/08/1992', 'ATIVO', 'brunarafaelav@outlook.com');
INSERT INTO usuario VALUES (002, 'Ugo Garcia SOUZA', 'AV. São João 1234, 04333-071, Centro, São Paulo - SP', 11935489174, 'M', 01920472603, 584027589, '21/11/1994', 'ATIVO', 'ugogarcia@bol.com.br')
INSERT INTO usuario VALUES (003,  'JOÃO DA SILVA', 'Rua Frei João, 234, 019632-020, Ipiranga, São Paulo - SP', 11935489171, 'M', 01920472601, 584027581, '19/06/1965', 'ATIVO', 'joaozinho@fatec.com.br');
INSERT INTO usuario VALUES (004,  'Rita Santos', 'AV. Ipiranga, 12345, 07462-029, Centro, São Paulo - SP', 11945002383, 'F', 01820973644, 491485512, '19/06/1977', 'ATIVO', 'ritinha@fatec.com.br');
INSERT INTO curso VALUES (001, 'Análise e desenvolvimento de sistemas', 'TECNOLOGIA');
INSERT INTO curso VALUES (002, 'Engenharia biomédica', 'BACHARELADO');
INSERT INTO aluno VALUES (001, '2040481622031', current_timestamp - 4, '01/12/2020', 001);
INSERT INTO aluno VALUES (002, '2145431929022', current_timestamp - 4, '01/12/2020', 002);
INSERT INTO professor VALUES (003, 0123456, 'Professor doutor efetivo', current_timestamp - 8, null);
INSERT INTO professor VALUES (004, 0234567, 'Professora doutora efetiva', current_timestamp - 4, null);
INSERT INTO reserva VALUES (001, current_timestamp - 3, '30/11/2020', 003, 'ANDAMENTO');
INSERT INTO reserva VALUES (002, current_timestamp - 3, '30/11/2020', 004, 'ANDAMENTO');
INSERT INTO reserva_obra VALUES (001,9788576055648, 'ANDAMENTO');
INSERT INTO reserva_obra VALUES (002,9788575594155, 'ANDAMENTO');
INSERT INTO emprestimo VALUES (001, current_timestamp - 2, 0.0, 003, 001, 'ANDAMENTO');
INSERT INTO emprestimo VALUES (002, current_timestamp + 4, 0.0, 004, 002, 'ANDAMENTO');
INSERT INTO itens_emprestimo VALUES (001,001,9788576055648,current_timestamp+7, null, 0.0, 'ANDAMENTO');
INSERT INTO itens_emprestimo VALUES (002,003,9788575594155,current_timestamp-7, current_timestamp+3, 3, 'ANDAMENTO');

/*SELECTS*/

/*
6. Mostrar as obras que estão reservadas e tem vencimento da reserva hoje, feitas por professoras mulheres com mais de 50 anos. Formato : Numero reserva-Nome do professor-Titulação-Titulo_obra
7. Mostrar uma lista dos empréstimos realizados no mês passado que contém obras escritas por autores que não são brasileiros e que tiveram multa em algum item  do empréstimo (basta um item somente) Número Empréstimo – Titulo Obra – Nome Autor – Nacionalidade Autor-Nacionalidade Autor-Número exemplar-ISBN-Data Retirada-Data Devolução-Valor Multa
8. Mostrar quantos exemplares foram emprestados no último trimestre publicados por editoras que não são brasileiras.
10. Mostrar a quantidade de reservas feitas para cada mês nos últimos 18 meses por professores que não sejam Doutores e por tipo de titulação : Mês – Titulação Professor - Qtde Reservas
11. Mostrar a quantidade de exemplares emprestados que ultrapassam 5 empréstimos no último trimestre e cujas obras tenham autores principais de nacionalidade diferente da editora que publicou o exemplar : Titulo Exemplar – Qtde Emprestimos
12. Mostrar o título das obras que foram reservadas nos últimos 6 meses por outros professores com a mesma titulação que o professor que você cadastrou. Mostre o nome do professor que fez a reserva também.
16. Mostre todos os dados do aluno campeão de atrasos em devolução de exemplares neste ano, por quantidade de vezes que atrasou
*/


--1. Mostrar os dados dos usuários do sexo feminino no formato : ‘João da Silva tem CPF 123 e nasceu em 10/02/1990’
SELECT u.Nome_usuario || ' tem CPF ' || u.CPF_USUARIO || ' e nasceu em ' || u.DT_NASCTO_USUARIO AS Dados_Usuario
from usuario u
WHERE u.SEXO_USUARIO = 'F';

--2. Mostrar o nome, sexo e data de nascimento dos alunos que tem ‘SILVA ou ‘SOUZA no nome e que nasceram entre 1988 e 1992
SELECT u.nome_usuario, u.sexo_usuario, u.dt_nascto_usuario AS Dados_Aluno
FROM usuario u INNER JOIN aluno a
ON u.cod_usuario = a.cod_usuario
WHERE UPPER(u.nome_usuario) LIKE '%SILVA%' OR UPPER(u.nome_usuario) LIKE '%SOUZA%'
AND EXTRACT(YEAR FROM dt_nascto_usuario) BETWEEN 1988 AND 1992;

--3. Mostrar os dados dos alunos que NÃO são de cursos de Tecnologia e que tem mais de 22 anos : Nome aluno-Idade-Nome Curso
SELECT u.NOME_USUARIO,u.DT_NASCTO_USUARIO, c.nome_curso from aluno a 
INNER JOIN curso c
ON a.cod_curso = c.cod_curso
JOIN usuario u ON
u.Cod_usuario = a.Cod_usuario
WHERE UPPER(c.tipo_curso) NOT LIKE '%TECNOLOGIA%';

--13. Mostrar todos os dados das obras que nunca foram reservadas. Resolver de três formas, sendo que uma com JUNÇÃO EXTERNA
-- LEFT JOIN
SELECT o.*, ro.num_reserva from obra o 
LEFT JOIN reserva_obra ro
ON o.ISBN = ro.ISBN
WHERE ro.ISBN IS NULL;

--NOT IN 
SELECT o.*, ro.num_reserva from obra o, reserva_obra ro
WHERE o.ISBN = ro.ISBN
AND ro.ISBN NOT IN (SELECT o.ISBN FROM obra o);

--MINUS
SELECT o.*, ro.num_reserva from obra o, reserva_obra ro
WHERE o.ISBN = ro.ISBN
AND o.ISBN IN (SELECT o.ISBN FROM obra o MINUS SELECT ro.ISBN  FROM  reserva_obra ro);

--14. Usando o comando DECODE mostre o nome dos autores e sua nacionalidade no formato: João da Silva – Brasileiro, outro exemplo Roger Pressman – Norteamericano
SELECT au.nome_autor AS Nome, 
DECODE (p.nome_pais, 'ESTADOS UNIDOS', 'Estadunidense', 'ALEMANHA', 'Alemão') AS Nacionalidade
from autor au INNER JOIN pais p
ON au.cod_pais = p.cod_pais
ORDER BY 1;

--15. Repita a consulta 18 acima, agora utilizando o CASE
SELECT au.nome_autor, p.nome_pais,
CASE
WHEN UPPER (p.nome_pais) LIKE 'ESTADOS UNIDOS' then 'Norte americano'
WHEN UPPER (p.nome_pais) LIKE 'ALEMANHA' then 'Alemão'
ELSE '?'
END AS Nacionalidade
from autor au INNER JOIN pais p
ON au.cod_pais = p.cod_pais
ORDER BY 1;


--5. Mostrar os empréstimos que tiveram origem em reserva no formato: 
--Número Empréstimo – Titulo Exemplar – Número exemplar - ISBN -
--Data Retirada- Data Devolução – Número Reserva – Data Reserva
SELECT em.Num_emprestimo, o.TITULO_ORIGINAL, e.NUM_EXEMPLAR, e.ISBN, em.DT_RETIRADA, ie.Dt_Devolucao, 
re.Num_reserva, re.Dt_reserva
FROM emprestimo em INNER JOIN reserva re 
ON em.NUM_RESERVA = re.NUM_RESERVA
INNER JOIN reserva_obra ro
ON re.Num_reserva = ro.Num_reserva
INNER JOIN obra o 
ON ro.ISBN = o.ISBN 
INNER JOIN exemplar e
ON o.ISBN = e.ISBN
INNER JOIN itens_emprestimo ie
ON em.num_emprestimo = ie.num_emprestimo; 

--4. Mostrar os autores que tem obras reservadas por professores admitidos há mais de 5 anos e o assunto não seja ‘Literatura’:  Nome autor – Numero Reserva – Data reserva-Situação Reserva-Titulo Obra-Assunto
SELECT au.nome_autor, re.num_reserva, re.Dt_reserva, re.Situacao_reserva, o.Titulo_original, o.Genero
FROM autor au INNER JOIN participantes_obra po
ON au.cod_autor = po.cod_autor
INNER JOIN obra o
ON po.ISBN = o.ISBN
INNER JOIN reserva_obra ro 
ON o.ISBN = ro.ISBN 
INNER JOIN reserva re
ON ro.num_reserva = re.num_reserva
INNER JOIN professor p 
ON re.Cod_usuario = p.Cod_usuario
WHERE p.DT_ADMISSAO >= current_timestamp - INTERVAL '5' YEAR 
AND UPPER(o.Genero ) NOT LIKE '%LITERATURA%';


--NAO FUNCIONA
--9. Mostrar quais nacionalidades tem menos de 5 autores principais das obras : Nacionalidade – Qtde obras
SELECT p.nome_pais,COUNT (o.ISBN) AS Qtde_obras
FROM autor au INNER JOIN participantes_obra po
ON au.cod_autor = po.cod_autor
INNER JOIN obra o
ON po.ISBN = o.ISBN
INNER JOIN pais p
ON au.cod_pais = p.cod_pais
WHERE UPPER(po.Tipo_participacao ) NOT LIKE '%PRINCIPAL%'; 
GROUP BY p.nome_pais, o.ISBN
HAVING COUNT(po.Tipo_participacao) <5,
ORDER BY 1,2;
