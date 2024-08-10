open Definicije

open ZagnaniAvtomat
open Trak

type stanje_vmesnika =
  | SeznamMoznosti
  | BranjeNiza
  | RezultatPrebranegaNiza

  | SestaviNovAvtomat

type model = {
  
  stanje_avtomata: ZagnaniAvtomat.t;
  stanje_vmesnika: stanje_vmesnika;
  prebrani_izhod: string
}

type msg =
  | PreberiNiz of string
  | ZamenjajVmesnik of stanje_vmesnika
  (*| VrniVPrvotnoStanje  *)
  | SestaviNovMealyjevAvtomat

let init avtomat =
  {
    stanje_avtomata = ZagnaniAvtomat.pozeni avtomat (Trak.prazen);
    stanje_vmesnika = SeznamMoznosti;
    prebrani_izhod = ""
  }


(*
let ustvari_avtomat () =
  print_endline "Vnesite začetno stanje: ";
  let ustvarjen_avtomat = prazen_avtomat (Stanje.iz_niza(read_line ())) in
  print_string "Vnesi ostala stanja (ločena s presledki): ";
  let stanja =
    read_line () |> String.split_on_char ' ' |> List.map Stanje.iz_niza in
  
  
  print_endline "Vnesite prehode v formatu stanje 1, vhod, stanje 2, izhod. Pritisnite Enter. ";
      let rec preberi_prehode () = 
        print_string "> ";
        match read_line () with
        | "" -> []
        | prehod -> 
          let s1, znak, s2, izhod = String.split_on_char ',' prehod in 
          let prehod = dodaj_prehod s1 znak s2 izhod in
          prehod :: preberi_prehode ()

*)
let preberi_niz model niz =
  let rec aux zagnani_avtomat i =
    if i < String.length niz then
      let zagnani_avtomat = korak_naprej zagnani_avtomat in
      aux (Option.get zagnani_avtomat) (i + 1)
    else zagnani_avtomat
  in
  let zagnan_avtomat = aux model.stanje_avtomata 0 in
  let prebrani_izhod = zagnan_avtomat.trak.izhod in
  { model with stanje_avtomata = zagnan_avtomat; prebrani_izhod }
   
  

let update model = function
  | PreberiNiz str ->
      let nov_model = preberi_niz model str in
      { nov_model with stanje_vmesnika = RezultatPrebranegaNiza }
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }
  (*| VrniVPrvotnoStanje ->
      {
        model with
        stanje_avtomata = ZagnaniAvtomat.pozeni model.avtomat (Trak.prazen);
        stanje_vmesnika = SeznamMoznosti;
        prebrani_izhod = ""
      }
        *)
  | SestaviNovMealyjevAvtomat -> {model with stanje_vmesnika = SestaviNovAvtomat}



let rec izpisi_moznosti () =
  print_endline "1) Vnesi in preberi niz.";
  print_endline "2) Sestavi nov Mealyjev avtomat.";
  print_string "> ";
  match read_line () with
  
  | "1" -> ZamenjajVmesnik BranjeNiza
  | "2" -> SestaviNovMealyjevAvtomat
  | _ ->
      print_endline "** VNESI 1 ALI 2 **";
      izpisi_moznosti ()

let izpisi_rezultat model =
  print_endline ("Izhod: " ^ model.prebrani_izhod)

let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti ->
    izpisi_moznosti ()
  | BranjeNiza ->
      print_string "Vnesi niz: ";
      let niz = read_line () in
      PreberiNiz niz
  | RezultatPrebranegaNiza ->
      izpisi_rezultat model;
      ZamenjajVmesnik SeznamMoznosti
  
  | SestaviNovAvtomat ->
      ZamenjajVmesnik SeznamMoznosti


let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let main () =
  print_string "Vnesi začetno stanje: ";
  let zacetno_stanje = read_line () |> Stanje.iz_niza in

  print_string "Vnesi ostala stanja (ločena s presledki): ";
  let stanja =
    read_line () |> String.split_on_char ' ' |> List.map Stanje.iz_niza in

  print_endline "Vnesi prehode (v obliki: stanje1 znak stanje2 izhod). Pritisni Enter, ko končaš.";
  let rec preberi_prehode acc =
    print_string "> ";
    match read_line () with
    | "" -> List.rev acc
    | vrstica ->
      let deli = String.split_on_char ' ' vrstica in
      match deli with
      | [s1; znak_str; s2; izhod] when String.length znak_str = 1 ->
          let znak = znak_str.[0] in
          let prehod = (Stanje.iz_niza s1, znak, Stanje.iz_niza s2, izhod) in
          preberi_prehode (prehod :: acc)
            
        | _ ->
            print_endline "Napačen format zapisa. Poskusi znova.";
            preberi_prehode acc
  in
  let prehodi = preberi_prehode [] in

  let avtomat = Avtomat.ustvari_avtomat zacetno_stanje stanja prehodi in
  let model = init avtomat in
  loop model

let () = main ()
