/********************************************************************
Atividade 7 - Banco de Dados Objeto-Relacional  : Com as instruções SQL para tipos e tabelas tipadas no Objeto Relacional
a)	Coloque os softwares utilizados como uma tabela aninhada nos cursos. Cadastre 2 softwares em cada curso.  ***/
SELECT * FROM or_software ;
SELECT * FROM or_curso ;
-- tipo para referencia ao software
DROP TYPE tiposoftw_curso FORCE ;
CREATE OR REPLACE TYPE tiposoftw_curso AS OBJECT
( softw_usado REF tiposoftware) ;
-- tabela de softwares usado
DROP TYPE tab_softw_curso FORCE ;
CREATE OR REPLACE TYPE tab_softw_curso AS TABLE OF tiposoftw_curso ;
-- aninhando em curso
ALTER TYPE tipocurso ADD ATTRIBUTE softwares_utilizados tab_softw_curso CASCADE ;
-- atualizando curso
UPDATE or_curso c set c.softwares_utilizados = tab_softw_curso (
               tiposoftw_curso ( (SELECT REF(s) FROM or_software s WHERE s.id_softw = 'SQLDEV') ) ,
               tiposoftw_curso ( (SELECT REF(s) FROM or_software s WHERE s.id_softw = 'ORADB' ) ) )
WHERE c.id_curso = 'SQL'     ;           
UPDATE or_curso c set c.softwares_utilizados = tab_softw_curso (
               tiposoftw_curso ( (SELECT REF(s) FROM or_software s WHERE s.id_softw = 'SQLDEV') ) ,
               tiposoftw_curso ( (SELECT REF(s) FROM or_software s WHERE s.id_softw = 'ORADB' ) ) ,
              tiposoftw_curso ( (SELECT REF(s) FROM or_software s WHERE s.id_softw = 'DTMOD' ) ) )
WHERE c.id_curso = 'DBA1'     ;  

SELECT c.nome_curso, sc.softw_usado.nome_softw
FROM or_curso c, TABLE (c.softwares_utilizados) sc ;

/****** b)	Insira 2 aulas realizadas para um determinado aluno. 
Posteriormente atualize o conteúdo dado e o arquivo de atividades para uma dessas aulas. ***/
SELECT * FROM or_aluno ;
SELECT * FROM or_turma ;

UPDATE or_aluno a SET a.aulas_realizadas = 
         tab_aula_realizada (
                      tipoaula_realizada ( 1, ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ) ,
                                                     current_timestamp + 4, 'Vanderleia Cardoso', null,  null, null, 'F' ) ,
                      tipoaula_realizada ( 2, ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ) ,
                                                     current_timestamp + 11, 'Timoteo Junior', null,  null, null, 'F' )   )
 WHERE a.id_aluno = 3 ;  
-- conteudo e arquivo atividade
SELECT a.nome_aluno, ar.*
FROM or_aluno a, TABLE (a.aulas_realizadas) ar ;

 UPDATE TABLE ( SELECT aulas_realizadas FROM or_aluno WHERE id_aluno = 3 ) ar
 SET ar.conteudo_dado = 'idem previsto', ar.arquivo_atividade = 'atv1_mpaula.sql'
 WHERE ar.num_aula = 1 AND ar.curso.id_curso = 'SQL'  ;

/****** c)	Insira uma nova certificação que seja da CISCO. Posteriormente altere a estrutura 
para fazer uma referência à tabela empresa. Atualize a referência para a empresa CISCO.  ***/
INSERT INTO or_certificacao VALUES (  'CCNA', 'Cisco Certified Network Associate', 240, 180, 'CISCO SYSTEMS INC') ;
-- estrutura
ALTER TYPE tipocertificacao ADD ATTRIBUTE  (certificadora REF tipoempresa) CASCADE ;
-- atualizando
UPDATE or_certificacao SET certificadora = 
                                 (SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%CISCO%') 
WHERE id_cert = 'CCNA' ;
UPDATE or_certificacao SET certificadora = 
                                 (SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%') 
WHERE id_cert = 'OCA' ;
-- excluindo o atributo anterior
DESC or_certificacao ;
ALTER TYPE tipocertificacao DROP ATTRIBUTE empresa_certificadora CASCADE ;
/****** d)	Insira um novo curso para a certificação criada acima em c) e programe 2 aulas. 
Crie uma nova turma e matricule 2 alunos NOVOS. Para esses novos alunos preencha uma aula realizada para cada um.  ***/
DESC or_curso ;
INSERT INTO or_curso VALUES ( 'REDES1', 'Fundamentos Redes de Computadores', 40, 75, 10, 1, 
   ( SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'CCNA' )  ,
   tab_aulas_programadas ( tipoaula_programada ( 1, 'Conceitos Redes', 'Todos exercicios cap 1', 'Capitulo 1', 'Redes_Fundamentos.pdf') ,
                                              tipoaula_programada ( 2, 'Cabeamento', 'Todos exercicios cap 2', 'Capitulo 2', 'Redes_Fundamentos.pdf')    ) ,
   tab_softw_curso ( tiposoftw_curso ( (SELECT REF(s) FROM or_software s WHERE s.id_softw = 'PKTRAC') ) ) ) ;                  

SELECT * FROM or_curso ;
-- dois novos alunos
INSERT INTO or_aluno VALUES ( 4, 'Rebeca Gleiser', 'F', current_date - INTERVAL '24' YEAR - INTERVAL '6' MONTH, 5522,
tipoendereco ( 'Rua', 'Labatut', 500, null, 'Ipiranga', 'Sao Paulo', 'SP', 'rebeca@gmail.com', 
                        tipofone (11921439821, 11976217665, 11911134567 )  ) ,
'gleiser', 'beca' , null ) ;
INSERT INTO or_aluno VALUES ( 5, 'Cantidio Sampaio', 'M', current_date - INTERVAL '31' YEAR - INTERVAL '8' MONTH, 8200,
tipoendereco ( 'Avenida', 'Cursino', 420, 'ap 92', 'Ipiranga', 'Sao Paulo', 'SP', 'sampaio@gmail.com', 
                        tipofone (11901920988, 11912345421, 11984932533 )  ) ,
'tidesampa', 'sampa' , null) ;
SELECT * FROM or_aluno ;
-- turma nova
DELETE FROM or_turma WHERE num_turma = 4 ;
INSERT INTO or_turma VALUES ( 4, current_date + 5, current_date + 25, 30, 'SEG-TER-QUI', '19-22hs', 800,
   ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'REDES1' ), 'ATIVA' ,
           tab_matriculas ( tipomatricula ( matricula_seq.nextval, current_timestamp +1, 755, 
                                                       (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 4 ) , null, null, null, 'CURSANDO') ,
                                       tipomatricula ( matricula_seq.nextval, current_timestamp + 2, 775, 
                                                       (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 5 ) , null, null, null, 'CURSANDO')    )    ) ;
-- aulas realizadas
UPDATE or_aluno a SET a.aulas_realizadas = 
         tab_aula_realizada (
                      tipoaula_realizada ( 1, ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'REDES1' ) ,
                                                     current_timestamp + 5, 'Cristina Net', null,  null, null, 'F' )  )
 WHERE a.id_aluno = 4 ;
UPDATE or_aluno a SET a.aulas_realizadas = 
         tab_aula_realizada (
                      tipoaula_realizada ( 4, ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'REDES1' ) ,
                                                     current_timestamp + 5, 'Cristina Net', null,  null, null, 'F' )  )
 WHERE a.id_aluno = 5 ;  
 UPDATE TABLE ( SELECT aulas_realizadas FROM or_aluno WHERE id_aluno = 5 ) ar
 SET ar.num_aula = 1
 WHERE ar.num_aula = 4 AND ar.curso.id_curso = 'REDES1'  ;

SELECT t.num_turma, t.dias_semana, t.curso.nome_curso AS Curso,
            t.curso.certificacao.nome_cert AS Certificacao, mt.num_matricula,
            mt.aluno.nome_aluno AS Aluno, mt.aluno.end_aluno.logradouro, mt.valor_pago, mt.situacao_matr
FROM or_turma t, TABLE (t.matriculas) mt 
WHERE t.dt_inicio > current_date ;

/****** e)	Mostre as aulas realizadas do curso criado em d) com os seguintes dados : 
Número da aula - Data hora- Conteúdo previsto - Conteudo dado - nome do aluno - 
número da matricula -  idade - sexo - endereço (logradouro, nº, complemento, bairro e cidade) -
nome do curso - nome da certificação. ***/
DESC or_aluno ;
DESCR or_turma ;
SELECT ar.num_aula, ar.dt_hora_aula AS Dia_aula, ap.conteudo_previsto AS Conteudo_Previsto,
ar.conteudo_dado AS Conteudo_Dado, a.nome_aluno, mt.num_matricula, 
a.sexo_aluno, a.end_aluno.logradouro, a.end_aluno.numero, a.end_aluno.complemento, 
a.end_aluno.bairro, a.end_aluno.cidade, ar.curso.nome_curso,  ar.curso.certificacao.nome_cert
FROM or_aluno a, TABLE ( a.aulas_realizadas) ar , or_curso c , TABLE ( c.aulas_programadas) ap,
or_turma t, TABLE (t.matriculas) mt 
WHERE c.id_curso = ar.curso.id_curso
AND ar.num_aula = ap.numero
AND t.curso.id_curso = c.id_curso
AND a.id_aluno = mt.aluno.id_aluno 
ORDER BY a.nome_aluno, ar.num_aula ;

/****** f)	Mostre os alunos que se matricularam em cursos de certificação da empresa Oracle
e o número de telefone tenha DDD 11 e comece com 99 : nome aluno - número da matrícula - nome do curso 
- nome da certificação - número do telefone  ***/
SELECT mt.aluno.nome_aluno AS Aluno, mt.num_matricula, t.curso.nome_curso AS Curso,
            t.curso.certificacao.nome_cert AS Certificacao, fn.* 
FROM or_turma t, TABLE (t.matriculas) mt , TABLE (mt.aluno.end_aluno.fones) fn
WHERE UPPER(t.curso.certificacao.certificadora.nome_empresa) LIKE '%ORACLE%' 
AND TO_CHAR(fn.column_value) LIKE '1199%' ; 