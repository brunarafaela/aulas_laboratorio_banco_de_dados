/*****************************
 Atividade 5  
 **************************/


--1) Mostre o nome, e-mail dos alunos, nome do curso e turma, para os alunos que fizeram cursos em que não se matricularam homens;
SELECT a.nome_aluno AS Nome_Aluno, a.email_aluno AS Email_Aluno, c.nome_curso AS Nome_Curso, t.num_turma AS Num_Turma
FROM aluno a 
	INNER JOIN matricula mt
		ON(a.id_aluno = mt.id_aluno) --aluno x matricula
	INNER JOIN turma t
		ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
	INNER JOIN curso c
		ON (t.id_curso = c.id_curso) --turma x curso
WHERE UPPER(a.sexo_aluno) NOT LIKE '%M%'
AND mt.id_aluno IS NULL;

--2) Mostre o nome dos fabricantes de software que ainda não tem softwares usados em cursos. Faça de três formas diferentes sendo uma com junção externa.
--LEFT JOIN
SELECT fsw.nome_fabr 
FROM fabricante_softw fsw
	INNER JOIN software s
	ON(fsw.ID_FABR = s.ID_FABR) --fabricante softw x softw 
	LEFT OUTER JOIN USO_SOFTWARES_CURSO usc
	ON(s.id_softw = usc.id_software) --softw x uso software curso
WHERE usc.id_software IS NULL;

--RIGHT JOIN
SELECT fsw.nome_fabr 
FROM fabricante_softw fsw
	INNER JOIN software s
	ON(fsw.ID_FABR = s.ID_FABR) --fabricante softw x softw 
	RIGHT OUTER JOIN USO_SOFTWARES_CURSO usc
	ON(s.id_softw = usc.id_software) --softw x uso software curso
WHERE s.id_softw IS NULL;


--3) Mostrar o nome do curso, valor do curso, turma, data de início e horário das aulas para as turmas que ainda não começaram, mas não tem ninguém matriculado. 
--Mostre por extenso o horário da aula, por exemplo : SEGUNDA,QUARTA E SEXTA-FEIRA. Use junção externa. Faça de duas formas : com DECODE e outra com CASE.
SELECT c.nome_curso, t.vl_curso, t.num_turma, t.dt_inicio, 
	CASE t.horario_aula 
	WHEN 'Seg-Qua-Sex 19h' THEN 'SEGUNDA, QUARTA E SEXTA-FEIRA 19h'
	WHEN 'Sabado 8h-12h' THEN  'SÁBADO'
	ELSE '?'
	END AS Horário_Aula
FROM curso c
INNER JOIN turma t
ON (c.id_curso = t.id_curso) --curso x turma
INNER JOIN matricula mt
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --turma x matricula
INNER JOIN aula au
ON(c.id_curso = au.id_curso) --curso x aula
WHERE mt.num_turma  IS NULL
AND t.dt_inicio < CURRENT_TIMESTAMP
ORDER BY 1;


SELECT c.nome_curso, t.vl_curso, t.num_turma, t.dt_inicio, 
	DECODE( t.horario_aula, 'Seg-Qua-Sex 19h', 'SEGUNDA, QUARTA E SEXTA-FEIRA 19h', 'Sabado 8h-12h', 'SABADO 8h-12h	') AS Horário
FROM curso c
INNER JOIN turma t
ON (c.id_curso = t.id_curso) --curso x turma
INNER JOIN matricula mt
ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --turma x matricula
INNER JOIN aula au
ON(c.id_curso = au.id_curso) --curso x aula
WHERE mt.num_turma  IS NULL
AND t.dt_inicio < CURRENT_TIMESTAMP
ORDER BY 1;

--4) Mostrar para os cursos de certificações ‘PROFESSIONAL’ as turmas que tem alunos matriculados mas o curso ainda não aulas programadas: Nome do curso, nome da certificação, quantidade de aulas, nome do aluno, sexo, código da turma, data de início e data prevista de término; 
SELECT c.nome_curso, ce.nome_cert, c.qtde_aulas, a.nome_aluno, a.sexo_aluno, t.num_turma, t.dt_inicio, t.dt_termino
FROM aluno a 
INNER JOIN matricula mt
	ON(a.id_aluno = mt.id_aluno) --aluno x matricula
	INNER JOIN turma t
	ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
	INNER JOIN curso c 
	ON (t.id_curso = c.id_curso) --turma x curso
	INNER JOIN certificacao ce
	ON (c.id_cert = ce.id_cert) -- curso x certificacao
	LEFT JOIN aula au
	ON (c.id_curso = au.id_curso) --curso x aula
WHERE au.id_curso IS NULL
AND UPPER(a.sexo_aluno) LIKE '%PROFESSIONAL%';


--5) Mostrar o nome do curso e a turma para os cursos que não são de certificações ‘INSTRUCTOR’ e que tiveram mais de R$ 2mil de arrecadação na turma e com mais de 90% de preenchimento de vagas.
SELECT c.nome_curso, t.num_turma, ce.nome_cert, SUM(t.VL_CURSO) AS "Arrecadação" , COUNT(mt.NUM_MATRICULA) AS "Matriculados"
FROM curso c INNER JOIN certificacao ce
ON (c.id_cert = ce.id_cert)
INNER JOIN turma t
ON (c.id_curso = t.id_curso)
INNER JOIN matricula mt
ON (t.NUM_TURMA = mt.NUM_TURMA)
WHERE UPPER(ce.nome_cert) NOT LIKE '%INSTRUCTOR%' 
AND t.VAGAS * 0.9 > COUNT(mt.NUM_MATRICULA)
GROUP BY c.nome_curso, t.num_turma, ce.nome_cert
HAVING SUM(t.VL_CURSO) > 2000 
ORDER BY 1,2;