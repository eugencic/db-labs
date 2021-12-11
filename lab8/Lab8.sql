--1. Sa se creeze doua viziuni in baza interogarilor formulate in doua exercitii indicate din capitolul 4. 
--Prima viziune sa fie construita in Editorul de interogari, iar a doua, utilizand View Designer.

-- Ex.13
CREATE VIEW View_2 AS
SELECT d.Id_Disciplina, d.Disciplina 
FROM studenti.studenti_reusita sr 
INNER JOIN studenti.studenti s 
ON sr.Id_Student = s.Id_Student
INNER JOIN plan_studii.discipline d 
ON sr.Id_Disciplina = d.Id_Disciplina 
WHERE s.Nume_Student = 'Florea' AND s.Prenume_Student ='Ioan';

SELECT * FROM View_2

--2. Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor
--create. Sa se adauge comentariile respective referitoare la rezultatele executarii acestor
--instructiuni.

--2.1
--INSERT
INSERT INTO View_1(Id_Student, Nume_Student, Prenume_Student)
VALUES(450, 'Popa', 'Eugeniu')

--UPDATE
UPDATE View_1
SET Nume_Student = 'Ionel'
WHERE Nume_Student = 'Ionut'

--DELETE
DELETE FROM View_1
WHERE Nume_Student = 'Ghimpu'
--The DELETE statement will not work here, because it is not possible, while the table has refference with "studenti_reusita" table.

--2.2
--INSERT
INSERT INTO View_2(Id_Disciplina, Disciplina) 
VALUES(40, 'Stiinte aplicate')

--UPDATE
UPDATE View_2
SET Disciplina = 'Sisteme de calcul'
WHERE Disciplina = 'Sisteme de calculare'

--DELETE
DELETE FROM View_2
WHERE Disciplina = 'Stiinte aplicate'

--3. Sa se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in asa fel, incat sa nu fie posibila modificarea sau stergerea
--tabelelor pe care acestea sunt definite si viziunile sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satisfacute.

--3.1
ALTER VIEW View_1
WITH SCHEMABINDING AS
(SELECT s.Nume_Student, s.Prenume_Student 
FROM studenti.studenti s 
WHERE s.Nume_Student LIKE '%u')
WITH CHECK OPTION;

--3.2
ALTER VIEW View_2
WITH SCHEMABINDING AS 
(SELECT d.Id_Disciplina, d.Disciplina 
FROM studenti.studenti_reusita sr 
INNER JOIN studenti.studenti s 
ON sr.Id_Student = s.Id_Student
INNER JOIN plan_studii.discipline d 
ON sr.Id_Disciplina = d.Id_Disciplina
WHERE s.Nume_Student = 'Florea' AND s.Prenume_Student ='Ioan')
WITH CHECK OPTION;

--4. Sa se scrie instructiunile de testare a proprietatilor noi definite.

SELECT * FROM View_1
SELECT * FROM View_2

INSERT INTO View_1(Id_Student, Nume_Student, Prenume_Student)
VALUES(452, 'Popa', 'Dorin')

INSERT INTO View_2(Id_Disciplina, Disciplina) 
VALUES(45, 'Stiinte aplicate')

--5. Sa se rescrie 2 interogari formulate in exercitiile din capitolul 4, in asa fel,
--incat interogarile imbricate sa fie redate sub forma expresiilor CTE.

--5.1
WITH CTE1
AS(SELECT s.Nume_Student, s.Prenume_Student FROM studenti.studenti s 
WHERE s.Nume_Student LIKE '%u')

SELECT * FROM CTE1;

--5.2
WITH CTE2
AS(SELECT d.Id_Disciplina, d.Disciplina  
FROM studenti.studenti_reusita sr 
INNER JOIN studenti.studenti s 
ON sr.Id_Student = s.Id_Student
INNER JOIN plan_studii.discipline d 
ON sr.Id_Disciplina = d.Id_Disciplina
WHERE s.Nume_Student = 'Florea' AND s.Prenume_Student ='Ioan')

SELECT * FROM CTE2;

--6. Se considera un graf orientat, precum cel din figura de mai jos si fie se doreste parcursa calea de la nodul id = 3 la nodul unde id = 0. Sa se faca reprezentarea grafului 
--orientat in forma de expresie-tabel recursiv. Sa se observe instructiunea de dupa UNION ALL a membrului recursiv, precum si partea de pana la UNION ALL reprezentata de membrul-ancora. 

DECLARE @Graph_tab TABLE
(
ID INT, 
prev_ID INT
)

INSERT @Graph_tab
SELECT 5, NULL UNION ALL
SELECT 4, NULL UNION ALL
SELECT 3, NULL UNION ALL
SELECT 2, 4 UNION ALL
SELECT 2, 3 UNION ALL
SELECT 1, 2 UNION ALL
SELECT 0, 5 UNION ALL
SELECT 0, 1;

WITH graph_ex6
AS
(SELECT *, 0 AS generation FROM @Graph_tab WHERE ID = 3
UNION ALL
SELECT graph. *, generation + 1
FROM @Graph_tab AS graph
INNER JOIN graph_ex6
ON graph.prev_ID = graph_ex6.ID)

SELECT * FROM graph_ex6;
