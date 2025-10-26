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

## 🛠️ Scripts de Creación BBDD + Carga de Datos
- `BeerCap.py` - Script Python multiplataforma
- `sql-server_BeerCap.sql` - Script específico SQL Server  
- `mysql_BeerCap.sql` - Script específico MySQL

## 💾 Archivos de Backup
- `BeerCap.BAK` - Backup nativo SQL Server
- `mysql_Beercap_backup.sql` - Dump completo MySQL

## 🗄️ Gestores de Base de Datos (SGBD) Utilizados
- **SQL Server 2022** (16.0.1121.4)
- **MySQL 8.0.37** (Community Server)

---

## 🎥 Video Demostración

### 🗄️ SQL Server Implementation
<a href="https://youtu.be/NX0rwcbG3Rw" target="_blank">
  <img src="https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/1.SQL-Server.png" 
       alt="BeerCap - Implementación SQL Server" 
       width="500" style="border-radius: 8px; border: 1px solid #ddd;">
</a>

- **00:00** - [Creación y carga desde script Python](https://youtu.be/NX0rwcbG3Rw?t=0)
- **01:40** - [Creación y carga desde sqlcmd usando script SQL](https://youtu.be/NX0rwcbG3Rw?t=100)
- **02:45** - [Generación de archivo backup](https://youtu.be/NX0rwcbG3Rw?t=165)
- **03:15** - [Restauración base de datos desde archivo backup](https://youtu.be/NX0rwcbG3Rw?t=195)

### 🐬 MySQL Implementation
<a href="https://youtu.be/PDrWpcEuUnI" target="_blank">
  <img src="https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/screenshots/2.MySQL.png" 
       alt="BeerCap - Implementación MySQL" 
       width="500" style="border-radius: 8px; border: 1px solid #ddd;">
</a>

- **00:00** - [Creación y carga desde script Python](https://youtu.be/PDrWpcEuUnI?t=0)
- **01:55** - [Creación y carga desde Workbench con script SQL](https://youtu.be/PDrWpcEuUnI?t=115)
- **03:05** - [Generación de archivo backup con mysqldump](https://youtu.be/PDrWpcEuUnI?t=185)
- **03:40** - [Restauración base de datos desde archivo backup](https://youtu.be/PDrWpcEuUnI?t=220)

### ☁️ BigQuery Implementation
<a href="https://youtu.be/Fd83Lj4Tdi0" target="_blank">
  <img src="https://raw.githubusercontent.com/beetlebum97/BeerCap/main/imagenes/screenshots/3.BigQuery.png" 
       alt="BeerCap - Implementación BigQuery" 
       width="500" style="border-radius: 8px; border: 1px solid #ddd;">
</a>

- **00:00** - [Creación del dataset](https://youtu.be/Fd83Lj4Tdi0?t=0)
- **00:40** - [Creación tabla Fabricantes](https://youtu.be/Fd83Lj4Tdi0?t=40)
- **02:15** - [Creación tabla Productores](https://youtu.be/Fd83Lj4Tdi0?t=135)
- **03:35** - [Creación tabla Cervezas](https://youtu.be/Fd83Lj4Tdi0?t=215)
- **04:45** - [Creación tabla Chapas](https://youtu.be/Fd83Lj4Tdi0?t=285)
- **05:55** - [Creación tabla Catas](https://youtu.be/Fd83Lj4Tdi0?t=355)
- **07:15** - [Ejemplo descarga de datos](https://youtu.be/Fd83Lj4Tdi0?t=435)

---

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
**OPCIÓN 1: Línea de comandos (sqlcmd).**
```
sqlcmd -S <servidor> -U <usuario> -P <password> -i sql-server_BeerCap.sql
```

```
E:\BeerCap>sqlcmd -S "%COMPUTERNAME%\SQLEXPRESS" -U sa -P manager -i sql\SQL-Server\sql-server_BeerCap.sql
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


**OPCIÓN 2: SQL Server Management Studio (SSMS).**

Cargar script sql y lanzar (F5).

![N|SSMS](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/ejecucion_ssms.jpg)


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

**WINDOWS**

- Cambio de línea: '\r\n'.
```
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chapas.csv'
INTO TABLE Chapas
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
```

### 3.2 EJECUTAR SCRIPT
**OPCIÓN 1: Línea de comandos (Bash).**
```
mysql -h <servidor> -u <usuario> -p < mysql_BeerCap.sql
```
```
david@debian-12:~$ mysql -h localhost -u david -p < mysql_BeerCap.sql
Enter password:
Fabricantes_Chapa       Productores_Cerveza     Cervezas        Chapas  Catas
26      167     341     401     309
````



**OPCIÓN 2: MySQL WORKBENCH**
Cargar script sql y lanzar.

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/ejecucion_workbench.jpg)


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
E:\BeerCap>sqlcmd -S %COMPUTERNAME%\SQLEXPRESS -U sa -P manager -Q "BACKUP DATABASE [BeerCap] TO DISK = 'E:\BeerCap\sql\SQL-Server\BeerCap.BAK' WITH NOUNLOAD, SKIP, STATS = 10, FORMAT, norewind"
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
E:\BeerCap>sqlcmd -S %COMPUTERNAME%\SQLEXPRESS -U sa -P manager -Q "RESTORE DATABASE [BeerCap] FROM DISK = 'E:\BeerCap\sql\SQL-Server\BeerCap.BAK' WITH REPLACE"
Se han procesado 560 páginas para la base de datos 'BeerCap', archivo 'BeerCap' en el archivo 1.
Se han procesado 2 páginas para la base de datos 'BeerCap', archivo 'BeerCap_log' en el archivo 1.
RESTORE DATABASE procesó correctamente 562 páginas en 0.073 segundos (60.092 MB/s).
```

### 4.2 MYSQL

**GUARDAR COPIA:**
```
mysqldump -h <servidor> -u <usuario> -p --databases <Nombre> > <backup.sql>
```
```
david@debian-12:~$ mysqldump -h localhost -u david -p --databases BeerCap > sql/MySQL/mysql_BeerCap_backup.sql
Enter password:
david@debian-12:~$ ls -l mysql_BeerCap_backup.sql
-rw-r--r-- 1 david david 150181 oct  1 17:05 mysql_BeerCap_backup.sql
```

**RESTURAR:**
```
david@debian-12:~$ mysql -h localhost -u david -p < sql/MySQL/mysql_BeerCap_backup.sql
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

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/BG_Crear_tabla.jpg)

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/BG_Crear_tabla2.jpg)

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/BG_Crear_tabla3.jpg)

![N|workbench](https://raw.githubusercontent.com/beetlebum97/BeerCap/main/screenshots/BG_Productores.jpg)

---

## 👤 Autor

**David Vázquez Rodríguez**  
📍 Madrid, España  
💼 [LinkedIn](https://www.linkedin.com/in/dvazrod)  
💻 [GitHub](https://github.com/beetlebum97)  

---

> © 2025 - Proyecto personal orientado a aprendizaje y portfolio profesional.