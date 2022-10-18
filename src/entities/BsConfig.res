type t = {bscFlags: array<string>}

let getGlobalyOpenedModules = bsConfig => {
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

let struct = {
  S.object1(. (
    "bsc-flags",
    S.option(S.array(S.string()))->S.defaulted([]),
  ))->S.transform(~parser=bscFlags => {bscFlags: bscFlags}, ())
}
