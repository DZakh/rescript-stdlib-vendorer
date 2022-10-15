module Source = {
  type subdirs = Recursive | Without | Specific(array<string>)
  type t = {
    dir: string,
    subdirs: subdirs,
  }

  let make = (~dir, ~subdirs) => {dir, subdirs}
}
type t = {sources: array<Source.t>, bscFlags: array<string>}

let make = (~sources, ~bscFlags) => {sources, bscFlags}

let globalyOpenedModules = bsConfig => {
  bsConfig.bscFlags
  ->Js.Array2.filter(bscFlag => {
    bscFlag->Js.String2.includes("-open")
  })
  ->Js.Array2.map(bscFlag => {
    bscFlag
    ->Js.String2.replace("-open", "")
    ->Js.String2.trim
    ->Js.String2.split(".")
    ->Js.Array2.unsafe_get(0)
  })
}
