let run = Cli.make(
  ~runLintCommand=Lint.run,
  ~runHelpCommand=(. ()) => Js.log("Help"),
  ~runLintHelpCommand=(. ()) => Js.log("Help lint"),
)

run(.)
