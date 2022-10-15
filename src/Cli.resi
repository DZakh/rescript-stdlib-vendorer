let make: (
  ~runLintCommand: (. unit) => unit,
  ~runHelpCommand: (. unit) => unit,
  ~runLintHelpCommand: (. unit) => unit,
  . unit,
) => unit
