let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~loadBsConfig=LoadBsConfig.make(),
    ~loadSourceDirs=LoadSourceDirs.make(),
  ),
  ~runHelpCommand=(. ()) => NodeJs.Console.console->NodeJs.Console.log("Help"),
  ~runLintHelpCommand=(. ()) => NodeJs.Console.console->NodeJs.Console.log("Lint help"),
)

runCli(.)
