type t = {content: string, path: string, moduleName: ModuleName.t}

let make = (~content, ~path) => {
  content,
  path,
  moduleName: ModuleName.fromPath(path)->Option.getExnWithMessage(
    "A ResFile should always have a valid module name.",
  ),
}

let lint = {
  let normalizeName = name => name->String.replaceRegExp(%re("/\W/g"), "")->String.toLowerCase

  (
    resFile,
    ~lintContext,
    ~prohibitedModuleNames,
    ~stdlibModuleName,
    ~ignoreIssuesBeforeStdlibOpen,
  ) => {
    if (
      resFile.moduleName === stdlibModuleName ||
        resFile.moduleName->ModuleName.isSubmodule(~ofModule=stdlibModuleName)
    ) {
      let stdlibParentDirName =
        resFile.path
        ->String.split("/")
        ->Array.at(-2)
        ->Option.getExnWithMessage("A ResFile should always have a directory name")

      if (
        stdlibModuleName->ModuleName.toString->normalizeName !== stdlibParentDirName->normalizeName
      ) {
        lintContext->LintContext.addIssue(
          LintIssue.make(
            ~path=resFile.path,
            ~kind=InvalidStdlibParentDirName({stdlibParentDirName: stdlibParentDirName}),
          ),
        )
      }
    } else {
      let shouldIgnoreLineRef = ref(ignoreIssuesBeforeStdlibOpen)
      resFile.content
      ->String.split("\n")
      ->Array.forEachWithIndex((line, idx) => {
        switch (shouldIgnoreLineRef.contents, ignoreIssuesBeforeStdlibOpen) {
        | (true, true)
          if Re.fromString(`^open ${stdlibModuleName->ModuleName.toString}$`)->Re.test(line) =>
          shouldIgnoreLineRef.contents = false
        | (true, _) => ()
        | (false, _) =>
          prohibitedModuleNames->Array.forEach(prohibitedModuleName => {
            switch {
              Re.fromString(`^ *open ${prohibitedModuleName->ModuleName.toString}($|\\.)`)->Re.test(
                line,
              )
            } {
            | false => Ok()
            | true =>
              Error(
                LintIssue.make(
                  ~path=resFile.path,
                  ~kind=ProhibitedModuleOpen({line: idx + 1, prohibitedModuleName}),
                ),
              )
            }
            ->Result.flatMap(
              () => {
                switch {
                  Re.fromString(
                    `^ *include ${prohibitedModuleName->ModuleName.toString}($|\\.)`,
                  )->Re.test(line)
                } {
                | false => Ok()
                | true =>
                  Error(
                    LintIssue.make(
                      ~path=resFile.path,
                      ~kind=ProhibitedModuleInclude({line: idx + 1, prohibitedModuleName}),
                    ),
                  )
                }
              },
            )
            ->Result.flatMap(
              () => {
                switch {
                  Re.fromString(
                    `^ *module.+= ${prohibitedModuleName->ModuleName.toString}($|\\.)`,
                  )->Re.test(line)
                } {
                | false => Ok()
                | true =>
                  Error(
                    LintIssue.make(
                      ~path=resFile.path,
                      ~kind=ProhibitedModuleAssign({line: idx + 1, prohibitedModuleName}),
                    ),
                  )
                }
              },
            )
            ->Result.flatMap(
              () => {
                switch {
                  Re.fromString(`(\\W|^)${prohibitedModuleName->ModuleName.toString}\\.`)->Re.test(
                    line,
                  )
                } {
                | false => Ok()
                | true =>
                  Error(
                    LintIssue.make(
                      ~path=resFile.path,
                      ~kind=ProhibitedModuleUsage({line: idx + 1, prohibitedModuleName}),
                    ),
                  )
                }
              },
            )
            ->(
              result =>
                switch result {
                | Ok() => ()
                | Error(lineLintIssue) => lintContext->LintContext.addIssue(lineLintIssue)
                }
            )
          })
        }
      })
    }
  }
}

let checkIsResFile = (~dirItem) => {
  dirItem->String.endsWith(".res") || dirItem->String.endsWith(".resi")
}
