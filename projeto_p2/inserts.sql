/*Integrantes
BRUNA_RAFAELA_VIANA_LIMA
JOAO_VICTOR_DE_SOUZA_CASTRO
VITOR_JOSE_DE_SOUZA_NASCIMENTO_TEODOSIO
*/


/*create tables*/

--tipoendereco(tipo_logradouro, logradouro, numero, complemento, bairro, cidade, UF, email, fone);
--unidade_saude(cod_unid(PK), nome_unid, end_unid, fone_unid, regiao, distrito, tipo_unid, registro REF funcionario);
--funcionario(registro_func(PK), nome_func, end_func, sexo_func, dt_nasc_func, fone_func,
--            email_func, cod_unid REF unidade_saude);
--paciente(num_sus(PK), nome_paciente, end_paciente, sexo_paciente, dt_nasc_paciente,
--         responsavel, cpf_responsavel, email_paciente);
--vacinacao(id_vac(PK), tipo_vac, dose_num, dt_dose_anterior);
--atendimento(num_atendimento, dt_hora_atendimento, motivo, diagnostico, tipo_atendimento, situacao_atendimento, observações);
--tipo_vacina(tipo_vacina);
--tipo_atendimento(tipo_atendimento);
--carteira_vacinacao(num_atendimento REF atendimento, vacina_aplicada tipo_vacina, data_vacinacao REF vacinacao);
--tipo_medico(registro_func REF funcionario);
--tipo_atendente( registro_func REF funcionario);


--vetor variável para telefone

DROP TYPE tipofone FORCE;
CREATE OR REPLACE TYPE tipofone AS VARRAY(5) OF INTEGER;


--definindo um tipo para endereco

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
fones tipofone)
FINAL;

--CRIAÇÃO DO TIPO unidade_saude E TABLE tabela_unidade_saude DO TIPO unidade_saude

DROP TYPE unidade_saude FORCE;
CREATE OR REPLACE TYPE unidade_saude AS OBJECT(
    cod_unid SMALLINT,
    nome_unid VARCHAR2(50),
    end_unid tipoendereco,
    fone_unid tipofone,
    regiao VARCHAR2(15),
    distrito VARCHAR2(20),
    tipo_unid VARCHAR2(8)
)
FINAL;

DROP TABLE tabela_unidade_saude CASCADE CONSTRAINTS;
CREATE TABLE tabela_unidade_saude OF unidade_saude(
    PRIMARY KEY(cod_unid),
    CHECK(tipo_unid IN ('UPA', 'UBS', 'AMA', 'Hospital'))
) OBJECT IDENTIFIER IS SYSTEM GENERATED;



--CRIAÇÃO DO TIPO funcionario E TABLE tabela_funcionario DO TIPO funcionario

DROP TYPE funcionario FORCE;
CREATE OR REPLACE TYPE funcionario AS OBJECT(
    registro_func SMALLINT,
    nome_func VARCHAR2(50),
    end_func tipoendereco,
    sexo_func CHAR(1),
    dt_nasc_func DATE,
    fone_func tipofone,
    email_func VARCHAR2(30),
    cod_unid REF unidade_saude
)
FINAL;

DROP TABLE tabela_funcionario CASCADE CONSTRAINTS;
CREATE TABLE tabela_funcionario OF funcionario(
    PRIMARY KEY (registro_func),
    CHECK(sexo_func IN ('M', 'F')),
    UNIQUE (email_func)
) OBJECT IDENTIFIER IS SYSTEM GENERATED;



--adicionando o registro do func a table

ALTER TYPE unidade_saude ADD ATTRIBUTE registro_func tabela_unidade_saude CASCADE;


--CRIAÇÃO DO TIPO paciente E TABLE tabela_paciente DO TIPO paciente

DROP TYPE paciente FORCE;
CREATE OR REPLACE TYPE paciente AS OBJECT(
    num_sus INTEGER,
    nome_paciente VARCHAR2(50),
    end_paciente tipoendereco,
    sexo_paciente CHAR(1),
    dt_nasc_paciente DATE,
    responsavel VARCHAR2(50),
    cpf_responsavel NUMBER(11),
    email_paciente VARCHAR2(30)
)
FINAL;

DROP TABLE tabela_paciente FORCE;
CREATE TABLE tabela_paciente OF paciente(
    PRIMARY KEY (num_sus),
    CHECK(sexo_paciente IN ('M', 'F')),
    UNIQUE (cpf_responsavel),
    UNIQUE (email_paciente)
)  OBJECT IDENTIFIER IS SYSTEM GENERATED;


--CRIAÇÃO DO TIPO vacinacao E TABLE tabela_vacinacao DO TIPO vacinacao

DROP TYPE vacinacao FORCE;
CREATE OR REPLACE TYPE vacinacao AS OBJECT(
    id_vac INTEGER,
    tipo_vac tipo_vacina,
    dose_num SMALLINT,
    dt_dose_anterior DATE
)
FINAL;

DROP TABLE tabela_vacinacao CASCADE CONSTRAINTS;
CREATE TABLE tabela_vacinacao OF vacinacao(
    PRIMARY KEY (id_vac)
)  OBJECT IDENTIFIER IS SYSTEM GENERATED;


--TABELAS ANINHADAS


--tipo médico

DROP TYPE tipo_medico FORCE;
CREATE OR REPLACE TYPE tipo_medico AS OBJECT(
    registro_func REF funcionario
)
FINAL;

DROP TABLE tabela_medico CASCADE CONSTRAINTS;
CREATE TABLE tabela_medico OF tipo_medico OBJECT IDENTIFIER IS SYSTEM GENERATED;


--tipo atendente

DROP TYPE tipo_atendente FORCE;
CREATE OR REPLACE TYPE tipo_atendente AS OBJECT(
    registro_func REF funcionario
)
FINAL;

DROP TABLE tabela_atendente CASCADE CONSTRAINTS;
CREATE TABLE tabela_atendente OF tipo_atendente OBJECT IDENTIFIER IS SYSTEM GENERATED;


--definindo um tipo para tipo_atendimento

DROP TYPE tipo_atendimento FORCE;
CREATE OR REPLACE TYPE tipo_atendimento AS OBJECT(
    atendimento VARCHAR2(20)
)
FINAL;

--criando tipo atendimento e aninhando em paciente
--tipo atendimento referencia medico e atendente

DROP TYPE atendimento FORCE;
CREATE OR REPLACE TYPE atendimento AS OBJECT(
    num_atendimento INTEGER,
    dt_hora_atendimento DATE,
    motivo VARCHAR2(50),
    diagnostico VARCHAR2(50),
    atendimento tipo_atendimento,
    situacao_atendimento VARCHAR2(20),
    medico REF tabela_medico,
    atendente REF tabela_atendente,
    observações VARCHAR2(300)
)
FINAL;

DROP TABLE tabela_atendimento CASCADE CONSTRAINTS;
CREATE TABLE tabela_atendimento OF atendimento(
    PRIMARY KEY (num_atendimento),
    dt_hora_atendimento NOT NULL,
    motivo NOT NULL,
    diagnostico NOT NULL,
    situacao_atendimento NOT NULL
    CHECK (situacao_atendimento IN ('FINALIZADO', 'EM ANDAMENTO', 'CANCELADO', 'EM ESPERA', 'NÃO REALIZADO'))
) OBJECT IDENTIFIER IS SYSTEM GENERATED
NESTED TABLE paciente STORE AS consulta_atendimento RETURN AS LOCATOR;


--definindo um tipo para tipo_vacina

DROP TYPE tipo_vacina FORCE;
CREATE OR REPLACE TYPE tipo_vacina AS OBJECT(
    vacina VARCHAR2(20)
)
FINAL;


--criando tipo carteira vacinação, referenciando atendimento e a vacina

DROP TYPE carteira_vacinacao FORCE;
CREATE OR REPLACE TYPE carteira_vacinacao AS OBJECT(
    num_atendimento REF atendimento,
    vacina_aplicada tipo_vacina,
    data_vacinacao REF vacinacao
)
FINAL;

DROP TABLE tabela_carteira_vacinacao CASCADE CONSTRAINTS;
CREATE TABLE tabela_carteira_vacinacao OF carteira_vacinacao(
    PRIMARY KEY (num_atendimento),
) OBJECT IDENTIFIER IS SYSTEM GENERATED
NESTED TABLE paciente STORE AS carteira_vacinacao RETURN AS LOCATOR;



--insert unidade_saude

INSERT INTO tabela_unidade_saude VALUES(
    0001,
    'UBS Centro',
    tipoendereco(
        'avenida',
        'paulistana',
        200,
        '',
        'centro',
        'São Paulo',
        'SP',
        'ubscentro@saude.sp.gov.br',
        tipofone([23311234, 23315678])
        ),
    'centro',
    'sé',
    'UBS'
)

INSERT INTO tabela_unidade_saude VALUES(
    0002,
    'Hospital Interlagos',
    tipoendereco(
        'avenida',
        'interlagos',
        2005,
        '',
        'interlagos',
        'São Paulo',
        'SP',
        'hospitalinterlagos@saude.sp.gov.br',
        tipofone([91181234, 91185678, 91180000])
    ),
    'sul',
    'Interlagos',
    'Hospital'
);

--insert funcionario

INSERT INTO funcionario VALUES(
    10001,
    'José Auugusto'
    tipoendereco(
        'rua',
        'dos autores',
        2303,
        'apto 32',
        'Campo Limpo',
        'São Paulo',
        'SP',
        'jose.augusto@gmail.com',
        tipofone(65541234)
    ),
    'M',
    '18/07/1987',
    tipofone(65541234),
    'jose.augusto@gmail.com',
    (SELECT REF(e) FROM tabela_unidade_saude e WHERE e.cod_unid = 0002)
);

INSERT INTO tabela_funcionario VALUES(
    10002,
    'Maria Aparecida da Silva'
    tipoendereco(
        'avenida',
        'paulista',
        1844,
        'apto 774',
        'bela vista',
        'São Paulo',
        'SP',
        'mariaap.silva@gmail.com',
        tipofone([24470145, 87744269])
    ),
    'F',
    '05/10/1974',
    tipofone([24470145, 87744269]),
    'mariaap.silva@gmail.com',
    (SELECT REF(e) FROM tabela_unidade_saude e WHERE e.cod_unid = 0002)
);

-- paciente

INSERT INTO tabela_paciente VALUES(
    192001,
    'João da Costa',
    tipoendereco(
        'rua',
        'das dores',
        666,
        'fundos',
        'capão redondo',
        'São Paulo',
        'SP',
        '',
        tipofone([98874123])
    ),
    'M',
    '30/09/1971',
    'Leila da Costa',
    11233115401,
    'leiladacosta@gmail.com'
);

INSERT INTO tabela_paciente VALUES(
    1924460,
    'Gabriela de Almeida Prado',
    tipoendereco(
        'av',
        'dos ourives',
        550,
        'bloco 1, apto 12',
        'parque bristol',
        'São Paulo',
        'SP',
        'gaprado@yahoo.com',
        tipofone([21145544, 987446554])
    ),
    'F',
    '22/04/2000',
    'Alberto de Almeida',
    44211566987,
    'albertoalmeida@hotmail.com'
);


-- vacina
INSERT INTO tabela_vacina VALUES(
    'Benzetacil'
);

INSERT INTO tabela_vacina VALUES(
    'Covid'
);

-- vacinação

INSERT INTO tabela_vacinacao VALUES(
    1000001,
    tipo_vac(
        'Benzetacil'
    ),
    1,
    '12/10/2019'
);

INSERT INTO tabela_vacinacao VALUES(
    1000002,
    tipo_vac(
        'Covid'
    ),
    2,
    ''
);

--medico

INSERT INTO tabela_medico VALUES(
    (
        SELECT REF(m) FROM tabela_funcionario m WHERE m.registro_func = 10002
    )
);

-- atendente

INSERT INTO tabela_atendente VALUES(
    (
        SELECT REF(m) FROM tabela_funcionario m WHERE m.registro_func = 10001
    )
);


-- atendimento

INSERT INTO tabela_atendimento VALUES(
    0000001,
    '20/10/2020',
    'Sintomas de gripe',
    'Gripe',
    tipoatendimento('Atendimento de urgência'),
    'EM ANDAMENTO',
    (
        SELECT REF(m) FROM tabela_funcionario m WHERE m.registro_func = 10002
    ),
    (
        SELECT REF(m) FROM tabela_funcionario m WHERE m.registro_func = 10001
    ),
    'Paciente encontra-se em observacao'
);

INSERT INTO tabela_atendimento VALUES(
    0000002,
    '21/10/2020',
    'Sintomas de COVID',
    'COVID',
    tipoatendimento('Atendimento de urgência'),
    'EM ANDAMENTO',
    (
        SELECT REF(m) FROM tabela_funcionario m WHERE m.registro_func = 10002
    ),
    (
        SELECT REF(m) FROM tabela_funcionario m WHERE m.registro_func = 10001
    ),
    'Paciente encontra-se em observacao'
);

-- carteira de vacinacao

INSERT INTO tabela_carteira_vacinacao VALUES(
    


);