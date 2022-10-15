let make = (~loadBsConfig) => {
  let standardLibModules = ["Belt", "Js", "ReScriptJs"]

  (. ()) => {
    loadBsConfig(.)
    ->Lib.Result.mapError((. loadBsConfigError) => {
      switch loadBsConfigError {
      | #PARSING_FAILURE(reason) => #BS_CONFIG_PARSE_FAILURE(reason)
      | #LOAD_FAILURE => #BS_CONFIG_LOAD_FAILURE
      }
    })
    ->Belt.Result.flatMap(bsconfig => {
      let globalyOpenedModules = bsconfig->BsConfig.globalyOpenedModules
      let maybeOpenedStandardLibModule = standardLibModules->Js.Array2.find(standardLibModule => {
        globalyOpenedModules->Js.Array2.some(
          globalyOpenedModule => {
            globalyOpenedModule === standardLibModule
          },
        )
      })
      switch maybeOpenedStandardLibModule {
      | Some(openedStandardLibModule) => Error(#HAS_GLOBALY_OPENED_STDLIB(openedStandardLibModule))
      | None => Ok()
      }
    })
  }
}
