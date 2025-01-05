#!/bin/bash

#Solicitud de info
echo "Introduce el archivo o todos [.]"
read action_commit
echo "Introduce el número de la versión"
read text_commit

git add $action_commit

git commit -m "$(date +"%Y-%m-%d %H:%M:%S") $text_commit"

git push