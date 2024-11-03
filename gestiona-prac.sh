#!/bin/bash

CRON_SCRIPT="$(dirname $(realpath $0))/recoge-prac.sh)"
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
		log "Opción 1: Seleccionado asignatura=$asignatura, origen=$origen, destino=$destino"
		
		if crontab -l 2> /dev/null | grep -q "$CRON_SCRIPT"
		then
			log "Opcion 1: Recogida previamente programada"
			echo -e "\nLa recogida ya estaba programada"
		else
			full_cron_job="$CRON_JOB $(realpath $origen) $(realpath $destino)"
			(crontab -l 2> /dev/null; echo "$full_cron_job") | crontab -
			log "Opcion 1: Recogida programada con éxito ($full_cron_job)"
			echo -e "\nRecogida programada con éxito"
		fi
	else
		log "Opción 1: Cancelada"
		echo "Operación cancelada"
	fi
}

run_opcion_2 () {
	echo "jajsas"
}

run_opcion_3 () {
	echo "keo"
}

run_opcion_4() {
	echo "33"
}


log "Iniciando ejecución"
trap 'log "Finalizando programa"' EXIT

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

