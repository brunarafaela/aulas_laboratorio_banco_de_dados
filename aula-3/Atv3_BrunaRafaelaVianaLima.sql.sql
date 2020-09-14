/********************************
			ATIVIDADE 3

Atividade 03: Com a instrução SELECT responda às seguintes consultas :
1– Mostrar os dados dos cursos no formato : ‘Fundamentos de Redes tem carga horária de 120 horas’**/
SELECT nome_curso|| ' tem carga horária de ' ||carga_hora_curso || ' horas ' AS "Dados do curso"
FROM curso;

/**
2- Mostrar o nome e carga horária das certificações que tem ‘PROFESSIONAL’ ou ‘INSTRUCTOR’ no nome e tem nota de corte superior
a 85**/

SELECT nome_cert, carga_hora_cert AS "Dados certificações"
FROM CERTIFICACAO
WHERE UPPER(nome_cert) LIKE '%PROFESSIONAL%' OR UPPER(nome_cert) LIKE '%INSTRUCTOR%'
AND nota_corte >= 85;


/** 3– Mostrar os dados das alunas que NÃO são tem as letras k,w e y no login e que tem mais de 22 anos : Nome Aluna-Idade-login **/

SELECT nome_aluno AS "Nome Aluna", login As "Login", DT_NASCTO_ALUNO AS "Idade"
from aluno
WHERE UPPER(login) NOT LIKE '%K%' AND UPPER(login)  NOT LIKE '%W%' AND  UPPER(login) NOT LIKE '%Y%'
AND  dt_nascto_aluno + INTERVAL '22' YEAR <= current_date; 


/**4- Mostrar os dados das turmas que tem entre 30 e 40 vagas e valor entre R$ 450 e R$ 550 que ainda não começaram :
Número da Turma – Data Início – Valor – Quantidade de vagas**/

SELECT NUM_TURMA AS "Número da turma", DT_INICIO AS "Dara Início", VL_CURSO AS "Valor"
FROM TURMA
WHERE VAGAS >=30 AND VAGAS <=40
AND VL_CURSO >=450 AND VL_CURSO <=550
AND DT_INICIO > current_date;

/** 5- Repetir a consulta 4 acima, usando a sintaxe do INNER JOIN e adicionando os
 seguintes critérios : para cursos com carga horária inferiores a 200 horas, no formato 
 : Nome do Curso- Carga Horária- Número da Turma – Data Início – Valor – Quantidade de vagas **/

SELECT  c.nome_curso AS "Nome do curso", c.carga_hora_curso AS "Carga horária", t.NUM_TURMA AS "Número da turma", t.DT_INICIO AS "Data início", t.VL_CURSO AS "Valor", t.VAGAS AS "Quantidade de vagas"
FROM turma t  INNER JOIN curso c
	ON (t.id_curso = c.id_curso)
WHERE CARGA_HORA_CURSO <200;

/**6- Mostrar os softwares utilizados em certificações da Oracle que tem pré-requisitos 
: Nome do Software-Versão-Id Certificação Pré- Requisito**/ 

SELECT s.NOME_SOFTW AS "Nome do software", s.VERSAO_SOFTW AS "Versão", ce.ID_CERT AS "Id certificação", ce.ID_CERT_PRE_REQ	AS "Pré-requisito"
FROM certificacao ce INNER JOIN curso cu
	ON  (ce.ID_CERT = cu.ID_CERT)
	INNER JOIN turma t
	ON (cu.ID_CURSO = t.ID_CURSO)
	INNER JOIN uso_softwares_curso sf
	ON (t.ID_CURSO = sf.ID_CURSO)
	INNER JOIN software s
	ON (s.ID_SOFTW = s.ID_SOFTW)
WHERE ID_CERT_PRE_REQ IS  NOT NULL;

/**7- Mostrar o nome dos alunos que fizeram matrícula hoje entre 10 e 14 horas:
 Número da Matrícula-Data e Hora-Valor Pago-Turma- Nome Curso**/

SELECT a.nome_aluno AS "Nome aluno", m.NUM_MATRICULA AS "Número da matrícula", m.DT_HORA_MATR AS "Data e hora", m.VL_PAGO AS "Valor pago", m.NUM_TURMA "Turma", c.NOME_CURSO AS "Nome curso"
from aluno a INNER JOIN matricula m
 ON (a.ID_ALUNO = m.ID_ALUNO)
 INNER JOIN curso c
ON (c.ID_CURSO = m.ID_CURSO)
WHERE EXTRACT(DAY FROM M.DT_HORA_MATR) = EXTRACT(DAY FROM current_date) 
AND EXTRACT(HOUR FROM M.DT_HORA_MATR) >10 AND EXTRACT(HOUR FROM M.DT_HORA_MATR) <14;

/**8- Mostrar os alunos que cancelaram matrícula em turmas que terminam no próximo mês em certificações oferecidas 
pela Cisco no formato - usando a sintaxe do INNER JOIN :
 Número Matrícula – Data Hora Matrícula –
  Nome do Aluno- Sexo- Turma – Horário Aula- Data Início-Data Término- Nome do Curso – Nome da Certificação**/
SELECT a.nome_aluno AS "Nome do Aluno", a.sexo_aluno AS "Sexo", t.num_turma AS "Turma", au.DT_HORA_AULA AS "Horário aula", T.DT_INICIO AS "Data início", t.DT_TERMINO AS "Data término", cu.NOME_CURSO AS "Nome do cuso", ce.nome_cert AS "Nome da certificação" 
from aluno a INNER JOIN matricula m
 ON (a.ID_ALUNO = m.ID_ALUNO)
 INNER JOIN turma t
 ON (m.NUM_TURMA = t.NUM_TURMA) 
 INNER JOIN curso cu
 ON (t.ID_CURSO = cu.ID_CURSO)
INNER JOIN aula au
 ON (cu.ID_CURSO = au.ID_CURSO)
INNER JOIN certificacao ce
 ON (cu.ID_CERT = ce.ID_CERT)
WHERE UPPER(SITUACAO_MATR)  LIKE '%CANCELADA%'
AND EXTRACT(MONTH FROM t.DT_TERMINO) > EXTRACT(MONTH FROM current_date) 
AND UPPER(ce.nome_cert) LIKE '%CISCO%' 