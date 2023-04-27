type t = {bscFlags: array<string>}

let getGlobalyOpenedModulesSet = bsConfig => {
  let set = Set.make()
  bsConfig.bscFlags->Array.forEach(bscFlag => {
    bscFlag
    ->ModuleName.fromBscFlag
    ->Option.forEach(moduleName => {
      set->Set.add(moduleName)->ignore
    })
  })
  set
}

let hasGloballyOpenedModule = (bsConfig, ~moduleName) => {
  let globalyOpenedModulesSet = bsConfig->getGlobalyOpenedModulesSet
  globalyOpenedModulesSet->Set.has(moduleName)
}

let lint = (bsConfig, ~prohibitedModuleNames) => {
  let globalyOpenedModulesSet = bsConfig->getGlobalyOpenedModulesSet
  let maybeOpenedProhibitedModule = prohibitedModuleNames->Array.find(prohibitedModule => {
    globalyOpenedModulesSet->Set.has(prohibitedModule)
  })
  switch maybeOpenedProhibitedModule {
  | Some(openedProhibitedModule) => Error(#HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule))
  | None => Ok()
  }
}

let struct = S.object(o => {
  bscFlags: o->S.field("bsc-flags", S.option(S.array(S.string()))->S.default(() => [])),
})

let fromJsonString = jsonString => jsonString->S.parseJsonWith(struct)->S.Result.mapErrorToString

module TestData = {
  let make = (~bscFlags) => {
    bscFlags: bscFlags,
  }
}
