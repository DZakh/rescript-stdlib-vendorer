type kind =
  | ProhibitedModuleOpen(ModuleName.t)
  | ProhibitedModuleInclude(ModuleName.t)
  | ProhibitedModuleAssign(ModuleName.t)
  | ProhibitedModuleUsage(ModuleName.t)
type t

let make: (~path: string, ~line: int, ~kind: kind) => t

let getLink: t => string

let getMessage: t => string
