############################################## #
# Ejercicio 1.10.2 sobre Gesquiere et al. (2011)
############################################## #
# 1) ¿Cuántas veces fueron los niveles de los individuos
#3 y 27 grabados?

# Primero, veamos la estructura del archivo:

head -n 3 ../data/Gesquiere2011_data.csv 

# maleID	GC	T
# 1	66.9	64.57
# 1	51.09	35.57

# Queremos extraer todas las filas en las que
# la primera columna es 3 (o 27) y cuéntalas.

# Para extraer solo la primera columna, podemos usar cut


cut -f 1 ../data/Gesquiere2011_data.csv | head -n 3

# maleID
# 1
# 1

# Entonces podemos canalizar los resultados a grep -c para contar
# el número de ocurrencias (tenga en cuenta la bandera -w como
# queremos hacer coincidir 3 pero no 13 o 23):

# maleID 3

cut -f 1 ../data/Gesquiere2011_data.csv | grep -c -w 3

# 61

# maleID 27

cut -f 1 ../data/Gesquiere2011_data.csv | grep -c -w 27

# 5

############################################## #
# 2) Escriba un script tomando como entrada el nombre del archivo
# y el DNI del individuo, y devolviendo el
# número de registros para esa ID.

# Solo necesitamos a) leer la entrada del comando
# línea (usando $1 para nombre de archivo y $2 para ID), y
# luego ejecute los comandos anteriores.

# El script count_baboons.sh muestra la solución

bash count_baboons.sh ../data/Gesquiere2011_data.csv 27

# 5

############################################## #
# 3) Escriba un script que devuelva el número de
# veces que se tomaron muestras de cada individuo.

# Esto requiere a) extraer todos los ID yb) llamar
# el script de arriba para cada ID

# Para obtener todas las identificaciones únicas, necesitamos cola -n +2 el
# archivo para eliminar el encabezado, cut -f 1 para extraer
# los ID, y luego ejecute sort | uniq para
# eliminar los duplicados:

tail -n +2 ../data/Gesquiere2011_data.csv | cut -f 1 | sort -n | uniq

# 1
# 2
# 3
# 4
# ...

# To store this list in a script, you can use

myIDS=`tail -n +2 ../data/Gesquiere2011_data.csv | cut -f 1 | sort -n | uniq`

# And now use a "loop" to cycle through all
# IDs:

for id in $myIDS
do
    mycounts=`bash count_baboons.sh ../data/Gesquiere2011_data.csv $id`
    echo "ID:" $id "counts:" $mycounts
done 

# El archivo count_all_baboons.sh muestra el completo
# texto:

bash count_all_baboons.sh

# ID: 1 counts: 10
# ID: 2 counts: 2
# ID: 3 counts: 61
# ...
