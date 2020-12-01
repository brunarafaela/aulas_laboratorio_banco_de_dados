/*curso (cod_curso(PK), nome_curso, tipo_curso)
usuario (cod_usuario (PK), nome_usuario, end_usuario, tipo_fone REF tipofone, sexo_usuario, cpf_usuario, rg_usuario, dt_nasc_usuario, situacao_usuario, email_usuario);
aluno (PA, dt_ingresso, dt_prevista_termino, dt_prevista_termino, curso REF curso);
professor (cod_funcional(PK), titulacao, dt_admissao, dt_desligamento);
obra (ISBN, titulo_original, idioma_original, genero,classificacao);
reserva (num_reserva(PK), dt_reserva, dt_limite, situacao_reserva, usuario REF professor);
itens_reserva_tipo (ISBN_item REF obra, situacao_item_reserva);
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

/*CREATE TABLES/*/
DROP TYPE tipo_fone FORCE;
CREATE OR REPLACE TYPE tipo_fone AS VARRAY(5) OF INTEGER;

DROP TYPE tipo_endereco FORCE;
CREATE OR REPLACE TYPE tipo_endereco AS OBJECT (
tipo_logradouro CHAR (12),
logradouro VARCHAR2(40),
numero SMALLINT,
complemento CHAR (10),
bairro VARCHAR2(25),
cidade VARCHAR2(30),
UF CHAR(2),
email VARCHAR2(32),
fones tipo_fone);

DROP TYPE tipo_curso FORCE;
CREATE OR REPLACE TYPE tipo_curso AS OBJECT(
    cod_curso CHAR(12),
    nome_curso VARCHAR2(30),
    tipo VARCHAR2(30));

DROP TABLE curso_table CASCADE CONSTRAINTS;
CREATE TABLE curso_table OF tipo_curso( PRIMARY KEY (cod_curso)) 
OBJECT IDENTIFIER IS SYSTEM GENERATED;

DROP TYPE tipo_usuario FORCE;
CREATE OR REPLACE TYPE tipo_usuario AS OBJECT(
    cod_usuario INTEGER,
    nome_usuario VARCHAR2(30),
    end_usuario tipo_endereco,
    sexo_usuario CHAR(1),
    cpf_usuario NUMBER(11),
    rg_usuario VARCHAR2(9),
    dt_nasc_usuario DATE,
    situacao_usuario VARCHAR2(30)) NOT FINAL;

DROP TYPE tipo_aluno FORCE;
CREATE OR REPLACE TYPE tipo_aluno UNDER tipo_usuario(
    ra NUMBER(18),
    dt_ingresso DATE,
    dt_prevista_termino DATE,
    cursos REF tipo_curso);

DROP TABLE aluno_table CASCADE CONSTRAINTS;
CREATE TABLE aluno_table OF tipo_aluno(
    PRIMARY KEY (cod_usuario),
    CHECK (sexo_usuario IN ('M', 'F')),
    UNIQUE (ra),
    UNIQUE (cpf_usuario),
    UNIQUE (rg_usuario))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

DROP TYPE tipo_professor FORCE;
CREATE OR REPLACE TYPE tipo_professor UNDER tipo_usuario(
    cod_funcional INTEGER,
    titulacao VARCHAR2(30),
    dt_admissao DATE,
    dt_desligamento DATE);

DROP TABLE professor_table CASCADE CONSTRAINTS;
CREATE TABLE professor_table OF tipo_professor(
    PRIMARY KEY (cod_usuario));

DROP TYPE tipo_obra FORCE;
CREATE OR REPLACE TYPE tipo_obra AS OBJECT(
    ISBN INTEGER,
    titulo_original VARCHAR2(300),
    idioma_original VARCHAR2(30),
    genero VARCHAR2(30),
    classificacao VARCHAR2(30));

DROP TABLE obra_table CASCADE CONSTRAINTS;
CREATE TABLE obra_table OF tipo_obra(
    PRIMARY KEY (ISBN)) 
OBJECT IDENTIFIER IS SYSTEM GENERATED;

DROP TYPE tipo_reserva FORCE;
CREATE OR REPLACE TYPE tipo_reserva AS OBJECT(
    num_reserva INTEGER,
    dt_reserva TIMESTAMP,
    dt_limite TIMESTAMP,
    situacao_reserva VARCHAR2(30),
    usuario REF tipo_professor);

DROP TABLE reserva_table CASCADE CONSTRAINTS;
CREATE TABLE reserva_table OF tipo_reserva(
    dt_reserva NOT NULL,
    dt_limite NOT NULL,
    situacao_reserva NOT NULL,
    CHECK (situacao_reserva in ('CANCELADO', 'EMPRESTIMO', 'ANDAMENTO', 'VENCIMENTO')),
    PRIMARY KEY (num_reserva)) 
OBJECT IDENTIFIER IS SYSTEM GENERATED;

DROP TYPE tipo_itens_reserva FORCE;
CREATE OR REPLACE TYPE tipo_itens_reserva AS OBJECT(
    isbn_obra REF tipo_obra,
    situacao_item_reserva VARCHAR2(50));


DROP TYPE tipo_emprestimo FORCE;
CREATE OR REPLACE TYPE tipo_emprestimo AS OBJECT(
    num_emprestimo INTEGER,
    cod_usuario REF tipo_aluno,
    num_reserva REF tipo_reserva,
    valor_total_multa NUMBER(6,2),
    situacao_emprestimo VARCHAR2(50),
    dt_retirada DATE);

DROP TABLE emprestimos CASCADE CONSTRAINTS;
CREATE TABLE emprestimos OF tipo_emprestimo(
    PRIMARY KEY (num_emprestimo),
    CHECK( situacao_emprestimo IN ('SEM DEVOLUÇÃO', 'ATRASADO', 'DEVOLVIDO', 'DEVOLVIDO COM MULTA', 'ANDAMENTO')))
    OBJECT IDENTIFIER IS SYSTEM GENERATED;

DROP type itens_reserva_table force;

CREATE OR REPLACE TYPE itens_reserva_table AS TABLE of tipo_itens_reserva;

ALTER TYPE tipo_reserva ADD ATTRIBUTE reservas itens_reserva_table CASCADE;

DROP type itens_reserva_table force;

CREATE OR REPLACE TYPE itens_reserva_table AS TABLE of tipo_itens_reserva;

ALTER TYPE tipo_reserva ADD ATTRIBUTE reservas itens_reserva_table CASCADE;

DROP TYPE tipo_autor FORCE;
CREATE OR REPLACE TYPE tipo_autor AS OBJECT(
    cod_autor INTEGER,
    nome_autor VARCHAR2(50),
    dt_nasc_autor DATE);

DROP TABLE autor CASCADE CONSTRAINTS;
CREATE TABLE autor OF tipo_autor(
    PRIMARY KEY (cod_autor))
OBJECT IDENTIFIER IS SYSTEM GENERATED;
 

DROP TYPE tipo_participacao_obra FORCE;
CREATE OR REPLACE TYPE tipo_participacao_obra AS OBJECT(
    isbn_obra REF tipo_obra,
    cod_autor REF tipo_autor,
    tipo_participacao VARCHAR2(50));
 
CREATE TABLE participacao_obra OF tipo_participacao_obra(
    PRIMARY KEY (isbn_obra, cod_autor),
    CHECK (tipo_participacao IN ('CO-AUTOR', 'REVISOR', 'TRADUTOR')));


/*INSERTS*/
INSERT INTO curso_table VALUES('001', 'Análise de sistemas', 'TECNOLOGIA');
INSERT INTO aluno_table VALUES(001, 'Bruna Rafaela', tipo_endereco('Rua', 'Vergueiro', 7000, null, 'Ipiranga', 'São Paulo', 'SP', 'brunarafaelav@outlook.com', tipo_fone(11987654321, 11998877665)),  'F', 47925721, '25487596x', DATE '2001-12-19', 'ATIVO', 20041998, DATE '2001-12-19', DATE '2001-12-19', (SELECT REF(c) FROM curso_table c WHERE c.cod_curso = '001'));
INSERT INTO professor_table VALUES(002, 'Rita Santos',tipo_endereco('Rua', 'Vergueiro', 7000, null, 'Ipiranga', 'São Paulo', 'SP', 'ritinha@fatec.com.b', tipo_fone(11987654321, 11998877665, 11991234567)),'F',57999721,'25487596x',DATE '1977-11-11','EM DIA',2020457896,'Professora doutora efetiva',DATE '2020-05-15',NULL);
INSERT INTO obra_table VALUES(9788575594155, 'O Capital', 'Alemão', 'Economia política', 'Libre');
INSERT INTO reserva_table VALUES(001, current_timestamp, current_timestamp + 14, 'ANDAMENTO', (SELECT REF(prof) FROM professor_table prof WHERE prof.cod_usuario = 001));
INSERT INTO autor VALUES(001, 'Karl Marx', DATE '1818-05-01');
INSERT INTO participacao_obra VALUES( (SELECT REF(o) FROM obra_table WHERE o.ISBN = 9788575594155), (SELECT REF(a) FROM autor WHERE a.cod_autor = 001), 'CO-AUTOR');
INSERT INTO emprestimos VALUES(001, (SELECT REF(a) FROM aluno_table a WHERE a.cod_usuario = 001), (SELECT REF(r) FROM reserva_table r WHERE r.num_reserva = 001),0.00, 'ANDAMENTO', DATE '2020-12-01');

/*SELECTS*/-

-- 3- Mostre os itens da reserva das reservas feitas este mês : Num Reserva-Data da Reserva – ISBN-Titulo Obra
SELECT r.num_reserva, r.dt_reserva, o.ISBN, o.titulo_original 
FROM reserva_table r, obra_table o
WHERE EXTRACT(month FROM r.dt_reserva) = '11';

-- 4- Complete a consulta acima mostrando também o Nome do Usuário e seus telefones
SELECT f.*, r.dt_reserva, o.ISBN, o.titulo_original, p.nome_usuario, r.num_reserva
FROM professor_table p, TABLE (p.end_usuario.fones)f, reserva_table r, obra_table o
WHERE EXTRACT(month FROM r.dt_reserva) = '11';

-- 5- Mostre o nome do curso e nome dos alunos que emprestaram este ano exemplares de obras escritas por autores Norte-Americanos, no formato : Num Emprestimo – Data Retirada-Nome Aluno – Nome Curso – ISBN – Número Exemplar – Titulo Obra- Nome Autor
SELECT r.num_reserva, r.dt_reserva, a.nome_usuario, c.nome_curso, o.ISBN, o.titulo_original
FROM TABLE (r.reservas)ir, reserva_table r
    JOIN emprestimo em ON (r.num_reserva = em.num_reserva)
    JOIN aluno_table a ON (em.cod_usuario = a.cod_usuario)
    JOIN curso_table c ON (a.cod_curso = c.cod_curso),
    JOIN obra_table o ON (o.ISBN = r.reserva.isbn_obra),
    JOIN participacao_obra po ON (o.ISBN = po.isbn_obra),
    JOIN autor aa ON (aa.cod_autor = po.cod_autor);

-- 6- Mostre o nome do autor e a contagem de exemplares emprestados por alunas (sexo do usuário) nos últimos 6 meses que ultrapassam 3 empréstimos.
SELECT a.nome_autor, COUNT(em.num_emprestimo) FROM autor a
    JOIN participacao_obra po ON (a.cod_autor = po.cod_autor)
    JOIN obra o ON (po.isbn_obra = o.ISBN),
    JOIN TABLE(r.reserva) re ON (re.isbn_obra = o.ISBN)
    JOIN reserva_table r ON (r.num_reserva = re.num_reserva)
    JOIN emprestimo em ON (em.num_reserva = r.num_reserva)
    JOIN aluno aa ON (em.cod_usuario = aa.cod_usuario)
    WHERE a.sexo_usuario = 'F';
