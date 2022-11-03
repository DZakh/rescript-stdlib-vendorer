let make: (
  ~runLintCommand: Port.RunLintCommand.t,
  ~runHelpCommand: Port.RunHelpCommand.t,
  ~runHelpLintCommand: Port.RunHelpLintCommand.t,
) => Port.RunCli.t
