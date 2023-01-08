type t = {projectPath: string, ignoreWithoutStdlibOpen: bool, stdlibModuleName: ModuleName.t}

let make = (~projectPath, ~ignoreWithoutStdlibOpen) => {
  projectPath,
  ignoreWithoutStdlibOpen,
  stdlibModuleName: ModuleName.defaultStdlibModuleName,
}

let getProjectPath = config => config.projectPath

let getStdlibModuleName = config => config.stdlibModuleName

let checkShouldIngoreResFileIssuesBeforeStdlibOpen = (config, ~bsConfig) => {
  config.ignoreWithoutStdlibOpen &&
  bsConfig->BsConfig.hasGloballyOpenedModule(~moduleName=config.stdlibModuleName)->not
}
