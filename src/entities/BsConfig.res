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

let lint = (bsConfig, ~prohibitedModules) => {
  let globalyOpenedModules = bsConfig->getGlobalyOpenedModules
  let maybeOpenedProhibitedModule = prohibitedModules->Js.Array2.find(prohibitedModule => {
    globalyOpenedModules->Js.Array2.some(globalyOpenedModule => {
      globalyOpenedModule === prohibitedModule
    })
  })
  switch maybeOpenedProhibitedModule {
  | Some(openedProhibitedModule) => Error(#HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule))
  | None => Ok()
  }
}

let struct = {
  S.object1(. (
    "bsc-flags",
    S.option(S.array(S.string()))->S.defaulted([]),
  ))->S.transform(~parser=bscFlags => {bscFlags: bscFlags}, ())
}
