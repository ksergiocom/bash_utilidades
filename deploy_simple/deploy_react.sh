#!/bin/bash

#################################################
# Deploy simple de React
# 1. Hacer push de la rama especificada
# 2. Conectarse al servidor
# 3. 
#   Si el repositorio no existe; hacer git clone.
#   Si el repositorio existe, hacer git pull.
# 4. Hacer `npm install` y `npm run build` en el servidor
#################################################

# Configuración
BRANCH="master"
SERVER_USER="sshuser"                    # Cambia por tu usuario en el servidor
SERVER_HOST="midominio.com"              # Cambia por la IP o dominio
APP_PATH="/ruta_absolute_servidor"    # Ruta donde está tu proyecto en el servidor
REPO_URL="git@github.com:gituser/gitrepo.git"  # Cambia por la URL SSH de tu repositorio

# 1. Hacer push de la rama especificada
echo -e "\n📤 Subiendo cambios a $BRANCH...\n"
git push origin "$BRANCH" || {
    echo -e "\n❌ Error al hacer git push\n"
    exit 1
}

# 2. Conectarse al servidor y ejecutar los comandos de deploy
echo -e  "\n🔗 Conectando a $SERVER_USER@$SERVER_HOST..."
ssh "$SERVER_USER@$SERVER_HOST" "
    if [ -d \"$APP_PATH/.git\" ]; then
        echo -e '\n🔄 Repositorio ya existe, haciendo git pull...\n'
        cd $APP_PATH && \
        git checkout $BRANCH && \
        git pull || { echo '❌ Error al hacer git pull'; exit 1; }
    else
        echo -e '\n📥 Repositorio no existe, haciendo git clone...\n'
        mkdir -p $APP_PATH && \
        git clone $REPO_URL $APP_PATH && \
        cd $APP_PATH && \
        git checkout $BRANCH || { echo -e '\n❌ Error al hacer git clone\n'; exit 1; }
    fi && \
    echo -e '\n📦 Instalando dependencias...' && \
    npm install && \
    echo -e '\n🏗️ Construyendo el proyecto...' && \
    npm run build || { echo '❌ Error al hacer npm install o npm run build'; exit 1; }
" || {
    echo -e "\n❌ Error en el despliegue remoto\n"
    exit 1
}

echo -e "\n✅ Deploy completado\n"