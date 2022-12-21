let make: (
  ~lint: Port.Lint.t,
  ~exitConsoleWithError: Port.ExitConsoleWithError.t,
) => Port.RunLintCommand.t
