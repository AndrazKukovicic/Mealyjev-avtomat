# Mealyjev-avtomat
Projektna naloga pri Programiranju 1

Mealyjev avtomat, je avtomat s končnim številom stanj in izhoddom odvisnim od trenutnega prehoda.
Formalno je Mealyjev avtomat predstavljen s šesterico ( $$ S, S_0, \sigma, \lambda, T, G $$ ) pri čemer je:
- S končna množica vseh stanj,
- S_0 začetno stanje, je element množice S,
- sigma je končna množica, ki jo imenujemo vhodna abeceda,
- lambda je končna množica, ki jo imenujemo izhodna abeceda,
- T je tranzicijska funkcija, ki preslika stanje in input v določeno naslednje stanje: T: S x sigma -> S,
- G je izhodna funkcija, ki slika iz parov stanja in vhoda v izhodno abecedo: G: S x sigma -> lambda. 
