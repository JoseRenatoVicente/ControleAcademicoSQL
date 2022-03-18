create table Aluno(
	CPF varchar(14) not null,
	RA varchar(14) not null,
	Nome varchar(60) not null,
	DataNascimento DATE not null,
	CONSTRAINT CPFAluno PRIMARY KEY (CPF)
);
GO


create table Disciplina(
	Sigla varchar(10) not null,
	Nome varchar(60) not null,
	CargaHoraria int not null,
	CONSTRAINT SiglaDisciplina PRIMARY KEY (Sigla)
);
GO

create table Matricula(
	NumeroMatricula int not null identity,
	Nota1 DECIMAL(5,2),
	Nota2 DECIMAL(5,2),
	NotaSubstutiva DECIMAL(5,2),
	Media DECIMAL(5,2),
	Faltas DECIMAL(5,2),
	Situacao varchar(20),
	Ano int,
	Semestre int,
	DataMatricula DATE,
	SiglaDisciplina varchar(10) not null,
	CPFAluno varchar(14) not null,
	CONSTRAINT ChaveMatricula PRIMARY KEY (Ano, Semestre, CPFAluno, SiglaDisciplina),
	CONSTRAINT NumeroMatricula UNIQUE (NumeroMatricula),
	FOREIGN KEY (SiglaDisciplina) REFERENCES Disciplina (Sigla),
	FOREIGN KEY (CPFAluno) REFERENCES Aluno (CPF)
);
GO

CREATE TRIGGER CalculoMedia
ON Matricula
AFTER INSERT
AS
BEGIN
	DECLARE @Nota1 DECIMAL(5,2),
			@Nota2 DECIMAL(5,2),
			@NotaSubstutiva DECIMAL(5,2),
			@Media DECIMAL(5,2),
			@Faltas DECIMAL(5,2),
			@Situacao varchar(20),
			@SiglaDisciplina varchar(10),
			@CargaHoraria int,
			@NumeroMatricula int

	SELECT @NumeroMatricula = NumeroMatricula, @Nota1 = Nota1, @Nota2 = Nota2, @NotaSubstutiva = NotaSubstutiva, @Media = Media, @Faltas = Faltas, @SiglaDisciplina = SiglaDisciplina FROM inserted;

	SELECT @CargaHoraria = CargaHoraria from Disciplina 
		WHERE Sigla = @SiglaDisciplina;

	SET @Media = (@Nota1 + @Nota2) / 2
	
	IF @Media < 5.0
	BEGIN
		IF @Nota1 < @Nota2
		BEGIN
			SET @Nota1 = @NotaSubstutiva
		END
		ELSE
			SET @Nota2 = @NotaSubstutiva
	

	SET @Media = (@Nota1 + @Nota2) / 2

	IF @Media < 5.0
		SET @Situacao = 'REPROVADO POR NOTA'
	ELSE
		SET @Situacao = 'APROVADO'
	END
	ELSE
		SET @Situacao = 'APROVADO'

	print((@CargaHoraria * 0.25)  )
	IF (@CargaHoraria * 0.25) <= @Faltas 
	BEGIN
		SET @Situacao = 'REPROVADO POR FALTA'
	END

	UPDATE Matricula SET Media = @Media, Situacao = @Situacao
		WHERE NumeroMatricula = @NumeroMatricula;

END
GO


CREATE PROCEDURE MostrarAlunosPorAnoDisciplina @SiglaDisciplina varchar(10), @Ano int
AS

SELECT Aluno.Nome, Matricula.Situacao, Aluno.RA, Matricula.CPFAluno, Matricula.Nota1, Matricula.Nota2, Matricula.Media, Matricula.Faltas, Matricula.Ano, Matricula.Semestre, Disciplina.Nome AS "Disciplina"
FROM Matricula JOIN Disciplina ON Disciplina.Sigla = Matricula.SiglaDisciplina JOIN Aluno ON Aluno.CPF = Matricula.CPFAluno
WHERE Matricula.SiglaDisciplina = @SiglaDisciplina AND Matricula.Ano = @Ano 


/*SELECT A.Nome, M.Situacao, A.RA, M.CPFAluno, M.Nota1, M.Nota2, M.Media, M.Faltas, M.Ano, M.Semestre, D.Nome AS [Disciplina]
FROM Matricula AS M, Aluno AS A, Disciplina AS D
WHERE M.SiglaDisciplina = @SiglaDisciplina AND M.Ano = @Ano AND D.Sigla = @SiglaDisciplina AND A.CPF = M.CPFAluno*/

GO

CREATE PROCEDURE BoletimAluno @CPF varchar(14), @Ano int, @Semestre int
AS

/*SELECT D.Nome AS [Nome Disciplina], M.Nota1, M.Nota2, M.NotaSubstutiva, M.Media, M.Faltas, (D.CargaHoraria * 0.25) [Faltas Permitidas], M.Situacao AS [Situacao Final], M.Ano, M.Semestre
FROM Matricula AS M, Disciplina AS D
WHERE M.CPFAluno = @CPF AND M.Ano = @Ano AND D.Sigla = M.SiglaDisciplina AND M.Semestre = @Semestre*/

SELECT Disciplina.Nome AS "Nome Disciplina", Matricula.Nota1, Matricula.Nota2, Matricula.NotaSubstutiva, Matricula.Media, Matricula.Faltas, (Disciplina.CargaHoraria * 0.25) "Faltas Permitidas", Matricula.Situacao AS "Situacao Final", Matricula.Ano, Matricula.Semestre
FROM Matricula JOIN Disciplina ON Disciplina.Sigla = Matricula.SiglaDisciplina
WHERE Matricula.CPFAluno = @CPF AND Matricula.Ano = @Ano AND Matricula.Semestre = @Semestre

GO

CREATE PROCEDURE MostrarAlunosReprovados @Ano int
AS

/*SELECT A.Nome, A.RA, M.CPFAluno, M.Nota1, M.Nota2, M.Media, M.Faltas, M.Ano, M.Semestre, D.Nome AS [Disciplina]
FROM Matricula AS M, Aluno AS A, Disciplina AS D
WHERE M.Ano = @Ano AND D.Sigla = M.SiglaDisciplina AND M.Situacao like '%REPROVADO%' AND M.CPFAluno = A.CPF*/

SELECT Aluno.Nome, Aluno.RA, Matricula.CPFAluno, Matricula.Nota1, Matricula.Nota2, Matricula.Media, Matricula.Faltas, Matricula.Ano, Matricula.Semestre, Disciplina.Nome AS "Disciplina"
FROM Matricula JOIN Aluno on Matricula.CPFAluno = Aluno.CPF join Disciplina ON Matricula.SiglaDisciplina = Disciplina.Sigla
WHERE Matricula.Ano = @Ano AND Matricula.Situacao = 'REPROVADO POR NOTA'

GO
