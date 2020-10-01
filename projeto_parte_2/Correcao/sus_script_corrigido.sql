
/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS'; ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

DROP TABLE tipo_atendimento CASCADE CONSTRAINTS ;
CREATE TABLE tipo_atendimento (
                id_tipo_atendimento NUMBER NOT NULL,
                tipo_atendimento VARCHAR2 NOT NULL,
                recursos_minimos VARCHAR2 NOT NULL,
                CONSTRAINT TIPO_ATENDIMENTO_PK PRIMARY KEY (id_tipo_atendimento)
);

DROP TABLE horario CASCADE CONSTRAINTS ;
CREATE TABLE horario (
                id_horario NUMBER NOT NULL,
                dia_semana CHAR NOT NULL,
                hora_inicial CHAR NOT NULL,
                hora_final CHAR NOT NULL,
                turno CHAR NOT NULL,
                CONSTRAINT HORARIO_PK PRIMARY KEY (id_horario)
);


DROP TABLE paciente CASCADE CONSTRAINTS ;
CREATE TABLE paciente (
                num_sus VARCHAR2 NOT NULL,
                nome_paciente VARCHAR2 NOT NULL,
                data_nascimento_paciente DATE NOT NULL,
                endereco_paciente VARCHAR2 NOT NULL,
                cpf_paciente NUMBER NOT NULL,
                responsavel_paciente VARCHAR2 NOT NULL,
                sexo_paciente CHAR(1) NOT NULL,
                rg_paciente VARCHAR2(10) NOT NULL,
                cpf_responsavel NUMBER NOT NULL,
                email_paciente VARCHAR2 NOT NULL,
                telefone_paciente NUMBER(11) NOT NULL,
                CONSTRAINT PACIENTE_PK PRIMARY KEY (num_sus)
);


DROP SEQUENCE paciente_seq;
CREATE SEQUENCE paciente_seq START WITH 1 INCREMENT BY 1
MINVALUE 1 MAXVALUE 10000 NOCYCLE;


DROP TABLE vacina CASCADE CONSTRAINTS ;
CREATE TABLE vacina (
                id_vacina NUMBER NOT NULL,
                desc_vacina VARCHAR2 NOT NULL,
                tipo_vacina VARCHAR2 NOT NULL,
                nome_vacina VARCHAR2 NOT NULL,
                CONSTRAINT VACINA_PK PRIMARY KEY (id_vacina)
);

DROP TABLE funcionario CASCADE CONSTRAINTS ;
CREATE TABLE funcionario (
                registro_funcional NUMBER NOT NULL,
                email_funcionari VARCHAR2 NOT NULL,
                nome_funcionario VARCHAR2 NOT NULL,
                sexo_funcionario CHAR(1) NOT NULL,
                endereco_funcionario VARCHAR2 NOT NULL,
                nascimento_funcionario DATE NOT NULL,
                telefone_funcionario NUMBER(11) NOT NULL,
                id_unidade NUMBER NOT NULL,
                CONSTRAINT FUNCIONARIO_PK PRIMARY KEY (registro_funcional)
);

DROP TABLE unidade_saude CASCADE CONSTRAINTS ;
CREATE TABLE unidade_saude (
                id_unidade NUMBER NOT NULL,
                nome_unidade VARCHAR2 NOT NULL,
                endereco_unidade VARCHAR2 NOT NULL,
                qtd_leitos_uti NUMBER NOT NULL,
                telefone_unidade NUMBER(11) NOT NULL,
                regiao_unidade VARCHAR2 NOT NULL,
                qtd_leitos_emergencia NUMBER NOT NULL,
                respo_unidade NUMBER NOT NULL,
                distrito_unidade VARCHAR2 NOT NULL,
                registro_funcional_responsavel NUMBER NOT NULL,
                CONSTRAINT UNIDADE_SAUDE_PK PRIMARY KEY (id_unidade)
);


DROP TABLE cobertura CASCADE CONSTRAINTS ;
CREATE TABLE cobertura (
                id_unidade NUMBER NOT NULL,
                id_tipo_atendimento NUMBER NOT NULL,
                CONSTRAINT COBERTURA_PK PRIMARY KEY (id_unidade, id_tipo_atendimento)
);


DROP TABLE escala_trabalho CASCADE CONSTRAINTS ;
CREATE TABLE escala_trabalho (
                data_inicial DATE NOT NULL,
                registro_funcional NUMBER NOT NULL,
                id_horario NUMBER NOT NULL,
                data_final DATE NOT NULL,
                regime VARCHAR2 NOT NULL,
                CONSTRAINT ESCALA_TRABALHO_PK PRIMARY KEY (data_inicial, registro_funcional, id_horario)
);

DROP TABLE medico CASCADE CONSTRAINTS ;
CREATE TABLE medico (
                registro_funcional NUMBER NOT NULL,
                crm_medico NUMBER NOT NULL,
                especialidade_medico VARCHAR2 NOT NULL,
                CONSTRAINT MEDICO_PK PRIMARY KEY (registro_funcional)
);


DROP TABLE atendente CASCADE CONSTRAINTS ;
CREATE TABLE atendente (
                registro_funcional NUMBER NOT NULL,
                CONSTRAINT ATENDENTE_PK PRIMARY KEY (registro_funcional)
);


DROP TABLE atendimento CASCADE CONSTRAINTS ;
CREATE TABLE atendimento (
                id_atendimento NUMBER NOT NULL,
                situacao_atendimento VARCHAR2 NOT NULL,
                id_paciente NUMBER NOT NULL,
                registro_funcional NUMBER NOT NULL,
                data_hora_atendimento TIMESTAMP NOT NULL,
                num_sus VARCHAR2 NOT NULL,
                id_tipo_atendimento NUMBER NOT NULL,
                id_unidade NUMBER NOT NULL,
                CONSTRAINT ATENDIMENTO_PK PRIMARY KEY (id_atendimento)
);


DROP SEQUENCE atendimento_seq;
CREATE SEQUENCE atendimento_seq START WITH 220000 INCREMENT BY 1
MINVALUE 1 MAXVALUE 10000 NOCYCLE;


DROP TABLE vacinacao CASCADE CONSTRAINTS ;
CREATE TABLE vacinacao (
                id_atendimento NUMBER NOT NULL,
                id_vacina NUMBER NOT NULL,
                horario_vacinacao DATE NOT NULL,
                data_dose_anterior VARCHAR2 NOT NULL,
                dose_numero VARCHAR2 NOT NULL,
                CONSTRAINT VACINACAO_PK PRIMARY KEY (id_atendimento, id_vacina)
);

DROP TABLE internacao CASCADE CONSTRAINTS ;
CREATE TABLE internacao (
                id_atendimento NUMBER NOT NULL,
                num_autorizacao_internacao VARCHAR2 NOT NULL,
                motivo_atendimento VARCHAR2 NOT NULL,
                leito_internacao VARCHAR2 NOT NULL,
                quarto_internacao NUMBER NOT NULL,
                tipo_internacao VARCHAR2 NOT NULL,
                CONSTRAINT INTERNACAO_PK PRIMARY KEY (id_atendimento)
);

DROP TABLE consulta_medica CASCADE CONSTRAINTS ;
CREATE TABLE consulta_medica (
                id_atendimento NUMBER NOT NULL,
                observacoes_atendimento VARCHAR2 NOT NULL,
                prescricao VARCHAR2 NOT NULL,
                diagnostico VARCHAR2 NOT NULL,
                CONSTRAINT CONSULTA_MEDICA_PK PRIMARY KEY (id_atendimento)
);

DROP TABLE pronto_atendimento CASCADE CONSTRAINTS ;
CREATE TABLE pronto_atendimento (
                id_atendimento NUMBER NOT NULL,
                motivo_atendimento VARCHAR2 NOT NULL,
                diagnostico VARCHAR2 NOT NULL,
                procedimentos VARCHAR2 NOT NULL,
                CONSTRAINT PRONTO_ATENDIMENTO_PK PRIMARY KEY (id_atendimento)
);


ALTER TABLE cobertura ADD CONSTRAINT TIPO_ATENDIMENTO_COBERTURA_FK
FOREIGN KEY (id_tipo_atendimento)
REFERENCES tipo_atendimento (id_tipo_atendimento)
NOT DEFERRABLE;

ALTER TABLE atendimento ADD CONSTRAINT TIPO_ATENDIMENTO_ATENDIMENT750
FOREIGN KEY (id_tipo_atendimento)
REFERENCES tipo_atendimento (id_tipo_atendimento)
NOT DEFERRABLE;

ALTER TABLE escala_trabalho ADD CONSTRAINT HORARIO_ESCALA_TRABALHO_FK
FOREIGN KEY (id_horario)
REFERENCES horario (id_horario)
NOT DEFERRABLE;

ALTER TABLE atendimento ADD CONSTRAINT PACIENTE_ATENDIMENTO_FK
FOREIGN KEY (num_sus)
REFERENCES paciente (num_sus)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE vacinacao ADD CONSTRAINT VACINA_VACINACAO_FK
FOREIGN KEY (id_vacina)
REFERENCES vacina (id_vacina)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE atendente ADD CONSTRAINT FUNCIONARIO_ATENDENTE_FK
FOREIGN KEY (registro_funcional)
REFERENCES funcionario (registro_funcional)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE medico ADD CONSTRAINT FUNCIONARIO_MEDICO_FK
FOREIGN KEY (registro_funcional)
REFERENCES funcionario (registro_funcional)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE escala_trabalho ADD CONSTRAINT FUNCIONARIO_ESCALA_TRABALHO_FK
FOREIGN KEY (registro_funcional)
REFERENCES funcionario (registro_funcional)
NOT DEFERRABLE;

ALTER TABLE unidade_saude ADD CONSTRAINT FUNCIONARIO_UNIDADE_SAUDE_FK
FOREIGN KEY (registro_funcional_responsavel)
REFERENCES funcionario (registro_funcional)
NOT DEFERRABLE;

ALTER TABLE funcionario ADD CONSTRAINT UNIDADE_SAUDE_FUNCIONARIO_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_saude (id_unidade)
NOT DEFERRABLE;

ALTER TABLE cobertura ADD CONSTRAINT UNIDADE_SAUDE_COBERTURA_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_saude (id_unidade)
NOT DEFERRABLE;

ALTER TABLE atendimento ADD CONSTRAINT UNIDADE_SAUDE_ATENDIMENTO_FK
FOREIGN KEY (id_unidade)
REFERENCES unidade_saude (id_unidade)
NOT DEFERRABLE;

ALTER TABLE atendimento ADD CONSTRAINT MEDICO_ATENDIMENTO_FK
FOREIGN KEY (registro_funcional)
REFERENCES medico (registro_funcional)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE atendimento ADD CONSTRAINT ATENDENTE_ATENDIMENTO_FK
FOREIGN KEY (registro_funcional)
REFERENCES atendente (registro_funcional)
NOT DEFERRABLE;

ALTER TABLE pronto_atendimento ADD CONSTRAINT ATENDIMENTO_PRONTO_ATENDIME777
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE consulta_medica ADD CONSTRAINT ATENDIMENTO_CONSULTA_MEDICA_FK
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE internacao ADD CONSTRAINT ATENDIMENTO_INTERNACAO_FK1
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;

ALTER TABLE vacinacao ADD CONSTRAINT ATENDIMENTO_VACINACAO_FK
FOREIGN KEY (id_atendimento)
REFERENCES atendimento (id_atendimento)
ON DELETE CASCADE
NOT DEFERRABLE;