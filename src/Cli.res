let exitConsoleWithError = (. ~message) => {
  open NodeJs
  Console.console->Console.log(message)
  Process.process->Process.exitWithCode(1)
}

let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~exitConsoleWithError,
    ~lint=Lint.make(~loadBsConfig=LoadBsConfig.make(), ~loadSourceDirs=LoadSourceDirs.make()),
  ),
  ~runHelpCommand=RunHelpCommand.make(),
  ~runHelpLintCommand=RunHelpLintCommand.make(),
  ~exitConsoleWithError,
)

runCli(.)
