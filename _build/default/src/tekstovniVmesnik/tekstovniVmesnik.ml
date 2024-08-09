open Definicije
open Avtomat

type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | BranjeNiza
  | RezultatPrebranegaNiza
  | OpozoriloONapacnemNizu
  | SestaviNovAvtomat

type model = {
  avtomat : t;
  stanje_avtomata : ZagnaniAvtomat.t;
  stanje_vmesnika : stanje_vmesnika;
  prebrani_izhod : string
}

type msg =
  | PreberiNiz of string
  | ZamenjajVmesnik of stanje_vmesnika
  | VrniVPrvotnoStanje
  | SestaviNovMealyjevAvtomat

let preberi_niz model niz =
  let rec aux zagnani_avtomat i =
    if i < String.length niz then
      match ZagnaniAvtomat.korak_naprej  zagnani_avtomat with
      | None -> zagnani_avtomat
      | Some nov_zagnani_avtomat -> aux nov_zagnani_avtomat (i + 1)
    else zagnani_avtomat
  in 
  let zagnani_avtomat = aux model.stanje_avtomata 0 in 
  let prebrani_izhod = zagnani_avtomat.trak.izhod in
  { model with stanje_avtomata = zagnani_avtomat; prebrani_izhod }
    
let update model = function
  | PreberiNiz str -> 
      let nov_model = preberi_niz model str in      
        { nov_model with stanje_vmesnika = RezultatPrebranegaNiza }
      | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }
      | VrniVPrvotnoStanje -> 
          {
            model with
            stanje_avtomata = ZagnaniAvtomat.pozeni model.avtomat (Trak.prazen);
            stanje_vmesnika = SeznamMoznosti;
            prebrani_izhod = ""
          }
      | SestaviNovMealyjevAvtomat -> 
        let avtomat = prazen_avtomat (Stanje.iz_niza "") in
        let model = init avtomat in
        { model with stanje_vmesnika = SestaviNovAvtomat}
  

let rec izpisi_moznosti () =
  print_endline "1) izpiši avtomat";
  print_endline "2) beri znake";
  print_endline "3) Sestavi nov Mealyjev avtomat";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata
  | "2" -> ZamenjajVmesnik BranjeNiza
  | "3" -> SestaviNovMealyjevAvtomat
  | _ ->
      print_endline "** VNESI 1, 2 ALI 3 **";
      izpisi_moznosti ()

let izpisi_avtomat avtomat =
  let izpisi_stanje stanje =
    let prikaz = Stanje.v_niz stanje in
    let prikaz =
      if stanje = zacetno_stanje avtomat then "-> " ^ prikaz else prikaz
    in
    let prikaz =
      if je_sprejemno_stanje avtomat stanje then prikaz ^ " +" else prikaz
    in
    print_endline prikaz
  in
  List.iter izpisi_stanje (seznam_stanj avtomat)

let beri_niz _model =
  print_string "Vnesi niz > ";
  let str = read_line () in
  PreberiNiz str

let rec izpisi_rezultat model =
  print_endline ("Izhod: " ^ model.prebrani_izhod);

let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()
  | IzpisAvtomata ->
      izpisi_avtomat model.avtomat;
      ZamenjajVmesnik SeznamMoznosti
  | BranjeNiza -> beri_niz model
  | RezultatPrebranegaNiza ->
      izpisi_rezultat model;
      ZamenjajVmesnik SeznamMoznosti
  | OpozoriloONapacnemNizu ->
      print_endline "Niz ni veljaven";
      ZamenjajVmesnik SeznamMoznosti
  | SestaviNovAvtomat -> main ();
  ZamenjajVmesnik SeznamMoznosti
      

let init avtomat =
  {
    avtomat;
    stanje_avtomata = ZagnaniAvtomat.pozeni avtomat (Trak.prazen);
    stanje_vmesnika = SeznamMoznosti;
    prebrani_izhod = ""
  }

let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let main () = 
  print_string "Vnesi začetno stanje: ";
  let zacetno_stanje = read_line () |> Stanje.iz_niza in 

  print_string "Vnesi sprejemna stanja (ločena s presledki): ";
  let sprejemna_stanja =
    read_line () |> String.split_on_char ' ' |> List.map Stanje.iz_niza in

    print_endline "Vnesi prehode (v obliki: stanje1 znak stanje2 izhod). Pritisni Enter, ko končaš.";
    let rec preberi_prehode acc =
      print_string "> ";
      match read_line () with 
      | "" -> List.rev acc
      | vrstica -> 
          let deli = String.split_on_char ' ' vrstica in 
          match deli with
          | [s1; znak; s2; izhod] -> 
            let prehod = (Stanje.iz_niza s1, String.get znak 0, Stanje.iz_niza s2, izhod) in
            preberi_prehode (prehod :: acc)
          | _ -> print_endline "Napačen format zapisa. Poskusi znova.";
                 preberi_prehode acc
          in
          let prehodi = preberi_prehode [] in

  let avtomat = ustvari_avtomat zacetno_stanje sprejemna_stanja prehodi in
  let model = init avtomat in
  loop model


  let () = main ()
