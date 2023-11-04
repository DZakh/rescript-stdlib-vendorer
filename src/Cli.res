let exitConsoleWithError = (~message) => {
  NodeJs.Console.console->NodeJs.Console.log(message)
  NodeJs.Process.process->NodeJs.Process.exitWithCode(1)
}

let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~exitConsoleWithError,
    ~lint=Lint.make(~loadResConfig=LoadResConfig.make(), ~loadSourceDirs=LoadSourceDirs.make()),
  ),
  ~runHelpCommand=RunHelpCommand.make(),
  ~runHelpLintCommand=RunHelpLintCommand.make(),
  ~exitConsoleWithError,
)

runCli()
