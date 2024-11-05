#!/bin/bash

CRON_SCRIPT="$(dirname $(realpath $0))/recoge-prac.sh"
CRON_JOB="0 8 * * * $CRON_SCRIPT"

log () {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - Gestiona prac: $1" >> "$(dirname $(realpath $0))/informe-pract.log"
}

print_bienvenida() {
	echo "ASO 24/25 – Práctica SCRIPT"
	echo "Miguel Hermoso Mantecón"
}

print_menu () {
	echo "Gestión de prácticas"
	echo "--------------------"
	echo 
	echo "Menú"
	echo -e "\t1) Programar recogida de prácticas"
	echo -e "\t2) Empaquetado de prácticas de una asignatura"
	echo -e "\t3) Ver tamaño y fecha del fichero de una asignatura"
	echo -e "\t4) Finalizar programa"
}


run_opcion_1 () {
	echo -e "\nMenú 1 – Programar recogida de prácticas\n"
	read -p "Asignatura cuyas prácticas desea recoger: " asignatura
	read -p "Ruta con las cuentas de los alumnos: " origen
	read -p "Ruta para almacenar prácticas: " destino

	echo -e "\nSe va a programar la recogida de las prácticas de $asignatura para mañana a las 8:00. Origen: $origen. Destino: $destino\n"

	confirmado=""
	while [ "$confirmado" != "s" -a "$confirmado" != "n" ]
	do
		read -p "Está de acuerdo (s/n)? " confirmado
	done

	if [ "$confirmado" = "s" ]
	then
		log "Opción 1: Seleccionado asignatura=\"$asignatura\", origen=\"$origen\", destino=\"$destino\""
		
		if crontab -l 2> /dev/null | grep -q "$CRON_SCRIPT"
		then
			log "Opción 1: Recogida previamente programada"
			echo -e "\nLa recogida ya estaba programada"
		else
			full_cron_job="$CRON_JOB $(realpath $origen) $(realpath $destino)"
			(crontab -l 2> /dev/null; echo "$full_cron_job") | crontab - 2> /dev/null
			log "Opción 1: Recogida programada con éxito ($full_cron_job)"
			echo -e "\nRecogida programada con éxito"
		fi
	else
		log "Opción 1: Cancelada"
		echo -e "\nOperación cancelada"
	fi
}

run_opcion_2 () {
	echo -e "\nMenú 2 – Empaquetar prácticas de la asignatura\n"
	read -p "Asignatura cuyas prácticas se desea empaquetar: " asignatura
	read -p "Ruta absoluta del directorio de prácticas: " prac_dir

	echo -e "\nSe van a empaquetar las prácticas de la asignatura $asignatura presentes en el directorio $prac_dir.\n"

	confirmado=""
	while [ "$confirmado" != "s" -a "$confirmado" != "n" ]
	do
		read -p "Está de acuerdo (s/n)? " confirmado
	done
	
	if [ "$confirmado" = "s" ]
	then
		log "Opción 2: Seleccionado asignatura=\"$asignatura\", directorio=\"$prac_dir\""

		prac_dir=$(realpath "$prac_dir")
		if [ -d "$prac_dir" ]
		then
			pck_name="$asignatura-$(date +'%y%m%d').tgz"
			( # Tar will keep directory structure so cd is necessary
				cd "$prac_dir"
				tar -czf "$pck_name" *.sh 2> /dev/null
			) # The above two lines execute in their own shell
			log "Opción 2: Practicas del directorio \"$prac_dir\" empaquetadas al fichero \"$prac_dir/$pck_name\""
			echo -e "\nPracticas empaquetadas con éxito al fichero $pck_name"
		else
			log "Opción 2: El directorio de prácticas \"$prac_dir\" no existe"
			echo -e "\nEl directorio de prácticas \"$prac_dir\" no existe"
		fi
	else
		log "Opción 2: Cancelada"
		echo -e "\nOperación cancelada"
	fi
}

run_opcion_3 () {
	echo -e "\nMenú 3 – Obtener tamaño y fecha del fichero\n"
	read -p "Asignatura sobre la que queremos información: " asignatura
	read -p "Ruta absoluta del directorio de prácticas: " prac_dir
	
	log "Opción 3: Seleccionado asignatura=\"$asignatura\", directorio=\"$prac_dir\""

	prac_dir=$(realpath "$prac_dir")
	if [ -d "$prac_dir" ]
	then
		pck_file=$(ls "$prac_dir/$asignatura"-*.tgz | sort -dr | head -n 1)
		if [ -f "$pck_file" ]
		then
			# Some machines do not have '-b' option for bytes
			byte_size=$(du -b "$pck_file" | cut -f1)
			log "Opción 3: Obtenido tamaño del fichero empaquetado de prácticas \"$pck_file\". Ocupa $byte_size bytes"
			echo -e "\nEl fichero generado es $(basename $pck_file) y ocupa $byte_size bytes."
		else
			log "Opción 3: No existe fichero empaquetado de prácticas en el directorio $prac_dir"
			echo -e "\nNo existe un fichero empaquetado de prácticas"
		fi
	else
		log "Opción 3: El directorio de prácticas \"$prac_dir\" no existe"
		echo -e "\nEl directorio de prácticas \"$prac_dir\" no existe"
	fi
}

run_opcion_4() {
	log "Opción 4: Petición de finalización"
}


log "Iniciando ejecución"
trap 'log "Finalizando ejecución"' EXIT

print_bienvenida
echo

opcion="0"


while [ "$opcion" -ne "4" ]
do
	print_menu
	echo
	read -p "Opción: " opcion

	case $opcion in
		1) log "Opción 1 seleccionada"; run_opcion_1; echo;;
		2) log "Opción 2 seleccionada"; run_opcion_2; echo;;
		3) log "Opción 3 seleccionada"; run_opcion_3; echo;;
		4) log "Opción 4 seleccionada"; run_opcion_4; echo;;
		*) echo -e "Opción inválida\n"; log "Opción inválida \"$opcion\" seleccionada";;
	esac
done

