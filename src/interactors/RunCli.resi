let make: (
  ~runLintCommand: Ports.RunLintCommand.t,
  ~runHelpCommand: Ports.RunHelpCommand.t,
  ~runHelpLintCommand: Ports.RunHelpLintCommand.t,
) => Ports.RunCli.t
