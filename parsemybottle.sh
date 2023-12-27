#!/bin/bash
# -*- coding: utf-8 -*-

# HTML Parsing script for acquiring information of hosts in a domain
# Script made by sp1d3rm0rph3us


### FUNCTIONS ###

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_red() {
    echo -e "${RED}$1${NC}"
}

print_green() {
    echo -e "${GREEN}$1${NC}"
}

print_blue(){
    echo -e "${BLUE}$1${NC}"
}

animate_dots() {
    local i
    for i in {1..4}; do
        echo -ne "..${i//?/.}" && sleep 0.2
        echo -ne "\r\033[K" && sleep 0.2
    done
    echo ""     # Empty line 
}

animate_banner() {
    local blue_color=$(tput setaf 4)
    local reset_color=$(tput sgr0)
    local banner=("====================" "====================" "============ ${blue_color}PARSE MY BOTTLE${reset_color}" "====================" "====================")
    local i

    for ((i=0; i<${#banner[@]}; i++)); do
        echo "${banner[$i]}"
        sleep 0.2
        echo -e "\r\033[K"  # Clears the line
    done
}


### Banner and main conditions ###

animate_banner

for i in {1..4}; do
    echo -ne "${RED}Because they can not hide${NC}${i//?/.}" && sleep 1
    echo -ne "\r\033[K" && sleep 0.2
done
echo ""     # Empty line 


if [ "$1" == "" ]; then
    echo "Usage: $0 [URL]"
    echo "Ex: $0 www.google.com"

else
    url=$1
    dir_destiny="/tmp"
    time=0

    # Set the filename to always be "index.html"
    file_name="index.html"

    # Downloads the file to /tmp as index.html
    echo "[*] Downloading webpage"
    animate_dots

    if wget -O "$dir_destiny/$file_name" "$url" 1>/dev/null 2>&1; then
        print_green "[+] Download successful!"
        echo ""
        echo "[*] Processing the output..."
        animate_dots

        # Treating the output
        cat "$dir_destiny/$file_name" | egrep 'href="http|href="https' | cut -d "=" -f2 | cut -d "|" -f1 | \
    cut -d '"' -f2 | egrep -v "Styleshout" > /tmp/hostslist ;

        # Getting the IP addresses of all hosts captured
        for url in $(cat /tmp/hostslist); do host $url | grep "has address" >> /tmp/hostslist; done;
        cat /tmp/hostslist | awk '{print "\033[0;33m" $0 "\033[0m"}'
 
        # Deleting the index.html file 
        print_red "[!] DELETING INDEX.HTML FILE..."
        rm /tmp/index.html
        animate_dots
        print_red "[!] DELETING HOSTSLISTS FILE..."
        rm /tmp/hostslist 
        animate_dots
        print_green "[+] DONE! :)"
        echo ""
        echo ""
        print_red "~ They can't hide ~"

    else
        # Checks if the HTTP status code is 403 and, if it is, prints it to the user
        http_status=$(wget --spider --server-response "$url" 2>&1 | awk '/HTTP.* 403 / {print $2}')
        if [ "$http_status" == "403" ]; then
            print_red "[!] HTTP Error 403: Forbidden"
            echo ""
            print_red "~ They can't hide... for too long ~"
            exit 1
        fi

        # Otherwise, print generic error screen 
        print_red "[-] Download failed. Please try again. Have you typed the URL correctly?"
        echo ""
        echo ""
        print_red "~ They can't hide... for too long ~"
        exit 1
    fi
fi

