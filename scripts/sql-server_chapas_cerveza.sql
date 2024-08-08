-- [[0. CREAR  Y USAR BASE DE DATOS]]

CREATE DATABASE CHAPAS_CERVEZA
GO

USE CHAPAS_CERVEZA
GO

-- [[1. CREAR TABLAS]]
-- URL es una palabra reservada. Como nombre de columna debe estar entre corchetes [].
-- Nombre de columna con espacios debe estar entre corchetes [].

-- 1.1 TABLA FABRICANTES_CHAPA

CREATE TABLE Fabricantes_Chapa(
	ID int PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE,
	Empresa nvarchar(255) NULL,
	País nvarchar(255) NULL,
	[URL] nvarchar(255) NULL,
	Imagen nvarchar(255) NULL
)
GO

-- 1.2 TABLA PRODUCTORES_CERVEZA

CREATE TABLE Productores_Cerveza(
	ID int PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE,
	País nvarchar(255) NULL,
	Región nvarchar(255) NULL,
	Ciudad nvarchar(255) NULL,
	Fundación int NULL,
	[URL] nvarchar(255) NULL,
	[Empresa matriz] nvarchar(255)
)
GO

-- 1.3 TABLA CERVEZAS
-- Columna Grado: delimitador decimal tiene que ser . en lugar de ,

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

-- 1.4 TABLA CHAPAS

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
	Formato nvarchar(255) CHECK (Formato IN('20cl','25cl','33cl','50cl')),
	Registro datetime DEFAULT CURRENT_TIMESTAMP,
	Imagen nvarchar(255),

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Fabricante) REFERENCES Fabricantes_Chapa (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
) 
GO

-- 1.5 TABLA CATAS

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

-- [[2. INSERTAR DATOS]]
-- Definir @directorio
-- BULK INSERT >> Importar/insertir registros

-- 2.1 DECLARAR VARIABLES

DECLARE @directorio nvarchar(255)
SET @directorio = N'D:\\db_chapas_cerveza_dev\\data\\'

DECLARE @archivo nvarchar(255)
DECLARE @rutacompleta nvarchar(255)
DECLARE @sql nvarchar(max)

-- 2.2 DATOS TABLA FABRICANTES_CHAPA
-- Construir consulta dinámica (Bulk insert no permite utilizar directamente una variable en FROM)

SET @archivo = N'fabricantes.csv'
SET @rutacompleta = @directorio + @archivo

SET @sql = N'BULK INSERT Fabricantes_Chapa
FROM ''' + @rutacompleta + N'''
WITH (
    FORMAT = ''CSV'',
    FIELDTERMINATOR = '';'',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = 2,
    CODEPAGE=''65001''
)'

-- Ejecutar consulta dinámica

EXEC sp_executesql @sql

-- 2.3 DATOS TABLA PRODUCTORES_CERVEZA
-- Actualizar variable archivo y rutacompleta
-- Construir consulta dinámica (Bulk insert no permite utilizar directamente una variable en FROM)

SET @archivo = N'productores.csv'
SET @rutacompleta = @directorio + @archivo

SET @sql = N'BULK INSERT Productores_Cerveza
FROM ''' + @rutacompleta + N'''
WITH (
    FORMAT = ''CSV'',
    FIELDTERMINATOR = '';'',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = 2,
    CODEPAGE=''65001''
)'

-- Ejecutar la consulta dinámica

EXEC sp_executesql @sql

-- 2.4 DATOS TABLA CERVEZAS
-- Actualizar variable archivo y rutacompleta
-- Construir consulta dinámica (Bulk insert no permite utilizar directamente una variable en FROM)

SET @archivo = N'cervezas.csv'
SET @rutacompleta = @directorio + @archivo

SET @sql = N'BULK INSERT Cervezas
FROM ''' + @rutacompleta + N'''
WITH (
    FORMAT = ''CSV'',
    FIELDTERMINATOR = '';'',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = 2,
    CODEPAGE=''65001''
)'

-- Ejecutar la consulta dinámica

EXEC sp_executesql @sql


-- 2.5 DATOS TABLA CHAPAS
-- Actualizar variable archivo y rutacompleta
-- Construir consulta dinámica (Bulk insert no permite utilizar directamente una variable en FROM)

SET @archivo = N'chapas.csv'
SET @rutacompleta = @directorio + @archivo

SET @sql = N'BULK INSERT Chapas
FROM ''' + @rutacompleta + N'''
WITH (
    FORMAT = ''CSV'',
    FIELDTERMINATOR = '';'',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = 2,
    CODEPAGE=''65001''
)'

-- Ejecutar la consulta dinámica

EXEC sp_executesql @sql

-- 2.6 DATOS TABLA CATAS
-- Actualizar variable archivo y rutacompleta
-- Construir consulta dinámica (Bulk insert no permite utilizar directamente una variable en FROM)

SET @archivo = N'catas.csv'
SET @rutacompleta = @directorio + @archivo

SET @sql = N'BULK INSERT Catas
FROM ''' + @rutacompleta + N'''
WITH (
    FORMAT = ''CSV'',
    FIELDTERMINATOR = '';'',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = 2,
    CODEPAGE=''65001''
)'

-- Ejecutar la consulta dinámica

EXEC sp_executesql @sql
GO

-- [[3. REGISTROS DE CADA TABLA]]

SELECT A.Nombre AS Fabricantes_Chapa, B.Nombre AS Productores_Cerveza, C.Nombre AS Cervezas, D.ID AS Chapas, E.Cerveza AS Catas
FROM (SELECT COUNT(FC.Nombre) AS Nombre FROM Fabricantes_Chapa FC) A
CROSS JOIN (SELECT COUNT(PC.Nombre) AS Nombre FROM Productores_Cerveza PC) B
CROSS JOIN (SELECT COUNT(C.Nombre) AS Nombre FROM Cervezas C) C
CROSS JOIN (SELECT COUNT(CH.ID) AS ID FROM Chapas CH) D
CROSS JOIN (SELECT COUNT(CT.Cerveza) AS Cerveza FROM Catas CT) E
GO