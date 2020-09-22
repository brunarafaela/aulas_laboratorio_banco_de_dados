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



--3) Mostrar a quantidade de matriculados por curso, mês (use a data da matrícula) e sexo com idade superior a 21 anos;
/*Qtd por curso Curso*/
SELECT c.nome_curso, COUNT(*) AS Matriculados
FROM matricula mt
INNER JOIN turma t
ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
INNER JOIN curso c
ON(t.id_curso = c.id_curso)
GROUP BY c.nome_curso;

/*Qtd por curso e mês*/
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, COUNT(*) AS Matriculados
FROM matricula mt
INNER JOIN turma t
ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
INNER JOIN curso c
ON(t.id_curso = c.id_curso)
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr);

/*Qtd por sexo*/
--Sem inner join
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, a.sexo_aluno As Sexo, COUNT(*) AS Matriculados
FROM matricula mt, turma t, curso c, aluno a
WHERE(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
AND (t.id_curso = c.id_curso)
AND (a.ID_ALUNO	= mt.ID_ALUNO)
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr),a.sexo_aluno;

--Com inner join
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, a.sexo_aluno As Sexo, COUNT(*) AS Matriculados
FROM matricula mt
INNER JOIN turma t
ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
INNER JOIN curso c
ON(t.id_curso = c.id_curso)
INNER JOIN aluno a
ON(a.ID_ALUNO	= mt.ID_ALUNO)
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr),a.sexo_aluno;


/*Qtd por idade maior de 21*/
SELECT c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, a.sexo_aluno As Sexo,a.dt_nascto_aluno AS Nascimento,  COUNT(*) AS Matriculados
FROM matricula mt, turma t, curso c, aluno a
WHERE(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
AND (t.id_curso = c.id_curso)
AND (a.ID_ALUNO	= mt.ID_ALUNO)
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr),a.sexo_aluno,a.dt_nascto_aluno;
HAVING COUNT(current_date - a.dt_nascto_aluno)/365.25) >29;


-- 4) Mostrar os cursos que utilizam mais de 3 softwares (nome do curso);
INSERT INTO uso_softwares_curso VALUES ( 'SQL', 'PKTRAC' ) ;
INSERT INTO uso_softwares_curso VALUES ( 'CCNA1', 'SQLDEV' ) ;

SELECT c.id_curso, c.nome_curso, COUNT(*) As Quantidade_de_software
FROM curso c 
INNER JOIN uso_softwares_curso usw
ON(c.ID_CURSO = usw.ID_CURSO)
INNER JOIN software s
ON(usw.ID_SOFTWARE = s.ID_SOFTW	)
GROUP BY c.id_curso, c.nome_curso
HAVING COUNT(usw.id_curso) >3;


--5) Mostrar o nome do curso e a turma para os cursos da empresa Cisco que tiveram mais de R$ 2mil de arrecadação por turma.
--6) Mostrar para cada empresa certificadora o valor total arrecadado e a média com as matrículas nos seus cursos, para cada mês, e o número de matriculados mas desde que ultrapassem mais de 50 por mês.
--7) Mostrar para cada aluno (nome) a quantidade de aulas cursadas em cada curso matriculado.
