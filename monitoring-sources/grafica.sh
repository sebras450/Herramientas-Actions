#!/bin/bash

# Datos del servidor de inicio
size_filesystem=500
name_filesystem=/Minio
max_length=$((size_filesystem/10))

# Datos obtenidos en el transcurso del día
DATA_FILE="$(dirname "$0")/datos.txt"  # Ruta relativa al script

# Verificar si el archivo existe
if [[ ! -f "$DATA_FILE" ]]; then
    echo "Error: El archivo $DATA_FILE no existe."
    exit 1
fi

# Función para leer y procesar datos
process_file() {
    local file=$1      # Recibe el nombre del archivo como argumento
    local column=$2    # Recibe la columna que vamos a leer
    local -n output_array=$3  # Referencia al array donde se almacenarán los resultados

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Usar la columna especificada para extraer datos
        local y=$(echo "$line" | awk -v col="$column" '{print $col}')
        output_array+=("$y")
    done < "$file"
}

# Declarar los arrays
declare -a values
declare -a days
declare -a dates
declare -a values_porcentage

# Llamar a la función
process_file "$DATA_FILE" 2 values  # Leer la columna 2
process_file "$DATA_FILE" 1 days    # Leer la columna 1
process_file "$DATA_FILE" 3 dates   # Leer la columna 3
## test prueba
# # Imprimir el contenido de los arrays
# echo "Valores procesados (columna 2): ${values[@]}"
# echo "Días procesados (columna 1): ${days[@]}"
# echo "Fechas procesadas (columna 3): ${dates[@]}"

# Gráfica
# Aumento del transcurso de los días
printf "Aumento de recursos en el transcurso de los X días\n"
printf "%-2s %-10s %s\n" "Uso" "Unidad" "Gráfica"
for value in "${values[@]}"; do
    bar=""
    for ((i=0; i<value; i+=5)); do
        bar="${bar}."
    done
    printf "%2d <unidad> | %s\n" "$value" "$bar"
done
echo

# Diferencia de días ; valor medio
declare -a values_difference
for ((i=0; i<${#values[@]}-1; i++)); do
    difference=$(( values[i+1] - values[i] ))
    values_difference+=($difference)
done

# Gráfica
j=0
promedio=0
total=0
count=${#values_difference[@]}

printf "Diferencia de recursos en el transcurso durante los X días\n"
printf "%-7s %-9s %-25s %-10s %-10s %s\n" "Día" "Día" "Fechas" "Diferencia" "Unidad" "Gráfica"

for var_1 in "${values_difference[@]}"; do
    bar=""
    total=$((total + var_1))
    for ((i=0; i<var_1; i++)); do
        bar="${bar}."
    done

    printf "%-7d %-7d %-25s %+-10d %-10s | %-s\n" \
        "${days[j]}" "${days[j+1]}" \
        "${dates[j]} - ${dates[j+1]}" \
        "${var_1}" \
        "<unidad>" \
        "$bar"

    j=$((j+1))
done
echo

# Promedio de cuanto esta creciendo el recurso monitoreado durante un tiempo
promedio=$((total / count))
printf '%0.s-' {1..102} && printf '\n'
printf "| %s | %s |\n" "Promedio de cuanto esta creciendo el recurso de monitoreo durante un tiempo de X días" "$promedio <unidad>"
printf '%0.s-' {1..102} && printf '\n'
printf "| %s | %s |\n" "Almacenamiento necesario durante los X días" "$((promedio * total)) <unidad>"
printf '%0.s-' {1..63} && printf '\n'

# Implementar una estimación a futura
