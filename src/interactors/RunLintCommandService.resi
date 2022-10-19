let make: (
  ~loadBsConfig: Ports.LoadBsConfig.t,
  ~loadSourceDirs: Ports.LoadSourceDirs.t,
) => Ports.RunLintCommand.t
