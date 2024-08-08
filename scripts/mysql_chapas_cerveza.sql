-- [[0. CREAR  Y USAR BASE DE DATOS]]

CREATE DATABASE CHAPAS_CERVEZA;

USE CHAPAS_CERVEZA;

-- [[1. CREAR TABLAS]]
-- Nombres de columnas con espacios en blanco: `nombre columna`.

-- 1.1 TABLA FABRICANTES_CHAPA

CREATE TABLE Fabricantes_Chapa(
	ID int PRIMARY KEY,
	Nombre varchar(255) UNIQUE,
	Empresa varchar(255) NULL,
	País varchar(255) NULL,
	URL varchar(255) NULL,
	Imagen varchar(255)
	);

-- 1.2 TABLA PRODUCTORES_CERVEZA

CREATE TABLE Productores_Cerveza(
	ID int PRIMARY KEY,
	Nombre varchar(255) UNIQUE,
	País varchar(255) NULL,
	Región varchar(255) NULL,
	Ciudad varchar (255) NULL,
	Fundación int NULL,
	URL varchar(255) NULL,
	`Empresa matriz` varchar(255) NULL
	);

-- 1.3 TABLA CERVEZAS
-- Columna Grado: decimal tiene que ser . en lugar de ,

CREATE TABLE Cervezas(
	ID int PRIMARY KEY,
	Nombre varchar(255) UNIQUE,
	Tipo varchar(255) NOT NULL,
	Estilo varchar(255) NOT NULL,
	Grado decimal (4,2) NOT NULL,
	IBU int NULL,
	Lanzamiento int NULL,
	Estado varchar (255) CHECK (Estado IN('Activa','Retirada')),
	País varchar(255) NOT NULL,
	URL varchar(255) NULL,
	Productor varchar(255),

   	FOREIGN KEY (Productor) REFERENCES Productores_Cerveza (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 1.4 TABLA CHAPAS

CREATE TABLE Chapas(
	ID int PRIMARY KEY,
	Cerveza varchar(255),
	Año int NOT NULL,
	Color varchar(255) NOT NULL,
	Fabricante varchar(255),
	Obturador varchar(255) NULL,
	Inscripción varchar(255) NULL,
	Estado varchar (255) CHECK (Estado IN('Perfecto','Bueno','Regular','Malo')),
	Repetida varchar (255) CHECK (Repetida IN('SI','NO')),
	Formato varchar (255) CHECK (Formato IN('20cl','25cl','33cl','50cl')),
	Registro datetime DEFAULT CURRENT_TIMESTAMP,
	Imagen varchar(255),

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Fabricante) REFERENCES Fabricantes_Chapa (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

-- 1.5 TABLA CATAS

CREATE TABLE Catas(
	ID int PRIMARY KEY,
	Cerveza varchar (255),
	`Nota de Cata` varchar (255) NOT NULL,
	Sabor varchar (255) CHECK (Sabor IN('Excelente','Bueno','Aceptable','Regular','Malo')),
	Puntos int NOT NULL,
	Fecha date,

	FOREIGN KEY (Cerveza) REFERENCES Cervezas (Nombre) ON UPDATE CASCADE ON DELETE CASCADE
);

-- [[2. INSERTAR DATOS]]
-- LOAD DATA INFILE: ficheros ubicados en el servidor. EN cliente, usar LOADA DATA LOCAL INFILE.
-- LOAD DATA ¡Indicar directorio de los ficheros csv!
-- NULLIF: Si el valor no existe lo guarda como NULL.
-- REPLACE(): Sustituir un valor por otr. Delimitador decimal (,) por (.) SET Grado = REPLACE(@Grado,',','.')
-- COALESCE(): Reemplazo valor vacío/null por valor de función. Registro = COALESCE(NULLIF(@Registro,''), CURRENT_TIMESTAMP)
-- TRIM(TRAILING '\r' FROM @Productor): Eliminar retornos de carro cuando hay problemas con la última de columna del csv.
-- LINES TERMINATED BY: Linux '\n'. Windows '\r\n'.


-- 2.2 DATOS TABLA FABRICANTES_CHAPA
-- Indicar ruta del archivo csv

LOAD DATA INFILE '/var/lib/mysql-files/fabricantes.csv'
INTO TABLE Fabricantes_Chapa
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,Nombre,@Empresa,@País,@URL,Imagen)
SET Empresa = NULLIF(@Empresa,''),
País = NULLIF(@País,''),
URL = NULLIF(@URL,'')
;

-- 2.3 DATOS TABLA PRODUCTORES_CERVEZA
-- Indicar ruta del archivo csv

LOAD DATA INFILE '/var/lib/mysql-files/productores.csv'
INTO TABLE Productores_Cerveza
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,Nombre,@País,@Región,@Ciudad,@Fundación,@URL,@`Empresa matriz`)
SET País = NULLIF(@País,''),
Región = NULLIF(@Región,''),
Ciudad = NULLIF(@Ciudad,''),
Fundación = NULLIF(@Fundación,''),
URL = NULLIF(@URL,''),
`Empresa matriz` = NULLIF(@`Empresa matriz`,'')
;

-- 2.4 DATOS TABLA CERVEZAS
-- Indicar ruta del archivo csv

LOAD DATA INFILE '/var/lib/mysql-files/cervezas.csv'
INTO TABLE Cervezas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,Nombre,Tipo,Estilo,Grado,@IBU,@Lanzamiento,Estado,País,@URL,@Productor)
SET IBU = NULLIF(@IBU,''),
Lanzamiento = NULLIF(@Lanzamiento,''),
URL = NULLIF(@URL,''),
Productor = TRIM(TRAILING '\r' FROM @Productor)
;

-- 2.5 DATOS TABLA CHAPAS
-- Indicar ruta del archivo csv

LOAD DATA INFILE '/var/lib/mysql-files/chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,Cerveza,Año,Color,Fabricante,@Obturador,@Inscripción,Estado,Repetida,@Formato,@Registro,Imagen)
SET Obturador = NULLIF(@Obturador,''),
Inscripción = NULLIF(@Inscripción,''),
Formato = NULLIF(@Formato,''),
Registro = COALESCE(NULLIF(@Registro,''), CURRENT_TIMESTAMP)
;

-- 2.6 DATOS TABLA CATAS
-- Indicar ruta del archivo csv

LOAD DATA INFILE '/var/lib/mysql-files/catas.csv'
INTO TABLE Catas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,Cerveza,`Nota de Cata`,Sabor,Puntos,@Fecha)
SET Fecha = NULLIF(TRIM(TRAILING '\r' FROM @Fecha),'')
;

-- [[3. REGISTROS DE CADA TABLA]]

SELECT A.Nombre AS Fabricantes_Chapa, B.Nombre AS Productores_Cerveza, C.Nombre AS Cervezas, D.ID AS Chapas, E.Cerveza AS Catas
FROM (SELECT COUNT(FC.Nombre) AS Nombre FROM Fabricantes_Chapa FC) A
CROSS JOIN (SELECT COUNT(PC.Nombre) AS Nombre FROM Productores_Cerveza PC) B
CROSS JOIN (SELECT COUNT(C.Nombre) AS Nombre FROM Cervezas C) C
CROSS JOIN (SELECT COUNT(CH.ID) AS ID FROM Chapas CH) D
CROSS JOIN (SELECT COUNT(CT.Cerveza) AS Cerveza FROM Catas CT) E
;