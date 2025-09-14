#!/bin/bash
# Uso: ./reemplazar.sh palabra_a_buscar palabra_a_reemplazar [dirs_a_ignorar...]
# Ejemplo: ./reemplazar.sh excento exento vendor node_modules storage

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ Debes indicar la palabra a buscar y la palabra de reemplazo."
    echo "Uso: $0 palabra_a_buscar palabra_a_reemplazar [dirs_a_ignorar...]"
    exit 1
fi

buscar="$1"
reemplazar="$2"
shift 2  # quitamos los dos primeros parámetros

# Construimos lista de exclusiones
excludes=()
for dir in "$@"; do
    if [ -d "$dir" ]; then
        excludes+=( -not -path "*/$dir/*" )
    else
        echo "⚠️ Aviso: '$dir' no es un directorio válido, se ignora."
    fi
done

# Ejecutamos find con exclusiones dinámicas
find . \
    -type f \
    "${excludes[@]}" \
    -exec sed -i "s/\b$buscar\b/$reemplazar/g" {} +

echo "✅ Se reemplazó '$buscar' por '$reemplazar' en todos los archivos permitidos."
