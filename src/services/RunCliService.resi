let make: (
  ~runLintCommand: Ports.runLintCommand,
  ~runHelpCommand: Ports.runHelpCommand,
  ~runLintHelpCommand: Ports.runLintHelpCommand,
) => Ports.runCli
