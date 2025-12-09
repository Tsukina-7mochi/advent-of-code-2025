type point = { x: int; y: int }

let new_edge p1 p2 =
    ( { x = min p1.x p2.x; y = min p1.y p2.y },
      { x = max p1.x p2.x; y = max p1.y p2.y } )

let parse_point s = 
    match String.split_on_char ',' s with
    | [x; y] -> { x = int_of_string x; y = int_of_string y }
    | _ -> failwith "Invalid point format"

let l1norm p = abs p.x + abs p.y
let psub p1 p2 = { x = p1.x - p2.x; y = p1.y - p2.y }
let l1distance p1 p2 = l1norm (psub p1 p2)
let pcross p1 p2 = p1.x * p2.y - p1.y * p2.x

let angle_sign_ccw o a b = pcross (psub a o) (psub b o)
let area p1 p2 = (abs (p1.x - p2.x) + 1) * (abs (p1.y - p2.y) + 1)

let circulate ls =
    match ls with
    | [] -> []
    | p::ps -> ps @ [p]

let list_zip ls1 ls2 = 
    let rec aux acc l1 l2 =
        match (l1, l2) with
        | ([], _) | (_, []) -> List.rev acc
        | (x::xs, y::ys) -> aux ((x, y)::acc) xs ys
    in
    aux [] ls1 ls2

(*
let print_point p =
    Printf.printf "(%d, %d)" p.x p.y
let print_point_list ps =
    List.iter (fun p -> print_point p; print_string ", ") ps
*)
let graham_comparator p0 p1 p2 = 
    let area = angle_sign_ccw p0 p1 p2 in
    if area = 0 then
        let d1 = l1distance p0 p1 in
        let d2 = l1distance p0 p2 in
        compare d1 d2
    else
        compare 0 area

let rec graham_scan ps stack =
    (*
    print_string "ps   : "; print_point_list ps; print_newline ();
    print_string "stack: "; print_point_list stack; print_newline ();
    print_newline ();
    *)

    match ps with
    | [] -> stack
    | p :: rest ->
        match stack with
        | [] | [_] -> graham_scan rest (p :: stack)
        | s1 :: s2 :: _ ->
            if angle_sign_ccw s1 s2 p >= 0 then
                graham_scan rest (p :: (List.tl stack))
            else
                graham_scan rest (p :: stack)

let convex_hull ps =
    match ps with
    | [] | [_] | [_; _] -> []
    | _ -> 
        let pick_top_left p1 p2 = if p1.y < p2.y || (p1.y = p2.y && p1.x < p2.x) then p1 else p2 in
        let p0 = List.fold_left pick_top_left (List.hd ps) ps in
        let ps = List.sort (graham_comparator p0) ps in
        graham_scan ps []

let combination_2 ls =
    let rec aux acc = function
        | [] | [_] -> acc
        | x :: xs ->
            let new_combs = List.map (fun y -> (x, y)) xs in
            aux (new_combs @ acc) xs
    in
    aux [] ls

let rect_contains_line (r1, r2) (l1, l2) =
    let x1 = min r1.x r2.x in
    let x2 = max r1.x r2.x in
    let y1 = min r1.y r2.y in
    let y2 = max r1.y r2.y in
    (l1.x < x2 && x1 < l2.x) && (l1.y < y2 && y1 < l2.y)

let is_valid_rect ls (r1, r2) =
    not (List.exists (rect_contains_line (r1, r2)) ls)

let part1 points =
    let hull = points
        |> List.sort (fun p1 p2 -> compare p1.x p2.x)
        |> convex_hull in
    let min_x_y = List.fold_left (fun acc p -> { x = min acc.x p.x; y = min acc.y p.y }) { x = max_int; y = max_int } hull in
    hull
        |> List.map (fun p -> psub p min_x_y)
        |> combination_2
        |> List.fold_left (fun acc (p1, p2) -> max acc (area p1 p2)) 0

let part2 points =
    let edges = list_zip points (circulate points)
        |> List.map (fun (p1, p2) -> new_edge p1 p2) in
    combination_2 points
        |> List.filter (is_valid_rect edges)
        |> List.map (fun (p1, p2) -> area p1 p2)
        |> List.fold_left (fun acc a -> max acc a) 0

let () =
    let input = In_channel.input_lines In_channel.stdin
        |> List.map parse_point in

    print_int (part1 input); print_newline ();
    print_int (part2 input); print_newline ()
