let make = (~loadBsConfig: Port.LoadBsConfig.t, ~loadSourceDirs: Port.LoadSourceDirs.t) =>
  (. ~config) => {
    let prohibitedModuleNames = ModuleName.defaultProhibitedModuleNames

    loadBsConfig(. ~config)
    ->Result.mapError(loadBsConfigError => {
      switch loadBsConfigError {
      | ParsingFailure(reason) => Port.Lint.BsConfigParseFailure(reason)
      }
    })
    ->Result.flatMap(bsConfig => {
      switch bsConfig->BsConfig.lint(~prohibitedModuleNames) {
      | Ok() => Ok(bsConfig)
      | Error(#HAS_OPENED_PROHIBITED_MODULE(openedProhibitedModule)) =>
        Error(Port.Lint.BsConfigHasOpenedProhibitedModule(openedProhibitedModule))
      }
    })
    ->Result.flatMap(bsConfig => {
      switch loadSourceDirs(. ~config) {
      | Ok(sourceDirs) => Ok(bsConfig, sourceDirs)
      | Error(loadSourceDirsError) =>
        Error(
          switch loadSourceDirsError {
          | ParsingFailure(reason) => Port.Lint.SourceDirsParseFailure(reason)
          | RescriptCompilerArtifactsNotFound => Port.Lint.RescriptCompilerArtifactsNotFound
          },
        )
      }
    })
    ->Result.flatMap(((bsConfig, sourceDirs)) => {
      let resFiles =
        sourceDirs
        ->SourceDirs.getProjectDirs
        ->Array.flatMap(sourceDir => {
          open NodeJs
          let fullDirPath = Path.resolve([config->Config.getProjectPath, sourceDir])
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
          ~ignoreIssuesBeforeStdlibOpen=config->Config.checkShouldIngoreResFileIssuesBeforeStdlibOpen(
            ~bsConfig,
          ),
          ~stdlibModuleName=config->Config.getStdlibModuleName,
        )
      })
      switch lintContext->LintContext.getIssues {
      | [] => Ok()
      | lintIssues => Error(Port.Lint.LintFailedWithIssues(lintIssues))
      }
    })
  }
