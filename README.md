2025-12-16

Nu sparas användarens lokala IP adress i en variabel. Koden får fram IP genom den IP-route som går ut 
mot googles 8.8.8.8 adress, därefter tittar den på source IPv4-adressen som togs för att kunna nå dit. 
Jag planerar för att ta de första 3 oktetterna ur denna för att användas när ping sweep genomförs.

Syftet med denna feature är att spara tid och göra så mycket som möjligt 
utan någon extra input från användaren. 

2025-12-15

Jag har skrivit en bit med kod som körs ifall IP-list.txt inte redan finns
på dator. Denna kommer användas senare i min kod som ska samla alla
IP-adresser som används av enheter på det nätverk användaren är uppkopplad 
på. 

