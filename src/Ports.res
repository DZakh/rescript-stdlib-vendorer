module Lint = {
  type error = [
    | #BS_CONFIG_PARSE_FAILURE(string)
    | #SOURCE_DIRS_PARSE_FAILURE(string)
    | #BS_CONFIG_HAS_OPENED_PROHIBITED_MODULE(ModuleName.t)
    | #LINT_FAILED_WITH_ISSUES(array<LintIssue.t>)
  ]
  type t = (. ~maybeStdlibModuleOverride: option<ModuleName.t>) => result<unit, error>
}

module RunLintCommand = {
  type t = (. ~maybeStdlibModuleOverride: option<ModuleName.t>) => unit
}

module RunHelpLintCommand = {
  type t = (. unit) => unit
}

module RunHelpCommand = {
  type t = (. unit) => unit
}

module LoadBsConfig = {
  type error = [#PARSING_FAILURE(string)]
  type t = (. unit) => result<BsConfig.t, error>
}

module LoadSourceDirs = {
  type error = [#PARSING_FAILURE(string)]
  type t = (. unit) => result<SourceDirs.t, error>
}

module RunCli = {
  type t = (. unit) => unit
}
