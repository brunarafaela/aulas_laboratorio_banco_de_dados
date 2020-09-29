
DROP TABLE cid CASCADE CONSTRAINTS ;
CREATE TABLE cid (
                id_cid NUMBER NOT NULL,
                nome_cid VARCHAR2 NOT NULL,
                sigla_cid VARCHAR2 NOT NULL,
                desc_cid VARCHAR2 NOT NULL,
                CONSTRAINT CID_PK PRIMARY KEY (id_cid)
);

DROP TABLE paciente CASCADE CONSTRAINTS ;
CREATE TABLE paciente (
                id_paciente NUMBER NOT NULL,
                nome_paciente VARCHAR2 NOT NULL,
                data_nascimento DATE NOT NULL,
                endereco_paciente VARCHAR2 NOT NULL,
                cpf_paciente NUMBER(11) NOT NULL,
                sexo_paciente CHAR(1) NOT NULL,
                rg_paciente VARCHAR2(10) NOT NULL,
                email_paciente VARCHAR2 NOT NULL,
                num_cartao_sus NUMBER NOT NULL,
                telefone_paciente NUMBER(11) NOT NULL,
                CONSTRAINT PACIENTE_PK PRIMARY KEY (id_paciente)
);

DROP SEQUENCE paciente_seq;
CREATE SEQUENCE paciente_seq START WITH 1 INCREMENT BY 1
MINVALUE 1 MAXVALUE 10000 NOCYCLE;

DROP TABLE unidade_atendimento CASCADE CONSTRAINTS ;
CREATE TABLE unidade_atendimento (
                id_unidade NUMBER NOT NULL,
                nome_unidade VARCHAR2 NOT NULL,
                endereco_unidade VARCHAR2 NOT NULL,
                telefone_unidade NUMBER(11) NOT NULL,
                regiao_unidade VARCHAR2 NOT NULL,
                distrito_unidade VARCHAR2 NOT NULL,
                CONSTRAINT UNIDADE_ATENDIMENTO_PK PRIMARY KEY (id_unidade)
);

DROP TABLE ama CASCADE CONSTRAINTS ;
CREATE TABLE ama (
                id_unidade NUMBER NOT NULL,
                tipos_atendimentos VARCHAR2 NOT NULL,
                tipos_vacinas VARCHAR2 NOT NULL,
                CONSTRAINT AMA_PK PRIMARY KEY (id_unidade)
);


ALTER TABLE ama ADD CONSTRAINT UNIDADE_ATENDIMENTO_AMA_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_atendimento (id_unidade)
ON DELETE CASCADE
NOT DEFERRABLE;


DROP TABLE ubs CASCADE CONSTRAINTS ;
CREATE TABLE ubs (
                id_unidade NUMBER NOT NULL,
                tipos_atendimentos VARCHAR2 NOT NULL,
                tipos_vacinas VARCHAR2 NOT NULL,
                CONSTRAINT UBS_PK PRIMARY KEY (id_unidade)
);


ALTER TABLE ubs ADD CONSTRAINT UNIDADE_ATENDIMENTO_UBS_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_atendimento (id_unidade)
NOT DEFERRABLE;


DROP TABLE vacina CASCADE CONSTRAINTS ;
CREATE TABLE vacina (
                id_vacina NUMBER NOT NULL,
                id_unidade NUMBER NOT NULL,
                desc_vacina VARCHAR2 NOT NULL,
                tipo_vacina VARCHAR2 NOT NULL,
                nome_vacina VARCHAR2 NOT NULL,
                CONSTRAINT VACINA_PK PRIMARY KEY (id_vacina)
);


ALTER TABLE vacina ADD CONSTRAINT AMA_VACINA_FK
FOREIGN KEY (id_unidade)
REFERENCES ama (id_unidade)
NOT DEFERRABLE;

ALTER TABLE vacina ADD CONSTRAINT UBS_VACINA_FK
FOREIGN KEY (id_unidade)
REFERENCES ubs (id_unidade)
NOT DEFERRABLE;


DROP TABLE upa CASCADE CONSTRAINTS ;
CREATE TABLE upa (
                id_unidade NUMBER NOT NULL,
                qtd_leitos_uti NUMBER NOT NULL,
                qtd_leitos_emergencia NUMBER NOT NULL,
                CONSTRAINT UPA_PK PRIMARY KEY (id_unidade)
);


ALTER TABLE upa ADD CONSTRAINT UNIDADE_ATENDIMENTO_UPA_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_atendimento (id_unidade)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE hospital_municipal CASCADE CONSTRAINTS ;
CREATE TABLE hospital_municipal (
                id_unidade NUMBER NOT NULL,
                qtd_leitos_uti NUMBER NOT NULL,
                qtd_leitos_emergencia NUMBER NOT NULL,
                CONSTRAINT HOSPITAL_MUNICIPAL_PK PRIMARY KEY (id_unidade)
);


ALTER TABLE hospital_municipal ADD CONSTRAINT UNIDADE_ATENDIMENTO_HOSPITAL_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_atendimento (id_unidade)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE funcionario CASCADE CONSTRAINTS ;
CREATE TABLE funcionario (
                id_funcionario VARCHAR2 NOT NULL,
                email_funcionari VARCHAR2 NOT NULL,
                nome_funcionario VARCHAR2 NOT NULL,
                cpf_funcionario NUMBER(11) NOT NULL,
                sexo_funcionario CHAR(1) NOT NULL,
                endereco_funcionario VARCHAR2 NOT NULL,
                endereco_funcionario VARCHAR2 NOT NULL,
                data_nascimento DATE NOT NULL,
                telefone_funcionario NUMBER(11) NOT NULL,
                rg_funcionario VARCHAR2(10) NOT NULL,
                CONSTRAINT FUNCIONARIO_PK PRIMARY KEY (id_funcionario)
);

DROP TABLE coordenador_unidade CASCADE CONSTRAINTS ;
CREATE TABLE coordenador_unidade (
                id_funcionario VARCHAR2 NOT NULL,
                id_coordenador NUMBER NOT NULL,
                id_unidade NUMBER NOT NULL,
                CONSTRAINT COORDENADOR_UNIDADE_PK PRIMARY KEY (id_funcionario, id_coordenador)
);


ALTER TABLE coordenador_unidade ADD CONSTRAINT UNIDADE_ATENDIMENTO_COORDENADOR_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_atendimento (id_unidade)
ON DELETE CASCADE
NOT DEFERRABLE;


ALTER TABLE coordenador_unidade ADD CONSTRAINT FUNCIONARIO_COORDENADOR_UNIDADE_FK
FOREIGN KEY (id_funcionario)
REFERENCES funcionario (id_funcionario)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE medico CASCADE CONSTRAINTS ;
CREATE TABLE medico (
                id_funcionario VARCHAR2 NOT NULL,
                crm_medico NUMBER NOT NULL,
                especialidade_medico VARCHAR2 NOT NULL,
                CONSTRAINT MEDICO_PK PRIMARY KEY (id_funcionario, crm_medico)
);


ALTER TABLE medico ADD CONSTRAINT FUNCIONARIO_MEDICO_FK
FOREIGN KEY (id_funcionario)
REFERENCES funcionario (id_funcionario)
ON DELETE CASCADE
NOT DEFERRABLE;


DROP TABLE atendimento CASCADE CONSTRAINTS ;
CREATE TABLE atendimento (
                id_atendimento NUMBER NOT NULL,
                id_paciente NUMBER NOT NULL,
                id_unidade NUMBER NOT NULL,
                id_funcionario VARCHAR2 NOT NULL,
                crm_medico NUMBER NOT NULL,
                data_atendimento TIMESTAMP NOT NULL,
                CONSTRAINT ATENDIMENTO_PK PRIMARY KEY (id_atendimento)
);

DROP SEQUENCE atendimento_seq;
CREATE SEQUENCE atendimento_seq START WITH 220000 INCREMENT BY 1
MINVALUE 1 MAXVALUE 10000 NOCYCLE;


ALTER TABLE atendimento ADD CONSTRAINT UNIDADE_ATENDIMENTO_ATENDIMENTO_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_atendimento (id_unidade)
NOT DEFERRABLE;


ALTER TABLE atendimento ADD CONSTRAINT PACIENTE_ATENDIMENTO_FK
FOREIGN KEY (id_paciente)
REFERENCES paciente (id_paciente)
ON DELETE CASCADE
NOT DEFERRABLE;


ALTER TABLE atendimento ADD CONSTRAINT MEDICO_ATENDIMENTO_FK
FOREIGN KEY (crm_medico, id_funcionario)
REFERENCES medico (crm_medico, id_funcionario)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE vacinacao CASCADE CONSTRAINTS ;
CREATE TABLE vacinacao (
                id_atendimento NUMBER NOT NULL,
                id_vacina NUMBER NOT NULL,
                horario_vacinacao DATE NOT NULL,
                crm_medico NUMBER NOT NULL,
                CONSTRAINT VACINACAO_PK PRIMARY KEY (id_atendimento, id_vacina)
);

ALTER TABLE vacinacao ADD CONSTRAINT ATENDIMENTO_VACINACAO_FK
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;


ALTER TABLE vacinacao ADD CONSTRAINT VACINA_VACINACAO_FK
FOREIGN KEY (id_vacina)
REFERENCES vacina (id_vacina)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE internacao CASCADE CONSTRAINTS ;
CREATE TABLE internacao (
                id_atendimento NUMBER NOT NULL,
                crm_medico NUMBER NOT NULL,
                data_internacao DATE NOT NULL,
                CONSTRAINT INTERNACAO_PK PRIMARY KEY (id_atendimento)
);


ALTER TABLE internacao ADD CONSTRAINT ATENDIMENTO_INTERNACAO_FK
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;


DROP TABLE consulta_medica CASCADE CONSTRAINTS ;
CREATE TABLE consulta_medica (
                id_atendimento NUMBER NOT NULL,
                crm_medico NUMBER NOT NULL,
                data_consulta DATE NOT NULL,
                estado_consulta VARCHAR2 NOT NULL,
                CONSTRAINT CONSULTA_MEDICA_PK PRIMARY KEY (id_atendimento)
);


ALTER TABLE consulta_medica ADD CONSTRAINT ATENDIMENTO_CONSULTA_MEDICA_FK
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;


DROP TABLE prescricao CASCADE CONSTRAINTS ;
CREATE TABLE prescricao (
                id_prescricao NUMBER NOT NULL,
                id_atendimento NUMBER NOT NULL,
                desc_prescricao VARCHAR2 NOT NULL,
                CONSTRAINT PRESCRICAO_PK PRIMARY KEY (id_prescricao, id_atendimento)
);

ALTER TABLE prescricao ADD CONSTRAINT CONSULTA_MEDICA_PRESCRICAO_FK
FOREIGN KEY (id_atendimento)
REFERENCES consulta_medica (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE pronto_atendimento CASCADE CONSTRAINTS ;
CREATE TABLE pronto_atendimento (
                id_atendimento NUMBER NOT NULL,
                crm_medico NUMBER NOT NULL,
                CONSTRAINT PRONTO_ATENDIMENTO_PK PRIMARY KEY (id_atendimento)
);


ALTER TABLE pronto_atendimento ADD CONSTRAINT ATENDIMENTO_PRONTO_ATENDIMENTO_FK
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

DROP TABLE diagnostico CASCADE CONSTRAINTS ;
CREATE TABLE diagnostico (
                id_diagnostico_inicial NUMBER NOT NULL,
                id_atendimento NUMBER NOT NULL,
                desc_diagnostico_inicial VARCHAR2 NOT NULL,
                id_cid NUMBER NOT NULL,
                CONSTRAINT DIAGNOSTICO_PK PRIMARY KEY (id_diagnostico_inicial, id_atendimento)
);

ALTER TABLE diagnostico ADD CONSTRAINT CONSULTA_MEDICA_DIAGNOSTICO_FK
FOREIGN KEY (id_atendimento)
REFERENCES consulta_medica (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE diagnostico ADD CONSTRAINT PRONTO_ATENDIMENTO_DIAGNOSTICO_FK
FOREIGN KEY (id_atendimento)
REFERENCES pronto_atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;


ALTER TABLE diagnostico ADD CONSTRAINT INTERNACAO_DIAGNOSTICO_FK
FOREIGN KEY (id_atendimento)
REFERENCES internacao (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE diagnostico ADD CONSTRAINT CID_DIAGNOSTICO_FK
FOREIGN KEY (id_cid)
REFERENCES cid (id_cid)
ON DELETE CASCADE
NOT DEFERRABLE;


DROP TABLE escala CASCADE CONSTRAINTS ;
CREATE TABLE escala (
                id_funcionario VARCHAR2 NOT NULL,
                crm_medico NUMBER NOT NULL,
                desc_escala VARCHAR2 NOT NULL,
                CONSTRAINT ESCALA_PK PRIMARY KEY (id_funcionario, crm_medico)
);

ALTER TABLE escala ADD CONSTRAINT MEDICO_ESCALA_FK
FOREIGN KEY (crm_medico, id_funcionario)
REFERENCES medico (crm_medico, id_funcionario)
ON DELETE CASCADE
NOT DEFERRABLE;


DROP TABLE atendente CASCADE CONSTRAINTS ;
CREATE TABLE atendente (
                id_funcionario VARCHAR2 NOT NULL,
                CONSTRAINT ATENDENTE_PK PRIMARY KEY (id_funcionario)
);

ALTER TABLE atendente ADD CONSTRAINT FUNCIONARIO_ATENDENTE_FK
FOREIGN KEY (id_funcionario)
REFERENCES funcionario (id_funcionario)
ON DELETE CASCADE
NOT DEFERRABLE;
