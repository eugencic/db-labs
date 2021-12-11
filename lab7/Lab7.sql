--6. Creati, in baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii si studenti. Transferati tabelul profesori din 
--schema dbo in schema cadre didactice, tinand cont de dependentelor definite asupra tabelului mentionat. in acelasi mod sa se trateze 
--tabelele orarul, discipline care apartin schemei plan_studii si tabelele studenti, studenti_reusita, care apartin schemei studenti. 
--Se scrie instructiunile SQL respective. 

ALTER SCHEMA cadre_didactice TRANSFER dbo.profesori

ALTER SCHEMA plan_studii TRANSFER dbo.orarul

ALTER SCHEMA plan_studii TRANSFER dbo.discipline

ALTER SCHEMA studenti TRANSFER dbo.studenti

ALTER SCHEMA studenti TRANSFER dbo.studenti_reusita


--SELECT * FROM studenti.studenti_reusita
--SELECT * FROM studenti.studenti
--SELECT * FROM plan_studii.discipline
--SELECT * FROM  cadre_didactice.profesori;

--7. Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele
--tabelelor accesate sa fie descrise in mod explicit, tinand cont de faptul ca tabelele au fost mutate in scheme noi.

-- Ex.2

SELECT Disciplina FROM plan_studii.discipline d
ORDER BY d.Nr_ore_plan_disciplina DESC ;

-- Ex.4
SELECT Disciplina FROM plan_studii.discipline d
WHERE LEN(Disciplina) > 20;

-- Ex.6
SELECT TOP(5) Nume_Student, Prenume_Student 

FROM studenti.studenti_reusita sr INNER JOIN plan_studii.discipline d ON sr.Id_Disciplina = d.Id_Disciplina
			INNER JOIN studenti.studenti s ON s.Id_Student = sr.Id_Student 

WHERE sr.Tip_Evaluare = 'Testul 2' AND sr.Nota IS NOT NULL AND d.Disciplina = 'Baze de date '  
ORDER BY Nota DESC

--8. Creati sinonimele respective pentru a simplifica interogarile construite in exercitiul precedent 
--si reformulati interogarile, folosind sinonimele create.

CREATE SYNONYM Discipline
FOR universitatea.plan_studii.discipline

CREATE SYNONYM Studenti_Reusita 
FOR universitatea.studenti.studenti_reusita

CREATE SYNONYM Studenti
FOR universitatea.studenti.studenti

CREATE SYNONYM Profesori
FOR universitatea.cadre_didactice.profesori 

-- Ex.2

SELECT Disciplina FROM Discipline d
ORDER BY d.Nr_ore_plan_disciplina DESC ;

-- Ex.4
SELECT Disciplina FROM Discipline d 
WHERE LEN(Disciplina) > 20;

-- Ex.6
SELECT TOP(5) Nume_Student, Prenume_Student 

FROM Studenti_reusita sr INNER JOIN Discipline d ON sr.Id_Disciplina = d.Id_Disciplina
			INNER JOIN Studenti s ON s.Id_Student = sr.Id_Student 

WHERE sr.Tip_Evaluare = 'Testul 2' AND sr.Nota IS NOT NULL AND d.Disciplina = 'Baze de date '  
ORDER BY Nota DESC

