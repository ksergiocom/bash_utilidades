#!/bin/bash

# -------------------------------------------------
# Script: deploy_uploads.sh
# Copia todo el contenido de storage/app/private/uploads
# al servidor remoto, creando la ruta destino si no existe.
# -------------------------------------------------

# Obtener el directorio donde está el script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"


# Configuración
SERVER_USER="sshuser"               # Cambia por tu usuario en el servidor
SERVER_HOST="midominio.com"         # IP o dominio del servidor
DESTINO="/ruta_absoluta_servidor" # Ruta completa en el servidor
ORIGEN="$SCRIPT_DIR/." # Ruta de origen (usando referencia este fichero)

# Verificar carpeta origen
if [ ! -d "$ORIGEN" ]; then
    echo "❌ Carpeta origen $ORIGEN no existe."
    exit 1
fi

# Crear carpeta destino en el servidor remoto si no existe
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p '$DESTINO'" || {
    echo "❌ Error creando carpeta destino en el servidor."
    exit 1
}

# Copiar archivos al servidor usando rsync
rsync -avz --progress "$ORIGEN/" "$SERVER_USER@$SERVER_HOST:$DESTINO/" || {
    echo "❌ Error copiando archivos al servidor."
    exit 1
}

echo "✅ Contenido de $ORIGEN copiado a $SERVER_HOST:$DESTINO correctamente."
