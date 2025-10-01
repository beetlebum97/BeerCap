# :beer: BeerCap :beer:
Base de datos de mi colección de chapas de cerveza a 1 de octubre de 2025.
Consta de 5 tablas y 1244 registros:
| TABLA | REGISTROS |
| ------ | ------ |
| Fabricantes_Chapa | 26 |
| Productores_Cerveza | 167 |
| Cervezas | 341 |
| Chapas | 401 |
| Catas | 309 |

![N|Diagrama](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/diagrama.png)
El repositorio contiene los scripts y archivos necesarios para generar la base de datos en servidores SQL Server y MySQL. También se puede crear en BigQuery.

**SCRIPTS CREACIÓN BBDD + CARGA DE DATOS**
- BeerCap.py
- sql-server_BeerCap.sql
- mysql_BeerCap.sql

**ARCHIVOS BACKUP**
- sql-server_BeerCap.BAK
- mysql_Beercap_backup.sql

**GESTORES (SGBD) UTILIZADOS**
- SQL Server 2022 16.0.1121.4
- MySQL 8.0.37

## 1. CREACIÓN Y CARGA: BeerCap.py
El script crea las tablas y carga los datos en MySQL o SQL Server.

### 1.1 EDITAR SCRIPT
Antes de ejecutar, editar la variable del directorio de datos según la ubicación de los archivos csv.

| LÍNEA | DIRECTORIOS |
| ------ | ------ |
| 6 | data_mysql = '/var/lib/mysql-files/' |
| 7 | data_sql_server = 'E:\\BeerCap_dev\\data\\' |

### 1.2 EJECUTAR SCRIPT
Introducir 4 argumentos. El motor debe ser mysql o sql-server.
```
python BeerCap.py <motor> <servidor> <usuario> <contraseña>
```
**SQL SERVER**
```
E:\BeerCap>python BeerCap.py sql-server %COMPUTERNAME%\SQLEXPRESS sa manager

Conectado a SQL Server

Fabricantes_Chapa: 26
Productores_Cerveza: 166
Cervezas: 341
Chapas: 401
Catas: 309
```
**MySQL**
```
E:\BeerCap>python BeerCap.py mysql 192.168.1.45 david manager

Conectado a MySQL

Fabricantes_Chapa: 26
Productores_Cerveza: 167
Cervezas: 341
Chapas: 401
Catas: 309
```

## 2. SQL SERVER: sql-server_BeerCap.sql
El script crea las tablas y carga los datos en servidores SQL Server.

### 2.1 EDITAR SCRIPT
Indicar el directorio donde se encuentran los archivos de datos (csv).

| LÍNEA | VARIABLE DIRECTORIO DATOS |
| ------ | ------ |
| 106 | SET @directorio = N'E:\\BeerCap\\data\\' |

### 2.2 EJECUTAR SCRIPT
**OPCIÓN 1: Línea de comandos no interactiva (sqlcmd).**
```
sqlcmd -S <servidor> -U <usuario> -P <password> -i sql-server_BeerCap.sql
```
```
sqlcmd -S "%COMPUTERNAME%\SQLEXPRESS" -U sa -P manager -i sql-server_BeerCap.sql
```
```
E:\BeerCap>sqlcmd -S "%COMPUTERNAME%\SQLEXPRESS" -U sa -P manager -i sql-server_BeerCap.sql
Se cambió el contexto de la base de datos a 'BeerCap'.

(26 filas afectadas)

(166 filas afectadas)

(341 filas afectadas)

(401 filas afectadas)

(309 filas afectadas)
Fabricantes_Chapa Productores_Cerveza Cervezas    Chapas      Catas
----------------- ------------------- ----------- ----------- -----------
               26                 166         341         401         309

(1 filas afectadas)
```

**OPCIÓN 2:  Línea de comandos interactiva (sqlcmd).** 
```
sqlcmd -S <servidor> -U <usuario> -P <password>
1> :r sql-server_BeerCap.sql
```
```
E:\BeerCap>sqlcmd -S "%COMPUTERNAME%\SQLEXPRESS" -U sa -P manager
1> :r sql-server_BeerCap.sql
Se cambió el contexto de la base de datos a 'BeerCap'.

(26 filas afectadas)

(166 filas afectadas)

(341 filas afectadas)

(401 filas afectadas)

(309 filas afectadas)
Fabricantes_Chapa Productores_Cerveza Cervezas    Chapas      Catas
----------------- ------------------- ----------- ----------- -----------
               26                 166         341         401         309
```

**OPCIÓN 3: SQL Server Management Studio (SSMS).**

Cargar script sql y lanzar (F5).

![N|SSMS](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/ejecucion_ssms.jpg)


## 3. MySQL: mysql_BeerCap.sql
El script crea las tablas y carga los datos en servidores MySQL.

### 3.1 EDITAR SCRIPT
_LOAD DATA: Indicar ruta de los ficheros .csv._
_LOAD DATA INFILE = archivos ubicados en el servidor._
_LOAD DATA LOCAL FILE = archivos ubicados en el cliente._

| LÍNEA | DIRECTORIOS DATOS |
| ------ | ------ |
| 101 | LOAD DATA INFILE '/var/lib/mysql-files/fabricantes.csv' |
| 115 | LOAD DATA INFILE '/var/lib/mysql-files/productores.csv' |
| 132 | LOAD DATA INFILE '/var/lib/mysql-files/cervezas.csv' |
| 147 | LOAD DATA INFILE '/var/lib/mysql-files/chapas.csv' |
| 162 | LOAD DATA INFILE '/var/lib/mysql-files/catas.csv' |

- Recomendable usar el directorio de cargas predefinido,para evitar problemas de permisos: ERROR 13 (HY000) (Errcode: 13 "Permission denied") 
que requieran cambio de configuración. 
```
mysql> SHOW VARIABLES LIKE 'secure_file_priv';
+------------------+-----------------------+
| Variable_name    | Value                 |
+------------------+-----------------------+
| secure_file_priv | /var/lib/mysql-files/ |
+------------------+-----------------------+
1 row in set (0,01 sec)
```
```
mysql> SHOW VARIABLES LIKE 'secure_file_priv';
+------------------+------------------------------------------------+
| Variable_name    | Value                                          |
+------------------+------------------------------------------------+
| secure_file_priv | C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\ |
+------------------+------------------------------------------------+
1 row in set (0.00 sec)
```

**LINUX**
- Cambio de línea: '\n'.
```
LOAD DATA INFILE '/var/lib/mysql-data/chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
```

**[WINDOWS**

- Cambio de línea: '\r\n'.
```
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
```

### 3.2 EJECUTAR SCRIPT
**OPCIÓN 1: Línea de comandos no interactiva(Bash).**
```
mysql -h <servidor> -u <usuario> -p < mysql_BeerCap.sql
```
```
david@debian-12:~$ mysql -h localhost -u david -p < mysql_BeerCap.sql
Enter password:
Fabricantes_Chapa       Productores_Cerveza     Cervezas        Chapas  Catas
26      167     341     401     309
````

**OPCIÓN 2: Línea de comandos interactiva (Bash).**
```
mysql -h <servidor> -u <usuario> -p
mysql> source mysql_BeerCap.sql
```
```
david@debian-12:~$ mysql -h localhost -u david -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.37 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> source mysql_BeerCap.sql
Query OK, 0 rows affected, 1 warning (0,01 sec)

Query OK, 1 row affected (0,00 sec)

Database changed
Query OK, 0 rows affected (0,03 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 0 rows affected (0,03 sec)

Query OK, 0 rows affected (0,02 sec)

Query OK, 26 rows affected (0,01 sec)
Records: 26  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 167 rows affected (0,00 sec)
Records: 167  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 341 rows affected (0,02 sec)
Records: 341  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 401 rows affected (0,02 sec)
Records: 401  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 309 rows affected (0,02 sec)
Records: 309  Deleted: 0  Skipped: 0  Warnings: 0

+-------------------+---------------------+----------+--------+-------+
| Fabricantes_Chapa | Productores_Cerveza | Cervezas | Chapas | Catas |
+-------------------+---------------------+----------+--------+-------+
|                26 |                 167 |      341 |    401 |   309 |
+-------------------+---------------------+----------+--------+-------+
1 row in set (0,00 sec)
```

**OPCIÓN 3: MySQL WORKBENCH**
Cargar script sql y lanzar.

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/ejecucion_workbench.jpg)


## 4. BACKUP
Se incluye el backup de cada BBDD. Indico como generarlo o restaurar

* sql-server_BeerCap.BAK
* mysql_BeerCap_backup.sql

### 4.1 SQL SERVER

**GUARDAR COPIA (.BAK):**
```
sqlcmd -S <servidor> -U <usuario> -P <contraseña> -Q "BACKUP DATABASE [NOMBRE_BASE_DE_DATOS] TO DISK = 'C:\RUTA\DE\ARCHIVO.BAK' WITH NOUNLOAD, SKIP, STATS = 10, FORMAT, norewind"
```
```
E:\BeerCap>sqlcmd -S %COMPUTERNAME%\SQLEXPRESS -U sa -P manager -Q "BACKUP DATABASE [BeerCap] TO DISK = 'E:\BeerCap\backup\BeerCap_sqlcmd.BAK' WITH NOUNLOAD, SKIP, STATS = 10, FORMAT, norewind"
10por ciento procesado.
20por ciento procesado.
30por ciento procesado.
40por ciento procesado.
51por ciento procesado.
60por ciento procesado.
70por ciento procesado.
80por ciento procesado.
90por ciento procesado.
100por ciento procesado.
Se han procesado 560 páginas para la base de datos 'BeerCap', archivo 'BeerCap' en el archivo 1.
Se han procesado 2 páginas para la base de datos 'BeerCap', archivo 'BeerCap_log' en el archivo 1.
BACKUP DATABASE procesó correctamente 562 páginas en 0.286 segundos (15.338 MB/s).
```

**RESTURAR:**
```
sqlcmd -S <servidor> -U <usuario> -P <contraseña> -Q "RESTORE DATABASE [NOMBRE_BASE_DE_DATOS] FROM DISK = 'C:\RUTA\DE\ARCHIVO.BAK' WITH REPLACE"
```
```
E:\BeerCap>sqlcmd -S %COMPUTERNAME%\SQLEXPRESS -U sa -P manager -Q "RESTORE DATABASE [BeerCap] FROM DISK = 'E:\BeerCap\backup\BeerCap_sqlcmd.BAK' WITH REPLACE"
Se han procesado 560 páginas para la base de datos 'BeerCap', archivo 'BeerCap' en el archivo 1.
Se han procesado 2 páginas para la base de datos 'BeerCap', archivo 'BeerCap_log' en el archivo 1.
RESTORE DATABASE procesó correctamente 562 páginas en 0.073 segundos (60.092 MB/s).
```

### 4.2 MYSQL

**GUARDAR COPIA:**
```
mysql -h <servidor> -u <usuario> -p --databases <NOMBRE_BBDD> > <copia.sql>
```
```
david@debian-12:~$ mysqldump -h localhost -u david -p --databases BeerCap > mysql_BeerCap_backup.sql
Enter password:
david@debian-12:~$ ls -l mysql_BeerCap_backup.sql
-rw-r--r-- 1 david david 150181 oct  1 17:05 mysql_BeerCap_backup.sql
```

**RESTURAR:**
```
david@debian-12:~$ mysql -h localhost -u david -p < mysql_BeerCap_backup.sql
Enter password:
david@debian-12:~$ echo $?
0
david@debian-12:~$ mysql -h localhost -u david -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 29
Server version: 8.0.37 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show schemas;
+--------------------+
| Database           |
+--------------------+
| BeerCap            |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0,00 sec)

mysql> select count(*) from BeerCap.Chapas;
+----------+
| count(*) |
+----------+
|      401 |
+----------+
1 row in set (0,00 sec)
```


## 5. BigQuery
### ASISTENTE CREACIÓN TABLA

1) Crear tabla desde: Subir 
2) Seleccionar archivo .csv de la tabla.
3) Formato de archivo: csv
3) Tabla: Nombre
4) Esquema > Editar como texto: pegar contenido de los archivos .json de la carpeta BigQuery.
5) Opciones avanzadas > Delimitador de campos > Personalizado: ;
6) Opciones avanzadas > Filas del encabezado que se omitirán: 1

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/BG_Crear_tabla.jpg)

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/BG_Crear_tabla2.jpg)

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/BG_Crear_tabla3.jpg)

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/resultados/BG_Productores.jpg)
