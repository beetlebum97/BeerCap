###################################################################################
######################### BASE DE DATOS CHAPAS DE CERVEZA #########################
###################################################################################
___________________________________________________________________________________
____________________________________INTRODUCCIÓN___________________________________

Base de datos de mi colección de chapas de cerveza a fecha 20-09-2023.
Incluye cinco tablas y un total de 978 registros (esquema: diagrama.png).

Listado de tablas:

- Fabricantes_Chapa (20 registros).
- Productores_Cerveza (141 registros).
- Cervezas (268 registros).
- Chapas (302 registros).
- Catas (247 registros).

El repositorio contiene los scripts y datos necesarios 
para cargar la base de datos en servidores SQL Server y MySQL (MariaDB). 

Versiones utilizadas:

- SQL Server: 16.0.1050.5
- MySQL: 10.11.3-MariaDB-1
- MySQL: 5.7.15-log

___________________________________________________________________________________
____________________________________INSTALACIÓN____________________________________

====================================SQL SERVER=====================================

-------------------1º) EDITAR SCRIPT SQL-SERVER_CHAPAS_CERVEZA.SQL-----------------

Instrucciones BULK INSERT: Modificar directorio del archivo.csv según su ubicación.

BULK INSERT #Temporal
FROM 'directorio\archivo.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE='65001'
	)

------------------2º) EJECUTAR SCRIPT SQL-SERVER_CHAPAS_CERVEZA.SQL----------------

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
(0 filas afectadas)

(20 filas afectadas)

(20 filas afectadas)

(0 filas afectadas)

(141 filas afectadas)

(141 filas afectadas)

(0 filas afectadas)

(268 filas afectadas)

(268 filas afectadas)

(0 filas afectadas)

(302 filas afectadas)

(302 filas afectadas)

(0 filas afectadas)

(247 filas afectadas)

(247 filas afectadas)
Fabricantes_Chapa Productores_Cerveza Cervezas    Chapas      Catas
----------------- ------------------- ----------- ----------- -----------
               20                 141         268         302         247

(1 filas afectadas)


=================================MYSQL-MARIADB==================================

-----------------1º) EDITAR SCRIPT MYSQL_CHAPAS_CERVEZA.SQL---------------------

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

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Data\archivo.csv'
LINES TERMINATED BY '\r\n'

---------------2º) EJECUTAR SCRIPT MYSQL_CHAPAS_CERVEZA.SQL----------------------

[OPCIÓN 1]

mysql -u usuario -p < directorio/mysql_chapas_cerveza.sql

[OPCIÓN 2]
mysql -u usuario -p
MariaDB [(none)]> source directorio/mysql_chapas_cerveza.sql

[OPCIÓN 3 WORKBENCH]

Cargar script sql y lanzar.

*** RESULTADO ***

Query OK, 1 row affected (0,000 sec)

Database changed
Query OK, 0 rows affected (0,046 sec)

Query OK, 0 rows affected (0,008 sec)

Query OK, 0 rows affected (0,009 sec)

Query OK, 0 rows affected (0,011 sec)

Query OK, 0 rows affected (0,008 sec)

Query OK, 20 rows affected (0,001 sec)
Records: 20  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 141 rows affected (0,004 sec)
Records: 141  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 268 rows affected (0,007 sec)
Records: 268  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 302 rows affected (0,008 sec)
Records: 302  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 247 rows affected (0,007 sec)
Records: 247  Deleted: 0  Skipped: 0  Warnings: 0

+-------------------+---------------------+----------+--------+-------+
| Fabricantes_Chapa | Productores_Cerveza | Cervezas | Chapas | Catas |
+-------------------+---------------------+----------+--------+-------+
|                20 |                 141 |      268 |    302 |   247 |
+-------------------+---------------------+----------+--------+-------+
1 row in set (0,001 sec)

