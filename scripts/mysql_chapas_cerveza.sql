-- CREAR BASE DE DATOS

CREATE DATABASE CHAPAS_CERVEZA;

USE CHAPAS_CERVEZA;

-- CREAR TABLAS
-- Nombres de columnas con espacios en blanco: `nombre columna`.

CREATE TABLE Fabricantes_Chapa(
	ID int AUTO_INCREMENT PRIMARY KEY,
	Nombre nvarchar(255) NOT NULL UNIQUE,
	Empresa nvarchar(255) NULL,
	País nvarchar(255) NULL,
	URL nvarchar(255) NULL
);

CREATE TABLE Productores_Cerveza(
	ID int AUTO_INCREMENT PRIMARY KEY,
	Nombre nvarchar(255) NOT NULL UNIQUE,
	País nvarchar(255) NULL,
	Región nvarchar(255) NULL,
	Ciudad nvarchar (255) NULL,
	Fundación int NULL,
	URL nvarchar(255) NULL,
	`Empresa matriz` nvarchar(255) NULL
);

CREATE TABLE Cervezas(
	ID int AUTO_INCREMENT PRIMARY KEY,
	Nombre nvarchar(255) UNIQUE NOT NULL,
	Tipo nvarchar(255) NOT NULL,
	Estilo nvarchar(255) NOT NULL,
	Grado decimal (4,2) NOT NULL,
	IBU int NULL,
	Lanzamiento int NULL,
	Estado nvarchar (255) CHECK (Estado IN('Activa','Retirada')),
	País nvarchar(255) NOT NULL,
	URL nvarchar(255) NULL,
	Productor nvarchar(255),

   	FOREIGN KEY (Productor) REFERENCES Productores_Cerveza (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Chapas(
	ID int AUTO_INCREMENT PRIMARY KEY,
	Cerveza nvarchar(255), 
	Año int NOT NULL,
	Color nvarchar(255) NOT NULL,
	Fabricante nvarchar(255),
	Obturador nvarchar(255) NULL,
	Símbolo nvarchar(255) NULL, 
	Estado nvarchar (255) CHECK (Estado IN('Perfecto','Bueno','Regular','Malo')),
	Repetida nvarchar (255) CHECK (Repetida IN('SI','NO')),
	Registro datetime DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Fabricante) REFERENCES Fabricantes_Chapa (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE Catas(
	ID int AUTO_INCREMENT PRIMARY KEY,
	Cerveza nvarchar (255),
	`Nota de Cata` nvarchar (255) NOT NULL,
	Sabor nvarchar (255) CHECK (Sabor IN('Excelente','Bueno','Aceptable','Regular','Malo')),
	Puntos int NOT NULL,
	Fecha date NULL,

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
);


-- IMPORTAR/INSERTAR REGISTROS
-- LOAD DATA INFILE: ficheros ubicados en el servidor. EN cliente, usar LOADA DATA LOCAL INFILE.
-- LOAD DATA ¡Indicar directorio de los ficheros csv!
-- NULLIF: Cuando no exista el valor, se inserta como NULL.
-- LINES TERMINATED BY: Linux '\n'. Windows '\r\n'.

LOAD DATA INFILE 'directorio/fabricantes.csv'
INTO TABLE Fabricantes_Chapa
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Nombre,@Empresa,@País,@URL)
SET Empresa = NULLIF(@Empresa,''),
País = NULLIF(@País,''),
URL = NULLIF(@URL,'')
;

LOAD DATA INFILE 'directorio/productores.csv'
INTO TABLE Productores_Cerveza
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Nombre,@País,@Región,@Ciudad,@Fundación,@URL,@`Empresa matriz`)
SET País = NULLIF(@País,''),
Región = NULLIF(@Región,''),
Ciudad = NULLIF(@Ciudad,''),
Fundación = NULLIF(@Fundación,''),
URL = NULLIF(@URL,''),
`Empresa matriz` = NULLIF(@`Empresa matriz`,'')
;

-- REPLACE(): Se sustituye delimitador decimal (,) por (.) antes de importar.

LOAD DATA INFILE 'directorio/cervezas.csv'
INTO TABLE Cervezas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Nombre,Tipo,Estilo,@Grado,@IBU,@Lanzamiento,Estado,País,@URL,Productor)
SET Grado = REPLACE(@Grado,',','.'),
IBU = NULLIF(@IBU,''),
Lanzamiento = NULLIF(@Lanzamiento,''),
URL = NULLIF(@URL,'')
;

LOAD DATA INFILE 'directorio/chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Cerveza,Año,Color,Fabricante,@Obturador,@Símbolo,Estado,Repetida)
SET Obturador = NULLIF(@Obturador,''),
Símbolo = NULLIF(@Símbolo,'')
;

LOAD DATA INFILE 'directorio/catas.csv'
INTO TABLE Catas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Cerveza,`Nota de Cata`,Sabor,Puntos,@Fecha)
SET Fecha = NULLIF(@Fecha,'')
;


-- REGISTROS DE CADA TABLA

SELECT A.Nombre AS Fabricantes_Chapa, B.Nombre AS Productores_Cerveza, C.Nombre AS Cervezas, D.ID AS Chapas, E.Cerveza AS Catas
FROM (SELECT COUNT(FC.Nombre) AS Nombre FROM Fabricantes_Chapa FC) A
CROSS JOIN (SELECT COUNT(PC.Nombre) AS Nombre FROM Productores_Cerveza PC) B
CROSS JOIN (SELECT COUNT(C.Nombre) AS Nombre FROM Cervezas C) C
CROSS JOIN (SELECT COUNT(CH.ID) AS ID FROM Chapas CH) D
CROSS JOIN (SELECT COUNT(CT.Cerveza) AS Cerveza FROM Catas CT) E
;

