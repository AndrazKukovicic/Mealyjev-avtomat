type stanje = Stanje.t
type izhod = string

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  sprejemna_stanja : stanje list;
  prehodi : (stanje * char * stanje * izhod) list;
}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje;
    sprejemna_stanja = [];
    prehodi = [];
   }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja;
  }

let dodaj_prehod stanje1 znak stanje2 izhod avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2, izhod) :: avtomat.prehodi }

let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2, _izhod) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> None
  | Some (_, _, stanje2, izhod) -> Some (stanje2, izhod)

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi

let je_sprejemno_stanje avtomat stanje =
  List.mem stanje avtomat.sprejemna_stanja


let preberi_niz avtomat q niz =
  let aux (acc_q, acc_izhod) znak =
    match acc_q with 
    | None -> (None, acc_izhod) 
    | Some q -> match prehodna_funkcija avtomat q znak with
        | None -> (None, acc_izhod)
        | Some (q', izhod) -> (Some q', acc_izhod ^ izhod)
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q, "")
