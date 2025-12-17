# 2025-12-17
Idag är Automated-Networkscanner 1.0 färdig!

Jag har lagt till en if sats som ska leta efter filen nmap. Om den inte finns kommer programmet att ladda ner det. 

# 2025-12-16

Nu sparas användarens lokala IP adress i en variabel. Koden får fram IP genom den IP-route som går ut mot googles 8.8.8.8 adress, därefter tittar den på source IPv4-adressen som togs för att kunna nå dit. Jag planerar för att ta de första 3 oktetterna ur denna för att användas när ping sweep genomförs.

Syftet med denna feature är att spara tid och göra så mycket som möjligt utan någon extra input från användaren.

Därefter delade jag upp IPv4 adressen så att nätverksdelen sparas i variabeln my_ip.

Använde mig av en for loop som både utför Ping sweep och sparar resultatet i IP-list.txt. Med hjälp av Ping sweep kan vi se vilka andra enheter som är med på nätverket användaren är uppkopplad till. 

Senare i projektet kommer informationen i IP-list.txt att användas för en TCP-portscan.

Programet använder sig nu av nmap för att skanna IPv4 adresserna efter öppna TCP-portar. 

# 2025-12-15

Jag har skrivit en bit med kod som körs ifall IP-list.txt inte redan finns
på dator. Denna kommer användas senare i min kod som ska samla alla
IP-adresser som används av enheter på det nätverk användaren är uppkopplad 
på.
