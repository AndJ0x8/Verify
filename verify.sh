#!/bin/bash

# Colors
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
purple="\e[0;35m\033[1m"
yellow="\e[0;33m\033[1m"
gray="\e[0;37m\033[1m"


# Ctrl c
trap ctrl_c INT

 function ctrl_c() {
   echo "$(tput setaf 5) "
   echo "---------------------------------------------------------------"
   echo -e "\n${yellow}[*]${end}${gray}..Saliendo..!!!${end}"
   sleep 2
   exit 0
}


# Figlet title
echo -e "${red}$(figlet -f standard   'VERIFY')${end}"

# Set up variables
chars=( "\e[32m▁\e[0m" "\e[32m▂\e[0m" "\e[32m▃\e[0m" "\e[32m▄\e[0m" "\e[32m▅\e[0m" "\e[32m▆\e[0m" "\e[32m▇\e[0m" "\e[32m█\e[0m" "\e[32m▇\e[0m" "\e[32m▆\e[0m" "\e[32m▅\e[0m" "\e[32m▄\e[0m" "\e[32m▃\e[0m" "\e[32m▂\e[0m" )

echo -e "\e[1;30m\e[0m"

# Function to show an animated progress bar
function progress_bar() {
    interval=0.1
    index=1
    while [[ true ]]; do
        echo -en "\r[${chars[index]}]"
        sleep $interval
        index=$(((index+1) % ${#chars[@]}))
    done
}


# Function to check the status of an onion site
function check_onion_status() {
    onion_url=$1
    max_wait_time=75

    progress_bar &
    progress_pid=$!

    response=$(torsocks curl --silent --head --max-time $max_wait_time $onion_url 2> /dev/null)

    kill $progress_pid > /dev/null 2>&1

    if [[ ! -z "$response" ]]; then
        if echo "$response" | grep -E "HTTP/[0-9]+\.[0-9]+ [2-5][0-9][0-9]" > /dev/null; then
            echo -e "\n${green}El sitio onion está activo: $onion_url ${end}"
        else
            echo -e "\n${red}El sitio onion está desactivado: $onion_url ${end}"
        fi
    else
        echo -e "\n${red}No se pudo obtener una respuesta del sitio onion (desactivado): $onion_url ${end}"
    fi
}




# User interaction to choose options
function menu() {
    echo -e "${purple}Opciones:${end}"
    echo "1. Introducir una dirección .onion"
    echo "2. Introducir un archivo con direcciones .onion"
    echo "3. Salir"
    read -p "Elige una opción: " choice

    case $choice in
        1)
            read -p "Introduce la URL del sitio onion que quieres comprobar: " onion_url
            check_onion_status "$onion_url"
            ;;
        2)
            read -p "Introduce la ruta del archivo  con direcciones .onion: " file_path
            if [ ! -f "$file_path" ]; then
                echo -e "${red}Archivo no encontrado.${end}"
            else
                while IFS= read -r onion_url; do
                    check_onion_status "$onion_url"
                done < "$file_path"
            fi
            ;;
        3)
            ctrl_c
            ;;
        *)
            echo -e "${red}Opción inválida.${end}"
            menu
            ;;
    esac
}

# Start the menu
menu
