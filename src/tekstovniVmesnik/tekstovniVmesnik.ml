open Definicije
open Avtomat
open ZagnaniAvtomat
open Trak

type stanje_vmesnika =
  | SeznamMoznosti
  | BranjeNiza
  | RezultatPrebranegaNiza
  | OpozoriloONapacnemNizu
  | SestaviNovAvtomat

type model = {
  avtomat: Avtomat.t;
  stanje_avtomata: ZagnaniAvtomat.t;
  stanje_vmesnika: stanje_vmesnika;
  prebrani_izhod: string
}

type msg =
  | PreberiNiz of string
  | ZamenjajVmesnik of stanje_vmesnika
  | VrniVPrvotnoStanje
  | SestaviNovMealyjevAvtomat

let init avtomat =
  {
    avtomat;
    stanje_avtomata = ZagnaniAvtomat.pozeni avtomat (Trak.prazen);
    stanje_vmesnika = SeznamMoznosti;
    prebrani_izhod = ""
  }


let ustvari_avtomat_interaktivno () =
  print_endline "Vnesite Število stanj: ";
  let st_stanj = int_of_string (read_line ()) in 
  let rec ustvari_stanja n acc =
    if n <= 0 then acc
    else
      let stanje = Printf.sprintf "q%d" (st_stanj - n + 1) in
      ustvari_stanja (n - 1) (stanje :: acc) in
      let stanja = ustvari_stanja st_stanj [] in
      print_endline "Vnesite prehode v formatu (tr stanje, vhod, nasl stanje, izhod): ";
      let rec preberi_prehode () = 
        print_string "> ";
        match read_line () with
        | "" -> []
        | prehod -> 
          let parts = String.split_on_char ',' prehod in 
          let prehod = (List.nth parts 0, List.nth parts 1, List.nth parts 2, List.nth parts 3) in
          prehod :: preberi_prehode () in

        let prehodna_funkcija = preberi_prehode () in
        ustvari_avtomat stanja prehodna_funkcija
let preberi_niz model niz =
  let rec aux zagnani_avtomat i =
    if i < String.length niz then
      let zagnani_avtomat = korak_naprej zagnani_avtomat in
      aux (Option.to_result zagnani_avtomat) (i + 1)
    else zagnani_avtomat
  in
  let zagnani_avtomat = aux model.stanje_avtomata 0 in
  let prebrani_izhod = zagnani_avtomat.trak.izhod in
  { model with stanje_avtomata = zagnani_avtomat; prebrani_izhod }

let rec update model = function
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
      let model = init (ustvari_avtomat_interaktivno ()) in
      { model with stanje_vmesnika = SestaviNovAvtomat }



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
      izpisi_moznosti ();
      ZamenjajVmesnik SeznamMoznosti
  | BranjeNiza ->
      print_string "Vnesi niz: ";
      let niz = read_line () in
      PreberiNiz niz
  | RezultatPrebranegaNiza ->
      izpisi_rezultat model;
      ZamenjajVmesnik SeznamMoznosti
  | OpozoriloONapacnemNizu ->
      print_endline "Niz ni veljaven";
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
        | [s1; znak; s2; izhod] ->
            let prehod = (s1, znak, s2, izhod) in
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
