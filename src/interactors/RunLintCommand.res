let make = (~lint: Port.Lint.t, ~exitConsoleWithError: Port.ExitConsoleWithError.t) => (
  ~config,
) => {
  switch lint(~config) {
  | Ok() => ()
  | Error(error) =>
    switch error {
    | BsConfigParseFailure(reason) =>
      exitConsoleWithError(~message=`Failed to parse "bsconfig.json": ${reason}`)
    | RescriptCompilerArtifactsNotFound =>
      exitConsoleWithError(
        ~message=`Couldn't find rescript compiler artifacts in the "./lib/bs/" directory. Try to run compiler before the lint script.`,
      )
    | SourceDirsParseFailure(reason) =>
      exitConsoleWithError(
        ~message=`Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error: ${reason}`,
      )
    | BsConfigHasOpenedProhibitedModule(moduleName) =>
      exitConsoleWithError(
        ~message=`Lint failed: Found globally opened module ${moduleName->ModuleName.toString}`,
      )
    | LintFailedWithIssues(lintIssues) => {
        let message =
          lintIssues
          ->Array.map(lintIssue => {
            [
              lintIssue->LintIssue.getLink->Colorette.underline,
              lintIssue->LintIssue.getMessage,
            ]->Array.joinWith("\n")
          })
          ->Array.concat([
            `Use the vendored standard library instead. Read more at: ${"https://github.com/DZakh/rescript-stdlib-vendorer"->Colorette.underline}`->Colorette.bold,
          ])
          ->Array.joinWith("\n\n")
        exitConsoleWithError(~message)
      }
    }
  }
}
