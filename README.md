# Mealyjev-avtomat
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
  (Vir: https://en.wikipedia.org/wiki/Mealy_machine)

## Primera Mealyjevega avtomata
Ogledali si bomo enostavna primera Mealyjevih avtomatov.

**I. Prvi avtomat** bo v nizu sestavljenem iz $0$ in $1$ zamenjal znaka $1$ in $0$.
V tem primeru je vhodna abeceda sestavljena le iz znakov $0$ in $1$: $\Sigma = \{0, 1\}$.
1. Imejmo začetno stanje $s_0 \in S$  avtomat pogleda prvi znak v nizu in če je enak $0$ ga zamenja z $1$ in se vrne nazaj v isto stanje. Tranzicijska funkcija je torej $T: (s_0, 0) \mapsto s_0$. Izhodna funkcija $0$ zamenja z $1$: $G: (s_o, 0) \mapsto 1$.
2. Če je zank v nizu enak $1$ ga zamenja z $0$  in se ponovno vrne v začetno stanje $s_0$ torej je tranzicijska funkcija v tem primeru enaka $T: (s_0, 1) \mapsto s_0$. Izhodna funkcija pa $G: (s_o, 1) \mapsto 0$.
3. Ko smo prišli do konca niza smo zamenjali vse znake.
   (Vir: https://www.geeksforgeeks.org/mealy-machine-for-1s-complement/)

**II. Drugi avtomat** je malo zapletenejši a popolnoma obvladljiv. V nizu iz $0$ in $1$ bo preveril ali se pojavita niza $101$ in $110$. V tem primeru bomo potrebovali štiri stanja, ki jih označimo z $q_0, q_1, q_2, q_3$ torej je množica vseh stanj: $S = {q_0, q_1, q_2, q_3}$. Vhodna abeceda je enaka kot pri prejšnjem primeru: $\Sigma = \{0, 1\}$. Sestavili bomo avtomat, ki bo v primeru pojavitve &101$ vrnil $A$, če se pojavi $110$ $B$, kadar pa bo znak končni znak nekega drugega niza bo vrnil $C$.
- Za začetno stanje bomo izbrali $q_0$. Prehodno in izhodno funkcijo bomo predstavili nekoliko pregledneje kot v prvem primeru predstavili kot seznam četveric oblike (vhodno stanje, vhodni znak, izhodno stanje, izhodni znak):
   - $(q_0, 0, q_0, C)$
   - $(q_0, 1, q_1, C)$
   - $(q_1, 0, q_2, C)$
   - $(q_1, 1, q_3, C)$
   - $(q_2, 0, q_0, C)$
   - $(q_2, 1, q_1, A)$
   - $(q_3, 0, q_2, B)$
   - $(q_3, 1, q_3, C)$
- Shema avtomata je prikazana na spodnji sliki. (Vir: https://static.javatpoint.com/tutorial/automata/images/automata-mealy-machine-example1_2.png dostopano. 16.8.2024)
  ![Shema opisanega avtomata](https://github.com/user-attachments/assets/06136b72-4396-4278-9a4e-b2e0ae012876)


  
## Primerjava Moorovega in Mealyjevega avtomata
Tako Moorovi kot Mealyjevi avtomati so primeri končnih avtomatov. Mealyjevi se  od Moorovih razlikujejo po tem, da je rezultat tranzicijske funkcije pri prvih odvisen od trenutnega stanja in trenutnih vhodnih podatkov, medtem ko je pri drugih odvisen le od trenutnega stanja. Pri Moorovih avtomatih je torej vsako stanje označeno z izhodno vrednostjo, medtem ko je pri Mealyjevih avtomatih vsak prehod med stanji označen z izhodno vrednostjo.
(Vir: https://en.wikipedia.org/wiki/Moore_machine)
