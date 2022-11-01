type t = {content: string, path: string, moduleName: ModuleName.t}

let make = (~content, ~path) => {
  content,
  path,
  moduleName: ModuleName.fromPath(path)->Option.getExnWithMessage(
    "A ResFile should always have a valid module name.",
  ),
}

let lint = {
  let normalizeName = name => name->String.replaceByRe(%re("/\W/g"), "")->String.toLowerCase

  (resFile, ~lintContext, ~prohibitedModuleNames, ~stdlibModuleName) => {
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
      resFile.content
      ->String.split("\n")
      ->Array.forEachi((line, idx) => {
        prohibitedModuleNames->Array.forEach(prohibitedModuleName => {
          let openRe = Re.fromString(`^ *open ${prohibitedModuleName->ModuleName.toString}($|\\.)`)
          if openRe->Re.test_(line) {
            lintContext->LintContext.addIssue(
              LintIssue.make(
                ~path=resFile.path,
                ~kind=ProhibitedModuleOpen({line: idx + 1, prohibitedModuleName}),
              ),
            )
          }
          let includeRe = Re.fromString(
            `^ *include ${prohibitedModuleName->ModuleName.toString}($|\\.)`,
          )
          if includeRe->Re.test_(line) {
            lintContext->LintContext.addIssue(
              LintIssue.make(
                ~path=resFile.path,
                ~kind=ProhibitedModuleInclude({line: idx + 1, prohibitedModuleName}),
              ),
            )
          }
          let assignRe = Re.fromString(
            `module.+= ${prohibitedModuleName->ModuleName.toString}($|\\.)`,
          )
          if assignRe->Re.test_(line) {
            lintContext->LintContext.addIssue(
              LintIssue.make(
                ~path=resFile.path,
                ~kind=ProhibitedModuleAssign({line: idx + 1, prohibitedModuleName}),
              ),
            )
          }
          let usageRe = Re.fromString(`(\\W|^)${prohibitedModuleName->ModuleName.toString}\\.`)
          if usageRe->Re.test_(line) {
            lintContext->LintContext.addIssue(
              LintIssue.make(
                ~path=resFile.path,
                ~kind=ProhibitedModuleUsage({line: idx + 1, prohibitedModuleName}),
              ),
            )
          }
        })
      })
    }
  }
}

let checkIsResFile = (~dirItem) => {
  dirItem->String.endsWith(".res") || dirItem->String.endsWith(".resi")
}
