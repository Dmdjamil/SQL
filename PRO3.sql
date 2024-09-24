/*Conversion du diagramme en un mod�le relationnel
Bas� sur le diagramme entit�-relation, voici le mod�le relationnel avec les trois tables : wine, producer, et harvest.

wine (Vin) :

NumW : Cl� primaire.
Category : Cat�gorie de vin.
Year : Ann�e de production.
Degree : Degr� d'alcool.
producer (Producteur) :

NumP : Cl� primaire.
FirstName : Pr�nom.
LastName : Nom.
Region : R�gion du producteur.
harvest (R�colte) :

NumW : Cl� �trang�re vers la table wine.
NumP : Cl� �trang�re vers la table producer.
Quantity : Quantit� de vin r�colt�.
*/

/*--------------------------------------------------------*/
/*---------------------------------------------------------*/
/*�tape 2 : Impl�mentation du mod�le relationnel � l'aide de SQL
Cr�ation des tables :*/

CREATE DATABASE PROJ3

USE PROJ3

CREATE TABLE win (
    NumW NUMERIC PRIMARY KEY,
    Category VARCHAR(50),
    ProductYear INT,
    Degree NUMERIC
);


CREATE TABLE producteur (
    NumP NUMERIC PRIMARY KEY,
    FirstName VARCHAR(80),
    LastName VARCHAR(80),
    Region VARCHAR(80)
);

CREATE TABLE harvest (
    NumW NUMERIC,
    NumP NUMERIC,
    Quantity NUMERIC,
    PRIMARY KEY (NumW, NumP),
    FOREIGN KEY (NumW) REFERENCES win(NumW),
    FOREIGN KEY (NumP) REFERENCES producteur(NumP)
);

/*Etape 3 : Insertion des donn�es dans les tables
Ins�rer des donn�es dans la table wine :*/


INSERT INTO win (NumW, Category, ProductYear, Degree) VALUES
(1, 'Rouge', 2019, 13.5),
(2, 'Blanc', 2020, 12.0),
(3, 'Rose', 2018, 11.5),
(4, 'Red', 2021, 14.0),
(5, 'Sparkling', 2017, 10.5),
(6, 'Blanc', 2019, 12.5),
(7, 'Rouge', 2022, 13.0),
(8, 'Rose', 2020, 11.0),
(9, 'Rouge', 2018, 12.0),
(10, 'Sparkling', 2019, 10.0),
(11, 'Blanc', 2021, 11.5),
(12, 'Rouge', 2022, 15.0);

/*Ins�rer des donn�es dans la table producteur */

INSERT INTO producteur(NumP, FirstName, LastName, Region) VALUES
(1, 'John', 'Smith', 'Sousse'),
(2, 'Emma', 'Johnson', 'Tunis'),
(3, 'Michael', 'Williams', 'Sfax'),
(4, 'Emily', 'Brown', 'Sousse'),
(5, 'James', 'Jones', 'Sousse'),
(6, 'Sarah', 'Davis', 'Tunis'),
(7, 'David', 'Miller', 'Sfax'),
(8, 'Olivia', 'Wilson', 'Monastir'),
(9, 'Daniel', 'Moore', 'Sousse'),
(10, 'Sophia', 'Taylor', 'Tunis'),
(11, 'Matthieu', 'Anderson', 'Sfax'),
(12, 'Am�lia', 'Thomas', 'Sousse');

/*Ins�rer des donn�es dans la table harvest :*/

INSERT INTO harvest (NumW, NumP, Quantity) VALUES
(1, 1, 100),
(2, 2, 200),
(3, 3, 150),
(4, 4, 120),
(5, 5, 180),
(6, 6, 220),
(7, 7, 170),
(8, 8, 130),
(9, 9, 300),
(10, 10, 90),
(11, 11, 110),
(12, 12, 320);


/*-------------------------------------------*/
/*Etape 4 : Requ�tes SQL pour r�pondre aux questions*/
/*-------------------------------------------*/
/*1. R�cup�rer une liste de tous les producteurs */

SELECT *
FROM producteur

/*2. R�cup�rer une liste tri�e de producteurs par nom */

SELECT *
FROM producteur
Order by LastName

/* 3. R�cup�rer une liste de producteurs de Sousse */

SELECT * FROM producteur
WHERE Region = 'Sousse';

/*4. Calculer la quantit� totale de vin produite avec le num�ro de vin 12*/ 

SELECT SUM(Quantity) AS TotalQuantity
FROM harvest
WHERE NumW = 12;

/*5. Calculer la quantit� de vin produite pour chaque cat�gorie :*/

SELECT w.Category, SUM(h.Quantity) AS TotalQuantity
FROM harvest h
JOIN win w ON h.NumW = w.NumW
GROUP BY w.Category;


/*6. Retrouver les producteurs de la r�gion de Sousse 
ayant r�colt� au moins un vin en quantit� sup�rieure � 300 litres. 
Affichez leurs noms et pr�noms, class�s par ordre alphab�tique */

SELECT p.FirstName, p.LastName
FROM producteur p
JOIN harvest h ON p.NumP = h.NumP
WHERE p.Region = 'Sousse' AND h.Quantity > 300
ORDER BY p.LastName, p.FirstName;

/* 7.Citer les num�ros de vins avec un degr� sup�rieur � 12, produits par le producteur num�ro 24 */

SELECT w.NumW
FROM harvest h
JOIN win w ON h.NumW = w.NumW
WHERE h.NumP = 24 AND w.Degree > 12;

/*8. Trouver le producteur qui a produit la plus grande quantit� de vin */

SELECT TOP 1 p.FirstName, p.LastName, SUM(h.Quantity) AS TotalQuantity 
FROM producteur p
JOIN harvest h ON p.NumP = h.NumP
GROUP BY p.FirstName, p.LastName
ORDER BY TotalQuantity DESC ;

/* 9. Trouver le degr� moyen de vin produit */

SELECT AVG(Degree) AS AvgDegree
FROM win;

/*10. Trouver le vin le plus ancien de la base de donn�es :*/

SELECT TOP 1 NumW
FROM win
ORDER BY ProductYear ASC;

/* 11. R�cup�rer une liste de producteurs ainsi que la quantit� totale de vin qu'ils ont produite*/

SELECT p.FirstName, p.LastName, SUM(h.Quantity) AS TotalQuantity
FROM producteur p
JOIN harvest h ON p.NumP = h.NumP
GROUP BY p.FirstName, p.LastName;

/*12. R�cup�rer une liste de vins ainsi que les coordonn�es de leurs producteurs :*/

SELECT w.NumW, w.Category, w.ProductYear, w.Degree, p.FirstName, p.LastName, p.Region
FROM win w
JOIN harvest h ON w.NumW = h.NumW
JOIN producteur p ON h.NumP = p.NumP;
