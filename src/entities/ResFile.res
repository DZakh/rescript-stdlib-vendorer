open Stdlib

type t = {content: string, path: string}

let make = (~content, ~path) => {content, path}

let lint = (resFile, ~lintContext, ~prohibitedModules) => {
  resFile.content
  ->String.split("\n")
  ->Array.forEachi((line, idx) => {
    prohibitedModules->Array.forEach(moduleName => {
      let openRe = Re.fromString(`^ *open ${moduleName}($|\.)`)
      if openRe->Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(~path=resFile.path, ~line=idx + 1, ~kind=ProhibitedModuleOpen(moduleName)),
        )
      }
      let includeRe = Re.fromString(`^ *include ${moduleName}($|\.)`)
      if includeRe->Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(
            ~path=resFile.path,
            ~line=idx + 1,
            ~kind=ProhibitedModuleInclude(moduleName),
          ),
        )
      }
      let assignRe = Re.fromString(`module.+= ${moduleName}($|\.)`)
      if assignRe->Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(
            ~path=resFile.path,
            ~line=idx + 1,
            ~kind=ProhibitedModuleAssign(moduleName),
          ),
        )
      }
      let usageRe = Re.fromString(`\\W${moduleName}\.`)
      if usageRe->Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(
            ~path=resFile.path,
            ~line=idx + 1,
            ~kind=ProhibitedModuleUsage(moduleName),
          ),
        )
      }
    })
  })
}
