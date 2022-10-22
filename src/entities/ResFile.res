open Stdlib

type t = {content: string, path: string, moduleName: ModuleName.t}

let make = (~content, ~path) => {
  content,
  path,
  moduleName: ModuleName.fromPath(path)->Option.getExnWithMessage(
    "A ResFile should always have a valid module name.",
  ),
}

let lint = (resFile, ~lintContext, ~prohibitedModuleNames, ~stdlibModuleName) => {
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
      stdlibModuleName
      ->ModuleName.toString
      ->String.replaceByRe(%re("/\W/g"), "")
      ->String.toLowerCase !==
        stdlibParentDirName->String.replaceByRe(%re("/\W/g"), "")->String.toLowerCase
    ) {
      // TODO: Add custom issue
      lintContext->LintContext.addIssue(
        LintIssue.make(~path=resFile.path, ~line=0, ~kind=ProhibitedModuleUsage(stdlibModuleName)),
      )
    }
  } else {
    resFile.content
    ->String.split("\n")
    ->Array.forEachi((line, idx) => {
      prohibitedModuleNames->Array.forEach(prohibitedModule => {
        let openRe = Re.fromString(`^ *open ${prohibitedModule->ModuleName.toString}($|\\.)`)
        if openRe->Re.test_(line) {
          lintContext->LintContext.addIssue(
            LintIssue.make(
              ~path=resFile.path,
              ~line=idx + 1,
              ~kind=ProhibitedModuleOpen(prohibitedModule),
            ),
          )
        }
        let includeRe = Re.fromString(`^ *include ${prohibitedModule->ModuleName.toString}($|\\.)`)
        if includeRe->Re.test_(line) {
          lintContext->LintContext.addIssue(
            LintIssue.make(
              ~path=resFile.path,
              ~line=idx + 1,
              ~kind=ProhibitedModuleInclude(prohibitedModule),
            ),
          )
        }
        let assignRe = Re.fromString(`module.+= ${prohibitedModule->ModuleName.toString}($|\\.)`)
        if assignRe->Re.test_(line) {
          lintContext->LintContext.addIssue(
            LintIssue.make(
              ~path=resFile.path,
              ~line=idx + 1,
              ~kind=ProhibitedModuleAssign(prohibitedModule),
            ),
          )
        }
        let usageRe = Re.fromString(`\\W${prohibitedModule->ModuleName.toString}\\.`)
        if usageRe->Re.test_(line) {
          lintContext->LintContext.addIssue(
            LintIssue.make(
              ~path=resFile.path,
              ~line=idx + 1,
              ~kind=ProhibitedModuleUsage(prohibitedModule),
            ),
          )
        }
      })
    })
  }
}

let checkIsResFile = (~dirItem) => {
  dirItem->String.endsWith(".res") || dirItem->String.endsWith(".resi")
}
