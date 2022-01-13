############################################## #
# Ejercicio 1.10.1 sobre Marra & DeWoody (2014)
############################################## #
# 1) Cambie el directorio a /CSB/unix/sandbox

# Si guardaste el directorio CSB en tu casa
# directorio, como se sugiere, debería poder
# para ir a la caja de arena escribiendo

cd ~/CSB/unix/sandbox

############################################## #
#2) ¿Cuál es el tamaño del archivo?
#Marra2014_data.fasta?


# La opción -l del comando ls también informa
# el tamaño del archivo. Agregar la bandera -h
# lo hace "human-readable" (es decir, usando K, M,
# en lugar de imprimir el número de bytes). 

ls -lh ../data/Marra2014_data.fasta

# Esto debería devolver 533K

# Alternativamente, el comando du (uso del disco) puede
# ser usado para una salida más compacta:

du -h ../data/Marra2014_data.fasta 

############################################## #
# 3) Crear una copia de Marra2014_data.fasta en el
# sandbox y asígnele el nombre my_file.fasta

# Para copiar un archivo, use el comando cp

cp ../data/Marra2014_data.fasta my_file.fasta

# Para asegurarse de que la copia salió bien, enumere los archivos
# en la caja de arena

ls

############################################## #
# 4) ¿Cuántos contigs se clasifican como
#isogrupo00036?

# Para contar las ocurrencias de una cadena dada, use
# grep con la opción -c

grep -c isogroup00036 my_file.fasta 

# Esto debería devolver 16

# Si no recuerda la opción -c, puede usar
# un tubo:

grep isogroup00036 my_file.fasta | wc -l

############################################## #
# 5) Reemplace el original "two-spaces" delimitador
# con una coma.

# En el archivo, la información de cada contig
# está separado por dos espacios:
# >contig00001 longitud=527 numreads=2 ...

# Nos gustaría obtener:
# >contig00001,longitud=527,númlecturas=2,...

# Podemos lograr usando cat para imprimir el
# archivo, y sustituya los espacios usando el
# comando tr en combinación con la opción
# -s (apretar).

# Antes de sobrescribir el archivo, asegurémonos
# no cometimos ningún error: canalizar el resultado
# a la cabeza para ver el resultado.

cat my_file.fasta | tr -s ' ' ',' | head -n 3

# Esto debería devolver:

#>contig00001,longitud=527,númlecturas=2,...
#ATCCTAGCTACTCTGGAGACTGAGGATTGAAGTTC...
#TTTACAATTAACCCACAAAAGGCTGTTACTGAAGG...

# que es lo que queremos.

# Tenga en cuenta que

# gato mi_archivo.fasta | tr-s ' ' ',' > mi_archivo.fasta

# no funcionaría en Linux (ver http://goo.gl/KIYV2N)

# Para evitar este problema, guarde en un archivo temporal
# y luego sobrescriba el archivo:

cat my_file.fasta | tr -s ' ' ',' > my_file.tmp
mv my_file.tmp my_file.fasta

############################################## #
# 6) ¿Cuántos isogrupos únicos hay en el archivo?

# Necesitamos extraer la información del isogrupo XXXXX
# para cada contig, ordenarlos y usar uniq para
# eliminar duplicados.

# Primero, usando grep '>' extracciones my_file.fasta
# todas las líneas con información contig:

grep '>' my_file.fasta | head -n 2
# >contig00001,length=527,numreads=2,gene=isogroup00001,status=it_thresh
# >contig00002,length=551,numreads=8,gene=isogroup00001,status=it_thresh

# Now use cut to extract the 4th column

grep '>' my_file.fasta | cut -d ',' -f 4 | head -n 2
#gene=isogroup00001
#gene=isogroup00001

# Finalmente, use ordenar | uniq | wc -l para contar el
# número de ocurrencias únicas.

grep '>' my_file.fasta | cut -d ',' -f 4 | sort | uniq | wc -l

# la respuesta es 43

# Alternativamente, uno puede usar grep escribiendo un
# complejo "regular expression" (¡más sobre esto más adelante!):

grep -o 'isogroup[[:digit:]]\+' my_file.fasta

# que significa "imprimir todas las ocurrencias del
# isogrupo de cadena seguido de uno o más dígitos"

# Luego, simplemente clasifique, elimine los duplicados y cuente:

grep -o 'isogroup[[:digit:]]\+' my_file.fasta | sort | uniq | wc -l

############################################## #
# 7) ¿Qué contig tiene el mayor número de lecturas?
# (número de lecturas)? ¿Cuántas lecturas tiene?

# Necesitamos aislar el número de lecturas también
# como los nombres de contig. Podemos usar una combinación
# de grep y corte:
grep '>' my_file.fasta | cut -d ',' -f 1,3 | head -n 3

# >contig00001,numreads=2
# >contig00002,numreads=8
# >contig00003,numreads=2

# Ahora queremos ordenar según el número de
# lee. Sin embargo, el número de lecturas es parte de
# una cadena más compleja. Podemos usar '=' a
# dividir según el signo =, y luego tomar
# la segunda columna (-k 2) para ordenar numéricamente (-n)

grep '>' my_file.fasta | cut -d ',' -f 1,3 | sort -t '=' -k 2 -n | head -n 5

# >contig00089,numreads=1
# >contig00176,numreads=1
# >contig00210,numreads=1
# >contig00001,numreads=2
# >contig00003,numreads=2

# Usando la bandera -r podemos ordenar en orden inverso:

grep '>' my_file.fasta | cut -d ',' -f 1,3 | sort -t '=' -k 2 -n -r | head -n 1

# >contig00302,númlecturas=3330

# Encontrar que el contig 00302 tiene el valor más alto
# cobertura, con 3330 lecturas.
