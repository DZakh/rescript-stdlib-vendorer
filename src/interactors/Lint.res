let make = (~loadBsConfig, ~loadSourceDirs, . ~maybeStdlibModuleOverride) => {
  let prohibitedModuleNames = ModuleName.defaultProhibitedModuleNames

  loadBsConfig(.)
  ->Result.mapError((. loadBsConfigError) => {
    switch loadBsConfigError {
    | #PARSING_FAILURE(reason) => #BS_CONFIG_PARSE_FAILURE(reason)
    }
  })
  ->Result.flatMap((. bsConfig) => {
    bsConfig
    ->BsConfig.lint(~prohibitedModuleNames)
    ->Result.mapError((. error) => {
      switch error {
      | #HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule) =>
        #BS_CONFIG_HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule)
      }
    })
  })
  // FIXME: There should be unit instead of underscore. Report to the compiler repo
  ->Result.flatMap((. _) => {
    loadSourceDirs(.)->Result.mapError((. loadSourceDirsError) =>
      switch loadSourceDirsError {
      | #PARSING_FAILURE(reason) => #SOURCE_DIRS_PARSE_FAILURE(reason)
      }
    )
  })
  ->Result.flatMap((. sourceDirs) => {
    let resFiles =
      sourceDirs
      ->SourceDirs.getProjectDirs
      ->Array.flatMap(sourceDir => {
        open NodeJs
        let fullDirPath = Path.resolve([Process.process->Process.cwd, sourceDir])
        Fs.readdirSync(fullDirPath)
        ->Array.filter(ResFile.checkIsResFile(~dirItem=_))
        ->Array.map(
          dirItem => {
            let resFilePath = `${fullDirPath}/${dirItem}`
            ResFile.make(
              ~content=Fs.readFileSyncWith(
                resFilePath,
                Fs.readFileOptions(~encoding="utf8", ()),
              )->Buffer.toString,
              ~path=resFilePath,
            )
          },
        )
      })

    let lintContext = LintContext.make()
    resFiles->Array.forEach(resFile => {
      resFile->ResFile.lint(
        ~lintContext,
        ~prohibitedModuleNames,
        ~stdlibModuleName=maybeStdlibModuleOverride->Option.getWithDefault(
          ModuleName.defaultStdlibModuleName,
        ),
      )
    })
    switch lintContext->LintContext.getIssues {
    | [] => Ok()
    | lintIssues => Error(#LINT_FAILED_WITH_ISSUES(lintIssues))
    }
  })
}
