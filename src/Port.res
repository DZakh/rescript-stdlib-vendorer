module Lint = {
  type error =
    | BsConfigParseFailure(string)
    | SourceDirsParseFailure(string)
    | BsConfigHasOpenedProhibitedModule(ModuleName.t)
    | LintFailedWithIssues(array<LintIssue.t>)
    | RescriptCompilerArtifactsNotFound
  type t = (. unit) => result<unit, error>
}

module RunLintCommand = {
  type t = (. unit) => unit
}

module RunHelpLintCommand = {
  type t = (. unit) => unit
}

module RunHelpCommand = {
  type t = (. unit) => unit
}

module LoadBsConfig = {
  type error = ParsingFailure(string)
  type t = (. unit) => result<BsConfig.t, error>
}

module LoadSourceDirs = {
  type error = RescriptCompilerArtifactsNotFound | ParsingFailure(string)
  type t = (. unit) => result<SourceDirs.t, error>
}

module RunCli = {
  type t = (. unit) => unit
}
