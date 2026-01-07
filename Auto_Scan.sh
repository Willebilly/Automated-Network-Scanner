#!/bin/bash
set -euo pipefail
if [ "$EUID" -ne 0 ]; then
  echo "Kör scriptet med sudo: sudo bash Auto_Scan.sh"
  exit 1
fi

echo "VARNING: Kör endast detta script på nätverk du äger eller har tillstånd att testa."
read -r -p "Fortsätt? (y/n): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Avbryter."
  exit 0
fi


# Följande körs ifall man inte har en text fil som heter IP-list
if [ ! -f IP-list.txt ]; then
echo "ERROR: IP-list.txt är ej installerad."
echo "Installerar: IP-list.txt"
touch IP-list.txt 																	# Skapar listan som kommer att innehålla våra grann-enheters IP-adresser.
echo "IP-list.txt installerad."
else
> IP-list.txt 																		# Om listan redan finns töms den för användning
fi

if [ ! -f /usr/bin/nmap ]; then 													# Om nmap är ej installerad kommer den att bli det här
echo "ERROR: nmap är ej installerad."
echo "Installerar: nmap"
sudo apt update && sudo apt install nmap 											# Installerar nmap
echo "nmap installerad."
fi

																					# Man måste veta vilka de första 3 oktetterna är i ens IP-adress range.
my_ip=$(ip route get 8.8.8.8 | grep -oP 'src \K[^ ]+') 								# Variabel som sparar IP-nätverket man är på som går ut mot internet.
echo "Din IPv4 adress: $my_ip"
oct="${my_ip%${my_ip##*.}}" 														# Tar bart den sista oktetten.
for ip in $(seq 1 254); do  														# Gör en Ping sweep från .1 - .254
ping -c 1 $oct$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> IP-list.txt & 	# Själva sweepen, men också sparar i IP-list.txt
done
wait # Väntar tills alla ping-kommandon är klara innan den går vidare.
echo "IPv4 har sparats i IP-list.txt"
echo ""

while IFS= read -r line; do 														# While loop för att kunna skanna porten för varje IPv4 adress i listan.
echo "Processing line: $line"
nmap -T5 --min-rate 5000 "$line" 													# Använder nmap för att skanna IPv4 TCP port.


echo ""
done < IP-list.txt # Visar att den ska hämta från IP-list.txt


## Varför jag jag la till set -euo pipefail: 
#För att göra scriptet robust och säkrare, så att fel inte passeras tyst. Det minskar risken för oförutsägbart beteende vid nätverksskanning.

## Förbättring 1: Flytt av wait:
#Jag flyttade kommandot wait från slutet av while read-loopen till direkt efter ping-sweepen.
# Detta säkerställer att alla ping-kommandon är klara innan vi börjar skanna med nmap, vilket förhindrar potentiella konflikter och förbättrar prestandan.
# När wait låg inne i while-loopen väntade scriptet vid fel tillfälle, vilket kunde leda till att portskanning startade innan alla IP-adresser hade hittats.

## Förbättring 2: säkerhets- och samtyckesvarning
# Jag lade till en säkerhets- och samtyckesvarning som visas innan nätverksskanningen startar.
# Användaren måste aktivt bekräfta att skanningen endast utförs på ett nätverk som man äger eller har tillstånd att testa.
# Om användaren inte godkänner detta avbryts scriptet direkt.
