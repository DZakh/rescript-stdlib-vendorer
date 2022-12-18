let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~lint=Lint.make(
      ~loadBsConfig=LoadBsConfig.make(
        ~projectPath={
          open NodeJs
          Process.process->Process.cwd
        },
      ),
      ~loadSourceDirs=LoadSourceDirs.make(),
    ),
  ),
  ~runHelpCommand=RunHelpCommand.make(),
  ~runHelpLintCommand=RunHelpLintCommand.make(),
)

runCli(.)
