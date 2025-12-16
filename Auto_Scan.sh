#!/bin/bash

# Följande körs ifall man inte har en text fil som heter IP-list
if [ ! -f IP-list.txt ]; then
echo "ERROR: IP-list.txt är ej installerad."
echo "Installerar: IP-list.txt"
touch IP-list.txt #Creates the List in which our  neighbouring devices will be.
echo "IP-list.txt installerad."
echo ""

fi

echo ""

# Man måste veta vilka de första 3 oktetterna är i ens IP-adress range.
my_ip=$(ip route get 8.8.8.8 | grep -oP 'src \K[^ ]+') # Variabel som sparar IP-nätverket man är på som går ut mot internet.
echo $my_ip
