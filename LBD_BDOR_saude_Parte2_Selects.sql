-- população de pessoa
INSERT INTO or_pessoa VALUES ( pessoa_seq.nextval , 'Givanildo Santos', 
tipoendereco ( 'Rua', 'Vergueiro', 7000, null, 'Ipiranga', 'Sao Paulo', 'SP', 'giva@gmail.com', 
                        tipofone (11987654321, 11998877665, 11991234567 )  ) ,         
'M', current_date - INTERVAL '20' YEAR, 998877, 'PACIENTE' ) ; 
INSERT INTO or_pessoa VALUES (  pessoa_seq.nextval , 'Madalena Trindade', 
tipoendereco ( 'Rua', 'Santa Cruz', 700, 'ap 33', 'Ipiranga', 'Sao Paulo', 'SP', 'mtrindade@gmail.com', 
                        tipofone (11987659876, 11998871212, 11991236151 )  ) ,         
'F', current_date - INTERVAL '40' YEAR, 123456, 'FUNCIONARIO' ) ; 
INSERT INTO or_pessoa VALUES (  pessoa_seq.nextval , 'Vitorino Alencar', 
tipoendereco ( 'Rua', 'Labatut', 122, 'ap 11', 'Ipiranga', 'Sao Paulo', 'SP', 'alencarv@gmail.com', 
                        tipofone (11965432876, 11995487112 )  ) ,         
'M', current_date - INTERVAL '30' YEAR, 728394, 'FUNCIONARIO' ) ; 
-- novos
INSERT INTO or_pessoa VALUES ( pessoa_seq.nextval , 'Emilia Clemente', 
tipoendereco ( 'Rua', 'Agata', 200, null, 'Aclimacao', 'Sao Paulo', 'SP', 'emilia@gmail.com', 
                        tipofone (11987654876, 11998877231, 11991234872 )  ) ,         
'M', current_date - INTERVAL '10' YEAR, 993214, 'PACIENTE' ) ; 
UPDATE or_pessoa SET sexo_pessoa = 'F' WHERE id_pessoa = 20004 ;
INSERT INTO or_pessoa VALUES ( pessoa_seq.nextval , 'Osmar Prado Junior', 
tipoendereco ( 'Rua', 'Consolacao', 100, 'ap 311', 'Centro', 'Sao Paulo', 'SP', 'pradojr@gmail.com', 
                        tipofone (11954354321, 11998874422, 11991234123 )  ) ,         
'M', current_date - INTERVAL '40' YEAR, 531872, 'PACIENTE' ) ; 
INSERT INTO or_pessoa VALUES (  pessoa_seq.nextval , 'Beatriz Ferreira Lopes', 
tipoendereco ( 'Rua', 'do Grito', 701, 'ap 36', 'Ipiranga', 'Sao Paulo', 'SP', 'bialopes@gmail.com', 
                        tipofone (11980039876, 11998456712 )  ) ,         
'F', current_date - INTERVAL '28' YEAR, 882211, 'FUNCIONARIO' ) ; 
INSERT INTO or_pessoa VALUES (  pessoa_seq.nextval , 'Magda Santaella', 
tipoendereco ( 'Rua', 'Agostinho Gomes', 501, 'ap 75', 'Ipiranga', 'Sao Paulo', 'SP', 'magdasanta@gmail.com', 
                        tipofone (11980003014, 11998499218 )  ) ,         
'F', current_date - INTERVAL '38' YEAR, 562189, 'FUNCIONARIO' ) ; 

SELECT * FROM or_pessoa ;

-- paciente
DESC or_paciente ;
SELECT * FROM or_pessoa ;
INSERT INTO or_paciente (num_sus, id_pessoa) VALUES ( 987654321, 20000) ;
INSERT INTO or_paciente (num_sus, id_pessoa) VALUES ( 987123654, 20004) ;
INSERT INTO or_paciente (num_sus, id_pessoa) VALUES ( 765123098, 20005) ;
--  populando funcionario
DELETE FROM or_funcionario ;
INSERT INTO or_funcionario (reg_funcional, cargo, dt_admissao, tipo_contrato, id_pessoa)
VALUES ( 300, 'MEDICO', current_date - 2000, 'EFETIVO', 20001 ) ;
INSERT INTO or_funcionario (reg_funcional, cargo, dt_admissao, tipo_contrato, id_pessoa)
VALUES ( 310, 'ATENDENTE', current_date - 100, 'TEMPORARIO', 20002) ;
INSERT INTO or_funcionario (reg_funcional, cargo, dt_admissao, tipo_contrato, id_pessoa)
VALUES ( 320, 'ENFERMEIRO', current_date - 38, 'TEMPORARIO', 20006)  ;
INSERT INTO or_funcionario (reg_funcional, cargo, dt_admissao, tipo_contrato, id_pessoa)
VALUES ( 330, 'AUXILIAR ENFERMAGEM', current_date - 338, 'EFETIVO', 20007)  ;
SELECT * FROM or_funcionario ;
-- populando unidade de saude
INSERT INTO or_unidade_saude VALUES ( 'AMA UBS Integrada Sao Vicente de Paula', 
tipoendereco( 'Rua', ' Vicente da Costa',  289 , null, 'Ipiranga', 'São Paulo','SP', 'svicente@sp.gov.br', tipofone(1120637354) ),
 'SUL', 'IPIRANGA', 'UBS', 0, 10, null) ;
INSERT INTO or_unidade_saude VALUES ( 'Hospital do Servidor Publico Municipal', 
tipoendereco('Rua','Castro Alves', 60, null, 'Liberdade', 'São Paulo', 'SP', 'hospservidor@sp.gov.br', tipofone(133977700) ), 
'CENTRO', 'LIBERDADE', 'HOSPITAL', 30, 80, null) ;
-- atualizando funcionario com a unidade
UPDATE or_funcionario SET unid_saude = 
           ( SELECT REF (us) FROM or_unidade_saude us WHERE UPPER(nome_unidade) LIKE '%SAO VICENTE%' ) ;
-- atualizando paciente com atendimento
UPDATE or_paciente p SET p.atendimentos  =
   tab_atende ( tipoatendimento ( seq_atende.nextval , current_timestamp - 15 , 'vacinacao', null, 'VACINACAO', 
   'vacina gripe', 'CONCLUIDO', ( SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 310 ), null,
   ( SELECT REF (us) FROM or_unidade_saude us WHERE UPPER(nome_unidade) LIKE '%SAO VICENTE%' ) ) ,
   tipoatendimento ( seq_atende.nextval , current_timestamp - 1 , 'vacinacao', null, 'VACINACAO', 
   'vacina gripe', 'CONCLUIDO', ( SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 310 ), null,
   ( SELECT REF (us) FROM or_unidade_saude us WHERE UPPER(nome_unidade) LIKE '%SAO VICENTE%' ) ) ) ; 
 
 UPDATE or_paciente p SET p.atendimentos  =
   tab_atende ( tipoatendimento ( 2022 , current_timestamp - 12 , 'vacinacao', null, 'VACINACAO', 
   'vacina febre amarela', 'CONCLUIDO', ( SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 320 ), null,
   ( SELECT REF (us) FROM or_unidade_saude us WHERE UPPER(nome_unidade) LIKE '%SAO VICENTE%' ) ) ,
   tipoatendimento ( 2023, current_timestamp , 'vacinacao', null, 'VACINACAO', 
   'vacina febre amarela', 'CONCLUIDO', ( SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 320 ), null,
   ( SELECT REF (us) FROM or_unidade_saude us WHERE UPPER(nome_unidade) LIKE '%SAO VICENTE%' ) ) ) 
  WHERE p.id_pessoa = 20004 ;
-- consulta
 UPDATE or_paciente p SET p.atendimentos  =
   tab_atende ( tipoatendimento ( 2023 , current_timestamp - 3 , 'Check-up', null, 'CONSULTA', 
   'dores no corpo', 'CONCLUIDO', ( SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 320 ), 
   ( SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 300 ),
   ( SELECT REF (us) FROM or_unidade_saude us WHERE UPPER(nome_unidade) LIKE '%SERVIDOR%' ) ) )
  WHERE p.id_pessoa = 20005 ;   
-- conferindo  
SELECT p.* , at.*
FROM or_paciente p, TABLE (p.atendimentos) at ; 

UPDATE TABLE ( SELECT p.atendimentos FROM or_paciente p WHERE p.num_sus = 987654321 ) at
SET at.num_atendimento = 2021 
WHERE TO_CHAR(at.data_hora_atendimento, 'DD/MM/YYYY') = TO_CHAR(current_timestamp- 1 , 'DD/MM/YYYY') ;

UPDATE TABLE ( SELECT p.atendimentos FROM or_paciente p WHERE p.num_sus = 765123098) at
SET at.num_atendimento = 2024 ; 
-- atualizando a carteira de vacinacao
UPDATE or_paciente p SET p.carteira_vacinacao  =
    tab_vacinacoes ( 
            tipocarteira_vacina ( 2020, ( SELECT REF(v) FROM or_vacina v WHERE UPPER( v.nome_vacina ) LIKE '%GRIPE%' ), 1) ,
            tipocarteira_vacina ( 2021, ( SELECT REF(v) FROM or_vacina v WHERE UPPER( v.nome_vacina ) LIKE '%GRIPE%' ), 2) ) 
WHERE p.num_sus = 987654321 ;  
UPDATE or_paciente p SET p.carteira_vacinacao  =
    tab_vacinacoes ( 
            tipocarteira_vacina ( 2022, ( SELECT REF(v) FROM or_vacina v WHERE UPPER( v.nome_vacina ) LIKE '%AMARELA%' ), 1) ,
            tipocarteira_vacina ( 2023, ( SELECT REF(v) FROM or_vacina v WHERE UPPER( v.nome_vacina ) LIKE '%AMARELA%' ), 2) ) 
WHERE p.num_sus = 987123654 ;  

-- populando vacina
INSERT INTO or_vacina VALUES ( 'Gripe Influenza', 'Por injeção via intramuscular na parte superior do braço - músculo deltóide',
1, 'todo ano', 'Proteção contra o virus influenza', 500, 1500,
tab_lote_vacina ( tipolote_vacina ( '101AH19', current_date - 500, 10000, current_date + 100 , 'Instituto Butantan') ,
                             tipolote_vacina ( '307FF20', current_date - 150, 15000, current_date + 300, 'FIOCRUZ') )  ) ;
INSERT INTO or_vacina VALUES ( 'Febre Amarela', 'Por injeção via intramuscular na parte superior do braço - músculo deltóide',
2, 'a cada 10 anos', 'Proteção contra a febre amarela', 800, 2500,
tab_lote_vacina ( tipolote_vacina ( '203FE451', current_date - 300, 11000, current_date + 180 , 'Instituto Butantan') ,
                             tipolote_vacina ( 'AF201543', current_date - 50, 15050, current_date + 400, 'FIOCRUZ') )  ) ;                             
                             
                             
/****************************************************
9 - Com a instrução SELECT responda às seguintes consultas para o BD Objeto-Relacional desenvolvido em 7 e 8 acima:
i)	Mostre o nome, logradouro, bairro e cidade, e número dos telefones para os pacientes com menos de 60 anos
cujo final de telefone seja número par;  ***/
DESC or_pessoa ;

SELECT p.nome_pessoa, p.end_pessoa.logradouro, p.end_pessoa.bairro, p.end_pessoa.cidade, fn.*
FROM or_pessoa p, TABLE(p.end_pessoa.fones) fn
WHERE p.tipo_pessoa = 'PACIENTE'
AND ROUND((current_date -p.dt_nascto_pessoa)/365.25,1) <= 60
AND MOD(fn.column_value, 2) = 0  ;

/****
ii)	Refaça a consulta 6-iii  Mostre a lista dos atendimentos diários de uma determinada Unidade de Saúde : 
Tipo Atendimento - Número - Data Hora Agendada - Paciente - Responsavel Paciente - Sexo- Fone - Email-Agendado por **/
DESC or_paciente ;
DESC tipoatendimento ;

SELECT at.tipo_atendimento, at.num_atendimento, at.data_hora_atendimento, p.nome_pessoa, pac.nome_responsavel, p.sexo_pessoa, fn.*,
p.end_pessoa.email, p2.nome_pessoa
FROM or_pessoa p, or_paciente pac,TABLE(pac.atendimentos) at, TABLE (p.end_pessoa.fones) fn, or_pessoa p2
WHERE p.id_pessoa = pac.id_pessoa
AND at.atendente.id_pessoa = p2.id_pessoa
AND TO_CHAR(at.data_hora_atendimento, 'DD/MM/YYYY') <= TO_CHAR(current_date - 1, 'DD/MM/YYYY' ) ;

/****
iii)	Mostre todos os dados da carteira de vacinação de pacientes que tomaram a vacina contra febre amarela nos últimos dois anos :
nome do paciente-nome do responsável-data vacinação-numero do atendimento-
nome da unidade de saúde-região e distrito-fones da unidade;  ***/
SELECT * FROM or_paciente ;
UPDATE or_paciente SET nome_responsavel = 'Ruan Carlos Clemente' WHERE id_pessoa = 20004 ;
DESC or_paciente ;
DESC tipoatendimento ;
DESC tipocarteira_vacina ;
DESC tipounid_saude ;

SELECT p.nome_pessoa, pac.nome_responsavel, cv.atendimento, at.data_hora_atendimento,
at.unid_saude.nome_unidade, at.unid_saude.regiao, at.unid_saude.distrito, fnu.*
FROM or_pessoa p, or_paciente pac, TABLE(pac.carteira_vacinacao) cv, TABLE(pac.atendimentos) at,
TABLE (at.unid_saude.end_unidade.fones) fnu
WHERE p.id_pessoa = pac.id_pessoa
AND cv.atendimento = at.num_atendimento 
AND UPPER(cv.vacina_aplicada.nome_vacina) LIKE '%AMARELA%'
AND at.data_hora_atendimento >= current_date - INTERVAL '2' YEAR ;

/****
iv)	Mostre os dados de atendimento de Internação motivados por -hipertensão- (pressão alta)
em pacientes do sexo feminino com menos de 35 anos : numero do atendimento-data e hora- nome da unidade de saúde-
tipo da unidade- medico responsável-diagnóstico-observações  ***/
SELECT at.tipo_atendimento, at.num_atendimento, at.data_hora_atendimento, 
at.unid_saude.nome_unidade, at.unid_saude.tipo_unidade, pmed.nome_pessoa AS Medico_Responsavel,
at.diagnostico, at.observacoes
FROM or_pessoa p, or_paciente pac,TABLE(pac.atendimentos) at, or_pessoa pmed, or_funcionario f
WHERE p.id_pessoa = pac.id_pessoa  -- pessoa x paciente
AND p.sexo_pessoa = 'F'
AND ROUND((current_date -p.dt_nascto_pessoa)/365.25,1) <= 35
AND f.reg_funcional = at.medico.reg_funcional -- funcionario x medico responsavel
AND f.id_pessoa = pmed.id_pessoa   -- pessoa x funcionario
AND UPPER(at.motivo) LIKE '%HIPERTENS%' ;

SELECT at.tipo_atendimento, at.motivo , f.reg_funcional, at.medico.reg_funcional 
FROM or_paciente pac , TABLE (pac.atendimentos) at , or_funcionario f
WHERE f.reg_funcional = at.medico.reg_funcional ; -- consulta
 
/****
v)	Refaça a consulta 6-viii. 
Mostre os pacientes que realizam consultas mas não tomam vacina : Nome Paciente-Idade-Sexo  ***/
DESC tipoatendimento ;
SELECT DISTINCT pac.id_pessoa, ROUND((current_date -p.dt_nascto_pessoa)/365.25,1) AS Idade, p.sexo_pessoa 
                    FROM or_paciente pac, TABLE (pac.atendimentos) at, or_pessoa p
                     WHERE p.id_pessoa = pac.id_pessoa
                     AND at.tipo_atendimento = 'CONSULTA'
AND pac.id_pessoa NOT IN  ( SELECT DISTINCT pac.id_pessoa AS Vacina
                                                       FROM or_paciente pac, TABLE (pac.atendimentos) at
                                                        WHERE at.tipo_atendimento = 'VACINACAO' ) ;
/****
vi)	Refaça a consulta 6-x.	Mostre os funcionários da área de enfermagem ( Enfermeiro, Auxiliar de Enfermagem, etc.) 
que nunca aplicaram vacina : Nome Funcionário-Cargo-Data Admissão-
Tempo de Trabalho ( quantidade em anos que trabalha na Unidade de saúde). 
Resolva de três forma diferentes sendo uma com junção externa   ***/
ALTER TYPE tipocarteira_vacina ADD ATTRIBUTE aplicado_por REF tipofuncionario CASCADE ;
UPDATE TABLE ( SELECT p.carteira_vacinacao FROM or_paciente p WHERE p.num_sus = 987654321) cv
SET cv.aplicado_por = (SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 330 ) ; 
UPDATE TABLE ( SELECT p.carteira_vacinacao FROM or_paciente p WHERE p.num_sus = 987123654) cv
SET cv.aplicado_por = (SELECT REF(f) FROM or_funcionario f WHERE f.reg_funcional = 330 ) ; 

-- juncao externa
SELECT p.nome_pessoa, f.cargo, f.dt_admissao, 
ROUND((current_date -f.dt_admissao)/365.25,1) AS Tempo_Trabalho_Anos, f.id_pessoa AS Enfermagem , aplicou.aplicador
FROM or_pessoa p JOIN or_funcionario f
ON ( p.id_pessoa = f.id_pessoa)
LEFT JOIN  (  SELECT f.reg_funcional AS aplicador
                                   FROM or_paciente pac , TABLE (pac.carteira_vacinacao) cv , or_funcionario f
                                  WHERE f.reg_funcional = cv.aplicado_por.reg_funcional ) aplicou
ON f.reg_funcional = aplicou.aplicador
WHERE UPPER(f.cargo) LIKE '%ENFERM%'
AND aplicou.aplicador IS NULL ;

-- NOT IN 
SELECT p.nome_pessoa, f.cargo, f.dt_admissao, 
ROUND((current_date -f.dt_admissao)/365.25,1) AS Tempo_Trabalho_Anos
FROM or_pessoa p JOIN or_funcionario f
ON ( p.id_pessoa = f.id_pessoa)
WHERE UPPER(f.cargo) LIKE '%ENFERM%'
AND f.id_pessoa NOT IN 
                                 (  SELECT f.id_pessoa
                                   FROM or_paciente pac , TABLE (pac.carteira_vacinacao) cv , or_funcionario f
                                  WHERE f.reg_funcional = cv.aplicado_por.reg_funcional )  ; 

-- MINUS
SELECT p.nome_pessoa, f.cargo, f.dt_admissao, 
ROUND((current_date -f.dt_admissao)/365.25,1) AS Tempo_Trabalho_Anos
FROM or_pessoa p JOIN or_funcionario f
ON ( p.id_pessoa = f.id_pessoa)
WHERE f.id_pessoa IN 
             ( SELECT p.id_pessoa
              FROM or_pessoa p JOIN or_funcionario f
              ON ( p.id_pessoa = f.id_pessoa)
              WHERE UPPER(f.cargo) LIKE '%ENFERM%'
                   MINUS ( 
                                   SELECT f.id_pessoa
                                   FROM or_paciente pac , TABLE (pac.carteira_vacinacao) cv , or_funcionario f
                                  WHERE f.reg_funcional = cv.aplicado_por.reg_funcional ) ) ; 

/****
vii)	Refaça a consulta 6-vii..	Mostre um ranking das 10 unidades de saúde que mais atenderam 
pacientes da -melhor idade- nos últimos 120 dias por motivo de -depressão- : 
Nome Unidade - Tipo Unidade- Quantidade, independente do tipo de atendimento  ***/                         
SELECT at.unid_saude.nome_unidade AS Unidade, at.unid_saude.tipo_unidade AS Tipo , COUNT(*) AS Quantidade_atendimentos
FROM or_pessoa p, or_paciente pac, TABLE(pac.atendimentos) at
WHERE p.id_pessoa = pac.id_pessoa  -- pessoa x paciente
AND ROUND((current_date -p.dt_nascto_pessoa)/365.25,1) >= 65
AND UPPER(at.motivo) NOT LIKE '%DEPRES%' 
AND at.data_hora_atendimento >= current_date - 120 
GROUP BY at.unid_saude.nome_unidade, at.unid_saude.tipo_unidade ;