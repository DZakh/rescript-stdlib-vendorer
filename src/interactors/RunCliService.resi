let make: (
  ~runLintCommand: Ports.RunLintCommand.t,
  ~runHelpCommand: Ports.RunHelpCommand.t,
  ~runLintHelpCommand: Ports.RunLintHelpCommand.t,
) => Ports.RunCli.t
