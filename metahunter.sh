#!/bin/bash
# Shell script that use a google dork to find files and download them from the internet to check its metadata
# WARNING: You NEED exiftool and lynx to use this script. To install it: sudo apt install exiftool lynx
# Made by: Sp1d3rM0rph3us

# Colors and Banner functions

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

print_yellow() {
    echo -e "${YELLOW}$1${NC}"
}

banner(){
    print_yellow "****************************************"
    print_yellow "*            METAHUNTER SCRIPT         *"
    print_yellow "****************************************"
    print_yellow "*  Obliterating your privacy, as usual *"
    print_yellow "****************************************"
}

# Checking for arguments

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "==== META HUNTER ===="
    echo "Usage $0 [example.com] [fileformat-without-dot] [OPTIONS]"
    echo ""
    echo "OPTIONS: -r"
    echo "-r                    - Autoremoves all downloaded files after the metadata dump has been done"

elif [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "==== META HUNTER ===="
    echo "Usage $0 [example.com] [fileformat-without-dot] [OPTION]"
    echo "!!!! Suported formats: pdf, doc, docx, xls, xlsx, ppt and pptx !!!!"
    echo "Use $0 -h or $0 --help for help"
    
else
    banner
    echo ""
    sleep 0.5
    echo "[*] Creating dork for $1 with extensions .$2"
    sleep 0.5
    # Command that google searches for the specific URL + extension and saves it to a variable
    lynx --dump "www.google.com/search?&q=site:$1+ext:$2" | grep ".$2" | cut -d "=" -f2 | egrep -v "site:|accounts" | sed 's/...$//' > /tmp/metahuntersites
    SEARCH=$(cat /tmp/metahuntersites)

    # Checking if the return of google's search was none
    if [ "$SEARCH" == "" ]; then
        print_red "[!] No .$2 files have been found :("
    else

        # Downloads all files found in that search
        for site in $SEARCH; do
            print_green "[+] Found $site"
            wget -q $site -P /tmp/
            sleep 0.2
        done
        echo "[!] All files downloaded"
        echo ""
        sleep 0.2
        print_yellow "[*] Dumping Metadata..."
        sleep 1

        # Print all the results
        exiftool /tmp/*.$2 | sed 's/\/tmp\///'
     
        # Checks if user has used the -r option, then removes all the files if it has
        if [ "$3" == "-r" ]; then
            echo ""
            print_green "[+] Metadata dump done, removing all downloaded files from /tmp"
            sleep 0.2
            print_red "Obliterating your privacy, as usual"
            sleep 0.2
            rm /tmp/*.$2 | rm /tmp/metahuntersites

        # If there is no -r option, then moves the downloaded files to user's Desktop or home directory
        else
            user=$(whoami)
            if [ "$user" == "root" ]; then
                mv /tmp/*.$2 /root
                rm /tmp/metahuntersites
                echo ""
                print_green "[+] Metadata dump done, all files located in /root"
                sleep 0.2
                print_red "Obliterating your privacy, as usual"
            else
                mv /tmp/*.$2 /home/$user/Desktop
                rm /tmp/metahuntersites
                echo ""
                print_green "[*] Metadata dump done, all files located in $user's Desktop"
                sleep 0.2
                print_red "Obliterating your privacy, as usual"
            fi
        fi
    fi 
fi
