#Caso Call Center Verde

create database call_center_verde;
use call_center_verde;

#Análisis Exploratorio

#Chequear rango de tiempo de llamadas, min fecha y max fecha. 
select min(tiempo_llamada) as fecha_min, max(tiempo_llamada) as fecha_max from call_center;

#Chequear la cantidad de columnas y filas que tenemos en nuestros datos. 
#Cantidad de columnas
select count(*) as cantidad, 
'Columnas' as descripcion
from information_schema.columns where table_name='call_center'; 
#Cantidad de filas
select count(*) as cantidad_filas from call_center;

#Chequear los valores unicos de las siguientes columnas:
#calificacion
select distinct(calificacion) from call_center;
#razon
select distinct(razon) from call_center;
#canal
select distinct(canal) from call_center;
#tiempo_respuesta
select distinct(tiempo_respuesta) from call_center;
#call_center
select distinct(call_center) from call_center;
#estado
select distinct(estado) from call_center;

#Chequear cantidad de registros y % de las columnas anteriores.
select calificacion, count(*) as registros,
round((count(*)/(select count(*) from call_center)) * 100, 1) as porcentaje
from call_center group by calificacion;

select razon, count(*) as registros,
round((count(*)/(select count(*) from call_center)) * 100, 1) as porcentaje
from call_center group by razon;

select canal, count(*) as registros,
round((count(*)/(select count(*) from call_center)) * 100, 1) as porcentaje
from call_center group by canal;

select tiempo_respuesta, count(*) as registros,
round((count(*)/(select count(*) from call_center)) * 100, 1) as porcentaje
from call_center group by tiempo_respuesta;

select call_center, count(*) as registros,
round((count(*)/(select count(*) from call_center)) * 100, 1) as porcentaje
from call_center group by call_center;

select estado, count(*) as registros,
round((count(*)/(select count(*) from call_center)) * 100, 1) as porcentaje
from call_center group by estado;

#Duracion promedio de las llamadas exitosas por call center, llamada exitosa es aquella que duracion<10min.
select call_center, avg(duracion_llamada) as promedio from call_center where duracion_llamada<10 group by call_center;

#Limpieza de Datos
#Del campo id extraer el codigo de 8 digitos en un nuevo campo.
select *, substring(id,5,8) as green_code from call_center; 

#Debemos actualizar el formato fechas de string a fecha.
select *, substring(id,5,8) as green_code,
str_to_date(tiempo_llamada, '%m/%d/%y') as tiempo_llamada from call_center;

#convertir aquellas llamadas que tengan puntucion 0 a nulas.
select *, substring(id,5,8) as green_code,
str_to_date(tiempo_llamada, '%m/%d/%y') as tiempo_llamada,
case when puntuacion=0 then null
else puntuacion end as puntuacion from call_center;

#la ciudad de nueva york se ha descargado mal por un problema con el sofwaare y hay que pasar aquellos que no tengan el formato adecuado al que corresponde. 
select *, substring(id,5,8) as green_code,
str_to_date(tiempo_llamada, '%m/%d/%y') as tiempo_llamada,
case when puntuacion=0 then null
else puntuacion end as puntuacion,
case when estado in('NewYork', 'NY', 'New York City') 
then estado='New York' else estado end as estado from call_center;

#5. Pasar minutos que estan en enteros a formato
select *, substring(id,5,8) as green_code,
str_to_date(tiempo_llamada, '%m/%d/%y') as tiempo_llamada,
case when puntuacion=0 then null
else puntuacion end as puntuacion,
case when estado in('NewYork', 'NY', 'New York City') 
then estado='New York' else estado end as estado,
SEC_TO_TIME(duracion_llamada *60) as duracion_llamada from call_center;

CREATE TABLE call_center_verde(
select substring(id,5,8) as id,
nombre_cliente, calificacion, 
case when puntuacion=0 then null
else puntuacion end as puntuacion,
str_to_date(tiempo_llamada, "%m/%d/%Y") as tiempo_llamada, razon, ciudad,
case when estado in('NewYork', 'NY', 'New York City') 
then estado='New York' else estado end as estado,
canal, tiempo_respuesta, 
SEC_TO_TIME(duracion_llamada *60) as duracion_llamada from call_center);


