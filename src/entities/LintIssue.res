type kind =
  | ProhibitedModuleOpen(string)
  | ProhibitedModuleInclude(string)
  | ProhibitedModuleAssign(string)
  | ProhibitedModuleUsage(string)
type t = {path: string, line: int, kind: kind}

let make = (~path, ~line, ~kind) => {
  {path, line, kind}
}

let getLink = lintIssue => `${lintIssue.path}:${lintIssue.line->Js.Int.toString}`

let getMessage = lintIssue =>
  switch lintIssue.kind {
  | ProhibitedModuleOpen(moduleName) => `Found "${moduleName}" module open.`
  | ProhibitedModuleInclude(moduleName) => `Found "${moduleName}" module include.`
  | ProhibitedModuleUsage(moduleName)
  | ProhibitedModuleAssign(moduleName) =>
    `Found "${moduleName}" module usage.`
  }
