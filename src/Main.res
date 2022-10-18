let runCli = RunCliService.make(
  ~runLintCommand=RunLintCommandService.make(
    ~loadBsConfig=LoadBsConfigService.make(),
    ~loadSourceDirs=LoadSourceDirsService.make(),
  ),
  ~runHelpCommand=(. ()) => Js.log("Help"),
  ~runLintHelpCommand=(. ()) => Js.log("Lint help"),
)

runCli(.)
