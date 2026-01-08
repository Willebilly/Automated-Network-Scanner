#!/bin/bash
set -euo pipefail

show_help() { # "Help" flaggans funktion
    cat << EOF
Usage: sudo bash Auto_Scan.sh [OPTIONS]

Options:
  -h, --help        Visar detta hjälp meddelande
  -v, --version     Visar vilken version av programmet du använder + lite extra info :)
EOF
}

for arg in "$@"; do # lägger till några argument här för att hjälpa användaren!!!
    case "$arg" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            cat README.md
            exit 0
            ;;
    esac
done


if [ "$EUID" -ne 0 ]; then # Vad har programmet för behörighet?
  echo "Kör scriptet med sudo: sudo bash Auto_Scan.sh"
  echo "Program avslutas."
  exit 1
fi

if ! ping -c1 www.google.com >/dev/null 2>&1 ; then # Kollar på användares nätverks status, har de någon till att börja med?
  echo "Ingen internet uppkoppling"
  echo "Se över din internet uppkoppling. Har du fått en ip adress?"
  echo "Program avslutas."
  exit 1
fi

echo "VARNING: Kör endast detta script på nätverk du äger eller har tillstånd att testa."
read -r -p "Fortsätt? (y/n): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Avbryter."
  exit 0
fi


# Funktionen tar bort IP-list.txt när scriptet avslutas eller om något gick snett.
end_func() {
if [ $? -eq 0 ]; then # Script fungerar och avslutades normalt!
  rm IP-list.txt
else # Script kraschar
  echo "Något gick snett!"
  rm IP-list.txt
fi
}

trap end_func EXIT # När koden avslutas eller om något går fel körs funktionen


# Följande körs ifall man inte har en text fil som heter IP-list
if [ ! -f IP-list.txt ]; then
  touch IP-list.txt 																# Skapar listan som kommer att innehålla våra grann-enheters IP-adresser.
else
  > IP-list.txt 																	# Om listan redan finns, på något sätt, töms den för användning
fi


if [ ! -f /usr/bin/nmap ]; then 													# Om nmap är ej installerad kommer den att bli det här
  sudo apt update && sudo apt install nmap 											# Installerar nmap
fi

																					# Man måste veta vilka de första 3 oktetterna är i ens IP-adress range.
my_ip=$(ip route get 8.8.8.8 | grep -oP 'src \K[^ ]+') 								# Variabel som sparar IP-nätverket man är på som går ut mot internet. Pingar Google.
echo "Din IPv4 adress: $my_ip"
oct="${my_ip%${my_ip##*.}}" 														# Tar bart den sista oktetten.
for ip in $(seq 1 254); do  														# Gör en Ping sweep från .1 - .254
ping -c 1 $oct$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> IP-list.txt & 	# Själva sweepen, men också sparar i IP-list.txt
done
wait 																				# Väntar tills alla ping-kommandon är klara innan den går vidare.
echo ""
echo "=================================================="
echo ""


while IFS= read -r line; do 														# While loop för att kunna skanna porten för varje IPv4 adress i listan.
echo "Processing line: $line"
nmap -T5 --min-rate 5000 "$line" 													# Använder nmap för att skanna IPv4 TCP port.
echo ""
done < IP-list.txt # Visar att den ska hämta från IP-list.txt
