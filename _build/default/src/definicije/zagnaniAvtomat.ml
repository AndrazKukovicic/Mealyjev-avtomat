type t = { avtomat : Avtomat.t; trak : Trak.t; stanje : Stanje.t }

let pozeni avtomat trak =
  { avtomat; trak; stanje = Avtomat.zacetno_stanje avtomat }

let avtomat { avtomat; _ } = avtomat
let trak { trak; _ } = trak
let stanje { stanje; _ } = stanje

let korak_naprej { avtomat; trak; stanje } =
  if 
    Trak.je_na_koncu trak then  { avtomat; trak; stanje } 
  else 
    let (stanje', izhod) =
      Avtomat.prehodna_funkcija avtomat stanje (Trak.trenutni_znak trak)   
    in
    { avtomat; trak = (Trak.dodaj_izhod (Trak.premakni_naprej trak) izhod) ; stanje = stanje' }
   


