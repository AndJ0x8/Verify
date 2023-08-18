#!/bin/bash

# Colors
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"

#update packages
sudo apt-get update

#Instalar figlet
sudo apt-get install -y figlet

#Install tor
sudo apt-get install -y tor

#Install torsocks
sudo apt-get install -y torsocks

# Install curl
sudo apt-get install -y curl

echo -e "${green}Dependencias instaladas correctamente.${end}"
