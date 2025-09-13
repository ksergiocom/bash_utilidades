#!/bin/bash

DB_NAME="mi_base_datos"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
FILENAME="backup_${TIMESTAMP}.sql"

# El path del script para trabajar desde cualquier lado
parentPath="$(dirname "$(realpath "$0")")"

# Crear el directorio de backups si no existe
if [[ ! -d "${parentPath}/backups" ]]
then
  mkdir -p "${parentPath}/backups"
  echo "Directorio de backups creado en ${parentPath}/backups"
fi

# Dump de base de datos
mysqldump --defaults-extra-file="${parentPath}/mysql.conf" $DB_NAME > "${parentPath}/backups/${FILENAME}"

echo "Backup completado correctamente en "


# Eliminar antiguos
find "${parentPath}/backups" -name "backup_*" -type f -mtime +30 -delete;

echo "Archivos antiguos eliminados"
