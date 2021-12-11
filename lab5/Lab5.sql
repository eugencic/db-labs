--1. Completati urmatorul cod pentru a afisa eel mai mare numar dintre cele trei numere prezentate:
DECLARE @N1 INT, @N2 INT, @N3 INT; 
DECLARE @MAI_MARE INT; 
SET @N1 = 60 * RAND(); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND();

IF @N1 > @N2 AND @N1 > @N3 SET @MAI_MARE = @N1
ELSE IF @N2 > @N1 AND @N2 > @N3 SET @MAI_MARE = @N2
ELSE SET @MAI_MARE = @N3

PRINT @N1; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

--2. Afisati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia notelor 6 si 8)
-- a studentului la primul test al disciplinei Baze de date,
-- folosind structura de altemativa IF. .. ELSE. Sa se foloseasca variabilele.
USE universitatea
DECLARE @notNR1 INT = 6;
DECLARE @notNR2 INT = 8;
DECLARE @disciplina VARCHAR(255) = 'Baze de date';
DECLARE @tipevaluare VARCHAR(90) = 'Testul 1';

IF @notNR1 != ANY
(SELECT nota FROM studenti_reusita
INNER JOIN discipline
ON discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
WHERE Disciplina = @disciplina AND Tip_Evaluare = @tipevaluare)
OR @notNR2 != ANY 
(SELECT nota FROM studenti_reusita
INNER JOIN discipline
ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
WHERE Disciplina = @disciplina AND Tip_Evaluare = @tipevaluare) 
BEGIN 
SELECT DISTINCT TOP (10) Nume_Student, Prenume_Student, Nota
FROM studenti
INNER JOIN studenti_reusita
ON studenti.Id_Student = studenti_reusita.Id_Student
INNER JOIN discipline
ON discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
WHERE Disciplina = @disciplina AND Tip_Evaluare = @tipevaluare AND nota NOT IN (@notNR1, @notNR2) 
END
ELSE PRINT 'THERE ARE NO MARKS EXCEPT 6 AND 8';

--3.Rezolvati aceesi sarcina, 1, apeland la structura selectiva CASE. 
DECLARE @N1 INT, @N2 INT, @N3 INT; 
DECLARE @MAI_MARE INT; 
SET @N1 = 60 * RAND(); 
SET @N2 = 60 * RAND(); 
SET @N3 = 60 * RAND(); 
 
SET @MAI_MARE = @N1;
SET @MAI_MARE =
CASE
WHEN @MAI_MARE < @N2 and @N2 > @N3 THEN @N2
WHEN @MAI_MARE < @N3 and @N2 < @N3 THEN @N3 
ELSE @N1
END

PRINT @N1; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

--4. Modificati exercitiile din sarcinile 1 si 2 pentru a include procesarea erorilor cu TRY si CATCH, si RAISERRROR.
--4.1
BEGIN TRY
DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT;
SET @N1 = 60 * RAND();
SET @N2 = 60 * RAND();
SET @N3 = 60 * RAND(); 

IF @N1 = @N2 RAISERROR('ERROR', 16,1);
ELSE IF @N1 > @N2 AND @N1 > @N3 SET @MAI_MARE = @N1
ELSE IF @N2 > @N1 AND @N2 > @N3 SET @MAI_MARE = @N2
ELSE IF @N3 > @N2 AND @N3 > @N1 SET @MAI_MARE = @N3

PRINT @N1; 
PRINT @N2; 
PRINT @N3; 
PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(20)); 
END TRY

BEGIN CATCH 
PRINT 'ERROR! SOMETHING WENT WRONG'
PRINT 'ERROR_LINE: ' + CAST(ERROR_LINE() AS VARCHAR(20)) 
PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR(20))
PRINT 'ERROR_SEVERITY: ' + CAST(ERROR_SEVERITY() AS VARCHAR(20))
PRINT 'ERROR_STATE: ' + CAST(ERROR_STATE() AS VARCHAR(20))
PRINT 'ERROR_MESSAGE: ' + CAST(ERROR_MESSAGE() AS VARCHAR(40))  
END CATCH 

--4.2
USE universitatea
DECLARE @notNR1 INT = 6;
DECLARE @notNR2 INT = 8;
DECLARE @disciplina VARCHAR(255) = 'Baze de date';
DECLARE @tipevaluare VARCHAR(90) = 'Testul 1';
DECLARE @studenti INT
SET @studenti = (SELECT COUNT(*)
FROM studenti s INNER JOIN studenti_reusita sr
ON s.Id_Student = sr.Id_Student
INNER JOIN discipline d
ON sr.Id_Disciplina = d.Id_Disciplina
WHERE Disciplina = @disciplina and Tip_Evaluare = @tipevaluare and nota not in (@notNR1, @notNR2))

BEGIN TRY
IF @studenti <= 10
RAISERROR('THERE ARE LESS STUDENTS THAN 10', 16, 1)
ELSE IF @notNR1 != ANY
(SELECT nota FROM studenti_reusita
INNER JOIN discipline
ON discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
WHERE Disciplina = @disciplina and Tip_Evaluare = @tipevaluare)
OR @notNR2 != ANY 
(SELECT nota FROM studenti_reusita
INNER JOIN discipline
ON discipline.Id_Disciplina= studenti_reusita.Id_Disciplina
WHERE Disciplina = @disciplina and Tip_Evaluare = @tipevaluare) 
BEGIN 
SELECT DISTINCT TOP (10) Nume_Student, Prenume_Student, Nota
FROM studenti
INNER JOIN studenti_reusita
ON studenti.Id_Student = studenti_reusita.Id_Student
INNER JOIN discipline
ON discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
WHERE Disciplina = @disciplina and Tip_Evaluare = @tipevaluare and nota not in (@notNR1, @notNR2) 
END
ELSE PRINT 'THERE ARE NO MARKS EXCEPT 6 AND 8';
END TRY

BEGIN CATCH
PRINT 'ERROR! SOMETHING WENT WRONG'
PRINT 'ERROR_LINE: ' + CAST(ERROR_LINE() AS VARCHAR(20)) 
PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR(20))
PRINT 'ERROR_SEVERITY: ' + CAST(ERROR_SEVERITY() AS VARCHAR(20))
PRINT 'ERROR_STATE: ' + CAST(ERROR_STATE() AS VARCHAR(20))
PRINT 'ERROR_MESSAGE: ' + CAST(ERROR_MESSAGE() AS VARCHAR(40)) 
END CATCH
