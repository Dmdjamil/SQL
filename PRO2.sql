CREATE DATABASE PRO2

USE PRO2


/* Table: PRODUITS                                           */
/*==============================================================*/
CREATE TABLE            PRODUITS (
   PRODUCTID         NUMERIC(6)                       NOT NULL,
   PRODUCTNAME        VARCHAR(40)                   NOT NULL,
   PRODUCTTYPE       VARCHAR(40)                       NOT NULL,
   PRICE    	 NUMERIC(9)                       NOT NULL,
   CONSTRAINT PK_PRODUITS  PRIMARY KEY (PRODUCTID),
  );
/*==============================================================*/
/* Table: CLIENT                                             */
/*==============================================================*/
CREATE TABLE            CLIENTS   (
   CUSTOMERID          VARCHAR(5)                         NOT NULL,
   CUSTOMERNAME              VARCHAR(40)                   NOT NULL,
   EMAIL            VARCHAR(60)                   NOT NULL,
   PHONE             NUMERIC(15)                    NOT NULL,
   CONSTRAINT PK_CLIENTS PRIMARY KEY (CUSTOMERID)
  );

/*==============================================================*/
/* Table: COMMANDES                                       */
/*==============================================================*/
CREATE TABLE            COMMANDES  (
   ORDERID         NUMERIC(6)                       NOT NULL,
   CUSTOMERID         VARCHAR(5)                         NOT NULL,
   ORDERDATE	         DATE                           NOT NULL,
   CONSTRAINT PK_COMMANDES  PRIMARY KEY (ORDERID),
   FOREIGN KEY (CUSTOMERID) REFERENCES CLIENTS (CUSTOMERID) ON DELETE NO ACTION ON UPDATE NO ACTION
    );
	
	
/*==============================================================*/
/* Table: COMMANDE_DETAILS                                */
/*==============================================================*/
CREATE TABLE           COMMANDE_DETAILS  (
   ORDERDETAILID       NUMERIC(6)                       NOT NULL,
   ORDERID        NUMERIC(6)                       NOT NULL,
   PRODUCTID     NUMERIC(8,2)                     NOT NULL,
   QUANTITY            NUMERIC(5)                       NOT NULL,
   CONSTRAINT PK_COMMANDE_DETAILS  PRIMARY KEY (ORDERDETAILID)
  );

/*==============================================================*/
/* Table : Types de prooduit                                */
/*==============================================================*/
CREATE TABLE PRUDUITTYPES (
	PRODUCTTYPEID NUMERIC(6)				NOT NULL,
	PRODUTTYPENAME VARCHAR (29)				NOT NULL
	CONSTRAINT PK_PRUDUITTYPES   PRIMARY KEY (PRODUCTTYPEID));

	/* Insertion des données */

INSERT INTO PRODUITS  VALUES  (1, 'WidgetA', 'Widget', 10.00);
INSERT INTO PRODUITS  VALUES  (2,'WidgetB','Widget',15.00);
INSERT INTO PRODUITS  VALUES  (3,'Gadget X','Gadget',20.00);
INSERT INTO PRODUITS  VALUES  (4,'Gaget Y','Gasdget',25.00);
INSERT INTO PRODUITS  VALUES  (5,'Machin Z','Machin Z',30.00);

INSERT INTO CLIENTS  VALUES  (1, 'John Smith', 'John@exemple.com', 123-456-7890);
INSERT INTO CLIENTS  VALUES  (2, 'Jane Doe', 'jane.doe@example.com', 987-654-3210);
INSERT INTO CLIENTS  VALUES  (3, 'Alice Brown', 'Alice.brown@example.com', 456-789-0123);


INSERT INTO COMMANDES  VALUES  (102,2,'2024-05-02');
INSERT INTO COMMANDES  VALUES  (101,1,'2024-05-01');
INSERT INTO COMMANDES  VALUES  (103, 3, '2024-05-01');



INSERT INTO COMMANDE_DETAILS  VALUES  (1, 101,1, 2);
INSERT INTO COMMANDE_DETAILS  VALUES  (2, 101,3, 1);
INSERT INTO COMMANDE_DETAILS  VALUES  (3, 102,2, 3);
INSERT INTO COMMANDE_DETAILS  VALUES  (4, 102,4, 2);
INSERT INTO COMMANDE_DETAILS  VALUES  (5, 103,5, 1);

INSERT INTO PRUDUITTYPES  VALUES  (1, 'Widget');
INSERT INTO PRUDUITTYPES  VALUES  (2, 'Gadget');
INSERT INTO PRUDUITTYPES  VALUES  (3, 'Doochikey');

/* Instruction 1 : Récupérer tous les produits.*/

SELECT *
FROM PRODUITS

/* Instruction 2 : Récupérer tous les Clients*/

SELECT *
FROM CLIENTS

/* Instruction 3 : Récupérer tous les COMMANDES */

SELECT *
FROM COMMANDES

/* Instruction 4 : Récupérer tous les Details commandes*/

SELECT *
FROM COMMANDE_DETAILS

/* Instruction 5 : Récupérer tous les types de prduit*/

SELECT *
FROM PRUDUITTYPES


/* Instruction 6 : Récupérez les noms des produits qui ont été commandés par au moins un client, 
ainsi que la quantité totale de chaque produit commandé.*/

SELECT P.PRODUCTNAME, SUM(CD.Quantity) AS TotalQuantityOrdered
FROM PRODUITS P
JOIN COMMANDE_DETAILS CD ON P.ProductID = CD.ProductID
GROUP BY P.ProductName
HAVING SUM(CD.Quantity) > 0;

/* Instrution 7: Récupérez les noms des clients qui ont passé une commande chaque jour de la semaine, 
ainsi que le nombre total de commandes passées par chaque client.*/

SELECT C.CUSTOMERNAME, COUNT(DISTINCT CM.ORDERID) AS TQOrder
FROM CLIENTS C
JOIN COMMANDES CM ON CM.CUSTOMERID = C.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CD.ORDERID = CM.ORDERID
GROUP BY C.CUSTOMERNAME
HAVING  COUNT(DISTINCT DATEPART(WEEKDAY, CM.ORDERDATE)) = 7;

/*Récupérez les noms des clients ayant passé le plus de commandes, 
ainsi que le nombre total de commandes passées par chaque client.*/

SELECT C.CUSTOMERNAME, COUNT(CD.QUANTITY) AS TotalOrders
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CD.ORDERID = CM.ORDERID
GROUP BY C.CUSTOMERNAME
ORDER BY TotalOrders DESC;

/*Récupérez les noms des produits qui ont été le plus commandés, 
ainsi que la quantité totale de chaque produit commandé.*/

SELECT P.PRODUCTNAME, SUM(CD.Quantity) AS TotalQuantityOrdered
FROM PRODUITS P
JOIN COMMANDE_DETAILS CD ON P.ProductID = CD.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantityOrdered DESC;


/*Récupérer les noms des clients ayant passé commande pour au moins un widget*/

SELECT DISTINCT C.CustomerName
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CM.ORDERID = CD.ORDERID
JOIN PRODUITS P ON CD.PRODUCTID = P.PRODUCTID
WHERE P.PRODUCTTYPE = 'WIDGET';

/*Récupérez les noms des clients ayant passé commande d'au moins un widget et d'au moins un gadget,
ainsi que le coût total des widgets et gadgets commandés par chaque client.*/

SELECT C.CustomerName, SUM(CASE 
WHEN P.ProductType = 'WIDGET' THEN CD.Quantity * P.Price 
WHEN P.ProductType = 'GADGET' THEN CD.Quantity * P.Price 
ELSE 0 
END) AS TotalCost
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CM.OrderID = CD.OrderID
JOIN PRODUITS P ON CD.ProductID = P.ProductID
WHERE P.ProductType IN ('WIDGET', 'GADGET')
GROUP BY C.CustomerName
HAVING COUNT(DISTINCT CASE WHEN P.ProductType = 'WIDGET' THEN P.ProductID END) > 0
AND COUNT(DISTINCT CASE WHEN P.ProductType = 'GADGET' THEN P.ProductID END) > 0;

/*Récupérez les noms des clients ayant passé commande d'au moins un gadget, 
ainsi que le coût total des gadgets commandés par chaque client.*/

SELECT C.CustomerName, SUM(CD.Quantity * P.Price) AS TotalGadgetCost
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CM.OrderID = CD.OrderID
JOIN PRODUITS P ON CD.ProductID = P.ProductID
WHERE P.ProductType = 'GADGET'
GROUP BY C.CustomerName
HAVING SUM(CD.Quantity) > 0;

/*Récupérez les noms des clients ayant passé commande d'au moins un bidule,
ainsi que le coût total des bidules commandés par chaque client.*/

SELECT C.CustomerName, SUM(CD.Quantity * P.PRICE) AS TotalBiduleCost
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CM.ORDERID= CD.ORDERID
JOIN PRODUITS P ON CD.PRODUCTID = P.PRODUCTID
WHERE P.ProductType = 'doochikey'
GROUP BY C.CUSTOMERNAME
HAVING SUM(CD.Quantity) > 0;


/*Récupérez les noms des clients qui ont passé une commande chaque jour de la semaine,
ainsi que le nombre total de commandes passées par chaque client.*/

SELECT C.CUSTOMERNAME, COUNT(CM.OrderID) AS TotalOrders
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
GROUP BY C.CustomerName
HAVING COUNT(DISTINCT DATEPART(WEEKDAY, CM.ORDERDATE)) = 7;

/*Récupérez le nombre total de widgets et de gadgets commandés par chaque client, ainsi que le coût total des commandes.*/
SELECT C.CustomerName, 
       SUM(CASE WHEN P.ProductType = 'WIDGET' THEN CD.Quantity ELSE 0 END) AS TotalWidgets,
       SUM(CASE WHEN P.ProductType = 'GADGET' THEN CD.Quantity ELSE 0 END) AS TotalGadgets,
       SUM(CASE WHEN P.ProductType IN ('WIDGET', 'GADGET') THEN CD.Quantity * P.Price ELSE 0 END) AS TotalCost
FROM CLIENTS C
JOIN COMMANDES CM ON C.CUSTOMERID = CM.CUSTOMERID
JOIN COMMANDE_DETAILS CD ON CM.ORDERID= CD.ORDERID
JOIN PRODUITS P ON CD.PRODUCTID = P.PRODUCTID
WHERE P.ProductType IN ('WIDGET', 'GADGET')
GROUP BY C.CustomerName;






