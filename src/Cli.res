let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~loadBsConfig=LoadBsConfig.make(),
    ~loadSourceDirs=LoadSourceDirs.make(),
  ),
  ~runHelpCommand=(. ()) => Js.log("Help"),
  ~runLintHelpCommand=(. ()) => Js.log("Lint help"),
)

runCli(.)
