INSERT INTO Aluno (CPF, RA, Nome, DataNascimento) VALUES
('942.420.110-91', '21131', 'José Renato', '2004-03-22'),
('529.776.870-50', '21131', 'Pedro', '2004-03-22');

INSERT INTO Disciplina (Sigla, Nome, CargaHoraria) VALUES
('002-IBD', 'Banco de dados', 200),
('001-PW', 'Programação Web', 100),
('004-AS', 'Arquitetura de software', 100),
('001-PM', 'Programação mobile', 100),
('001-ES', 'Estrutura de dados', 100),
('003-AS', 'Analise Sistemas', 150);

/*REPROVADO POR FALTA*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(10, 5, 0, 50, 2022, 2, '2022-03-14', '002-IBD', '942.420.110-91');

/*REPROVADO POR FALTA*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(2, 5, 0, 50, 2022, 2, '2022-03-14', '001-ES', '942.420.110-91');

/*Erro ao adicionar*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(2, 5, 0, 50, 2022, 2, '2022-03-14', '002-IBD', '942.420.110-91');

/*REPROVADO POR NOTA*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(2, 1, 0, 10, 2022, 2, '2022-03-14', '004-AS', '942.420.110-91');

/*APROVADO*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(10, 5, 0, 10, 2022, 2, '2022-03-14', '001-PW', '942.420.110-91');

/*Nota substutiva Reprovado por nota*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(4, 1, 1, 10, 2022, 2, '2022-03-14', '004-AS', '529.776.870-50');

/*Nota substutiva APROVADO*/
INSERT INTO Matricula (Nota1, Nota2, NotaSubstutiva, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(0, 5, 7, 10, 2022, 2, '2022-03-14', '001-PW', '529.776.870-50');

INSERT INTO Matricula (Nota1, Nota2, Faltas, Ano, Semestre, DataMatricula, SiglaDisciplina, CPFAluno) VALUES
(10, 5, 50, 2022, 2, '2022-03-14', '002-IBD', '529.776.870-50'),
(10, 7, 10, 2022, 2, '2022-03-14', '001-PW', '529.776.870-50');

select * from Matricula

delete from Matricula

EXEC.MostrarAlunosPorAnoDisciplina '001-PW', 2022
GO

EXEC.BoletimAluno '942.420.110-91', 2022, 2
GO

EXEC.MostrarAlunosReprovados 2022
GO