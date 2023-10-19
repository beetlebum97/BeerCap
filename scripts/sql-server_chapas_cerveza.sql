-- CREAR BASE DE DATOS

CREATE DATABASE CHAPAS_CERVEZA
GO

USE CHAPAS_CERVEZA
GO

-- [CREATE TABLE] >> CREAR TABLAS
-- URL es una palabra reservada. Como nombre de columna debe estar entre corchetes [].
-- Nombre de columna con espacios debe estar entre corchetes [].

-- [BULK INSERT] >> IMPORTAR/INSERTAR REGISTROS
-- BULK INSERT: ¡Indicar directorio de los archivos csv!

-- 1. Tabla Fabricantes_Chapa

CREATE TABLE Fabricantes_Chapa(
	ID int PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE,
	Empresa nvarchar(255) NULL,
	País nvarchar(255) NULL,
	[URL] nvarchar(255) NULL
)
GO

BULK INSERT Fabricantes_Chapa
FROM '\\directorio\\fabricantes.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

-- 2. Tabla Productores_Cerveza

CREATE TABLE Productores_Cerveza(
	ID int PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE,
	País nvarchar(255) NULL,
	Región nvarchar(255) NULL,
	Ciudad nvarchar(255) NULL,
	Fundación int NULL,
	[URL] nvarchar(255) NULL,
	[Empresa matriz] nvarchar(255) NULL 
)
GO

BULK INSERT Productores_Cerveza
FROM '\\directorio\\productores.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

-- 3. Tabla Cervezas

CREATE TABLE Cervezas(
	ID int PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE,
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

BULK INSERT Cervezas
FROM '\\directorio\\cervezas.csv' 
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

-- 4. Tabla Chapas

CREATE TABLE Chapas(
	ID int PRIMARY KEY,
	Cerveza nvarchar(255), 
	Año int NOT NULL,
	Color nvarchar(255) NOT NULL,
	Fabricante nvarchar(255),
	Obturador nvarchar(255) NULL,
	Inscripción nvarchar(255) NULL, 
	Estado nvarchar(255) CHECK (Estado IN('Perfecto','Bueno','Regular','Malo')),
	Repetida nvarchar(255) CHECK (Repetida IN('SI','NO')),
	Formato nvarchar(255) CHECK (Formato IN('25cl','33cl','50cl')),
	Registro datetime DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Fabricante) REFERENCES Fabricantes_Chapa (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
) 
GO

BULK INSERT Chapas
FROM '\\directorio\\chapas.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

-- 5. Tabla Catas

CREATE TABLE Catas(
	ID int PRIMARY KEY,
	Cerveza nvarchar(255),
	[Nota de Cata] nvarchar(255) NOT NULL,	
	Sabor nvarchar(255) CHECK (Sabor IN('Excelente','Bueno','Aceptable','Regular','Malo')),
	Puntos int NOT NULL,
	Fecha date DEFAULT '2019-01-15',

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
)
GO

BULK INSERT Catas
FROM '\\directorio\\catas.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)
GO

-- REGISTROS DE CADA TABLA

SELECT A.Nombre AS Fabricantes_Chapa, B.Nombre AS Productores_Cerveza, C.Nombre AS Cervezas, D.ID AS Chapas, E.Cerveza AS Catas
FROM (SELECT COUNT(FC.Nombre) AS Nombre FROM Fabricantes_Chapa FC) A
CROSS JOIN (SELECT COUNT(PC.Nombre) AS Nombre FROM Productores_Cerveza PC) B
CROSS JOIN (SELECT COUNT(C.Nombre) AS Nombre FROM Cervezas C) C
CROSS JOIN (SELECT COUNT(CH.ID) AS ID FROM Chapas CH) D
CROSS JOIN (SELECT COUNT(CT.Cerveza) AS Cerveza FROM Catas CT) E
GO