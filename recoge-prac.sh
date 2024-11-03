#!/bin/bash

# Parámetros:
# 1) directorio origen
# 2) directorio destino

log () {
	echo "Recoge prac: $1" >> informe-pract.log
}

log "Iniciando ejecución"
trap 'log "Finalizando ejecución"' EXIT

src_dir="$1"
dest_dir="$2"

if [ "$#" -ne 2 ]
then
	echo "Uso: $0 <directorio origen> <directorio destino>"
	log "Error en los parámetros"
	exit 1
fi

if [ ! -d "$src_dir" ]
then
	echo "El directorio origen \"$src_dir\" no existe"
	log "El directorio origen \"$src_dir\" no existe"
	exit 1
fi

if [ ! -d "$dest_dir" ]
then
	echo "El directorio destino \"$dest_dir\" no existe"
	log "El directorio destino \"$dest_dir\" no existe"
	exit 1
fi

for dir in "$src_dir"/*
do 
    if [ -d "$dir" ]
    then
        alumno=$(basename "$dir")
		prac_file="$dir/prac.sh"
		if [ -f "$prac_file" -a -r "$prac_file" ]
		then
			cp "$dir/prac.sh" "$dest_dir/$alumno.sh"
			log "Copiado $dir/prac.sh a $dest_dir/$alumno.sh"
		fi
    fi 
done