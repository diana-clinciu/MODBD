# Proiect MODBD – Gestiune Hotel

### Descriere

Acest proiect reprezintă un sistem de gestiune pentru o unitate hotelieră, care oferă servicii de cazare, evenimente și servicii suplimentare (spa, fitness, transport etc.).
Proiectul include etapele de analiză, implementare a bazei de date și dezvoltare a aplicației.

### Structura proiectului

1.Fișier complet al proiectului (.docx)
Integrează toate cerințele proiectului.
Denumire: NumeEchipa_Nume_Prenume_Proiect

2.Componența echipei (.txt)
Conține membrii echipei și task-urile realizate de fiecare.
Denumire: NumeEchipa_Nume_Prenume_Echipa

3.Raport de analiză (.docx)
Include descrierea modelului și obiectivele aplicației, diagrame OLTP (E-R și conceptuală), diagrama stea/fulg pentru DW, etc.
Denumire: NumeEchipa_Nume_Prenume_Analiza

4.Scripturi baze de date (.txt)
Conține scripturile de creare și populare a bazelor de date OLTP și DW, definirea constrângerilor, indecșilor, obiectelor dimensiune și partițiilor.
Denumire: NumeEchipa_Nume_Prenume_Sursa

5.Descriere aplicație (.docx)
Include funcționalitatea aplicației, print-screen-uri care demonstrează rularea corectă și rapoartele generate din cererile SQL.
Denumire: NumeEchipa_Nume_Prenume_Aplicatie

## Setup Baze de Date Distribuite (Proiect MODBD)
Exista 2 baze de date distribuite: una pe EU, alta pe APAC.

Baza de date OLTP initiala se afla pe serverul de baze de date de pe EU.

## Pasul 1: Crearea rețelei Docker
Deschideți un terminal (PowerShell / Command Prompt) și rulați comanda asta pentru ca bazele de date să poată comunica între ele:

`bash
docker network create hotel_net
`

## Pasul 2: Pornirea celor 2 Servere
Rulați pe rând aceste două comenzi. 

**Serverul 1 (EU) - pe portul 1522:**

`bash
docker run -d --name oracle-eu --network hotel_net -p 1522:1521 -e ORACLE_PWD=password container-registry.oracle.com/database/free:latest
`

**Serverul 2 (APAC) - pe portul 1523:**

`bash
docker run -d --name oracle-apac --network hotel_net -p 1523:1521 -e ORACLE_PWD=password container-registry.oracle.com/database/free:latest
`


