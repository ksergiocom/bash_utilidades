#!/bin/bash

#################################################
# Deploy simple de Laravel
# 1. Hacer push de la rama especificada
# 2. Conectarse al servidor
# 3. 
#   Si el repositorio no existe; hacer git clone.
#   Si el repositorio existe, hacer git pull.
# 4. Instalar dependencias de PHP y JS
# 5. Ejecutar build de Vite y optimización de Laravel
#################################################

# Tengo en cuenta que el fichero esta en la raiz del repo
cd "$(dirname "$0")" || { echo "❌ No se pudo acceder al directorio del script"; exit 1; }

# Configuración
BRANCH="main"
SERVER_USER="user"             
SERVER_HOST="midominio.com"              
APP_PATH="/ruta_absolute_server"              
REPO_URL="git@github.com:gituser/gitrepo.git" 

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
    echo -e '\n📦 Instalando dependencias de PHP...' && \
    composer install --no-dev --optimize-autoloader && \
    echo -e '\n📦 Instalando dependencias de Node...' && \
    npm install && \
    echo -e '\n🏗️ Construyendo assets con Vite...' && \
    npm run build && \
    echo -e '\n⚙️ Optimizando Laravel...' && \
    php artisan migrate --force && \
    php artisan optimize || { echo '❌ Error en el build o artisan optimize'; exit 1; }
" || {
    echo -e "\n❌ Error en el despliegue remoto\n"
    exit 1
}

echo -e "\n✅ Deploy de Laravel completado 🚀\n"
