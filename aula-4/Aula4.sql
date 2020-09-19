/**************************
Aula 4 - SQL - DDL e DML
***************************/

/*****************************************************************
INNER JOIN E Funcoes de agregacao -- Group by
******************************************************************/


select * from aluno;
select * from matricula;
select * from aula;
select * from certificacao;
select * from empresa_certificacao;
select * from fabricante_softw;
select * from turma;
select * from curso;
select * from participacao_aula;
select * from software;
select * from uso_softwares_curso;

--17- Alunos matriculados em cursos que a empresa certificadora é fabricante dos softwares usados no curso
SELECT a.nome_aluno, c.nome_curso, fsw.nome_fabr
FROM aluno a, matricula mt, turma t, curso c, certificacao ce, empresa_certificacao emp, uso_softwares_curso swc, software s, fabricante_softw fsw
WHERE a.id_aluno = mt.id_aluno -- aluno x matricula
AND (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
AND t.id_curso = c.id_curso-- turma x curso
AND c.id_cert = ce.id_cert -- curso x certificacao
AND ce.id_empresa_cert = emp.id_empresa --certificacao x empresa certificadora
AND swc.id_curso = c.id_curso --curso x uso softw
AND swc.ID_SOFTWARE	 = s.ID_SOFTW --uso sofw x softw
AND s.id_fabr = fsw.id_fabr -- softw x fabricante softw
AND UPPER(emp.nome_empresa) LIKE '%||UPPER(fsw.nome_fabr)||%';

--18- Funcoes de grupo -- agregacao
SELECT COUNT(*) FROM matricula;
SELECT * FROM CURSO;
SELECT COUNT(*) FROM CURSO;
SELECT COUNT(id_curso_pre_req) FROM CURSO;
SELECT COUNT(*) As Qtde_linhas,
	SUM(c.carga_hora_curso) as Soma,
	AVG(c.carga_hora_curso) As Media,
	MAX(c.carga_hora_curso) As Maior,
	MIN(c.carga_hora_curso) AS Menor
FROM curso c;	

--19- por certificacao
SELECT COUNT(*) FROM matricula;
SELECT * FROM CURSO;
SELECT COUNT(*) FROM CURSO;
SELECT COUNT(id_curso_pre_req) FROM CURSO;
SELECT COUNT(*) As Qtde_linhas,
	SUM(c.carga_hora_curso) as Soma,
	AVG(c.carga_hora_curso) As Media,
	MAX(c.carga_hora_curso) As Maior,
	MIN(c.carga_hora_curso) AS Menor
FROM curso c
GROUP BY c.id_cert;


--20- Mostrar para cada curso (nome) e o total arrecadado nos ultimos 12 meses (considere a data de matricula)
SELECT c.nome_curso, SUM(mt.vl_pago) AS "Valor total por curso"
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso;

--21 - IDEM, AGORA POR MES
UPDATE matricula SET dt_hora_matr = dt_hora_matr - INTERVAL '1' MONTH
WHERE MOD(num_matricula, 2) =1;

SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes,
SUM(mt.vl_pago) AS "Valor total por curso", COUNT(*) AS Matriculados
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr), c.nome_curso
ORDER BY 1,2;
--Regra do grup by: as colunas que nao tem funcao de grupo, sao as colunas que tem que aparecer na clausula group by


--22 - idem mas que tenha arrecadado mais de 750
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes,
SUM(mt.vl_pago) AS "Valor total por curso", COUNT(*) AS Matriculados
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --condicao para linha, antes do grupo by
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr), c.nome_curso
HAVING SUM(mt.vl_pago) > 750 --where ou condicao para grupo, depois do grupo by 
--HAVING COUNT(*)>1
ORDER BY 1,2;


--23- mostrar a media de idade dos alunos por sexo e curso que tem mais de 1 matriculado
SELECT c.nome_curso, a.sexo_aluno, AVG((current_date - a.dt_nascto_aluno)/365.25) AS Media_Idade
FROM aluno a join matricula mt
	ON (a.id_aluno = mt.id_aluno)
	JOIN turma t
	ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
	JOIN curso c
	ON (t.id_curso = c.id_curso)
GROUP BY c.nome_curso, a.sexo_aluno
HAVING COUNT(mt.id_aluno) >1;


--24- mostre a quantidade de alunos matriculados em cada turma
SELECT t.num_turma, t.id_curso, COUNT(mt.id_aluno) AS Matriculados
FROM turma t INNER JOIN matricula mt
	ON (t.num_turma = mt.num_turma)
	WHERE mt.situacao_matr != 'CANCELADA'
	GROUP BY t.num_turma, t.id_curso;
--somente por curso
SELECT t.id_curso, COUNT(mt.id_aluno) AS Matriculados
FROM turma t INNER JOIN matricula mt
	ON (t.num_turma = mt.num_turma)
	WHERE mt.situacao_matr != 'CANCELADA'
	GROUP BY t.id_curso;

--25 - idem com menos de 10 e para cada certificacao
SELECT  t.num_turma, t.id_curso, ce.nome_cert, COUNT(mt.id_aluno) AS Matriculados
FROM turma t INNER JOIN matricula mt
	ON (t.num_turma = mt.num_turma)
	INNER JOIN curso c
	ON  (t.id_curso = c.id_curso)
	INNER JOIN certificacao ce 
	ON (c.id_cert = ce.id_cert)
WHERE mt.situacao_matr != 'CANCELADA'
GROUP BY t.num_turma, t.id_curso, ce.nome_cert
HAVING COUNT(mt.id_aluno) < 2;

 

/*****************************
 Atividade 4  
 **************************/

--1) Reescrever a consulta 17 da aula com a sintaxe do INNER JOIN;
SELECT a.nome_aluno, c.nome_curso, fsw.nome_fabr
FROM aluno a INNER JOIN matricula mt
	ON(a.id_aluno = mt.id_aluno)
	INNER JOIN turma t
	ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
	INNER JOIN curso c
	ON (t.id_curso = c.id_curso)
	INNER JOIN certificacao ce
	ON (c.id_cert = ce.id_cert)
	INNER JOIN empresa_certificacao emp
	ON(ce.id_empresa_cert = emp.id_empresa)
	INNER JOIN uso_softwares_curso swc
	ON(swc.id_curso = c.id_curso)
	INNER JOIN software s
	ON(swc.ID_SOFTWARE = s.ID_SOFTW)
	INNER JOIN fabricante_softw fsw
	ON(s.id_fabr = fsw.id_fabr)
WHERE UPPER(emp.nome_empresa) LIKE '%||UPPER(fsw.nome_fabr)||%';

--2) Mostrar para cada curso a média de duração das turmas em dias;
--3) Mostrar a quantidade de matriculados por curso, mês (use a data da matrícula) e sexo com idade superior a 21 anos; 4) Mostrar os cursos que utilizam mais de 3 softwares (nome do curso);
--5) Mostrar o nome do curso e a turma para os cursos da empresa Cisco que tiveram mais de R$ 2mil de arrecadação por turma.
--6) Mostrar para cada empresa certificadora o valor total arrecadado e a média com as matrículas nos seus cursos, para cada mês, e o número de matriculados mas desde que ultrapassem mais de 50 por mês.
--7) Mostrar para cada aluno (nome) a quantidade de aulas cursadas em cada curso matriculado.

