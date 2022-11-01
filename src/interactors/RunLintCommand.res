module Console = NodeJs.Console
module Process = NodeJs.Process

let make = (~lint, . ~maybeStdlibModuleOverride) => {
  switch lint(. ~maybeStdlibModuleOverride) {
  | Ok() => ()
  | Error(error) => {
      switch error {
      | #BS_CONFIG_PARSE_FAILURE(reason) =>
        Console.console->Console.logMany([`Failed to parse "bsconfig.json":`, reason])
      | #SOURCE_DIRS_PARSE_FAILURE(reason) =>
        Console.console->Console.logMany([
          `Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error:`,
          reason,
        ])
      | #BS_CONFIG_HAS_OPENED_PROHIBITED_MODULE(moduleName) =>
        Console.console->Console.log(
          `Lint failed: Found globally opened module ${moduleName->ModuleName.toString}`,
        )
      | #LINT_FAILED_WITH_ISSUES(lintIssues) => {
          lintIssues->Array.forEach(lintIssue => {
            Console.console->Console.logMany([
              lintIssue->LintIssue.getLink->Colorette.underline,
              "\n",
              lintIssue->LintIssue.getMessage,
              "\n",
            ])
          })
          Console.console->Console.log(
            `Use your custom standard library. Read more in the article: ${"https://satin-lodge-4d6.notion.site/The-ultimate-answer-to-Belt-vs-Js-in-ReScript-b23caf1278144a2a81117bebf9d17617"->Colorette.underline}`->Colorette.bold,
          )
        }
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
