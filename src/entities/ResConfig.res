type t = {bscFlags: array<string>}

let getGlobalyOpenedModulesSet = resConfig => {
  let set = Set.make()
  resConfig.bscFlags->Array.forEach(bscFlag => {
    bscFlag
    ->ModuleName.fromBscFlag
    ->Option.forEach(moduleName => {
      set->Set.add(moduleName)->ignore
    })
  })
  set
}

let hasGloballyOpenedModule = (resConfig, ~moduleName) => {
  let globalyOpenedModulesSet = resConfig->getGlobalyOpenedModulesSet
  globalyOpenedModulesSet->Set.has(moduleName)
}

let lint = (resConfig, ~prohibitedModuleNames) => {
  let globalyOpenedModulesSet = resConfig->getGlobalyOpenedModulesSet
  let maybeOpenedProhibitedModule = prohibitedModuleNames->Array.find(prohibitedModule => {
    globalyOpenedModulesSet->Set.has(prohibitedModule)
  })
  switch maybeOpenedProhibitedModule {
  | Some(openedProhibitedModule) => Error(#HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule))
  | None => Ok()
  }
}

let struct = S.object(s => {
  bscFlags: s.fieldOr("bsc-flags", S.array(S.string), []),
})

let fromJsonString = jsonString =>
  jsonString->S.parseJsonStringWith(struct)->Result.mapError(S.Error.message)

module TestData = {
  let make = (~bscFlags) => {
    bscFlags: bscFlags,
  }
}
