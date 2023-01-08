type t

let make: (~projectPath: string, ~ignoreWithoutStdlibOpen: bool) => t

let getProjectPath: t => string
let getStdlibModuleName: t => ModuleName.t
let checkShouldIngoreResFileIssuesBeforeStdlibOpen: (t, ~bsConfig: BsConfig.t) => bool
