include Js.Array2

@send
external flatMap: (array<'a>, 'a => array<'b>) => array<'b> = "flatMap"

let get = Belt.Array.get

@send
external last: (array<'a>, @as(json`-1`) _) => option<'a> = "at"

@send
external at: (array<'a>, int) => option<'a> = "at"
