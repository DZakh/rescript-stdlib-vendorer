include Js.Array2

@send
external flatMap: (array<'a>, 'a => array<'b>) => array<'b> = "flatMap"

let get = Belt.Array.get
