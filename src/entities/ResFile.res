type t = {content: string, path: string}

let make = (~content, ~path) => {content, path}

let lint = (resFile, ~lintContext, ~prohibitedModules) => {
  resFile.content
  ->Js.String2.split("\n")
  ->Js.Array2.forEachi((line, idx) => {
    prohibitedModules->Js.Array2.forEach(moduleName => {
      let openRe = Js.Re.fromString(`^ *open ${moduleName}($|\.)`)
      if openRe->Js.Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(~path=resFile.path, ~line=idx + 1, ~kind=ProhibitedModuleOpen(moduleName)),
        )
      }
      let includeRe = Js.Re.fromString(`^ *include ${moduleName}($|\.)`)
      if includeRe->Js.Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(
            ~path=resFile.path,
            ~line=idx + 1,
            ~kind=ProhibitedModuleInclude(moduleName),
          ),
        )
      }
      let assignRe = Js.Re.fromString(`module.+= ${moduleName}($|\.)`)
      if assignRe->Js.Re.test_(line) {
        lintContext->LintContext.addIssue(
          LintIssue.make(
            ~path=resFile.path,
            ~line=idx + 1,
            ~kind=ProhibitedModuleAssign(moduleName),
          ),
        )
      }
      let usageRe = Js.Re.fromString(`\\W${moduleName}\.`)
      if usageRe->Js.Re.test_(line) {
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
