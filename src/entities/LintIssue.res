open Stdlib

type kind =
  | ProhibitedModuleOpen(ModuleName.t)
  | ProhibitedModuleInclude(ModuleName.t)
  | ProhibitedModuleAssign(ModuleName.t)
  | ProhibitedModuleUsage(ModuleName.t)
type t = {path: string, line: int, kind: kind}

let make = (~path, ~line, ~kind) => {
  {path, line, kind}
}

let getLink = lintIssue => `${lintIssue.path}:${lintIssue.line->Int.toString}`

let getMessage = lintIssue =>
  switch lintIssue.kind {
  | ProhibitedModuleOpen(moduleName) => `Found "${moduleName->ModuleName.toString}" module open.`
  | ProhibitedModuleInclude(moduleName) =>
    `Found "${moduleName->ModuleName.toString}" module include.`
  | ProhibitedModuleUsage(moduleName)
  | ProhibitedModuleAssign(moduleName) =>
    `Found "${moduleName->ModuleName.toString}" module usage.`
  }
