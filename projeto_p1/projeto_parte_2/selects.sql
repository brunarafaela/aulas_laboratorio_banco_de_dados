--PRIMEIRO SELECT

SELECT nome_paciente || ' tem ' || ROUND((current_date-data_nascimento_paciente)/365.25,0) || ' e reside em ' || endereco_paciente AS info
FROM paciente WHERE UPPER(nome_paciente) NOT LIKE '%K%' AND
    UPPER(nome_paciente) NOT LIKE '%W%' AND
    UPPER(nome_paciente) NOT LIKE '%Y%'AND
    sexo_paciente = 'F' AND
    ROUND((current_date - data_nascimento_paciente)/365.25,0) > 21;


--SEGUNDO SELECT 

SELECT u.nome_unidade, f.nome_funcionario, m.especialidade_medico, et.regime, h.hora_inicial, h.hora_final, h.dia_semana
FROM unidade_saude u
    JOIN funcionario f ON (u.id_unidade = f.id_unidade)
    JOIN medico m ON (f.registro_funcional = m.registro_funcional)
    JOIN escala_trabalho et ON (et.registro_funcional = m.registro_funcional)
    JOIN horario h ON (h.id_horario = et.id_horario)
    WHERE UPPER(m.especialidade_medico) LIKE '%ORTOPEDIA%' 
    AND et.data_inicial BETWEEN '05/10/2020' AND '11/10/2020' ORDER BY h.hora_inicial;



--TERCEIRO SELECT

SELECT u.nome_unidade, ta.tipo_atendimento, a.data_hora_atendimento, p.responsavel_paciente, p.sexo_paciente, p.telefone_paciente,
p.email_paciente FROM unidade_saude u
    JOIN atendimento a ON (u.id_unidade = a.id_unidade)
    JOIN paciente p ON (a.num_sus = p.num_sus)
    JOIN tipo_atendimento ta ON (a.id_tipo_atendimento = ta.id_tipo_atendimento)
    WHERE a.id_unidade = 50001;


--QUARTO SELECT

SELECT f.nome_funcionario, p.nome_paciente, i.motivo_atendimento, i.leito_internacao, a.data_hora_atendimento
FROM funcionario f
    JOIN medico m ON (f.registro_funcional = m.registro_funcional)
    JOIN internacao i ON (m.registro_funcional = i.registro_funcional)
    JOIN atendimento a ON (i.id_atendimento = a.id_atendimento)
    JOIN paciente p ON (a.num_sus = p.num_sus)
    WHERE i.quarto_internacao = 102
    AND a.data_hora_atendimento BETWEEN '01/JAN/2020' AND '30/DEZ/2020';


--QUINTO SELECT

SELECT u.tipo_unidade, u.distrito_unidade, a.data_hora_atendimento, pa.motivo_atendimento, COUNT(pa.id_atendimento) AS pronto_atendimentos
FROM unidade_saude u
    JOIN atendimento a ON (u.id_unidade = a.id_unidade)
    JOIN pronto_atendimento pa ON (a.id_atendimento = pa.id_atendimento)
    WHERE a.data_hora_atendimento BETWEEN '01/JAN/2015' AND CURRENT_DATE
    AND UPPER(u.distrito_unidade) LIKE '%IPIRANGA%'
GROUP BY u.tipo_unidade, u.distrito_unidade, a.data_hora_atendimento, pa.motivo_atendimento
ORDER BY pa.motivo_atendimento;


--SEXTO SELECT

SELECT f.nome_funcionario, COUNT(av.id_agendamento) AS agendamentos, EXTRACT(MONTH FROM av.data_hora_agendamento) AS qual_mes
FROM funcionario f
    JOIN atendente a ON (f.registro_funcional = a.registro_funcional)
    JOIN agendamento_vacinacao av ON (a.registro_funcional = av.registro_funcional)
    WHERE av.data_hora_agendamento >= CURRENT_TIMESTAMP - INTERVAL '6' MONTH
GROUP BY f.nome_funcionario, EXTRACT(MONTH FROM av.data_hora_agendamento);



--SÉTIMO SELECT
 
SELECT u.nome_unidade, u.tipo_unidade, COUNT(a.id_atendimento) AS atendimentos FROM unidade_saude u
    JOIN funcionario f ON (u.id_unidade = f.id_unidade)
    JOIN medico m ON (f.registro_funcional = m.registro_funcional)
    JOIN consulta_medica cm ON (m.registro_funcional = cm.registro_funcional)
    JOIN atendimento a ON (cm.id_atendimento = a.id_atendimento)
    JOIN paciente p ON (a.num_sus = p.num_sus)
    WHERE ROUND((current_date - p.data_nascimento_paciente)/365.25,0) >= 65
        AND UPPER(cm.motivo_consulta) LIKE '%DEPRESSÃO%'
        AND a.data_hora_atendimento >= CURRENT_DATE - INTERVAL '3' MONTH
        AND ROWNUM <= 10
    GROUP BY u.nome_unidade, u.tipo_unidade;


 
--OITAVO SELECT
 
SELECT a.id_atendimento, p.nome_paciente, ROUND((current_date - p.data_nascimento_paciente)/365.25,0), p.sexo_paciente
FROM paciente p
    JOIN atendimento a ON (p.num_sus = a.num_sus)
    JOIN consulta_medica cm ON (a.id_atendimento = cm.id_atendimento)
    WHERE a.num_sus NOT IN (SELECT p.num_sus FROM paciente
                                    JOIN atendimento a ON (p.num_sus = a.num_sus)
                                    JOIN vacinacao v ON (a.id_atendimento = v.id_atendimento));



--DÉCIMO SELECT 

--LEFT JOIN
SELECT f.nome_funcionario, f.cargo_funcionario, f.data_adminissao_funcionario AS "Data_de_admissão", current_timestamp - f.data_adminissao_funcionario AS "Tempo_de_Trabalho"
from funcionario f INNER JOIN atendente at
ON (f.registro_funcional = at.registro_funcional) --funcionario é um atendente
INNER JOIN atendimento a 
ON (at.registro_funcional = a.registro_funcional) --enfermeiros que realizaram atendimento
LEFT JOIN vacinacao v
ON (a.id_atendimento = v.id_atendimento) --atendimentos que nao foram vacinacao
WHERE v.id_atendimento IS NULL
AND UPPER(f.cargo_funcionario) LIKE '%ENFERM%';


--MINUS
SELECT f.nome_funcionario, f.cargo_funcionario, f.data_adminissao_funcionario AS "Data_de_admissão", current_timestamp - f.data_adminissao_funcionario AS "Tempo_de_Trabalho"
FROM funcionario f, atendente at, atendimento a
 WHERE (f.registro_funcional = at.registro_funcional) --funcionário é um atendente
 AND (at.registro_funcional = a.registro_funcional) --enfermeiros que realizaram atendimento
AND a.id_atendimento IN
                    (SELECT a.id_atendimento FROM atendimento a --todos os atendimentos
                MINUS 
                    SELECT v.id_atendimento from vacinacao v)--menos atendimentos que nao foram vacinacao
AND UPPER(f.cargo_funcionario) LIKE '%ENFERM%';


--NOT IN
SELECT f.nome_funcionario, f.cargo_funcionario, f.data_adminissao_funcionario AS "Data_de_admissão", current_timestamp - f.data_adminissao_funcionario AS "Tempo_de_Trabalho"
FROM funcionario f, atendente at, atendimento a
     WHERE (f.registro_funcional = at.registro_funcional) --funcionário é um atendente
    AND (at.registro_funcional = a.registro_funcional) --enfermeiros que realizaram atendimento
AND a.id_atendimento NOT IN
                        (SELECT v.id_atendimento FROM vacinacao v) --atendimentos que nao estao em vacinacao
AND UPPER(f.cargo_funcionario) LIKE '%ENFERM%';


--DÉCIMO PRIMEIRO SELECT

SELECT  p.nome_paciente, p.num_sus, cv.doses_restantes, u.nome_unidade, u.regiao_unidade, u.distrito_unidade, a.data_hora_atendimento AS ultima_dose
FROM paciente p
    JOIN atendimento a ON (p.num_sus = a.num_sus)
    JOIN vacinacao va ON (a.id_atendimento = va.id_atendimento)
    JOIN carteira_vacinacao cv ON (va.id_atendimento = cv.id_atendimento)
    JOIN unidade_saude u ON (a.id_unidade = u.id_unidade)
    WHERE cv.doses_restantes > 0;