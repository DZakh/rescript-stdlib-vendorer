let make: (
  ~projectPath: string,
  ~loadBsConfig: Port.LoadBsConfig.t,
  ~loadSourceDirs: Port.LoadSourceDirs.t,
) => Port.Lint.t
