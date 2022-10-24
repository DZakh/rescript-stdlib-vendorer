let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~lint=Lint.make(~loadBsConfig=LoadBsConfig.make(), ~loadSourceDirs=LoadSourceDirs.make()),
  ),
  ~runHelpCommand=RunHelpCommand.make(),
  ~runHelpLintCommand=RunHelpLintCommand.make(),
)

runCli(.)
