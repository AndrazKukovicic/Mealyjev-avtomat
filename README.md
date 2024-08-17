# Mealyjev-avtomat
---
### Projektna naloga pri Programiranju 1
---
Mealyjev avtomat, je avtomat s končnim številom stanj in izhodom odvisnim od trenutnega prehoda.
Formalno je Mealyjev avtomat predstavljen s šesterico $(S, s_0, \Sigma, \Lambda, T, G)$ pri čemer je:
- $S$ končna množica vseh stanj,
- $s_0$ začetno stanje, je element množice S,
- $\Sigma$ je končna množica, ki jo imenujemo vhodna abeceda. V njej so zbrani simboli oziroma črke, ki jih lahko uporabimo za zapis vhodnih podatkov oziroma niza.
- $\Lambda$ je končna množica, ki jo imenujemo izhodna abeceda,
- $T$ je tranzicijska ali prehodna funkcija, ki preslika stanje in input v določeno naslednje stanje: $T: S \times \Sigma \rightarrow S$,
- $G$ je izhodna funkcija, ki slika iz parov stanja in vhoda v izhodno abecedo: $G: S \times \Sigma \rightarrow \Lambda$.
  
  (Vir: https://en.wikipedia.org/wiki/Mealy_machine, dostopano 16.8.2024)
  
---

## Primera Mealyjevega avtomata
Ogledali si bomo enostavna primera Mealyjevih avtomatov.

**I. Prvi avtomat** bo v nizu sestavljenem iz $0$ in $1$ zamenjal znaka $1$ in $0$.
V tem primeru je vhodna abeceda sestavljena le iz znakov $0$ in $1$: $\Sigma =$ {0, 1}.
1. Imejmo začetno stanje $s_0 \in S$  avtomat pogleda prvi znak v nizu in če je enak $0$ ga zamenja z $1$ in se vrne nazaj v isto stanje. Tranzicijska funkcija je torej $T: (s_0, 0) \mapsto s_0$. Izhodna funkcija $0$ zamenja z $1$: $G: (s_o, 0) \mapsto 1$.
2. Če je zank v nizu enak $1$ ga zamenja z $0$  in se ponovno vrne v začetno stanje $s_0$ torej je tranzicijska funkcija v tem primeru enaka $T: (s_0, 1) \mapsto s_0$. Izhodna funkcija pa $G: (s_o, 1) \mapsto 0$.
3. Ko smo prišli do konca niza smo zamenjali vse znake.
   
   (Vir: https://www.geeksforgeeks.org/mealy-machine-for-1s-complement/, dostopano 16.8.2024)

**II. Drugi avtomat** je malo zapletenejši a popolnoma obvladljiv. V nizu iz $0$ in $1$ bo preveril ali se pojavita niza $101$ in $110$. V tem primeru bomo potrebovali štiri stanja, ki jih označimo s $q_0, q_1, q_2, q_3$ torej je množica vseh stanj: $S = {q_0, q_1, q_2, q_3}$. Vhodna abeceda je enaka kot pri prejšnjem primeru: $\Sigma =$ {0, 1}. Sestavili bomo avtomat, ki bo v primeru pojavitve $101$ vrnil $A$, če se pojavi $110$ vrnil $B$, kadar pa bo znak končni znak nekega drugega niza bo vrnil $C$.
- Za začetno stanje bomo izbrali $q_0$. Prehodno in izhodno funkcijo bomo predstavili nekoliko pregledneje kot v prvem primeru predstavili kot seznam četveric oblike (vhodno stanje, vhodni znak, izhodno stanje, izhodni znak):
   - $(q_0, 0, q_0, C)$
   - $(q_0, 1, q_1, C)$
   - $(q_1, 0, q_2, C)$
   - $(q_1, 1, q_3, C)$
   - $(q_2, 0, q_0, C)$
   - $(q_2, 1, q_1, A)$
   - $(q_3, 0, q_2, B)$
   - $(q_3, 1, q_3, C)$
     
     (Vir: https://www.javatpoint.com/automata-mealy-machine, dostopano 16.8.2024)
- Shema avtomata je prikazana na spodnji sliki.

  (Vir: https://static.javatpoint.com/tutorial/automata/images/automata-mealy-machine-example1_2.png, dostopano 16.8.2024)

  ![Shema opisanega avtomata](https://github.com/user-attachments/assets/06136b72-4396-4278-9a4e-b2e0ae012876)

---
  
## Primerjava Moorovega in Mealyjevega avtomata
Tako Moorovi kot Mealyjevi avtomati so primeri končnih avtomatov. Mealyjevi se od Moorovih razlikujejo po tem, da je rezultat prehodne funkcije pri prvih odvisen od trenutnega stanja in trenutnih vhodnih podatkov, medtem ko je pri drugih odvisen le od trenutnega stanja. Pri Moorovih avtomatih je torej vsako stanje označeno z izhodno vrednostjo, medtem ko je pri Mealyjevih avtomatih vsak prehod med stanji označen z izhodno vrednostjo.

(Vir: https://en.wikipedia.org/wiki/Moore_machine, dostopano 16.8.2024)

---
# Implementacija Mealyjevega avtomata 
## Razlika med mojim in profesorjevim modelom
Za implementacijo mojega modela sem si pomagal s profesorjevim zgledom, ki je dostopen na https://github.com/matijapretnar/programiranje-1/tree/master/projekt. Moja implementacija je v grobem nadgradnja profesorjeve v dveh točkah:
- implementira Mealyjev avtomat: dodan je bil tip za zapis izhoda in prilagojene vse funkcije,
- uporabnik lahko v tekstovnem vmesniku vnese poljuben Mealyjev avtomat in tako obdela poljuben niz.

## Navodila za uporabo

Datoteke skupaj sestavljajo tekstovni vmesnik, ki ga izgradimo z ukazom `dune build`. Ustvari se datoteka `tekstovniVmesnik.exe`, ki jo lahko poženemo z ukazom `opam exec -- dune exec ./tekstovniVmesnik.exe` za tak zagon moramo imeti nameščen `opam`. 

Ob splošnih navodilih za uporabo so zapisana tudi navodila za implementacijo našega prvega primera.
- Prikazal se bo napis
  ```
  Vnesi začetno stanje:
  ```
  tu vnesemo oznako za začetno stanje in pritisnemo `Enter`, v našem primeru vnesemo `s0`in pritisnemo `Enter`.
- Nato se prikaže
  ```
  Vnesi ostala stanja (ločena s presledki):
  ```
  vnesemo še oznake ostalih stanj in pritisnemo `Enter`, v našem primeru ne vnesemo dodatnih stanj, pritisnemo le `Enter`.
- Prikaže se vrstica
  ```
  Vnesi prehode v obliki: vhodno_stanje vhodni_znak izhodno_stanje izhodni_znak. Pritisni Enter po vsakem prehodu.
  ```
  tu navedemo prehode v zahtevanem formatu, v našem primeru napišemo `s0 1 s0 0`, `Enter`, `s0 0 s0 1` in dvakrat `Enter`.
- Pojavita se možnosti izbire
  ```
  1) Vnesi in preberi niz.
  2) Sestavi nov Mealyjev avtomat.
   ```
   vpišemo ustrezno številko.
  - Če vnesemo `1`in `Enter`se prikaže
    ```Vnesi niz:```
    kjer lahko vnesemo niz, ki ga želimo pognati v avtomatu in potrdimo z `Enter`. V našem primeru vnesemo poljuben niz sestavljen iz 1 in 0. Po potrditvi se bo izpisalo
    ```
    Izhod: 
    1) Vnesi in preberi niz.
    2) Sestavi nov Mealyjev avtomat.
    ```
    z navedenim izhodnim nizom in ponovno možnostjo izbire za naslednje dejanje. V našem primeru bo izhod niz z zamenjanimi znaki 1 in 0.
  - Če pa vnesemo `2` in potrdimo z `Enter` bomo lahko pričeli z vnašanjem parametrov za nov Mealyjev avtomat.
  
---
## Struktura datotek
Datoteke, ki so vsebinsko pomembne za implementacijo avtomata se nahajajo v mapi `src`. V njej sta mapi `definicije` in `tekstovniVmesnik`.
- V prvi so štiri datoteke `avtomat.ml`, `trak.ml`, `stanje.ml` in `zagnaniAvtomat.ml`.
  - Prva vsebuje definicijo tipa avtomat in funkcije za ustvarjanje novega avtomata in funkcijo `prehodna_funkcija`, ki za posamezno vhodno stanje in znak vrne izhodno stanje in izhodni znak.
  - Druga vsebuje definicije traku in nekaj funkcij za delo s trakom, npr. premik traka za eno mesto naprej, vnos niza v trak in podobno.
  - Tretja vsebuje definicijo tipa `Stanje`.
  - Četrta pa funkciji pomembni za poganjanje avtomata ob vsakem premiku niza.
- V drugi pa je zgolj datoteka `tekstovniVmesnik`, ki vsebuje funkcije, ki med sabo povežejo datoteke iz mape `definicije`, izpisujejo za uporabnika prijazne zapise in obdelujejo uporabnikove vnose. 

