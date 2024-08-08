type t = { niz : string; indeks_trenutnega_znaka : int; izhod : string }

let trenutni_znak trak = String.get trak.niz trak.indeks_trenutnega_znaka
let je_na_koncu trak = String.length trak.niz = trak.indeks_trenutnega_znaka


let premakni_naprej trak =
  if trak.indeks_trenutnega_znaka < String.length trak.niz -1 then
  { trak with indeks_trenutnega_znaka = succ trak.indeks_trenutnega_znaka }
  else trak

let iz_niza niz = { niz; indeks_trenutnega_znaka = 0; izhod = "" }
let prazen = iz_niza ""
let v_niz trak = trak.niz

let dodaj_izhod trak izhodni_znak =
  { trak with izhod = trak.izhod ^ izhodni_znak }

let vrni_izhod trak =
  trak.izhod

let prebrani trak = String.sub trak.niz 0 trak.indeks_trenutnega_znaka

and neprebrani trak =
  String.sub trak.niz trak.indeks_trenutnega_znaka
    (String.length trak.niz - trak.indeks_trenutnega_znaka)
