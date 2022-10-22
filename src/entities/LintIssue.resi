type kind =
  | ProhibitedModuleOpen({line: int, prohibitedModuleName: ModuleName.t})
  | ProhibitedModuleInclude({line: int, prohibitedModuleName: ModuleName.t})
  | ProhibitedModuleAssign({line: int, prohibitedModuleName: ModuleName.t})
  | ProhibitedModuleUsage({line: int, prohibitedModuleName: ModuleName.t})
  | InvalidStdlibParentDirName({stdlibParentDirName: string})
type t

let make: (~path: string, ~kind: kind) => t

let getLink: t => string

let getMessage: t => string
