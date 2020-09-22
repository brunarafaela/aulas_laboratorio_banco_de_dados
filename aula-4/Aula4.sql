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
SELECT * FROM matricula;
SELECT COUNT(*) FROM matricula;
SELECT * FROM CURSO;
SELECT COUNT(*) FROM CURSO;
SELECT COUNT(id_curso_pre_req) FROM CURSO;
SELECT COUNT(*) As Qtde_linhas, --Mostra a quantidade de registros
	SUM(c.carga_hora_curso) as Soma, --Mostra a soma de carga horaria de todos os registros
	AVG(c.carga_hora_curso) As Media, --Mostra a Media de carga horaria de todos os registros
	MAX(c.carga_hora_curso) As Maior, --Mostra a Maior de carga horaria de todos os registros
	MIN(c.carga_hora_curso) AS Menor --Mostra a Menor de carga horaria de todos os registros
FROM curso c;	

--19- por certificacao
SELECT * FROM matricula;
SELECT COUNT(*) FROM matricula;
SELECT * FROM CURSO;
SELECT COUNT(*) FROM CURSO;
SELECT COUNT(id_curso_pre_req) FROM CURSO;
SELECT COUNT(*) As Qtde_linhas, --Mostra a quantidade de registros
	SUM(c.carga_hora_curso) as Soma, --Mostra a soma de carga horaria de todos os registros
	AVG(c.carga_hora_curso) As Media, --Mostra a Media de carga horaria de todos os registros
	MAX(c.carga_hora_curso) As Maior, --Mostra a Maior de carga horaria de todos os registros
	MIN(c.carga_hora_curso) AS Menor --Mostra a Menor de carga horaria de todos os registros
FROM curso c
GROUP BY c.ID_CERT; --Exibe organizado pelo id



--20- Mostrar para cada curso (nome) e o total arrecadado nos ultimos 12 meses (considere a data de matricula)
SELECT c.nome_curso, SUM(mt.vl_pago) AS "Valor total por curso" --SUM é a soma total
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --Chave composta de matricula com turma 
AND t.id_curso = c.id_curso --Turma com curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH --Data da matricula menor ou igual a hoje - 12 meses
GROUP BY c.nome_curso;

--21 - IDEM, AGORA POR MES
UPDATE matricula SET dt_hora_matr = dt_hora_matr - INTERVAL '1' MONTH
WHERE MOD(num_matricula, 2) =1;

SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, --Extrai o mês da data da matricula
SUM(mt.vl_pago) AS "Valor total por curso", COUNT(*) AS Matriculados --SUM Soma total do valor pago - conta matriculados
FROM curso c, matricula mt, turma t
WHERE (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --Chave composta da matricula com turma
AND t.id_curso = c.id_curso --Turma com curso
AND mt.dt_hora_matr >= current_timestamp - INTERVAL '12' MONTH --Data da matricula menor ou igual a hoje menos 12 meses
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr), c.nome_curso --Ordena por nome do curso e por mês 
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
HAVING SUM(mt.vl_pago) > 750 --where ou condicao para grupo, depois do grupo by  --tendo a soma do valor pago maior que 750
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