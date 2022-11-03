module Console = NodeJs.Console
module Process = NodeJs.Process

let make = (~lint: Port.Lint.t, . ~maybeStdlibModuleOverride) => {
  switch lint(. ~maybeStdlibModuleOverride) {
  | Ok() => ()
  | Error(error) => {
      switch error {
      | BsConfigParseFailure(reason) =>
        Console.console->Console.logMany([`Failed to parse "bsconfig.json":`, reason])
      | RescriptCompilerArtifactsNotFound =>
        Console.console->Console.log(`Couldn't find rescript compiler artifacts in the "./lib/bs/" directory. Try to run compiler before the lint script.`)
      | SourceDirsParseFailure(reason) =>
        Console.console->Console.logMany([
          `Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error:`,
          reason,
        ])
      | BsConfigHasOpenedProhibitedModule(moduleName) =>
        Console.console->Console.log(
          `Lint failed: Found globally opened module ${moduleName->ModuleName.toString}`,
        )
      | LintFailedWithIssues(lintIssues) => {
          lintIssues->Array.forEach(lintIssue => {
            Console.console->Console.logMany([
              lintIssue->LintIssue.getLink->Colorette.underline,
              "\n",
              lintIssue->LintIssue.getMessage,
              "\n",
            ])
          })
          Console.console->Console.log(
            `Use custom standard library. Read more in the documentation: ${"https://github.com/DZakh/rescript-stdlib-cli"->Colorette.underline}`->Colorette.bold,
          )
        }
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
