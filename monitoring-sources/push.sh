#!/bin/bash

# Solicitud de info
echo "Ingresa la ubicación del repositorio"
read repo_location
echo "Introduce el número de la versión"
read text_commit

# Ejecutar comandos Git con la opción -C
git -C "$repo_location" add .
git -C "$repo_location" commit -m "$(date +"%Y-%m-%d %H:%M:%S") $text_commit"
git -C "$repo_location" push
