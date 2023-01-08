type t

let make: (~content: string, ~path: string) => t

let lint: (
  t,
  ~lintContext: LintContext.t,
  ~prohibitedModuleNames: array<ModuleName.t>,
  ~stdlibModuleName: ModuleName.t,
  ~ignoreIssuesBeforeStdlibOpen: bool,
) => unit

let checkIsResFile: (~dirItem: string) => bool
