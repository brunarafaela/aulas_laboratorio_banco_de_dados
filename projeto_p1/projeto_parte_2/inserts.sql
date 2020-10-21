-- Tabela Horário 

INSERT INTO horario VALUES(1, 'Seg/Qua/Sex', 'Sete AM', 'Dezessete PM', 'Diurno');
INSERT INTO horario VALUES(2, 'Ter/Qui/Sab', 'Dezessete PM', 'Meia Noite', 'Noturno');


-- Tabela Paciente

INSERT INTO paciente VALUES(paciente_seq.nextval, 'Alberto das Neves', '15/10/1987', 'Rua das dores, 763', 9248275907, 'Maria das Neves', 'M', '156135371', 456789643120, 'alberto.neves@gmail.com', 11965547841, 'a1b2c4');
INSERT INTO paciente VALUES(paciente_seq.nextval, 'Catarina Souza', '22/05/2000', 'Av Ipiranga, 4450', 6532178403, 'Roberta Souza', 'F', '505993077', 68049739090, 'catsouza4@gmail.com', 11574774621, 'catt12');
INSERT INTO paciente VALUES(paciente_seq.nextval, 'Rafael Sistino Alves', '29/02/1992', 'Av do Cursino, 1947, apto 22', 8856478662, 'Rafael Sistino Alves', 'M', '4648756443', 13345789314, 'rafa.salves@gmail.com', 11478511423, 'r@flve');
INSERT INTO paciente VALUES(paciente_seq.nextval, 'Sandra Rosa Madalena', '10/05/1989', 'Rua São João Del Rei, 12', 4455668877, 'Sidney Magal', 'F', '445588214', 46874421012, 'srmdalena.oi@hotmail.com', 1188547233, '4456sim');
INSERT INTO paciente VALUES(paciente_seq.nextval, 'Neymar Júnior', '05/02/1992', 'Santos Boulevard, 10', 6547897463, 'Neymar Pai', 'M', '156144872', 22134688796, 'neymar@junior.com', 1194472241, 'nj2wwd');
INSERT INTO paciente VALUES(paciente_seq.nextval, 'Vitor', '26/01/1985', 'Rua Francisca Borges', 44887755661, 'Voninha', 'M', '6695551234', 42980165617, 'vitor.teodosio@fatec.sp.gov.br', 11963188329, 'xxdxp23');
INSERT INTO paciente VALUES(paciente_seq.nextval, 'Kelly Aguilera', '03/10/1997', 'Av dos Trabalhadores', 9228473973, 'Cristina Aguilera', 'F', '156144451', 422449643120, 'kelly0310@gmail.com', 11989164269, 'agunh2');


-- Tabela Vacina 

INSERT INTO vacina VALUES(1, 'Vacina COVID-19', 'Vacina de prescrição', 'Covid19', '3214412xx233354', '20/10/2021' , 'Reações não conhecidas', 'Covid 19', 10);
INSERT INTO vacina VALUES(2, 'Vacina COVID-19', 'Vacina de prescrição', 'Covid19', '3214412xx232254', '20/10/2021', 'Reações não conhecidas', 'Covid 19', 15);
INSERT INTO vacina VALUES(3, 'Vacina Benzetacil', 'Vacina de prescrição', 'Benzetacil', '3aaad22233354', '20/10/2021', 'Dormencia na área de aplicação, dor muscular na área de aplicação', 'Virose, gripe', 1000);
INSERT INTO vacina VALUES(4, 'Vacina Tétano', 'Vacina de prevenção', 'Tétano', '447785451zxc546', '20/10/2021', 'Reações não conhecidas', 'Tétano', 1233);


-- Tabela Unidade de Saúde 

INSERT INTO unidade_saude VALUES(50001, 'UPA Sul', 'Rua das Upas 212', 20, 23445511, 'Zona Sul', 1, 1114, 'Ipiranga', 'UPA');
INSERT INTO unidade_saude VALUES(50002, 'UBS Sul', 'Rua das UBSs, 2', 25, 23445522, 'Zona Sul', 2, 1115, 'Ipiranga',  'UBS');
INSERT INTO unidade_saude VALUES(50003, 'AMA', 'Av das AMAs, 2222', 10, 23445533, 'Zona Sul', 0, 1116, 'Ipiranga',  'AMA');

-- Tabela Funcionário

INSERT INTO funcionario VALUES (11233, 'ari.medico@empresa.com', 'Ari Ferreira', 'M', 'Av dos Medicos, 664', '05/05/1995', 1198775454, 50001, 'Medico Temporario', '01/02/2017', '31/12/2020', 'EFETIVO');

INSERT INTO funcionario VALUES (11234, 'samira.medico@empresa.com', 'Samira Cristina', 'F', 'Av dos Medicos, 445', '12/11/1988', 1197754412, 50001, 'Medica Efetiva', '01/05/2010', '01/01/2100', 'TEMPORARIO');
INSERT INTO funcionario VALUES (11235, 'roberta.medica@empresa.com', 'Roberta Dualib', 'F', 'Av dos Medicos, 1115', '27/03/1990', 1194454422, 50001, 'Médica Residente', '20/01/2017', '31/12/2020', 'TERCEIRO');
INSERT INTO funcionario VALUES (11236, 'carlos.adm@empresa.com', 'Carlos Augusto', 'M', 'Av dos Financeiros, 44777', '15/02/1971', 119777772, 50001, 'Atendente', '30/09/2005', '01/01/2100', 'EFETIVO');

-- Tabela Cobertura-n
INSERT INTO cobertura VALUES(50001, )


-- Tabela Escala de Trabalho-n

INSERT INTO escala_trabalho VALUES('05/10/2020', 11233, 1, '11/10/2020', 'Full Time');
INSERT INTO escala_trabalho VALUES('01/01/2020', 11234, 1, '31/12/2020', 'Full Time');
INSERT INTO escala_trabalho VALUES('01/01/2020', 11235, 2, '31/12/2020', 'Full Time');


--Tabela Médico

INSERT INTO medico VALUES (11233, 114577894, 'Ortopedia');
INSERT INTO medico VALUES (11234, 456472144, 'Clinica Geral');
INSERT INTO medico VALUES (11235, 878974321, 'Clinica Geral');

-- Tabela Atendente

INSERT INTO atendente VALUES(11236);

-- Tabela Tipo Atendimento

INSERT INTO tipo_atendimento VALUES (00000001, 'Consulta', 'Nenhum recurso necessário');
INSERT INTO tipo_atendimento VALUES (00000002, 'Consulta com Vacinação', 'Vacinas');
INSERT INTO tipo_atendimento VALUES (00000003, 'Consulta com Internação', 'Leitos disponíveis');
INSERT INTO tipo_atendimento VALUES (00000004, 'Internação regular', 'Leitos disponíveis');
INSERT INTO tipo_atendimento VALUES (00000005, 'Internação UTI', 'Leitos UTI disponíveis');

-- Tabela Atendimento--n

INSERT INTO atendimento VALUES (1210001,  'em espera',  11236,  current_timestamp,  1, 3, 50001);
INSERT INTO atendimento VALUES (1210002, 'em andamento', 11236,  current_timestamp,  2,  2, 50001);
INSERT INTO atendimento VALUES (1210004,  'em espera', 11236,  current_timestamp,  4,  4, 50001);

--Tabela Agendamento Vacinação

INSERT INTO agendamento_vacinacao VALUES(21312301, 1, '02/11/2020', 'agendado', current_timestamp, 'ATDMVC1', 11236);

--Tabela Campanha Vacinação 

INSERT INTO campanha_vacinacao VALUES (00019, 1, 'Campanha Covid', 'Dozes adicionais de 3 em 3 meses', 'Assintomaticos', '15/12/2020', '31/12/2021', 'CPF e Carteira de Vacinação', 001);
INSERT INTO campanha_vacinacao VALUES (00019, 1, 'Campanha Covid', 'Dozes adicionais de 3 em 3 meses', 'Assintomaticos', '15/12/2020', '31/12/2021', 'CPF e Carteira de Vacinação', 001);


-- Tabela Vacinação 

INSERT INTO vacinacao VALUES (1210002, 1, '1a dose', 11234, 00019, 21312301);

--Tabela Consulta Médica 

INSERT INTO consulta_medica VALUES(1210002, 'paciente ok', 'nada prescrito', 'nenhum sintoma aparente', 11234);

--Tabela Carteira Vacinação

INSERT INTO carteira_vacinacao VALUES (1, 1, 1, 1210002, '05/10/2021', 3);

--Tabela Pronto Atendimento 

INSERT INTO pronto_atendimento VALUES(1210004, 'Consulta emergencial', 'Mal estar temporário, não relacionado objetivamente', 'Temperatura, pressão', 11234);

-- Tabela Internação 

INSERT INTO internacao VALUES(1210004, '46412291', 'internação preventiva', 'leito 00978', 10000001, 'observação', 11234);

INSERT INTO internacao VALUES(1210003, '49822201', 'internação urgente', 'leito 01088', 10000002, 'UTI', 11234);
