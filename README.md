# :beer: BeerCAP :beer:
Base de datos de mi colección de chapas de cerveza a 10 de octubre de 2024.
Consta de 5 tablas y 1182 registros:
| TABLA | REGISTROS |
| ------ | ------ |
| Fabricantes_Chapa | 26 |
| Productores_Cerveza | 164 |
| Cervezas | 325 |
| Chapas | 372 |
| Catas | 295 |

![N|Diagrama](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/diagrama.png)
El repositorio contiene los scripts y archivos necesarios para generar la Base de Datos en servidores SQL Server y MySQL. También se puede crear en BigQuery.

[SCRIPTS CREACIÓN BBDD + CARGA DE DATOS]
- BeerCap.py
- sql-server_BeerCap.sql
- mysql_BeerCap.sql

[SCRIPTS BACKUP]
- sql-server_BeerCap.bak
- mysql_Beercap_backup.sql

[GESTORES (SGBD) UTILIZADOS]
- SQL Server 2022 16.0.1121.4
- MySQL 8.0.37
- MySQL 5.7.15

## PYTHON: BeerCap.py
El script crea las tablas y carga los datos en BBDD MySQL o SQL Server.

### EDITAR SCRIPT
Antes de ejecutar, edita la variable del directorio de datos según la ubicación de tus archivos csv.

| LÍNEA | DIRECTORIOS |
| ------ | ------ |
| 6 | data_mysql = '/var/lib/mysql-files/' |
| 7 | data_sql_server = 'D:\\BeerCap_dev\\data\\' |

### EJECUTAR SCRIPT
Introducir 4 argumentos. El motor debe ser mysql o sql-server.
```sh
python BeerCap.py <motor> <servidor> <usuario> <contraseña>
```
SQL SERVER
```sh
python chapas_cerveza.py sql-server LAPTOP-29V8XXD2\SQLEXPRESS sa ******
```
```sh
Conectado a SQL Server

Fabricantes_Chapa: 26
Productores_Cerveza: 164
Cervezas: 325
Chapas: 372
Catas: 295
```
MySQL
```sh
python BeerCap.py mysql 192.168.1.41 david ******
```
```sh
Conectado a MySQL

Fabricantes_Chapa: 26
Productores_Cerveza: 164
Cervezas: 325
Chapas: 372
Catas: 295
```

## SQL SERVER: sql-server_BeerCap.sql
El script crea las tablas y carga los datos en servidores SQL Server.

### EDITAR SCRIPT
Indicar el directorio donde se encuentra los archivos de datos (csv).

| LÍNEA | VARIABLE DIRECTORIO DATOS |
| ------ | ------ |
| 101 | SET @directorio = N'D:\\BeerCap\\data\\' |

### EJECUTAR SCRIPT
OPCIÓN 1: Línea de comandos (sqlcmd)
```sh
sqlcmd -S <servidor> -U <usuario> -P <password> -i sql-server_BeerCap.sql
```
```sh
sqlcmd -S LAPTOP-29V8XXD2\SQLEXPRESS -U sa -P ***** -i sql-server_BeerCap.sql
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

![N|SSMS](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/ejecucion_ssms.jpg)

RESULTADO
```sh
Se cambió el contexto de la base de datos a 'BeerCap'.

(26 filas afectadas)

(164 filas afectadas)

(325 filas afectadas)

(372 filas afectadas)

(295 filas afectadas)
Fabricantes_Chapa Productores_Cerveza Cervezas    Chapas      Catas
----------------- ------------------- ----------- ----------- -----------
               26                 164         325         372         295
```

## MySQL: mysql_BeerCap.sql
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
mysql -u <usuario> -p < mysql_BeerCap.sql
```
```sh
root@debian-12:~# mysql -u root -p < mysql_BeerCap.sql
Enter password:
Fabricantes_Chapa       Productores_Cerveza     Cervezas        Chapas  Catas
26      164     325     372     295
````

OPCIÓN 2: Línea de comandos (Bash)
```sh
mysql -u <usuario> -p
MariaDB [(none)]> source mysql_BeerCap.sql
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

mysql> source mysql_BeerCap.sql
Query OK, 1 row affected (0,02 sec)

Database changed
Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,03 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 26 rows affected (0,01 sec)
Records: 26  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 164 rows affected (0,01 sec)
Records: 164  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 325 rows affected (0,03 sec)
Records: 325  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 372 rows affected (0,02 sec)
Records: 372  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 295 rows affected (0,02 sec)
Records: 295  Deleted: 0  Skipped: 0  Warnings: 0

+-------------------+---------------------+----------+--------+-------+
| Fabricantes_Chapa | Productores_Cerveza | Cervezas | Chapas | Catas |
+-------------------+---------------------+----------+--------+-------+
|                26 |                 164 |      325 |    372 |   295 |
+-------------------+---------------------+----------+--------+-------+
1 row in set (0,00 sec)
```

OPCIÓN 3: MySQL WORKBENCH
Cargar script sql y lanzar.

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/ejecucion_workbench.jpg)


## BACKUP
Un script por cada motor.
Ejecutar por línea de comandos o herramienta gráfica.

- sql-server_BeerCap.bak
- mysql_BeerCap_backup.sql

## BigQuery

###ASISTENTE CREACIÓN TABLA

1) Crear tabla desde: Subir 
2) Seleccionar archivo .csv de la tabla.
3) Formato de archivo: csv
3) Tabla: Nombre
4) Esquema > Editar como texto: pegar contenido de los archivos .json de la carpeta BigQuery.
5) Delimitador de campos > Personalizado: ;
6) Filas del encabezado que se omitirán: 0

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/bigquery.jpg)
