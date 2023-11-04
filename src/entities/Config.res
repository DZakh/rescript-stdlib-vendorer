type t = {
  projectPath: string,
  ignoreWithoutStdlibOpen: bool,
  stdlibModuleName: ModuleName.t,
  ignorePaths: array<string>,
}

let make = (~projectPath, ~ignoreWithoutStdlibOpen, ~ignorePaths) => {
  projectPath,
  ignoreWithoutStdlibOpen,
  stdlibModuleName: ModuleName.defaultStdlibModuleName,
  ignorePaths,
}

let getProjectPath = config => config.projectPath

let getStdlibModuleName = config => config.stdlibModuleName

let checkShouldIngoreResFileIssuesBeforeStdlibOpen = (config, ~resConfig) => {
  config.ignoreWithoutStdlibOpen &&
  resConfig->ResConfig.hasGloballyOpenedModule(~moduleName=config.stdlibModuleName)->not
}

let checkIsIgnoredPath = (config, ~relativePath) => {
  config.ignorePaths->Array.some(ignorePath => relativePath->String.startsWith(ignorePath))
}
