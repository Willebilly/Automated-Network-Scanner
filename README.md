2025-12-16

Nu sparas användarens lokala IP adress i en variabel som senare kommer 
att användas i programet. Den kollar IP-route ut mot googles adress och
tittar på source IPv4 som togs för att kunna nå dit. Jag plannerar att 
de första 3 oktetterna kommer senare att användas när ping sweep genomförs.

Syftet med denna feature är att spara tid och göra så mycket som möjligt 
utan någon extra input från användaren. 

2025-12-15

Jag har skrivit en bit med kod som körs ifall IP-list.txt inte redan finns
på dator. Denna kommer användas senare i min kod som ska samla alla
IP-adresser som används av enheter på det nätverk användaren är uppkopplad 
på. 

