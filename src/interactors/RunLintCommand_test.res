open Ava

module ExitConsoleWithError = {
  let make = () => {
    let calls = []
    (
      calls,
      (. ~message) => {
        calls->Array.push(message)->ignore
      },
    )
  }
}

test("Doesn't log anything on success", t => {
  let (exitConsoleWithErrorCalls, exitConsoleWithError) = ExitConsoleWithError.make()
  let lint = (. ~config as _) => Ok()
  let runLintCommand = RunLintCommand.make(~exitConsoleWithError, ~lint)

  runLintCommand(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false))

  t->Assert.deepEqual(exitConsoleWithErrorCalls, [], ())
})

test("Handles BsConfigParseFailure error", t => {
  let (exitConsoleWithErrorCalls, exitConsoleWithError) = ExitConsoleWithError.make()
  let lint = (. ~config as _) => Error(Port.Lint.BsConfigParseFailure("Something went wrong"))
  let runLintCommand = RunLintCommand.make(~exitConsoleWithError, ~lint)

  runLintCommand(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false))

  t->Assert.snapshot(exitConsoleWithErrorCalls, ())
})

test("Handles RescriptCompilerArtifactsNotFound error", t => {
  let (exitConsoleWithErrorCalls, exitConsoleWithError) = ExitConsoleWithError.make()
  let lint = (. ~config as _) => Error(Port.Lint.RescriptCompilerArtifactsNotFound)
  let runLintCommand = RunLintCommand.make(~exitConsoleWithError, ~lint)

  runLintCommand(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false))

  t->Assert.snapshot(exitConsoleWithErrorCalls, ())
})

test("Handles SourceDirsParseFailure error", t => {
  let (exitConsoleWithErrorCalls, exitConsoleWithError) = ExitConsoleWithError.make()
  let lint = (. ~config as _) => Error(Port.Lint.SourceDirsParseFailure("Something went wrong"))
  let runLintCommand = RunLintCommand.make(~exitConsoleWithError, ~lint)

  runLintCommand(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false))

  t->Assert.snapshot(exitConsoleWithErrorCalls, ())
})

test("Handles BsConfigHasOpenedProhibitedModule error", t => {
  let (exitConsoleWithErrorCalls, exitConsoleWithError) = ExitConsoleWithError.make()
  let lint = (. ~config as _) => Error(
    Port.Lint.BsConfigHasOpenedProhibitedModule(ModuleName.TestData.make("Js")),
  )
  let runLintCommand = RunLintCommand.make(~exitConsoleWithError, ~lint)

  runLintCommand(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false))

  t->Assert.snapshot(exitConsoleWithErrorCalls, ())
})

test("Handles LintFailedWithIssues error", t => {
  let (exitConsoleWithErrorCalls, exitConsoleWithError) = ExitConsoleWithError.make()
  let lint = (. ~config as _) => Error(
    Port.Lint.LintFailedWithIssues([
      LintIssue.make(
        ~kind=ProhibitedModuleInclude({
          prohibitedModuleName: ModuleName.TestData.make("Js"),
          line: 5,
        }),
        ~path="/path/LintIssue_test.res",
      ),
      LintIssue.make(
        ~kind=InvalidStdlibParentDirName({
          stdlibParentDirName: "stdlib",
        }),
        ~path="/path/LintIssue_test.res",
      ),
    ]),
  )
  let runLintCommand = RunLintCommand.make(~exitConsoleWithError, ~lint)

  runLintCommand(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false))

  t->Assert.snapshot(exitConsoleWithErrorCalls, ())
})
