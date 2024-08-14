type stanje = Stanje.t


type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  prehodi : (stanje * string * stanje * string) list;
}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje;
    prehodi = [];
   }

let dodaj_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_prehod stanje1 znak stanje2 izhod avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2, izhod) :: avtomat.prehodi }

  (*treba je nekako popraviti tipe pri prehodna_funkcija, znak mora biti tipa string*)
let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2, _izhod) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> failwith "Ni ustreznega prehoda"
  | Some (_, _, stanje2, izhod) ->(stanje2, izhod)

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi




let ustvari_avtomat zacetno_stanje stanja prehodi =
  let pr_avtomat = prazen_avtomat zacetno_stanje in
  let avtomat = List.fold_left (fun a s -> dodaj_stanje s a) pr_avtomat stanja in
  List.fold_left (fun a (s1, znak, s2, izhod) -> dodaj_prehod s1 znak s2 izhod a) avtomat prehodi

