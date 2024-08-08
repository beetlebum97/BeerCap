# :beer: CHAPAS DE CERVEZA :beer:
Base de datos de mi colección de chapas de cerveza a 8 de agosto de 2024.
Consta de 5 tablas y 1153 registros:
| TABLA | REGISTROS |
| ------ | ------ |
| Fabricantes_Chapa | 26 |
| Productores_Cerveza | 160 |
| Cervezas | 316 |
| Chapas | 361 |
| Catas | 290 |

[![N|Diagrama](https://raw.githubusercontent.com/beetlebum97/db_chapas_cerveza/main/diagrama.png)](https://raw.githubusercontent.com/beetlebum97/db_chapas_cerveza/main/diagrama.png)
El repositorio contiene los scripts y archivos necesarios para generar la Base de Datos en servidores SQL Server y MySQL. También se puede crear en BigQuery.

[SCRIPTS CREACIÓN BBDD + CARGA DE DATOS]
- chapas_cerveza.py
- sql-server_chapas_cerveza.sql
- mysql_chapas_cerveza.sql

[SCRIPTS BACKUP]
- sql-server_CHAPAS_CERVEZA.bak
- mysql_backup_chapas_cerveza.sql

[GESTORES (SGBD) UTILIZADOS]
- SQL Server 2022 16.0.1121.4
- MySQL 8.0.37
- MySQL 5.7.15

## PYTHON: chapas_cerveza.py
El script crea las tablas y carga los datos en servidores MySQL y SQL Server.

### EDITAR SCRIPT
Antes de lanzar, hay que editar los directorios de los archivos csv. 
Son 10 cambios en total (5 por motor). En futuras versiones incluiré una 
variable específica.

| LÍNEA | DIRECTORIOS MYSQL |
| ------ | ------ |
| 31 | LOAD DATA INFILE '/var/lib/mysql-files/fabricantes.csv' |
| 58 | LOAD DATA INFILE '/var/lib/mysql-files/productores.csv' |
| 93 | LOAD DATA INFILE '/var/lib/mysql-files/cervezas.csv' |
| 128 | LOAD DATA INFILE '/var/lib/mysql-files/chapas.csv' |
| 156 | LOAD DATA INFILE '/var/lib/mysql-files/catas.csv' |

| LÍNEA | DIRECTORIOS SQL SERVER |
| ------ | ------ |
| 222 | FROM 'D:\\db_chapas_cerveza_dev\\data\\fabricantes.csv' |
| 248 | FROM 'D:\\db_chapas_cerveza_dev\\data\\productores.csv' |
| 279 | FROM 'D:\\db_chapas_cerveza_dev\\data\\cervezas.csv' |
| 312 | FROM 'D:\\db_chapas_cerveza_dev\\data\\chapas.csv' |
| 338 | FROM 'D:\\db_chapas_cerveza_dev\\data\\catas.csv' |

### EJECUTAR SCRIPT
Introducir 4 argumentos. El motor debe ser mysql o sql-server.
```sh
python chapas_cerveza.py <motor> <servidor> <usuario> <contraseña>
```
SQL SERVER
```sh
python chapas_cerveza.py sql-server LAPTOP-29V8XXD2\SQLEXPRESS sa ******
```
```sh
Conectado a SQL Server
Fabricantes_Chapa: 26
Productores_Cerveza: 160
Cervezas: 316
Chapas: 361
Catas: 290
```
MySQL
```sh
python chapas_cerveza.py mysql 192.168.1.41 david ******
```
```sh
Conectado a MySQL
Fabricantes_Chapa: 26
Productores_Cerveza: 160
Cervezas: 316
Chapas: 361
Catas: 290
```

## SQL SERVER: sql-server_chapas_cerveza.sql
El script crea las tablas y carga los datos en servidores SQL Server.

### EDITAR SCRIPT
Indicar el directorio donde se encuentra los archivos de datos (csv).

| LÍNEA | VARIABLE DIRECTORIO DATOS |
| ------ | ------ |
| 101 | SET @directorio = N'D:\\db_chapas_cerveza_dev\\data\\' |

### EJECUTAR SCRIPT
OPCIÓN 1: Línea de comandos (sqlcmd)
```sh
sqlcmd -S <servidor> -U <usuario> -P <password> -i sql-server_chapas_cerveza.sql
```
```sh
sqlcmd -S LAPTOP-29V8XXD2\SQLEXPRESS -U sa -P ***** -i sql-server_chapas_cerveza.sql
```

OPCIÓN 2:  Línea de comnandos (sqlcmd)
```sh
sqlcmd -S <servidor> -U <usuario> -P <password>
1> :r sql-server_chapas_cerveza.sql
2> GO
```
```sh
sqlcmd -S LAPTOP-29V8XXD2\SQLEXPRESS -U sa -P *****
1> :r sql-server_chapas_cerveza.sql
2> GO
```

OPCIÓN 3: SQL Server Management Studio (SSMS)

Cargar script sql y lanzar (F5).

RESULTADO
```sh
Se cambió el contexto de la base de datos a 'CHAPAS_CERVEZA'.

(26 filas afectadas)

(160 filas afectadas)

(316 filas afectadas)

(361 filas afectadas)

(290 filas afectadas)
Fabricantes_Chapa Productores_Cerveza Cervezas    Chapas      Catas
----------------- ------------------- ----------- ----------- -----------
               26                 160         316         361         290
```

## MySQL: mysql_chapas_cerveza.sql
El script crea las tablas y carga los datos en servidores MySQL.

### EDITAR SCRIPT
LOAD DATA: Indicar ruta de los ficheros .csv.

LOAD DATA INFILE = archivos ubicados en el servidor.

LOAD DATA LOCAL FILE = archivos ubicados en el cliente.

| LÍNEA | DIRECTORIOS DATOS |
| ------ | ------ |
| 99 | LOAD DATA INFILE '/var/lib/mysql-files/fabricantes.csv' |
| 113 | LOAD DATA INFILE '/var/lib/mysql-files/productores.csv' |
| 130 | LOAD DATA INFILE '/var/lib/mysql-files/cervezas.csv' |
| 145 | LOAD DATA INFILE '/var/lib/mysql-files/chapas.csv' |
| 160 | LOAD DATA INFILE '/var/lib/mysql-files/catas.csv' |

[LINUX]

- Recomendable usar directorio dentro de /var/lib/ para evitar problemas de permisos que
requieran cambio de configuración: ERROR 13 (HY000) (Errcode: 13 "Permission denied").
- Cambio de línea: '\n'.

```sh
LOAD DATA INFILE '/var/lib/mysql-data/chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
```

[WINDOWS]

- Recomendable usar el directorio preparado para las cargas, y asi evitar problemas de permisos: ERROR 13 (HY000) (Errcode: 13 "Permission denied") 
que requieran cambio de configuración. 

```sh
mysql> SHOW VARIABLES LIKE 'secure_file_priv';
+------------------+------------------------------------------------+
| Variable_name    | Value                                          |
+------------------+------------------------------------------------+
| secure_file_priv | C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\ |
+------------------+------------------------------------------------+
1 row in set (0.00 sec)
```

- Cambio de línea: '\r\n'.

```sh
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
```

### EJECUTAR SCRIPT
OPCIÓN 1: Línea de comandos (Bash)
```sh
mysql -u <usuario> -p < mysql_chapas_cerveza.sql
```
```sh
root@debian-12:~# mysql -u root -p < mysql_chapas_cerveza.sql
Enter password:
Fabricantes_Chapa       Productores_Cerveza     Cervezas        Chapas  Catas
26      160     316     361     290
````

OPCIÓN 2: Línea de comandos (Bash)
```sh
mysql -u <usuario> -p
MariaDB [(none)]> source mysql_chapas_cerveza.sql
```
```sh
root@debian-12:~# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.37 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> source mysql_chapas_cerveza.sql
Query OK, 1 row affected (0,02 sec)

Database changed
Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,03 sec)

Query OK, 0 rows affected (0,03 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 26 rows affected (0,01 sec)
Records: 26  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 160 rows affected (0,01 sec)
Records: 160  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 316 rows affected (0,01 sec)
Records: 316  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 361 rows affected (0,02 sec)
Records: 361  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 290 rows affected (0,01 sec)
Records: 290  Deleted: 0  Skipped: 0  Warnings: 0

+-------------------+---------------------+----------+--------+-------+
| Fabricantes_Chapa | Productores_Cerveza | Cervezas | Chapas | Catas |
+-------------------+---------------------+----------+--------+-------+
|                26 |                 160 |      316 |    361 |   290 |
+-------------------+---------------------+----------+--------+-------+
1 row in set (0,00 sec)
```

OPCIÓN 3: MySQL WORKBENCH
Cargar script sql y lanzar.

## BACKUP
Un script por cada motor. No es necesario editarlos, pues son una copia de la bbdd creada.
Ejecutar por línea de comandos o herramienta gráfica.

- sql-server_CHAPAS_CERVEZA.bak
- mysql_backup_chapas_cerveza.sql

## BigQuery

###ASISTENTE CREACIÓN TABLA

1) Crear tabla desde: Subir 
2) Seleccionar archivo .csv de la tabla.
3) Formato de archivo: csv
3) Tabla: Nombre
4) Esquema > Editar como texto: pegar contenido de los archivos .json de la carpeta BigQuery.
5) Delimitador de campos > Personalizado: ;
6) Filas del encabezado que se omitirán: 0