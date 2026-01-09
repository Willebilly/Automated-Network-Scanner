# Automated Network Scanner v2.0

## Syfte/Mål
Detta projekt syftar till att skapa ett skript som automatiskt scannar aktiva enheter i användarens nätverk. 
Mer specifikt det nätverk som ger åtkomst till internet. Därefter ska programmet visa vilka tcp-portar dessa enheter inklusive användaren har öppna. Programmet är skrivet i bash.

## Funktion
Skriptet visar följande information:
* Din IPv4 address
* Enheter i samma nätverk och deras IPv4 address
* TCP portar som är öppna hos enheterna inklusive dig
> INFO:

> En .txt fil kommer att skapas i samma mapp, den kommer att användas av koden.

> En log fil, [ L0G.txt ] kommer att skapas i samma mapp, där kan du se vad som har hänt och hur skriptet har jobbat.

## Systemkrav
Programmet är endast **körbart i _Linux_ miljöer**. Ex: Ubuntu, Debian, Kali Linux.

Skriptet kontrollerar automatiskt användarens privilegier innan programmet börjar skanna.
Skriptet kontrollerar automatiskt användarens internet uppkoppling innan programmet börjar skanna.

## Instruktioner för körning
1. Ladda ned filen Auto_Scan.sh i en mapp i din Linux miljö. 
2. ! Gå in på mappen i Linux terminal. !
3. Skriv i terminalen: chmod +x Auto_Scan.sh 
4. För att köra programmet skriv i terminalen: sudo bash Auto_Scan.sh
5. Godkänn att det är ok att köra programmet i ditt nuvarande nätverk.

## Screenshot
När allt fungerar bör du få följande resultat!

<img width="637" height="759" alt="Skärmbild 2026-01-09 152831" src="https://github.com/user-attachments/assets/9e027fc6-b91e-4273-996c-1b5ca126eae7" />

## Flowschart :)
![Automated-Network-Scanner Flowschart image](https://github.com/user-attachments/assets/e1f376d3-007a-4c30-861e-1f7135d5e04b)
