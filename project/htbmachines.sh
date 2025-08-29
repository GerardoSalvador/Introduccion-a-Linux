#!/bin/bash


#Colours
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
endColour="\033[0m\e[0m"

# Hicimos primero: curl -s -X GET https://htbmachines.github.io/ | cat
# Vemos que no nos sale ninguna maquina, vemos el archivo bundle.js
# Hacemos: curl -s -X GET https://htbmachines.github.io/bundle.js | cat -l js
# Hacemos filtrado por una maquina para ver la maquina: curl -s -X GET https://htbmachines.github.io/bundle.js | grep "Tentacle"
# Instalamos: sudo apt install node-js-beautify
# curl -s -X GET https://htbmachines.github.io/bundle.js | js-beautify
# curl -s -X GET https://htbmachines.github.io/bundle.js > bundle.js
# cat bundle.js | js-beautify | sponge bundle.js 
# eq = equal, ne = not equal, gt=grater than, lt=less than


# FUNCIONES ------------------

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm && exit 1
}


# Ctrl+C
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
    echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de máquina${endColour}" 
    echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar panel de ayuda${endColour}"
    echo -e "\t${purpleColour}u)${endColour} ${grayColour}Actualizar archivo bundle.js${endColour}"


}


function searchMachine(){
	echo $1
}

function updateFiles(){

    if [ ! -f bundle.js ]; then
      tput civis # Ocultar el cursor
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
      curl -s -X GET $main_url > bundle.js
      js-beautify bundle.js | sponge bundle.js
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Todos los archivos han sido descargados${endColour}"
      tput cnorm
    else
      tput civis
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando si hay actualizaciones pendientes...${endColour}"
      curl -s -X GET $main_url > bundle_temp.js
      js-beautify bundle_temp.js | sponge bundle_temp.js
      md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
      md5_original_value=$(md5sum bundle.js | awk '{print $1}')

      if [ "$md5_temp_value" == "$md5_original_value" ]; then
        echo -e "${yellowColour}[+]${endColour} ${grayColour}No se han detectado actualizaciones, lo tienes todo al día ;) ${endColour}"
        rm bundle_temp.js
      else
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Se han encontrado actualizaciones disponibles${endColour}"
        sleep 1
        rm bundle.js && mv bundle_temp.js bundle.js
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Los archivos han sido actualizados${endColour}"
      fi
      
      tput cnorm
    fi
}

# Indicadores
declare -i parameter_counter=0




while getopts "m:uh" arg; do
	case $arg in 
		m) machineName=$OPTARG; let parameter_counter+=1;;
        u) let parameter_counter+=2;;
		h) ;;
	esac
done

if [ $parameter_counter -eq 1 ]; then
	searchMachine $machineName

elif [ $parameter_counter -eq 2 ]; then
    updateFiles
else
	helpPanel
fi


















