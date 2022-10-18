let make = (~loadBsConfig, ~loadSourceDirs) => {
  let prohibitedModules = ["Belt", "Js", "ReScriptJs"]

  (. ()) => {
    loadBsConfig(.)
    ->Lib.Result.mapError((. loadBsConfigError) => {
      switch loadBsConfigError {
      | #PARSING_FAILURE(reason) => #BS_CONFIG_PARSE_FAILURE(reason)
      }
    })
    ->Belt.Result.flatMap(bsConfig => {
      bsConfig
      ->BsConfig.lint(~prohibitedModules)
      ->Lib.Result.mapError((. error) => {
        switch error {
        | #HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule) =>
          #BS_CONFIG_HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule)
        }
      })
    })
    ->Belt.Result.flatMap(() => {
      loadSourceDirs(.)->Lib.Result.mapError((. loadSourceDirsError) =>
        switch loadSourceDirsError {
        | #PARSING_FAILURE(reason) => #SOURCE_DIRS_PARSE_FAILURE(reason)
        }
      )
    })
    ->Belt.Result.flatMap(sourceDirs => {
      let resFiles =
        sourceDirs
        ->SourceDirs.getProjectDirs
        ->Lib.Array.flatMap(sourceDir => {
          open NodeJs
          let fullDirPath = Path.resolve([Process.process->Process.cwd, sourceDir])
          Fs.readdirSync(fullDirPath)
          ->Js.Array2.filter(dirItem => dirItem->Js.String2.endsWith(".res"))
          ->Js.Array2.map(dirItem => `${fullDirPath}/${dirItem}`)
        })
        ->Js.Array2.map(resFilePath => {
          open NodeJs
          ResFile.make(
            ~content=Fs.readFileSyncWith(
              resFilePath,
              Fs.readFileOptions(~encoding="utf8", ()),
            )->Buffer.toString,
            ~path=resFilePath,
          )
        })

      let lintContext = LintContext.make()
      resFiles->Js.Array2.forEach(resFile => {
        resFile->ResFile.lint(~lintContext, ~prohibitedModules)
      })
      switch lintContext->LintContext.getIssues {
      | [] => Ok()
      | lintIssues => Error(#LINT_FAILED_WITH_ISSUES(lintIssues))
      }
    })
  }
}
