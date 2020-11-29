-- Esquema das tabelas
-- curso (cod_curso(pk), nome_curso,  tipo_curso);
-- usuario (cod_usuario (pk), nome_usuario, end_usuario, tipo_fone REF tipofone, sexo_usuario, cpf_usuario, rg_usuario, dt_nasc_usuario, situacao_usuario, email_usuario);
-- aluno (ra, dt_ingresso, dt_prevista_termino, dt_prevista_termino, curso REF curso);
-- professor (cod_funcional(pk), titulacao, dt_admissao, dt_desligamento);
-- obra (ISBN, titulo_original, idioma_original, genero,classificacao);
-- reserva (num_reserva(pk), dt_reserva, dt_limite, situacao_reserva, usuario REF professor);
-- itens_reserva_tipo (ISBN_item REF obra, situacao_item_reserva);

ALTER SESSION SET NSL_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';
SELECT sessiontimezone, current_timestamp FROM dual;


DROP TYPE tipo_fone FORCE;
CREATE OR REPLACE TYPE tipo_fone AS VARRAY(5) OF INTEGER;

DROP TYPE tipoendereco FORCE;
CREATE OR REPLACE TYPE tipoendereco AS OBJECT (
tipo_logradouro CHAR (12),
logradouro VARCHAR2(40),
numero SMALLINT,
complemento CHAR (10),
bairro VARCHAR2(25),
cidade VARCHAR2(30),
UF CHAR(2),
email VARCHAR2(32),
fones tipo_fone);


DROP TYPE curso FORCE;
CREATE OR REPLACE TYPE curso AS OBJECT(
    cod_curso CHAR(12),
    nome_curso VARCHAR2(30),
    tipo_curso VARCHAR2(30)
);

CREATE TABLE curso_table OF curso(
    PRIMARY KEY (cod_curso)
) OBJECT IDENTIFIER IS SYSTEM GENERATED;

--b. Curso e o Aluno é uma referência de objeto;
DROP TYPE usuario FORCE;
CREATE OR REPLACE TYPE usuario AS OBJECT(
    cod_usuario INTEGER,
    nome_usuario VARCHAR2(30),
    end_usuario tipoendereco,
    sexo_usuario CHAR(1),
    cpf_usuario NUMBER(11),
    rg_usuario VARCHAR2(9),
    dt_nasc_usuario DATE,
    situacao_usuario VARCHAR2(30)
) NOT FINAL;


-- a. Aluno como subtipo de Usuário
DROP TYPE aluno FORCE;
CREATE OR REPLACE TYPE aluno UNDER usuario(
    ra NUMBER(18),
    dt_ingresso DATE,
    dt_prevista_termino DATE,
    cursos REF curso
);

DROP TABLE aluno_table CASCADE CONSTRAINTS;
CREATE TABLE aluno_table OF aluno(
    PRIMARY KEY (cod_usuario),
    CHECK (sexo_usuario IN ('M', 'F')),
    UNIQUE (ra),
    UNIQUE (cpf_usuario),
    UNIQUE (rg_usuario)
) OBJECT IDENTIFIER IS SYSTEM GENERATED;

-- c. Reserva e o Professor é uma referência de objeto;
DROP TYPE professor FORCE;
CREATE OR REPLACE TYPE professor UNDER usuario(
    cod_funcional INTEGER,
    titulacao VARCHAR2(30),
    dt_admissao DATE,
    dt_desligamento DATE
);

CREATE TABLE professor_table OF professor(
    PRIMARY KEY (cod_usuario)
);

DROP TYPE obra FORCE;
CREATE OR REPLACE TYPE obra AS OBJECT(
    ISBN INTEGER,
    titulo_original VARCHAR2(300),
    idioma_original VARCHAR2(30),
    genero VARCHAR2(30),
    classificacao VARCHAR2(30)
);

DROP TABLE obra_table CASCADE CONSTRAINTS;
CREATE TABLE obra_table OF obra(
    PRIMARY KEY (ISBN)
) OBJECT IDENTIFIER IS SYSTEM GENERATED;

DROP TYPE reserva FORCE;
CREATE OR REPLACE TYPE reserva AS OBJECT(
    num_reserva INTEGER,
    dt_reserva TIMESTAMP,
    dt_limite TIMESTAMP,
    situacao_reserva VARCHAR2(30),
    usuario REF professor
);

DROP TABLE reserva_table CASCADE CONSTRAINTS;
CREATE TABLE reserva_table OF reserva(
    dt_reserva NOT NULL,
    dt_limite NOT NULL,
    situacao_reserva NOT NULL,
    CHECK (situacao_reserva in ('CANCELADO', 'EMPRESTIMO', 'ANDAMENTO', 'VENCIMENTO')),
    PRIMARY KEY (num_reserva)
) OBJECT IDENTIFIER IS SYSTEM GENERATED;


DROP TYPE itens_reserva_tipo FORCE;
CREATE OR REPLACE TYPE itens_reserva_tipo AS OBJECT(
    isbn_obra REF obra,
    situacao_item_reserva VARCHAR2(50)
);

-- d. Itens da reserva como tabela aninhada de Reserva; a Obra é uma referência de objeto
DROP type itens_reserva_table force;
CREATE OR REPLACE TYPE itens_reserva_table AS TABLE of itens_reserva_tipo;
ALTER TYPE reserva ADD ATTRIBUTE reservas itens_reserva_table CASCADE;

DROP TYPE autor_tipo FORCE;
CREATE OR REPLACE TYPE autor_tipo AS OBJECT(
    cod_autor INTEGER,
    nome_autor VARCHAR2(50),
    dt_nasc_autor DATE
);


 
CREATE TABLE autor OF autor_tipo();
 
DROP TYPE participacao_obra_tipo FORCE;
CREATE OR REPLACE TYPE participacao_obra_tipo AS OBJECT(
    isbn_obra REF obra,
    cod_autor REF autor
    tipo_participacao VARCHAR2(50)
);
 
CREATE TABLE participacao_obra OF participacao_obra_tipo(
    PRIMARY KEY (isbn_obra, cod_autor),
    CHECK (tipo_participacao IN ('Co-autor', 'Revisor', 'Tradutor'))
);


--2- Insira uma linha em cada tabela tipada;

INSERT INTO curso_table VALUES(
    'OCA', 'Oracle data base', 'Tecnologico'
);

INSERT INTO aluno_table VALUES(
    1, 'José Aldo Peréz',
    tipoendereco
        ('Rua', 'Vergueiro', 7000, null, 'Ipiranga', 'São Paulo', 'SP', 'mascale20@gmail.com', tipo_fone(11987654321, 11998877665)),
    'M',
    47925721,
    '25487596x',
    DATE '2001-12-19',
    'EM DIA',
    20041998,
    DATE '2001-12-19',
    DATE '2001-12-19',
    (SELECT REF(c) FROM curso_table c WHERE c.cod_curso = 'OCA')
);

INSERT INTO professor_table VALUES(
    8965, 'José Alto Peréz',
    tipoendereco
        ('Rua', 'Vergueiro', 7000, null, 'Ipiranga', 'São Paulo', 'SP', 'mascale20@gmail.com', tipo_fone(11987654321, 11998877665, 11991234567)),
    'M',
    57999721,
    '25487596x',
    DATE '1997-11-11',
    'EM DIA',
    2020457896,
    'Mestre',
    DATE '2020-05-15',
    NULL
);

INSERT INTO obra_table VALUES(
    978853382273, 'Como não reprovar em DB fazendo a recuperação', 'aramaico', 'DRAMA', '18 anos'
);

INSERT INTO reserva_table VALUES(
    78945, current_timestamp, current_timestamp + 14, 'ANDAMENTO',
    (SELECT REF(prof) FROM professor_table prof WHERE prof.cod_usuario = 8965)
);


INSERT INTO autor VALUES(
    4001, 'José Escritor', DATE '1949-05-12'
);
 
INSERT INTO participacao_obra VALUES(
    (SELECT REF(o) FROM obra_table WHERE o.ISBN = 978853382273), (SELECT REF(a) FROM autor WHERE a.cod_autor = 4001), 'Co-autor'
);

-- 3- Mostre os itens da reserva das reservas feitas este mês : Num Reserva-Data da Reserva – ISBN-Titulo Obra

SELECT r.num_reserva || ' - ' || r.dt_reserva || ' - ' || o.ISBN || ' - ' || o.titulo_original FROM reserva_table r, obra_table o
    WHERE EXTRACT(month FROM r.dt_reserva) = '11';


-- 4- Complete a consulta acima mostrando também o Nome do Usuário e seus telefones

SELECT f.*, r.dt_reserva, o.ISBN, o.titulo_original, p.nome_usuario,
    r.num_reserva FROM professor_table p, TABLE (p.end_usuario.fones)f, reserva_table r, obra_table o
    WHERE EXTRACT(month FROM r.dt_reserva) = '11';


-- 5- Mostre o nome do curso e nome dos alunos que emprestaram este ano exemplares de obras escritas por autores Norte-Americanos, no formato : Num
--Emprestimo – Data Retirada-Nome Aluno – Nome Curso – ISBN – Número Exemplar – Titulo Obra- Nome Autor

 
SELECT r.num_reserva, r.dt_reserva, a.nome_usuario, c.nome_curso, o.ISBN, o.titulo_original
FROM TABLE (r.reservas)ir, reserva_table r
    JOIN emprestimo em ON (r.num_reserva = em.num_reserva)
    JOIN aluno_table a ON (em.cod_usuario = a.cod_usuario)
    JOIN curso_table c ON (a.cod_curso = c.cod_curso),
    JOIN obra_table o ON (o.ISBN = r.reserva.isbn_obra)
    JOIN participacao_obra po ON (o.ISBN = po.isbn_obra)
    JOIN autor aa ON (aa.cod_autor = po.cod_autor)


-- 6- Mostre o nome do autor e a contagem de exemplares emprestados por alunas ( sexo do usuário) nos últimos 6 meses que ultrapassam 3 empréstimos.

SELECT a.nome_autor, COUNT(em.num_emprestimo) FROM autor a
    JOIN participacao_obra po ON (a.cod_autor = po.cod_autor)
    JOIN obra o ON (po.isbn_obra = o.ISBN),
    JOIN TABLE(r.reserva) re ON (re.isbn_obra = o.ISBN)
    JOIN reserva_table r ON (r.num_reserva = re.num_reserva)
    JOIN emprestimo em ON (em.num_reserva = r.num_reserva)
    JOIN aluno aa ON (em.cod_usuario = aa.cod=ultrapassam)
    WHERE a.sexo_usuario = 'F'
