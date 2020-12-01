/******************************************************************************************
Atividade 05 - Escreva a instrução em SQL para responder às seguintes consultas:
1) Mostre o nome, e-mail dos alunos, nome do curso e turma, para os alunos
que fizeram cursos em que não se matricularam homens;
******************************************************************************************/
SELECT a.nome_aluno, a.email_aluno, c.id_curso, c.nome_curso, t.num_turma AS Turma
FROM aluno a JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                      JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                      JOIN curso c ON ( c.id_curso = t.id_curso)
WHERE mt.id_curso NOT IN ( 
                                                  SELECT mt.id_curso 
                                                  FROM aluno a JOIN matricula mt 
                                                  ON ( a.id_aluno = mt.id_aluno)
                                                  WHERE a.sexo_aluno = 'M' )  ;   

/*** 2) Mostre o nome dos fabricantes de software que ainda não tem softwares usados em cursos.
Faça de três formas diferentes sendo uma com junção externa. ****/
-- juncao externa
SELECT fsw.nome_fabr, s.id_softw AS Software, usw.id_software AS Uso
FROM fabricante_softw fsw JOIN software s 
                                                ON  s.id_fabr = fsw.id_fabr
            LEFT JOIN uso_softwares_curso usw 
            ON usw.id_software = s.id_softw  -- uso softw x softw
WHERE usw.id_software IS NULL ; 

-- NOT IN 
SELECT fsw.nome_fabr, s.id_softw AS Software
FROM fabricante_softw fsw, software s
WHERE s.id_fabr = fsw.id_fabr
AND s.id_softw NOT IN ( 
                                           SELECT usw.id_software FROM uso_softwares_curso usw ) ; -- softwares usados

-- MINUS
SELECT fsw.nome_fabr
FROM fabricante_softw fsw, software s
WHERE s.id_fabr = fsw.id_fabr
AND s.id_softw IN ( 
                                  SELECT s.id_softw FROM software s  -- todos os softwares
                                        MINUS
                                            SELECT usw.id_software FROM uso_softwares_curso usw ) ; -- software usados

SELECT * FROM fabricante_softw fsw ;
SELECT * FROM uso_softwares_curso usw  ;
SELECT * FROM software s  ;
INSERT INTO software VALUES ( 'SAPR3', 'SAP R3', '3.1', 'Windows 10', 'SAP', 50) ;

/*** 3) Mostrar o nome do curso, valor do curso, turma, data de início e horário das aulas 
para as turmas que ainda não começaram, mas não tem ninguém matriculado. 
Mostre por extenso o horário da aula, por exemplo : SEGUNDA,QUARTA E SEXTA-FEIRA. 
Use junção externa. Faça de duas formas : com DECODE e outra com CASE. ****/
INSERT INTO turma VALUES (2, 'DBA1', current_date + 20 , current_date + 50 , 50, 'Seg-Qua-Sex 19-22h', 
750, 'Rebecca Stanfield', 'ATIVA' , 'OCP') ;

--DECODE
SELECT c.nome_curso, t.vl_curso As Valor, t.num_turma, t.dt_inicio AS Inicio, t.dt_termino AS Termino,
DECODE( UPPER(t.horario_aula),  'SEG-QUA-SEX' , 'SEGUNDA-QUARTA-SEXTA 19-22h', 
    'TER-QUI' ,  'TERCA-QUINTA 19-22h') AS Horario, mt.id_aluno AS Matriculado
FROM curso c JOIN turma t  ON ( c.id_curso = t.id_curso)
            LEFT JOIN  matricula mt ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
WHERE t.dt_inicio > current_date 
AND mt.id_aluno IS NULL ;

-- CASE
SELECT c.nome_curso, t.vl_curso As Valor, t.num_turma, t.dt_inicio AS Inicio, t.dt_termino AS Termino,
CASE 
     WHEN UPPER(t.horario_aula) LIKE 'SEG-QUA-SEX%' THEN 'SEGUNDA-QUARTA-SEXTA 19-22h'
     WHEN UPPER(t.horario_aula) LIKE 'TER-QUI%' THEN 'TERCA-QUINTA 19-22h'
 END AS Horario, mt.id_aluno AS Matriculado
FROM curso c JOIN turma t  ON ( c.id_curso = t.id_curso)
            LEFT JOIN  matricula mt ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
WHERE t.dt_inicio > current_date 
AND mt.id_aluno IS NULL ;

/*** 4) Mostrar para os cursos de certificações 'PROFESSIONAL' as turmas que tem alunos matriculados 
mas o curso ainda não aulas programadas: Nome do curso, nome da certificação, quantidade de aulas,
nome do aluno, sexo, código da turma, data de início e data prevista de término; ****/
SELECT c.nome_curso, ce.nome_cert, c.qtde_aulas, a.nome_aluno, a.sexo_aluno,
t.num_turma, t.dt_inicio AS Inicio, t.dt_termino AS Termino, au.id_curso AS Aula
FROM aluno a JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                      JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                      JOIN curso c ON ( c.id_curso = t.id_curso)
                      JOIN certificacao ce ON ( ce.id_cert = c.id_cert)
                      LEFT JOIN aula au ON ( au.id_curso = c.id_curso)
WHERE UPPER ( ce.nome_cert) LIKE '%PROFESSIONAL%'
AND au.id_curso IS NULL ;

/*** 5) Mostrar o nome do curso e a turma para os cursos que não são de certificações 'INSTRUCTOR'
e que tiveram mais de R$ 2mil de arrecadação na turma e com mais de 90% de preenchimento de vagas. ****/
SELECT t.id_curso, c.nome_curso, t.num_turma, SUM(mt.vl_pago) AS Arrecadacao, COUNT(mt.id_aluno) AS Matriculados
FROM aluno a JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                      JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                      JOIN curso c ON ( c.id_curso = t.id_curso)
                      JOIN certificacao ce ON ( ce.id_cert = c.id_cert)
WHERE UPPER ( ce.nome_cert) NOT LIKE '%INSTRUCTOR%'
GROUP BY t.id_curso, c.nome_curso, t.num_turma 
HAVING SUM(mt.vl_pago) > 2000
AND COUNT(mt.id_aluno)/ ( SELECT MAX(t1.vagas) FROM turma t1
                        WHERE t1.num_turma = t.num_turma AND t1.id_curso = t.id_curso)  >= 0.9 ;