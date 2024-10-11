# :zap: ACTUALIZACIÓN 20241011 -> Version 3 :zap:
- Nuevo nombre BeerCap.
- 10 chapas nuevas.
- Variables directorio datos (data_mysql y data_sql_server) incluidas en el script de python (BeerCap.py).

# :zap: ACTUALIZACIÓN 20240808 -> Version 2 :zap:
- 50 chapas nuevas.
- Imágenes de las chapas y logos de los fabricantes.
- Se añade columna imágenes en las tablas Fabricantes_Chapa y Chapas para en un futuro cargar esas imágenes.
- Scripts con el backup de la BD (MySQL y SQL Server).

# :zap: ACTUALIZACIÓN 20231019 -> Version 1 :zap:

- Script de python. chapas_cerveza.py realiza todo el proceso de creación e inserción de registros en la base de datos. Admite 2 tipos (mysql,sql server) y requiere 4 parámetros de entrada.

python chapas_cerveza.py <tipo> <servidor> <usuario> <contraseña>

	1º Tipo base de datos: mysql | sql-server
	2º Servidor
	3º Usuario
	4º Contraseña

- Código SQL más sencillo, ordenado e intuitivo. Como la fuente de los datos soy yo, he eliminado complicaciones y procesamientos innecesarios, propios de una descarga externa de los mismos.

- Archivos json para crear las tablas en BigQuery.

- 28 chapas nuevos.