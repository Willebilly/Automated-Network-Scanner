## Automated Network Scanner v1.2

### Syfte/Mål
Detta projekt syftar till att skapa ett script som automatiskt scannar aktiva enheter i användarens nätverk. 
Mer specifikt det nätverk som ger åtkomst till internet. Därefter ska programmet visa vilka tcp-portar dessa enheter inklusive användaren har öppna. Programmet är skrivet i bash.

### Funktion
Scriptet visar följande information:
Din IPv4 address
Enheter i samma nätverks IPv4 address
TCP portar som är öppna hos enheterna
> INFO:
> En .txt fil kommer att skapas i samma mapp, den kommer att användas av koden.

### Systemkrav
Programmet är endast körbart i Linux miljöer. Ex: Ubuntu, Debian, Kali Linux.

OBS: Man bör ha nmap för installerad, annars blir den automatiskt installerad när man väl kör Auto_Scan.sh. Alltså ingen fara om nmap inte är det, men för säkerhets skull. 

### Instruktioner för körning
Ladda ned filen Auto_Scan.sh i en mapp i din Linux miljö. 
! Gå in på mappen i Linux terminal. !
Skriv i terminalen: chmod +x Auto_Scan.sh 
För att köra programmet skriv i terminalen: sudo bash Auto_Scan.sh
Godkänn att det är ok att köra programmet i ditt nuvarande nätverk.
