type t

let make: (~content: string, ~path: string) => t

let lint: (t, ~lintContext: LintContext.t, ~prohibitedModules: array<ModuleName.t>) => unit
