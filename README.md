# Automated Network Scanner v1.2

## Syfte/Mål
Detta projekt syftar till att skapa ett script som automatiskt scannar aktiva enheter i användarens nätverk. 
Mer specifikt det nätverk som ger åtkomst till internet. Därefter ska programmet visa vilka tcp-portar dessa enheter inklusive användaren har öppna. Programmet är skrivet i bash.

## Funktion
Scriptet visar följande information:
* Din IPv4 address
* Enheter i samma nätverk och deras IPv4 address
* TCP portar som är öppna hos enheterna inklusive dig
> INFO:
> En .txt fil kommer att skapas i samma mapp, den kommer att användas av koden.

## Systemkrav
Programmet är endast **körbart i _Linux_ miljöer**. Ex: Ubuntu, Debian, Kali Linux.

Scriptet kontrollerar automatiskt användarens privilegier innan den startar.

## Instruktioner för körning
1. Ladda ned filen Auto_Scan.sh i en mapp i din Linux miljö. 
2. ! Gå in på mappen i Linux terminal. !
3. Skriv i terminalen: chmod +x Auto_Scan.sh 
4. För att köra programmet skriv i terminalen: sudo bash Auto_Scan.sh
5. Godkänn att det är ok att köra programmet i ditt nuvarande nätverk.

## Screenshot
När allt fungerar bör du få följande resultat!
<img width="646" height="726" alt="Testkörning av kod" src="https://github.com/user-attachments/assets/9961a80e-ea22-4244-8161-646c78d624c9" />

## Flowschart
![Automated-Network-Scanner Flowschart image](https://github.com/user-attachments/assets/0bebcd16-7b60-432f-818b-f3f775736122)
