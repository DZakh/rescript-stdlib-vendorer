let projectPath = {
  open NodeJs
  Process.process->Process.cwd
}

let runCli = RunCli.make(
  ~runLintCommand=RunLintCommand.make(
    ~lint=Lint.make(
      ~loadBsConfig=LoadBsConfig.make(~projectPath),
      ~loadSourceDirs=LoadSourceDirs.make(~projectPath),
    ),
  ),
  ~runHelpCommand=RunHelpCommand.make(),
  ~runHelpLintCommand=RunHelpLintCommand.make(),
)

runCli(.)
