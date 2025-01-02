#!/bin/bash

# Nombre del archivo donde se va a guardar la información
OUTPUT_FILE="dato_monitoreo.txt"


# Crear el encabeza del archivo "dato_monitoreo.txt" si no existe

if [ ! -f "$OUTPUT_FILE" ]; then
    echo -e "Dato\tMonitoreo \tFecha" > "$OUTPUT_FILE"
fi

# Inicializar con el contador
COUNTER=1

# Obtención de información
SIZE=$(du -sm /home/sebastian/Documents/ | awk '{print$1}')
TIMESTAMP=$(date "+%d-%B-%Y-%H:%M")

# Guardar datos en el archivo
echo -e "$COUNTER\t\t$SIZE\t\t$TIMESTAMP" >> "$OUTPUT_FILE"
