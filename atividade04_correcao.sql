/******************************************************************************************
Atividade 04 - Escreva a instrução em SQL para responder às seguintes consultas:
1) Reescrever a consulta 17 da aula com a sintaxe do INNER JOIN;   ****/
SELECT a.nome_aluno, c.nome_curso, fsw.nome_fabr
FROM aluno a JOIN  matricula mt ON  a.id_aluno = mt.id_aluno -- aluno x matricula
             JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
             JOIN curso c On t.id_curso = c.id_curso -- turma x curso
             JOIN certificacao ce ON c.id_cert = ce.id_cert    -- curso x certificacao
             JOIN empresa_certificacao emp ON ce.id_empresa_cert = emp.id_empresa -- certificacao x empresa certificadora
             JOIN softw_uso_curso swc ON swc.id_curso = c.id_curso  -- curso x uso softw
             JOIN software s ON swc.id_software = s.id_softw  -- uso softw x softw
             JOIN fabricante_softw fsw ON s.id_fabr = fsw.id_fabr -- softw x fabricante softw
WHERE  UPPER(emp.nome_empresa) LIKE '%'||UPPER(fsw.nome_fabr)||'%' ;

/* 2) Mostrar para cada curso a média de duração das turmas em dias;  */
SELECT c.nome_curso, AVG(t.dt_termino - t.dt_inicio) AS Media_duracao
FROM turma t JOIN curso c ON ( t.id_curso = c.id_curso)
WHERE t.situacao_turma != 'CANCELADA'
GROUP BY c.nome_curso ;

SELECT * FROM turma ;

/* 3) Mostrar a quantidade de matriculados por curso, mês (use a data da matrícula) e sexo com idade superior a 21 anos;  */
SELECT c.nome_curso,  EXTRACT ( MONTH FROM mt.dt_hora_matr) AS Mes , a.sexo_aluno, COUNT ( mt.id_aluno) AS Alunos_Matriculados
FROM aluno a JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                       JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                       JOIN curso c ON ( t.id_curso = c.id_curso)
WHERE a.dt_nascto_aluno <= current_date - INTERVAL '21' YEAR
GROUP BY c.nome_curso, EXTRACT ( MONTH FROM mt.dt_hora_matr),  a.sexo_aluno 
ORDER BY 1, 2 ;

/* 4) Mostrar os cursos que utilizam mais de 3 softwares (nome do curso);  */
SELECT c.nome_curso , COUNT(swc.id_software) AS Qtde
FROM uso_softwares_curso swc  JOIN  curso c ON swc.id_curso = c.id_curso
GROUP BY c.nome_curso
HAVING COUNT(swc.id_software)  >= 1 ;

/* 5) Mostrar o nome do curso e a turma para os cursos da empresa Cisco que tiveram mais de R$ 2mil de arrecadação por turma.  */
SELECT c.nome_curso, t.num_turma, SUM(mt.vl_pago) AS Arrecadado
FROM aluno a JOIN  matricula mt ON  a.id_aluno = mt.id_aluno -- aluno x matricula
                           JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
                          JOIN curso c On t.id_curso = c.id_curso -- turma x curso
                           JOIN certificacao ce ON c.id_cert = ce.id_cert    -- curso x certificacao
                           JOIN empresa_certificacao emp ON ce.id_empresa_cert = emp.id_empresa -- certificacao x empresa certificadora
WHERE  UPPER(emp.nome_empresa) LIKE '%CISCO%'
GROUP BY c.nome_curso, t.num_turma 
HAVING SUM(mt.vl_pago) > 200 ;

/* 6) Mostrar para cada empresa certificadora o valor total arrecadado e a média com as matrículas nos seus cursos, 
para cada mês, e o número de matriculados mas desde que ultrapassem mais de 50 por mês. */
SELECT emp.nome_empresa, EXTRACT ( MONTH FROM mt.dt_hora_matr) AS Mes , 
              SUM(mt.vl_pago) AS Arrecadado, AVG(mt.vl_pago) AS Media 
FROM aluno a JOIN  matricula mt ON  a.id_aluno = mt.id_aluno -- aluno x matricula
                           JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
                          JOIN curso c On t.id_curso = c.id_curso -- turma x curso
                           JOIN certificacao ce ON c.id_cert = ce.id_cert    -- curso x certificacao
                           JOIN empresa_certificacao emp ON ce.id_empresa_cert = emp.id_empresa -- certificacao x empresa certificadora
GROUP BY emp.nome_empresa, EXTRACT ( MONTH FROM mt.dt_hora_matr)
HAVING COUNT ( mt.id_aluno) > 0 
ORDER BY 1, 2 ; 

/*  7) Mostrar para cada aluno (nome) a quantidade de aulas cursadas em cada curso matriculado. */
SELECT a.nome_aluno, c.nome_curso, COUNT(*)
FROM aluno a JOIN participacao_aula pa ON ( a.id_aluno = pa.id_aluno)
                           JOIN matricula mt ON  a.id_aluno = mt.id_aluno -- aluno x matricula
                           JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
                          JOIN curso c On t.id_curso = c.id_curso -- turma x curso
WHERE pa.presenca = 'P' 
GROUP BY   a.nome_aluno, c.nome_curso ;                      
