#!/bin/bash
# Script that automatically look for the ns address of a domain and try to force a zone transfer
# Made by Sp1d3rM0rph3us

# COLOR VARIABLES AND BANNER #

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_red() {
    printf "${RED}$1${NC}\n"
}

print_green() {
    printf "${GREEN}$1${NC}\n"
}

print_blue(){
    printf "${BLUE}$1${NC}\n"
}

print_yellow() {
    printf "${YELLOW}$1${NC}\n"
}

banner(){
    print_red "****************************************"
    print_red "*             GET OVER HERE            *"
    print_red "****************************************"
    print_red "*  Obliterating your privacy, as usual *"
    print_red "****************************************"
}

if [ "$1" == "" ]; then
    printf "Usage: $0 [domain]\n"

else
    banner
    nameservers=$(host -t ns "$1" | cut -d " " -f4 | sed 's/.$//')
    printf "[*] Getting $1's name server address...\n"
    sleep 1
    print_green "[+] Target's Name Servers:\n"
    printf "$nameservers\n"
    print_yellow "[*] Trying to force a zone transfer in all NS"
    sleep 0.5
    for ns in $nameservers; do
        host -l -a "$1" "$ns"
    done
    
    echo ""
    print_red "Obliterating your privacy, as usual"
fi
