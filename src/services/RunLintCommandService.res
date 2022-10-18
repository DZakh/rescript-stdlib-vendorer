let make = (~loadBsConfig, ~loadSourceDirs) => {
  let standardLibModules = ["Belt", "Js", "ReScriptJs"]

  (. ()) => {
    loadBsConfig(.)
    ->Lib.Result.mapError((. loadBsConfigError) => {
      switch loadBsConfigError {
      | #PARSING_FAILURE(reason) => #BS_CONFIG_PARSE_FAILURE(reason)
      }
    })
    ->Belt.Result.flatMap(bsConfig => {
      let globalyOpenedModules = bsConfig->BsConfig.getGlobalyOpenedModules
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
    ->Belt.Result.flatMap(() => {
      loadSourceDirs(.)->Lib.Result.mapError((. loadSourceDirsError) =>
        switch loadSourceDirsError {
        | #PARSING_FAILURE(reason) => #SOURCE_DIRS_PARSE_FAILURE(reason)
        }
      )
    })
    ->Belt.Result.map(sourceDirs => {
      let resFilePaths =
        sourceDirs
        ->SourceDirs.getProjectDirs
        ->Lib.Array.flatMap(sourceDir => {
          NodeJs.Fs.readdirSync(sourceDir)
          ->Js.Array2.filter(dirItem => dirItem->Js.String2.endsWith(".res"))
          ->Js.Array2.map(dirItem => `${sourceDir}/${dirItem}`)
        })
      Js.log(resFilePaths)
    })
  }
}
