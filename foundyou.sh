#!/bin/bash
# Script that gets the server's IP address and utilizes whois to get relevant information about it
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
    print_blue "****************************************"
    print_blue "*              FOUNDYOU :)             *"
    print_blue "****************************************"
    print_blue "*  Obliterating your privacy, as usual *"
    print_blue "****************************************"
}

# MAIN CONDITION #
if [ "$#" == "" ]; then
    echo "Usage $0 [ipaddr-or-fqdn]"

else
    banner
    hostinfo=$(host "$1")
    printf "[*] Getting $1's IP addresses\n"
    sleep 1
    if echo "$hostinfo" | grep -q "NXDOMAIN"; then
        print_red "[-] Couldn't find IP addresses linked to $1... yet."

    else
        printf "[+] $1's informations:\n"
        print_green "$hostinfo"
        sleep 0.5
        printf "[*] Getting $1's registry informations...\n"
        sleep 1
        target=$(echo $hostinfo | cut -d " " -f4)
        whoisit=$(whois "$target" | egrep "inetnum|aut-num|owner" | egrep -v "owner-c")
        if [ -n "$whoisit" ]; then
            print_green "$whoisit"
            sleep 1
            echo ""
            print_red "Obliterating your privacy, as usual"
        else
            whoisit_backup=$(whois "$target" | egrep "NetRange|NetName|OriginAS|Organization")
            print_green "$whoisit_backup"
            sleep 1
            echo ""
            print_red "Obliterating your privacy, as usual"
        fi
    fi
fi
