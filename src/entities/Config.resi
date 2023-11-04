type t

let make: (~projectPath: string, ~ignoreWithoutStdlibOpen: bool, ~ignorePaths: array<string>) => t

let getProjectPath: t => string
let getStdlibModuleName: t => ModuleName.t
let checkShouldIngoreResFileIssuesBeforeStdlibOpen: (t, ~resConfig: ResConfig.t) => bool
let checkIsIgnoredPath: (t, ~relativePath: string) => bool
