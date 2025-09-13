#!/bin/bash

# Path de trabajo. !El mismo que el de este archivo!
CURRENT_DIR_PATH=$(dirname "$0")
#echo "$PATH"

# Credenciales (necesarias para acceso)
REMOTE_CONF="mysql.conf"
LOCAL_CONF="mysql-local.conf"

# Nombres de la base de datos de donde se exporta e importa
REMOTE_DB="mi_db_remota"
LOCAL_DB="mi_db_local"

# Arhchivo temporal del mysqldump (lo borro al final)
DUMP_FILE="$CURRENT_DIR_PATH/dump_$(date +%Y%m%d_%H%M%S).sql"

echo "Realizando dump de la base de datos remota..."
mysqldump --defaults-extra-file="$REMOTE_CONF" "$REMOTE_DB" > "$DUMP_FILE"

echo "Importando dump a la base de datos local..."
mysql --defaults-extra-file="$LOCAL_CONF" "$LOCAL_DB" < "$DUMP_FILE"

# !El path es por si ejecuto desde otro directorio! 
rm "$CURRENT_DIR_PATH/$DUMP_FILE"

echo "Base de datos sincronizada con exito!"
