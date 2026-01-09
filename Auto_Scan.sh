#!/bin/bash

# ===========================================================
#					EXTRA VARIABLES WORTH CHECKING
# ===========================================================

set -euo pipefail
VERSION="2.0" # Ändra på denna vid varje förändring innan commit!!!!!!!!!!
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE_PATH="$SCRIPT_DIR/L0G.txt"
LOG_LIST=()

# ===========================================================
#						HELP / VERSION
# ===========================================================

show_help() { # Help flaggans funktion
    cat << EOF
Usage: sudo bash Auto_Scan.sh [OPTIONS]

Options:
  -h, --help        Visar detta hjälp meddelande
  -v, --version     Visar vilken version av programmet du använder + lite extra info :)
EOF
}

show_version() {
	echo "Auto_Scan version $VERSION"
}

# ===========================================================
#						ARGUMENTS
# ===========================================================

flag_arg() {
for arg in "$@"; do # lägger till några argument här
    case "$arg" in
        -h|--help)
            show_help
            log_func "INFO" "User needs help; -h/--help"
            exit 0
            ;;
        -v|--version)
            show_version
            log_func "INFO" "User needs the Auto_Scan.sh's version"
            exit 0
            ;;
         *)
            log_func "ERROR" "Unknown flag, aborting"
            echo "Okänd flagga: $arg"
            exit 1
            
    esac
done
}

# ===========================================================
#					  	  CHECKS
# ===========================================================

rot_or_nah() {
	log_func "DEBUG" "Checking if program run as root"
	if [ "$EUID" -ne 0 ]; then # Vad har programmet för behörighet?
	  log_func "ERROR" "Program was not run as root"
	  echo "Kör scriptet med sudo: sudo bash Auto_Scan.sh"
	  exit 1
	fi
	log_func "INFO" "Program run as root"
}

net_con() {
	log_func "DEBUG" "Checking internet connection"
	if ! ping -c1 www.google.com >/dev/null 2>&1 ; then # Kollar på användares nätverks status, har de någon till att börja med?
	  log_func "INFO" "PINGED www.google.com"
	  log_func "ERROR" "No internet connection"
	  echo "Ingen internet uppkoppling"
	  echo "Se över din internet uppkoppling. Har du fått en ip adress?"
	  exit 1
	fi
	log_func "INFO" "PINGED www.google.com successfully"
}

user_warning() {
	log_func "DEBUG" "User consent needed"
	echo "VARNING: Kör endast detta script på nätverk du äger eller har tillstånd att testa."
	read -r -p "Fortsätt? (y/n): " answer
	
	if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
	  log_func "ERROR" "User aborted"
	  echo "Avbryter."
	  exit 0
	fi
	log_func "INFO" "User accepted"
}

# ===========================================================
#						  CLEANUP
# ===========================================================

# Funktionen tar bort IP-list.txt när scriptet avslutas eller om något gick snett.
end_func() {
	if [ -f IP-list.txt ]; then # Om listan hittas tas den bort.
	  rm IP-list.txt
	  log_func "INFO" "Deleted IP-list.txt"
	fi
	if [ "$EUID" == 0 ]; then # Om man kör skriptet som root.
	  if [ $? -eq 0 ]; then # Script fungerar och avslutades normalt!
	    echo ""
	    echo "PROGRAM AVSLUTAS."
	    log_func "INFO" "Program shutting down"
	    writer_to_L0G
	  else # Script kraschar, detta är en FATAL
	    echo "Något gick snett!"
	    log_func "FATAL" "Program shutting down"
	    writer_to_L0G
	  fi
	else
	  echo "Program Avslutas."
	fi
}

trap end_func EXIT # När koden avslutas eller om något går fel körs funktionen

# ===========================================================
#						   LOG STUFF
# ===========================================================

L0G_maker() { # Skapar log filen om den inte hittas i nuvarande katalog.
	if [ ! -f L0G.txt ]; then
	touch L0G.txt
	log_func "INFO" "L0G.txt was created."
	fi
}

log_func() { # Logg funktionen som kommer spara händelser och fel meddelanden i en array
	# Log Levels: DEBUG, INFO, WARN, ERROR, FATAL
	local log_level=$1 # Representerar Log Level
	local message=$2 # Meddelandet som kommer dyka upp om vad som hände. 
	local epoch_ns=$(date +%s%N) # Antalet nano sekunder som gör det lättare att sortera senare. Kommer att tas bort också senare.
	local human_time=$(date +"%Y-%m-%d %H:%M:%S") # Datumet och tiden som detta inträffade.
	
	LOG_LIST+=("$epoch_ns|$human_time [$log_level] $message") # Lägger till i array LOG_LIST.
}

writer_to_L0G() { # Funktionen som sorterar och skriver ner allt i L0G.txt.
	mapfile -t sorted_logs < <( printf "%s\n" "${LOG_LIST[@]}" | sort -n -t'|' -k1 ) # Sorterar LOG_LIST efter epoch tiden. Äldst högst upp.
	for entry in "${sorted_logs[@]}"; do # Skriver in i L0G.txt 
	  echo "${entry#*|}" >> "$LOG_FILE_PATH"
	done 
}

# ===========================================================
#						  SCAN LOGIC
# ===========================================================

IP_list_maker() {
# Följande körs ifall man inte har en text fil som heter IP-list
	if [ ! -f IP-list.txt ]; then
	  touch IP-list.txt
	  log_func "INFO" "IP-list.txt was created." 										# Skapar listan som kommer att innehålla våra grann-enheters IP-adresser.
	elif [ -f IP-list.txt ]; then
	  > IP-list.txt
	  log_func "INFO" "IP-list.txt was cleared." 										# Om listan redan finns, på något sätt, töms den för användning
	else
	  log_func "ERROR" "IP_list_maker function is not working properly"
	fi
}

nmap_installer() {
	log_func "DEBUG" "Checking nmap status"
	if [ ! -f /usr/bin/nmap ]; then 													# Om nmap är ej installerad kommer den att bli det här
	  sudo apt update && sudo apt install nmap 											# Installerar nmap
	  log_func "INFO" "nmap has been installed and updated"
	fi
}

IP_range_calc() {
	log_func "DEBUG" "Calculating IPv4 address range"
	# Man måste veta vilka de första 3 oktetterna är i ens IP-adress range.
	my_ip=$(ip route get 8.8.8.8 | grep -oP 'src \K[^ ]+') 								# Variabel som sparar IP-nätverket man är på som går ut mot internet. Pingar Google.
	echo "Din IPv4 adress: $my_ip"
	oct="${my_ip%${my_ip##*.}}" 														# Tar bart den sista oktetten.
	log_func "INFO" "Calculated IPv4 address range"
}

ping_sweep() {
	log_func "DEBUG" "Perfroming the ping sweep"
	for ip in $(seq 1 254); do  														# Gör en Ping sweep från .1 - .254
	ping -c 1 $oct$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> IP-list.txt & 	# Själva sweepen, men också sparar i IP-list.txt
	done
	log_func "INFO" "Auto_Scan.sh has performed the ping-sweep"
	log_func "INFO" "Auto_Scan.sh has logged responsive IPv4:s in IP-list.txt"
	wait 																				# Väntar tills alla ping-kommandon är klara innan den går vidare.
	echo ""
	echo "=================================================="
	echo ""
}

port_scan() {
	log_func "DEBUG" "Initiating port scan"
	log_func "INFO" "IP-list.txt is being used"
	while IFS= read -r line; do 														# While loop för att kunna skanna porten för varje IPv4 adress i listan.
	echo "Processing Internet Protocol: $line"
	nmap -T5 --min-rate 5000 "$line" 													# Använder nmap för att skanna IPv4 TCP port.
	echo ""
	done < IP-list.txt 																	# Visar att den ska hämta från IP-list.txt
	log_func "INFO" "Port scan has been completed"
}

# ===========================================================
#						    MAIN
# ===========================================================

main() { 																				# Här kör koden JIPPIE!!!
  flag_arg "$@"
  log_func "INFO" "SCRIPT HAS BEGUN!!!"
  L0G_maker
  rot_or_nah
  net_con
  user_warning
  IP_list_maker
  nmap_installer
  IP_range_calc
  ping_sweep
  port_scan
}

main "$@"
