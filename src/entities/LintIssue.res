type kind =
  | ProhibitedModuleOpen({line: int, prohibitedModuleName: ModuleName.t})
  | ProhibitedModuleInclude({line: int, prohibitedModuleName: ModuleName.t})
  | ProhibitedModuleAssign({line: int, prohibitedModuleName: ModuleName.t})
  | ProhibitedModuleUsage({line: int, prohibitedModuleName: ModuleName.t})
  | InvalidStdlibParentDirName({stdlibParentDirName: string})
type t = {path: string, kind: kind}

let make = (~path, ~kind) => {
  {path, kind}
}

let getLink = lintIssue =>
  switch lintIssue.kind {
  | InvalidStdlibParentDirName(_) => lintIssue.path
  | ProhibitedModuleOpen({line})
  | ProhibitedModuleInclude({line})
  | ProhibitedModuleAssign({line})
  | ProhibitedModuleUsage({line}) =>
    `${lintIssue.path}:${line->Int.toString}`
  }

let getMessage = lintIssue =>
  switch lintIssue.kind {
  | InvalidStdlibParentDirName({stdlibParentDirName}) =>
    `The "${stdlibParentDirName}" is an invalid directory name for custom standary library related files. Put the files to the directory with the name "stdlib" to make it easier to find them.`
  | ProhibitedModuleOpen({prohibitedModuleName}) =>
    `Found "${prohibitedModuleName->ModuleName.toString}" module open.`
  | ProhibitedModuleInclude({prohibitedModuleName}) =>
    `Found "${prohibitedModuleName->ModuleName.toString}" module include.`
  | ProhibitedModuleUsage({prohibitedModuleName})
  | ProhibitedModuleAssign({prohibitedModuleName}) =>
    `Found "${prohibitedModuleName->ModuleName.toString}" module usage.`
  }
