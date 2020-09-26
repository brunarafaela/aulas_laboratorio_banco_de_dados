/**************************
Aula 5 - SQL - DDL e DML
***************************/

/*****************************************************************
Subqueries, OUTER JOIN, CASE e DECODE
******************************************************************/


--26 - mostrados todos os dados do curso com a turma mais cara -- usando subconsulta - um select dentro do outro
SELECT c.*
FROM curso c INNER JOIN turma t
ON(c.id_curso = t.id_curso)
WHERE t.vl_curso = (SELECT MAX(t.vl_curso)  FROM turma t);

--27- Quem fez os mesmos cursos que Tereza Cristina (Maria Rita Soares no meu banco)
SELECT a.nome_aluno, mt.id_curso
FROM matricula mt INNER JOIN turma t
ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
INNER JOIN aluno a
ON (mt.id_aluno = a.id_aluno) --turma x aluno
	WHERE mt.id_aluno IN (
		SELECT mt.id_curso
		FROM matricula mt INNER JOIN turma t
		ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
		INNER JOIN aluno a
		ON (mt.id_aluno = a.id_aluno) --turma x aluno
		WHERE UPPER(a.nome_aluno) LIKE 'TERE_A%' AND UPPER(a.nome_aluno) LIKE '%CRISTINA%');

--JUNCAO EXTERNA - OUTER JOIN
--Relembrando o INNER JOIN
--Alunos que fizeram matricula
SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a INNER JOIN matricula mt
ON (a.id_aluno = mt.id_aluno);

--Alunos que nao fizeram matricula
--Tabela Aluno A   Tabela Matricula B 
-- => A - B ou seja, quem está no A MAS NAO ESTÁ NO B
-- A - B = B - A? NAO. SAO COISAS DIFERENTES

SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a  LEFT OUTER JOIN matricula mt
ON (a.id_aluno = mt.id_aluno);

SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a  LEFT OUTER JOIN matricula mt --aluno(PK) diferença matricula(FK) A-B
ON (a.id_aluno = mt.id_aluno)
WHERE mt.id_aluno IS NULL;

--privilegiando a FK ->nao retornada, nao existe FK que aponte para a PKa
SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM aluno a  RIGHT OUTER JOIN matricula mt --  matricula(FK) diferença aluno(PK) B-A
ON (a.id_aluno = mt.id_aluno)
WHERE a.id_aluno IS NULL;

--usando right mas privilegiando a PK
SELECT a.id_aluno As Aluno, a.nome_aluno, mt.id_aluno AS Matriculado
FROM matricula mt RIGHT OUTER JOIN aluno a  --aluno(PK) diferença matricula(FK) A-B
ON (a.id_aluno = mt.id_aluno)
WHERE a.id_aluno IS NULL;

--29 -forma mais intuitiva com NOT IN
SELECT a.id_aluno, a.nome_aluno FROM aluno a --todos os alunos
WHERE a.id_aluno NOT IN 
					(SELECT mt.id_aluno FROM matricula mt);

--30 usando operados de conjunto --MINUS no orace, em outros sgbds é EXCEPT
SELECT a.id_aluno FROM aluno a --todos os alunos
MINUS (SELECT DISTINCT mt.id_aluno FROM matricula mt);

--MINUS SELECT DISTINCT
SELECT a.* FROM aluno a
WHERE a.id_aluno IN
     (SELECT a.id_aluno FROM aluno a --todos os alunos
			MINUS (SELECT DISTINCT mt.id_aluno FROM matricula mt));

--31 mostrar todos os dados dos ursos que ainda nao utilizam software
SELECT * FROM uso_softwares_curso;
SELECT * from curso;

--Junção externa
SELECT c.*, usw.id_curso as Usando
FROM curso c LEFT JOIN uso_softwares_curso usw
		ON (c.id_curso = usw.id_curso)
WHERE usw.id_curso IS NULL;

--32-MINUS
SELECT c.* FROM curso c where c.id_curso IN(
SELECT c.id_curso from curso c
MINUS (SELECT usw.id_curso from uso_softwares_curso usw));


--NOT IN
SELECT c.* FROM curso c WHERE c.id_curso NOT IN(
	SELECT usw.id_curso FROM uso_softwares_curso usw);

--33 - alunos que fizeram matriculas em certificacoes da Cisco mas nao participaram da aula
SELECT a.nome_aluno, c.nome_curso, c.id_curso, pa.id_curso, pa.id_aluno
FROM aluno a JOIN matricula mt ON (a.id_aluno = mt.id_aluno) --aluno x matricula
			JOIN turma t ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
			JOIN curso c ON (c.id_curso = t.id_curso) --turma x curso
			JOIN certificacao ce ON (ce.id_cert = c.id_cert) --curso x certificacao
			JOIN empresa_certificacao emp ON (ce.id_empresa_cert = emp.id_empresa) --certificacao x empresa certificacao
			JOIN aula au on (a.id_curso = c.id_curso) --aula x curso
			LEFT JOIN   participacao_aula pa ON (au.num_aula = pa.num_aula AND pa.id_aluno = a.id_aluno AND pa.id_curso = au.id_curso)	 --aula x 
WHERE UPPER(emp.nome_empresa) LIKE '%CISCO%'
AND pa.id_aluno IS NULL;

--34 - DECODE -corresponde a um IF
SELECT a.nome_aluno, DECODE (a.sexo_aluno, 'M', 'Masculino', 'F', 'Feminino') AS Sexo
FROM aluno a
ORDER BY 1;

--35- CASE
SELECT a.nome_aluno,
	CASE a.sexo_aluno 
		WHEN 'M' THEN 'Masculino'
		WHEN 'F' THEN 'Feminino'
		ELSE '?'
	END AS Sexo
FROM aluno a
ORDER BY 1;		

--outra forma
SELECT a.nome_aluno,
	CASE 
		WHEN a.sexo_aluno  = 'M' THEN 'Masculino'
		WHEN a.sexo_aluno  = 'F' THEN 'Feminino'
		WHEN UPPER(a.email_aluno) LIKE '%FATEC%' THEN 'Fatecano'
		ELSE '?'
	END AS Informacao
FROM aluno a
ORDER BY 1;		

