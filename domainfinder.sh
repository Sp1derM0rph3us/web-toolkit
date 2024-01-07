#!/bin/bash
# Simple script for bruteforcing finding subdomains by bruteforce and finding cname registries for possible domain takeover
# Made by: Sp1d3rM0rph3us

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

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printf "Usage: $0 [OPTION] [domain] [wordlist]\n"
    printf "\n"
    printf "OPTIONS: -t [takeover-mode], -e [enum-mode]\n"
    printf "\n"
    printf "[-t]          - Takeover mode. It will only look for cname registries.\n"
    printf "[-e]          - Enumeration mode. It will look for subdomains in general\n"

else
    if [[ "$1" == "" || "$2" == "" || "$3" == "" ]]; then
        printf "Usage: $0 [OPTION] [domain] [wordlist]\n"
        printf "Type $0 -h or --help for more information\n"
        printf "Script by: Sp1d3rM0rph3us\n"

    else
        wordlist=$(cat "$3")
        if [ "$1" == "-t" ]; then
            print_yellow "[*] Bruteforcing cname registries of $2...\n"
            for word in $wordlist; do
                host -t cname "$word.$2" | grep "is an alias for" | sed 's/is an alias for/-->/; s/\.$//; s/^/[+] /'
                sleep 1 
            done
            printf "\n"
            print_red "Obliterating your privacy, as usual."
        elif [ "$1" == "-e" ]; then
             print_yellow "[*] Bruteforcing subdomains of $2...\n"
            for word in $wordlist; do
                host "$word.$2" | grep -v "NXDOMAIN" | sed 's/\.$//; s/^/[+] /'
                sleep 0.5
            done
            printf "\n"
            print_red "Obliterating your privacy, as usual."
        else
            print_red "[-] Unrecognized option: $1"
        fi
    fi
fi
