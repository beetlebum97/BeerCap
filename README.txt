###################################################################################
######################### BASE DE DATOS CHAPAS DE CERVEZA #########################
###################################################################################
___________________________________________________________________________________
____________________________________INTRODUCCIÓN___________________________________

Base de datos de mi colección de chapas de cerveza a fecha 19-10-2023.
Incluye cinco tablas y un total de 1006 registros (esquema: diagrama.png).

Listado de tablas:

- Fabricantes_Chapa (24 registros).
- Productores_Cerveza (144 registros).
- Cervezas (275 registros).
- Chapas (311 registros).
- Catas (252 registros).

El repositorio contiene los scripts y datos necesarios 
para cargar la base de datos en servidores SQL Server y MySQL (MariaDB).
También se puede crear en BigQuery. 

Versiones utilizadas:

- SQL Server: 16.0.1050.5
- MySQL: 10.11.3-MariaDB-1
- MySQL: 5.7.15-log

___________________________________________________________________________________
____________________________________INSTALACIÓN____________________________________

=====================================[PYTHON]======================================

El script chapas_cerveza.py está preparado para crear y cargar los datos en MySQL 
o SQL Server.

1º) EDITAR SCRIPT CHAPAS_CERVEZA.PY------------------------------------------------

Antes de lanzar, es necesario editar los directorios de los archivos csv. 
Son 10 cambios en total (5 por motor). En futuras versiones incluiré una 
variable específica.

-> 5 INSERCIONES LOAD DATA (MySQL)

INSERTAR_FABRICANTES = """
            LOAD DATA INFILE '/directorio/fabricantes.csv'
            INTO TABLE Fabricantes_Chapa
            FIELDS TERMINATED BY ';'
            LINES TERMINATED BY '\n'
            IGNORE 1 LINES
            (ID,Nombre,@Empresa,@País,@URL)
            SET Empresa = NULLIF(@Empresa,''),
            País = NULLIF(@País,''),
            URL = NULLIF(@URL,'')
            ; """

-> 5 INSERCIONES BULK INSERT (SQL Server)

INSERTAR_FABRICANTES = """
            BULK INSERT Fabricantes_Chapa
            FROM 'directorio\\fabricantes.csv'
            WITH (
            FORMAT = 'CSV',
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            CODEPAGE='65001'
            ) """


2º EJECUTAR SCRIPT CHAPAS_CERVEZA.PY-----------------------------------------------------

Debemos introducir 4 parámetros.

python chapas_cerveza.py <tipo> <servidor> <usuario> <contraseña>

	1º Tipo base de datos: mysql | sql-server
	2º Servidor
	3º Usuario
	4º Contraseña

Si no se introducen los parámetros o el tipo es incorrecto, devolverá mensaje de error:

"Tipo de base de datos no reconocido"
"Por favor, proporciona el tipo de base de datos, el servidor, el usuario y 
la contraseña como argumentos"

[PRUEBA]

D:\db_chapas_cerveza_dev\github\scripts>python chapas_cerveza.py mysql 192.168.1.44 pepe *****

Conectado a MySQL

Fabricantes_Chapa: 24
Productores_Cerveza: 144
Cervezas: 275
Chapas: 311
Catas: 252

D:\db_chapas_cerveza_dev\github\scripts>python chapas_cerveza.py sql-server 0000\SQLEXPRESS sa ****

Conectado a SQL Server

Fabricantes_Chapa: 24
Productores_Cerveza: 144
Cervezas: 275
Chapas: 311
Catas: 252


======================================[SQL SERVER]=======================================

1º) EDITAR SCRIPT SQL-SERVER_CHAPAS_CERVEZA.SQL------------------------------------------

5 Instrucciones BULK INSERT: Modificar directorio del archivo.csv según su ubicación.

BULK INSERT Tabla
FROM 'directorio\archivo.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)

2º) EJECUTAR SCRIPT SQL-SERVER_CHAPAS_CERVEZA.SQL----------------------------------------

[OPCIÓN 1 COMANDO]

sqlcmd -S servidor -U usuario -P password -i directorio\sql-server_chapas_cerveza.sql

[OPCIÓN 2 COMANDO]

sqlcmd -S servidor -U usuario -P password
1> :r directorio\sql-server_chapas_cerveza.sql
2> GO

[OPCIÓN 3 SQL SERVER MANAGEMENT STUDIO]

Cargar script sql y lanzar (F5).

*** RESULTADO ***

Se cambió el contexto de la base de datos a 'CHAPAS_CERVEZA'.

(24 filas afectadas)

(144 filas afectadas)

(275 filas afectadas)

(311 filas afectadas)

(252 filas afectadas)
Fabricantes_Chapa Productores_Cerveza Cervezas    Chapas      Catas
----------------- ------------------- ----------- ----------- -----------
               24                 144         275         311         252



===================================[MYSQL-MARIADB]====================================

1º) EDITAR SCRIPT MYSQL_CHAPAS_CERVEZA.SQL--------------------------------------------

LOAD DATA: Adaptar ruta de los ficheros .csv según su ubicación.
LOAD DATA INFILE = archivos ubicados en el servidor.
LOAD DATA LOCAL FILE = archivos ubicados en el cliente.

[LINUX]

Recomendable usar directorio dentro de /var/lib para evitar problemas de permisos que
requieran cambio de configuración: ERROR 13 (HY000) (Errcode: 13 "Permission denied").
Cambio de línea: '\n'.

LOAD DATA INFILE '/var/lib/mysql-data/archivo.csv'
LINES TERMINATED BY '\n' 

[WINDOWS]

Recomendable usar directorio C:\\ProgramData\\MySQL\\MySQL Server <versión>\\Data
para evitar problemas de permisos: ERROR 13 (HY000) (Errcode: 13 "Permission denied") 
que requieran cambio de configuración. Cambio de línea: '\r\n'.

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Data\\archivo.csv'
LINES TERMINATED BY '\r\n'

2º) EJECUTAR SCRIPT MYSQL_CHAPAS_CERVEZA.SQL------------------------------------------

[OPCIÓN 1]

mysql -u usuario -p < directorio/mysql_chapas_cerveza.sql

[OPCIÓN 2]
mysql -u usuario -p
MariaDB [(none)]> source directorio/mysql_chapas_cerveza.sql

[OPCIÓN 3 WORKBENCH]

Cargar script sql y lanzar.

*** RESULTADO ***

MariaDB [(none)]> source chapas_cerveza.sql
Query OK, 1 row affected (0,000 sec)

Database changed
Query OK, 0 rows affected (0,018 sec)

Query OK, 24 rows affected (0,002 sec)
Records: 24  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 0 rows affected (0,008 sec)

Query OK, 144 rows affected (0,003 sec)
Records: 144  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 0 rows affected (0,010 sec)

Query OK, 275 rows affected (0,007 sec)
Records: 275  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 0 rows affected (0,010 sec)

Query OK, 311 rows affected (0,008 sec)
Records: 311  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 0 rows affected (0,007 sec)

Query OK, 252 rows affected (0,007 sec)
Records: 252  Deleted: 0  Skipped: 0  Warnings: 0

+-------------------+---------------------+----------+--------+-------+
| Fabricantes_Chapa | Productores_Cerveza | Cervezas | Chapas | Catas |
+-------------------+---------------------+----------+--------+-------+
|                24 |                 144 |      275 |    311 |   252 |
+-------------------+---------------------+----------+--------+-------+
1 row in set (0,001 sec)


===================================[BIGQUERY]====================================

ASISTENTE CREACIÓN TABLA

1) Crear tabla desde: Subir 
2) Seleccionar archivo .csv de la tabla.
3) Tabla: Nombre
4) Esquema > Editar como texto: Pegar contenido del archivo json de la tabla.
5) Delimitador de campos > Personalizado: ;
6) Filas del encabezado que se omitirán: 0

