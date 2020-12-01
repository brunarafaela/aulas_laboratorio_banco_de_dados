/*******
Atividade 03: Com a instrução SELECT responda às seguintes consultas :
1- Mostrar os dados dos cursos no formato : 'Fundamentos de Redes tem carga horária de 120 horas'  **/
SELECT c.nome_curso||' tem carga horaria de '||TO_CHAR(c.carga_hora_curso)||' horas' AS "Dados Curso"
FROM curso c 
ORDER BY c.nome_curso ;

/* 2- Mostrar o nome e carga horária das certificações que tem 'PROFESSIONAL' ou 'INSTRUCTOR'
no nome e tem nota de corte superior a 85 */
SELECT ce.nome_cert, ce.carga_hora_cert, ce.nota_corte
FROM certificacao ce
WHERE ( UPPER(ce.nome_cert) LIKE '%PROFESSIONAL%' 
          OR UPPER(ce.nome_cert) LIKE '%INSTRUCTOR%' )
AND ce.nota_corte >= 85 ;

/* 3' Mostrar os dados das alunas que NÃO tem as letras k,w e y no login e que tem mais de 22 anos : 
Nome Aluna-Idade-login */
SELECT a.nome_aluno AS Aluna, ROUND((current_date-a.dt_nascto_aluno)/365.25,0) AS Idade, a.login
FROM aluno a
WHERE ROUND((current_date-a.dt_nascto_aluno)/365.25,0) > 22
AND a.sexo_aluno = 'F'
AND UPPER(a.login) NOT LIKE '%K%' 
          AND UPPER(a.login) NOT LIKE '%Y%' 
          AND UPPER(a.login) NOT LIKE '%W%' ; 

/* 4- Mostrar os dados das turmas que tem entre 30 e 40 vagas e valor entre R$ 450 e R$ 550 
que ainda não começaram :
Número da Turma ' Data Início ' Valor ' Quantidade de vagas */
SELECT t.num_turma, TO_CHAR(t.dt_inicio, 'DD/MM/YYYY') AS Data_Inicio, t.vl_curso, t.vagas
FROM turma t
WHERE t.vagas BETWEEN 30 AND 50
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR( t.dt_inicio, 'DD/MM/YYYY'))  > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYYY'))  ;

SELECT current_timestamp FROM dual ;

/* 5- Repetir a consulta 4 acima, usando a sintaxe do INNER JOIN e adicionando os seguintes critérios : 
para cursos com carga horária inferiores a 200 horas, no formato : 
Nome do Curso- Carga Horária- Número da Turma ' Data Início ' Valor ' Quantidade de vagas */
SELECT c.nome_curso, c.carga_hora_curso, t.num_turma, t.dt_inicio, t.vl_curso, t.vagas
FROM turma t INNER JOIN curso c
                           ON ( t.id_curso = c.id_curso) 
WHERE t.vagas BETWEEN 30 AND 40
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR( t.dt_inicio, 'DD/MM/YYYY'))  > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYYY'))
AND c.carga_hora_curso < 200 ;

/* 6- Mostrar os softwares utilizados em certificações da Oracle que tem pré-requisitos : 
Nome do Software-Versão-Id Certificação Pré-Requisito */
INSERT INTO softw_uso_curso VALUES ( 'SQL', 'SQLDEV' ) ;
INSERT INTO softw_uso_curso VALUES ( 'CCNA1', 'PKTRAC' ) ;
SELECT * FROM softw_uso_curso ;

SELECT s.nome_softw, s.versao_softw, ce.id_cert_pre_req
FROM software s, softw_uso_curso swc , curso c, certificacao ce, empresa_certificacao ec
WHERE s.id_softw = swc.id_software -- software x uso softw
AND swc.id_curso = c.id_curso  -- uso softw x curso
AND c.id_cert = ce.id_cert  -- curso x cert 
AND ce.id_empresa_cert = ec.id_empresa -- cert x empresa certificacao
AND UPPER(ec.nome_empresa) LIKE '%ORACLE%'
AND ce.id_cert_pre_req IS NOT NULL ;

SELECT * FROM certificacao ;

/* 7- Mostrar o nome dos alunos que fizeram matrícula hoje entre 10 e 14 horas: 
Número da Matrícula-Data e Hora-Valor Pago-Turma-Nome Curso */
SELECT a.nome_aluno, mt.num_matricula, mt.dt_hora_matr, mt.vl_pago, t.num_turma, c.nome_curso
FROM aluno a, matricula mt, turma t , curso c
WHERE a.id_aluno = mt.id_aluno -- aluno x matricula
AND (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
AND t.id_curso = c.id_curso -- turma x curso
AND TO_CHAR(mt.dt_hora_matr, 'DD/MM/YYYY') = TO_CHAR(current_timestamp, 'DD/MM/YYYY') 
AND EXTRACT ( HOUR FROM mt.dt_hora_matr) BETWEEN 10 AND 14 ;

SELECT * FROM matricula ;
SELECT current_timestamp FROM dual ;

/* 8- Mostrar os alunos que cancelaram matrícula em turmas que terminam 
no próximo mês em certificações oferecidas pela Cisco no formato - usando a sintaxe do INNER JOIN :
Número Matrícula ' Data Hora Matrícula ' Nome do Aluno- Sexo- Turma ' Horário Aula-
Data Início-Data Término- Nome do Curso ' Nome da Certificação */
SELECT mt.num_matricula, mt.dt_hora_matr, a.nome_aluno, a.sexo_aluno, t.num_turma,
t.horario_aula, t.dt_inicio, t.dt_termino, c.nome_curso, ce.nome_cert
FROM aluno a INNER JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                           INNER JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                           INNER JOIN curso c ON ( t.id_curso = c.id_curso)
                           INNER JOIN certificacao ce ON ( c.id_cert = ce.id_cert) 
                           INNER JOIN empresa_certificacao ec ON ( ce.id_empresa_cert = ec.id_empresa)
WHERE EXTRACT ( MONTH FROM t.dt_termino) = EXTRACT(MONTH FROM Current_date ) + 1
AND UPPER(ec.nome_empresa) LIKE '%CISCO%' ;