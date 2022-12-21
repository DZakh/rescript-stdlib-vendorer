let make: (
  ~runLintCommand: Port.RunLintCommand.t,
  ~runHelpCommand: Port.RunHelpCommand.t,
  ~runHelpLintCommand: Port.RunHelpLintCommand.t,
  ~exitConsoleWithError: Port.ExitConsoleWithError.t,
) => Port.RunCli.t
