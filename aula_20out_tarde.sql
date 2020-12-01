/***********************************************************************
Aula 20/out - BDOR Tabelas aninhadas
*************************************************************************/
/******** 
Esquema Objeto-Relacional BD Certificacoes 
Aluno ( id_aluno(PK), nome_aluno, sexo_aluno, dt_nascto_aluno, cpf_aluno, {end_aluno}, login, senha,
 {aulas_realizadas} )
Certificacao ( id_cert(PK), nome_cert, carga_hora_cert, tempo_maximo, empresa_certificadora)
Curso (id_curso(PK), nome_curso, carga_hora_curso, qtde_aulas, nota_corte, sequencia,
          {aulas_programadas}, REF certificacao, {softwares_usados} )
Aula_programada (numero, conteudo_previsto, atividade_prevista, material, arquivo_material) 
Turma(num_turma(PK), REF curso,dt_inicio,dt_termino,vagas,horario_aula,vl_curso, {matriculas} )
Empresa( nome, pais, area_atuacao)
Software(id_softw(PK),nome_softw,versao,sistema_operacional, REF empresa)
Aula_realizada ( numero, REF curso, dt_hora_aula, instrutor, conteudo_dado, arquivo_atividade, dt_hora_entrega, presenca )
Matricula ( num_matricula, dt_hora_matr, valor_pago, REF aluno, prova_certificacao, aproveitamento_final, 
                  frequencia_final, situacao_matricula ) 
*****/
SELECT * FROM or_aluno ;
-- tipo para matricula
DROP TYPE tipomatricula FORCE ;
CREATE OR REPLACE TYPE tipomatricula AS OBJECT
( num_matricula INTEGER,
dt_hora_matr TIMESTAMP,
valor_pago NUMBER(6,2) ,
aluno REF tipoaluno ,
prova_certificacao NUMBER(5,2),
aproveitamento_final NUMBER(5,2),
frequencia_final NUMBER(5,2) ,
situacao_matr CHAR(15) ) ;
-- tabela de tipomatricula (não é uma tabela relacional tipada), é uma tabela coleção
DROP TYPE tab_matriculas FORCE ;
CREATE OR REPLACE TYPE tab_matriculas AS TABLE OF tipomatricula ; 
-- criar uma novo atributo em turma que é uma tabela aninhada das matriculas
ALTER TYPE tipoturma ADD ATTRIBUTE matriculas tab_matriculas CASCADE ; 
SELECT * FROM or_turma ;
-- criando uma sequencia para o numero da matricula
DROP SEQUENCE matricula_seq ;
CREATE SEQUENCE matricula_seq START WITH 2020 ;
-- inserindo duas novas matriculas para a turma 1
-- Matricula ( num_matricula, dt_hora_matr, valor_pago, REF aluno, prova_certificacao, aproveitamento_final, 
--                  frequencia_final, situacao_matricula
UPDATE or_turma t SET t.matriculas = 
         tab_matriculas ( tipomatricula ( matricula_seq.nextval, current_timestamp -1, 490, 
                                   (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 1 ) , null, null, null, 'CURSANDO') ,
                                   tipomatricula ( matricula_seq.nextval, current_timestamp, 475, 
                                   (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 3 ) , null, null, null, 'CURSANDO') )
WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL' ;

SELECT t.num_turma, t.curso.id_curso , mt.num_matricula, mt.aluno.nome_aluno, mt.valor_pago
FROM or_turma t , TABLE (t.matriculas) mt ;
-- excluindo a segunda matricula
DELETE FROM TABLE ( SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
WHERE mt.num_matricula = 2020 AND UPPER(mt.aluno.nome_aluno) LIKE 'MARIA PAULA%' ;
-- inserindo uma nova matricula para uma turma que já tem matriculados
INSERT INTO TABLE ( SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
VALUES ( matricula_seq.nextval, current_timestamp, 488.25 , 
              (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 2 ) , null, null, null, 'CURSANDO' ) ;
-- atualizando uma matricula especifica             
UPDATE TABLE ( SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
SET mt.valor_pago = 400
WHERE mt.num_matricula = 2021 ;
-- inserindo uma nova turma com uma nova matricula
INSERT INTO or_turma VALUES ( 3, current_date + 30, current_date + 60, 50, 'SABADO', '08-17hs', 600,
   ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ), 'ATIVA' ,
           tab_matriculas ( tipomatricula ( matricula_seq.nextval, current_timestamp +3, 555, 
                                   (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 3 ) , null, null, null, 'CURSANDO') 
                                    )    ) ;
-- dados de matriculas na turma, aluno, curso e certificacao que ainda não comecaram
SELECT t.num_turma, t.dias_semana, t.curso.nome_curso AS Curso,
            t.curso.certificacao.nome_cert AS Certificacao, mt.num_matricula,
            mt.aluno.nome_aluno AS Aluno, mt.aluno.end_aluno.logradouro, mt.valor_pago, mt.situacao_matr
FROM or_turma t, TABLE (t.matriculas) mt 
WHERE t.dt_inicio > current_date ;

-- aninhando as aulas programadas na tabela curso
DROP TYPE tab_aulas_programadas FORCE ;
CREATE OR REPLACE TYPE tab_aulas_programadas AS TABLE of tipoaula_programada ; 
-- criar o novo atributo em curso
ALTER TYPE tipocurso ADD ATTRIBUTE aulas_programadas tab_aulas_programadas CASCADE ;
DESC tipocurso ;
-- inserindo 2 aulas para o curso de SQL  -- Aula_programada (numero, conteudo_previsto, atividade_prevista, material, arquivo_material) 
SELECT * FROM or_curso ;
DESC tipoaula_programada ;
UPDATE or_curso c SET c.aulas_programadas =
         tab_aulas_programadas ( 
                  tipoaula_programada ( 1, 'Visao Geral SQL', 'Todos exercicios cap 1', 'Capitulo 1', 'SQL Fundamentos.pdf') ,
                  tipoaula_programada ( 2, 'Comandos DDL', 'Todos exercicios cap 2', 'Capitulo 2', 'SQL Fundamentos.pdf')    ) 
 WHERE c.id_curso = 'SQL' ;                                                       

SELECT c.nome_curso, ap.* 
FROM or_curso c, TABLE ( c.aulas_programadas) ap ;
-- aulas realizadas como tabela aninhada em aluno
-- Aula_realizada ( numero, REF curso, dt_hora_aula, instrutor, conteudo_dado, 
--                             arquivo_atividade, dt_hora_entrega, presenca )
DROP TYPE tipoaula_realizada FORCE ;
CREATE OR REPLACE TYPE tipoaula_realizada AS OBJECT
( num_aula INTEGER , 
curso REF tipocurso, 
dt_hora_aula TIMESTAMP,
instrutor VARCHAR2(30) ,
conteudo_dado VARCHAR2(30),
arquivo_atividade VARCHAR2(50),
dt_hora_entrega_atividade TIMESTAMP,
presenca CHAR(1) ) ; 
-- tabela de tipoaula_realizada
DROP TYPE  tab_aula_realizada FORCE ;
CREATE OR REPLACE TYPE tab_aula_realizada AS TABLE OF tipoaula_realizada ; 
-- criando um novo atributo para aluno das aulas realizadas
SELECT * FROM or_aluno ;
INSERT INTO or_aluno VALUES ( 2, 'Astrid Tupinamba', 'F', current_date - INTERVAL '22' YEAR - INTERVAL '3' MONTH, 9988,
tipoendereco ( 'Rua', 'Santa Cruz', 300, null, 'Ipiranga', 'Sao Paulo', 'SP', 'tupiastrid@gmail.com', 
                        tipofone (11921354321, 11907677665, 11907034567 )  ) ,
'tupinamba', 'tupi' ) ;
INSERT INTO or_aluno VALUES ( 3, 'Maria Paula de Assis', 'F', current_date - INTERVAL '27' YEAR - INTERVAL '2' MONTH, 7755,
tipoendereco ( 'Avenida', 'Gentil de Moura', 120, 'ap 22', 'Ipiranga', 'Sao Paulo', 'SP', 'mapassis@gmail.com', 
                        tipofone (11921359988, 11907673421, 11907035533 )  ) ,
'maripaula', 'mpa93' ) ;
--
ALTER TYPE tipoaluno ADD ATTRIBUTE aulas_realizadas tab_aula_realizada CASCADE;
-- populando duas novas aulas em aluno
UPDATE or_aluno a SET a.aulas_realizadas = 
         tab_aula_realizada (
                      tipoaula_realizada ( 1, ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ) ,
                                                     current_timestamp + 10, 'Chico Rei', null,  null, null, 'F' ) ,
                      tipoaula_realizada ( 2, ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ) ,
                                                     current_timestamp + 11, 'Chico Rei', null,  null, null, 'F' )   )
 WHERE a.id_aluno = 1 ;  
 -- atualizando uma das aulas do aluno SEbastião
 UPDATE TABLE ( SELECT aulas_realizadas FROM or_aluno WHERE id_aluno = 1 ) ar
 SET ar.instrutor = 'Rita Reis'
 WHERE ar.num_aula = 1 AND ar.curso.id_curso = 'SQL'  ;
-- consulta das aulas do aluno Sebastiao confrontando aula realizada x aula programada
SELECT a.nome_aluno, ar.curso.nome_curso, ar.num_aula, ar.dt_hora_aula AS Dia_aula, 
ap.conteudo_previsto AS Previsto,
ar.conteudo_dado AS Dado, ap.* 
FROM or_aluno a, TABLE ( a.aulas_realizadas) ar , or_curso c , TABLE ( c.aulas_programadas) ap
WHERE c.id_curso = ar.curso.id_curso
AND ar.num_aula = ap.numero ;