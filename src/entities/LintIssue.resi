type kind =
  | ProhibitedModuleOpen(string)
  | ProhibitedModuleInclude(string)
  | ProhibitedModuleAssign(string)
  | ProhibitedModuleUsage(string)
type t

let make: (~path: string, ~line: int, ~kind: kind) => t

let getLink: t => string

let getMessage: t => string
