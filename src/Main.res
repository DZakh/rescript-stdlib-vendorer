let runCli = RunCliService.make(
  ~runLintCommand=RunLintCommandService.make(~loadBsConfig=LoadBsConfigService.make()),
  ~runHelpCommand=(. ()) => Js.log("Help"),
  ~runLintHelpCommand=(. ()) => Js.log("Lint help"),
)

runCli(.)
