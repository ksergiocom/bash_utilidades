#!/bin/bash

# Vaciar fichero de salida
> specs.txt

# Leer cada línea del fichero de hosts
# Formato:
# Nombre_maquina:usuario:contraseña:ip:puerto_ssh
# ---------------------
# IFS Internal Field Separator
# Entonces IFS=: Separa cada linea usando ':' y asigno directamente a esas variables.
# ---------------------
while IFS=: read -r id user pass host port 
do
    
    echo "Obteniendo info de $user@$host:$port..."
        
    echo -e "\n---------\nMáquina: $id\n" >> specs.txt
    
    # ------------------------------------
    # Pasamos la passwor de forma segura a ssh
    # ssh -o Strict (evita el mensaje de los keyrings)
    # -p Para los puertos "no default" de VirtualBox
    # -n previene leer de la stdin (porque entra en conflicto con el read del bucle, sin esto solo pilla el primero)
    # inxi es la utilidad que uso para sacar los datos
    # -------------------------------------
    sshpass -p "$pass" \
    ssh -o StrictHostKeyChecking=no \
        -p "$port" \
        -n \
        "$user@$host" \
        "true > /dev/null; inxi -Fxz" \
        >> specs.txt
        # Si quiero errores silenciosos, NO se porque alguien querría eso, puedo redireccionar la salida de errores
        # 2>/dev/null
    
    # --------------------------------------
    # Podemos usar diferentes comandos para logear info:
    #
    # inxi -Fxz             # Información completa del sistema y hardware: CPU, RAM, discos, red, kernel
    # sudo lshw -short      # Lista resumida de hardware (CPU, memoria, placas, dispositivos)
    # lsblk -f              # Muestra discos, particiones y sistemas de archivos
    # lscpu                 # Información detallada de la CPU
    # lsusb                 # Lista dispositivos USB conectados
    # lspci                 # Lista dispositivos PCI conectados (GPU, tarjetas de red, etc.)
    # sudo dmidecode -t system -t bios  # Información del sistema y BIOS/firmware
    # free -h               # Estado de la memoria: total, usada, libre
    # uname -a              # Información general del kernel, hostname, arquitectura, versión
    # uname -r              # Versión del kernel
    # uname -m              # Arquitectura de la CPU (x86_64, i686, etc.)
    # uptime                # Tiempo que lleva encendido el sistema y carga promedio
    # dmesg | tail -n 20    # Últimos 20 mensajes del kernel (opcional)
    # ip addr               # Muestra las IPs de todas las interfaces de red
    # ip route              # Muestra la tabla de rutas y puerta de enlace
    # ss -tulnp             # Lista puertos abiertos y servicios escuchando
    # netstat -tulnp        # Alternativa clásica para ver puertos abiertos
    # ping -c 1 8.8.8.8     # Test de conectividad a Internet (1 paquete)
    # nmcli device status   # Estado de las interfaces de red (si NetworkManager instalado)
    #
    # --------------------------------------


    # Separador
done < .credenciales