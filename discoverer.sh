#!/bin/bash
# Directory and file bruteforcing tool for web reconnaissance
# Made by: Sp1derM0rph3us

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_purple() {
    printf "${PURPLE}$1${NC}\n"
}

banner(){
    print_purple "****************************************"
    print_purple "*              DISCOVERER              *"
    print_purple "****************************************"
    print_purple "*  ${RED}Obliterating your privacy, as usual${PURPLE} *"
    print_purple "****************************************"
}

if [[ "$1" == "" || "$2" == "" ]]; then
    printf "Usage: $0 [target] [wordlist]"

else
    banner
    wordlist=$(cat $2)
    ua="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0"
    max_url_lenght=50

    for word in $wordlist; do
        req=$(curl -s -o /dev/null --user-agent "$ua" -w "%{http_code}" "$1/$word")
        printf "\r[*] Trying: %-$(($max_url_lenght + 5))s" "$1/$word"

        if [ "$req" == "200" ]; then
            print_green "[+] Found 200 - OK: $1/$word"
        elif [ "$req" == "403" ]; then
            print_purple "[*] Found 403 - Forbidden: $1/$word"
        else
            :
        fi
    done
    printf "\r[+] Done!%-$(($max_url_lenght + 5))s \n"
    print_red "Obliterating your privacy, as usual"
fi
