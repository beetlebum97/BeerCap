-- CREAR BASE DE DATOS

CREATE DATABASE CHAPAS_CERVEZA
GO

USE CHAPAS_CERVEZA
GO

-- CREAR TABLAS
-- URL es una palabra reservada. Como nombre de columna debe estar entre corchetes [].
-- Nombre de columna con espacios debe estar entre corchetes [].

CREATE TABLE Fabricantes_Chapa(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Nombre nvarchar(255) NOT NULL UNIQUE,
	Empresa nvarchar(255) NULL,
	País nvarchar(255) NULL,
	[URL] nvarchar(255) NULL   
)
GO

CREATE TABLE Productores_Cerveza(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Nombre nvarchar(255) NOT NULL UNIQUE,
	País nvarchar(255) NULL,
	Región nvarchar(255) NULL,
	Ciudad nvarchar(255) NULL,
	Fundación int NULL,
	[URL] nvarchar(255) NULL,
	[Empresa matriz] nvarchar(255) NULL 
)
GO

CREATE TABLE Cervezas(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE NOT NULL,
	Tipo nvarchar(255) NULL,
	Estilo nvarchar(255) NULL,
	Grado decimal(4,2) NULL,
	IBU int NULL,
	Lanzamiento int NULL,
	Estado nvarchar(255) CHECK (Estado IN('Activa','Retirada')),
	País nvarchar(255) NULL,
	[URL] nvarchar(255) NULL,
	Productor nvarchar(255),

    FOREIGN KEY (Productor) REFERENCES Productores_Cerveza (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
)
GO

CREATE TABLE Chapas(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Cerveza nvarchar(255), 
	Año int NULL,
	Color nvarchar(255) NOT NULL,
	Fabricante nvarchar(255),
	Obturador nvarchar(255) NULL,
	Símbolo nvarchar(255), 
	Estado nvarchar(255) CHECK (Estado IN('Perfecto','Bueno','Regular','Malo')),
	Repetida nvarchar(255) CHECK (Repetida IN('SI','NO')),
	Registro datetime DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Fabricante) REFERENCES Fabricantes_Chapa (Nombre) ON UPDATE CASCADE ON DELETE CASCADE

) 
GO

CREATE TABLE Catas(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Cerveza nvarchar(255),
	[Nota de Cata] nvarchar(255) NULL,	
	Sabor nvarchar(255) CHECK (Sabor IN('Excelente','Bueno','Aceptable','Regular','Malo')),
	Puntos int NULL,
	Fecha date DEFAULT '2019-01-15',

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
) 
GO

-- IMPORTAR/INSERTAR REGISTROS
-- BULK INSERT: ¡Indicar directorio de los archivos csv!

SELECT Nombre,Empresa,País,[URL] INTO #Temporal FROM Fabricantes_Chapa
GO

BULK INSERT #Temporal
FROM 'directorio\fabricantes.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

INSERT INTO Fabricantes_Chapa (Nombre,Empresa,País,[URL]) SELECT * FROM #Temporal
GO

SELECT Nombre,País,Región,Ciudad,Fundación,[URL],[Empresa matriz] INTO #Temporal2 FROM Productores_Cerveza
GO

BULK INSERT #Temporal2
FROM 'directorio\productores.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

INSERT INTO Productores_Cerveza (Nombre,País,Región,Ciudad,Fundación,[URL],[Empresa matriz]) SELECT * FROM #Temporal2
GO

SELECT Nombre,Tipo,Estilo,CAST(Grado as nvarchar)AS 'Grado',IBU,Lanzamiento,Estado,País,[URL],Productor INTO #Temporal3 FROM Cervezas
GO

BULK INSERT #Temporal3
FROM 'directorio\cervezas.csv' 
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

-- REPLACE(): Sustituir delimitador decimal en el archivo csv. Cambiar (,) por (.)

INSERT INTO Cervezas (Nombre,Tipo,Estilo,Grado,IBU,Lanzamiento,Estado,País,[URL],Productor) 
SELECT Nombre,Tipo,Estilo,REPLACE(Grado,',','.') AS 'Grado',IBU,Lanzamiento,Estado,País,[URL],Productor FROM #Temporal3
GO

SELECT Cerveza,Año,Color,Fabricante,Obturador,Símbolo,Estado,Repetida INTO #Temporal4 FROM Chapas
GO

BULK INSERT #Temporal4
FROM 'directorio\chapas.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

INSERT INTO Chapas(Cerveza,Año,Color,Fabricante,Obturador,Símbolo,Estado,Repetida) SELECT * FROM #Temporal4
GO

SELECT Cerveza,[Nota de Cata],Sabor,Puntos,Fecha INTO #Temporal5 FROM Catas
GO

BULK INSERT #Temporal5
FROM 'directorio\catas.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

INSERT INTO Catas (Cerveza,[Nota de Cata],Sabor,Puntos,Fecha) SELECT * FROM #Temporal5
GO

-- REGISTROS DE CADA TABLA

SELECT A.Nombre AS Fabricantes_Chapa, B.Nombre AS Productores_Cerveza, C.Nombre AS Cervezas, D.ID AS Chapas, E.Cerveza AS Catas
FROM (SELECT COUNT(FC.Nombre) AS Nombre FROM Fabricantes_Chapa FC) A
CROSS JOIN (SELECT COUNT(PC.Nombre) AS Nombre FROM Productores_Cerveza PC) B
CROSS JOIN (SELECT COUNT(C.Nombre) AS Nombre FROM Cervezas C) C
CROSS JOIN (SELECT COUNT(CH.ID) AS ID FROM Chapas CH) D
CROSS JOIN (SELECT COUNT(CT.Cerveza) AS Cerveza FROM Catas CT) E
GO