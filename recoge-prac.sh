#!/bin/bash

# Parámetros:
# 1) directorio origen
# 2) directorio destino

dirs=$(ls "$1")
for dir in "$dirs"
do
	if [ ! -d "$dir" ]; then echo "Not dir $dir"; continue; fi
	echo "$dir"
done
