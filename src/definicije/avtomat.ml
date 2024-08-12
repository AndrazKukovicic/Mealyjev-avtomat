type stanje = Stanje.t
type izhod = string

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  prehodi : (stanje * char * stanje * izhod) list;
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

(*
  let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2, _izhod) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> failwith "Konec niza"
  | Some (_, _, stanje2, izhod) -> (stanje2, izhod)
  *)
  let prehodna_funkcija avtomat stanje znak =
    match
      List.find_opt
        (fun (stanje1, znak', _stanje2, _izhod) -> stanje1 = stanje && znak = znak')
        avtomat.prehodi
    with
    | None -> 
        print_endline ("Ni prehoda za stanje: " ^ (Stanje.v_niz stanje) ^ " in znak: " ^ (String.make 1 znak));
        failwith "Konec niza"
    | Some (_, _, stanje2, izhod) ->
        print_endline ("Prehod: " ^ (Stanje.v_niz stanje) ^ " --" ^ (String.make 1 znak) ^ "--> " ^ (Stanje.v_niz stanje2) ^ ", izhod: " ^ izhod);
        (stanje2, izhod)

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi
let preberi_niz avtomat stanje niz =
  let aux (acc_s, acc_izhod) znak =
    match acc_s with 
    | None -> (None, acc_izhod) 
    | Some stanje -> match prehodna_funkcija avtomat stanje znak with
        
        | (stanje', izhod) -> (Some stanje', acc_izhod ^ izhod)
   
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some stanje, "") |> snd
(* 
let preberi_niz avtomat stanje niz =
  let aux (acc_s, acc_izhod) znak =
    match acc_s with 
    | None -> (None, acc_izhod) 
    | Some stanje -> match prehodna_funkcija avtomat stanje znak with
        | None -> (None, acc_izhod)
        | Some (stanje', izhod) -> (Some stanje', acc_izhod ^ izhod)
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some stanje, "")
*)
let ustvari_avtomat zacetno_stanje stanja prehodi =
  let pr_avtomat = prazen_avtomat zacetno_stanje in
  let avtomat = List.fold_left (fun a s -> dodaj_stanje s a) pr_avtomat stanja in
  List.fold_left (fun a (s1, znak, s2, izhod) -> dodaj_prehod s1 znak s2 izhod a) avtomat prehodi

