open NodeJs

@module("minimist")
external parseCommandArguments: (array<string>, unit) => S.unknown = "default"

type error =
  | CommandNotFound
  | IllegalOption({optionName: string})
  | BsConfigParsingFailure(string)
  | SourceDirsParsingFailure(string)
  | LintErrorHasGlobalyOpenedStdlib(string)
type command = Help | Lint | LintHelp

let make = (~runLintCommand, ~runHelpCommand, ~runLintHelpCommand) => {
  (. ()) => {
    let commandArguments = Process.process->Process.argv->Js.Array2.sliceFrom(2)
    let result =
      commandArguments
      ->parseCommandArguments()
      ->S.parseWith(
        S.union([
          S.object1(. (
            "_",
            S.union([S.tuple0(.), S.tuple1(. S.literalVariant(String("help"), ()))]),
          ))
          ->S.Object.strict
          ->S.transform(~parser=() => Help, ()),
          S.object1(. (
            "_",
            S.tuple2(. S.literalVariant(String("help"), ()), S.literalVariant(String("lint"), ())),
          ))
          ->S.Object.strict
          ->S.transform(~parser=(((), ())) => LintHelp, ()),
          S.object1(. ("_", S.tuple1(. S.literalVariant(String("lint"), ()))))
          ->S.Object.strict
          ->S.transform(~parser=() => Lint, ()),
        ]),
      )
      ->Lib.Result.mapError((. error) => {
        switch error.code {
        | InvalidUnion(unionErrors) => {
            let maybeIllegalOptionName =
              unionErrors
              ->Js.Array2.find(error =>
                switch error.code {
                | ExcessField(_) => true
                | _ => false
                }
              )
              ->Belt.Option.map(excessFieldError => {
                switch excessFieldError.code {
                | ExcessField(illegalOptionName) => illegalOptionName
                | _ =>
                  Js.Exn.raiseError("The excessFieldError always must have the ExcessField code")
                }
              })

            switch maybeIllegalOptionName {
            | Some(illegalOptionName) => IllegalOption({optionName: illegalOptionName})
            | None => CommandNotFound
            }
          }

        | _ => Js.Exn.raiseError("Parsed error always must have the InvalidUnion code")
        }
      })
      ->Belt.Result.flatMap(command => {
        switch command {
        | Help => runHelpCommand(.)->Ok
        | LintHelp => runLintHelpCommand(.)->Ok
        | Lint =>
          runLintCommand(.)->Lib.Result.mapError((. lintCommandError) => {
            switch lintCommandError {
            | #BS_CONFIG_PARSE_FAILURE(reason) => BsConfigParsingFailure(reason)
            | #SOURCE_DIRS_PARSE_FAILURE(reason) => SourceDirsParsingFailure(reason)
            | #HAS_GLOBALY_OPENED_STDLIB(moduleName) => LintErrorHasGlobalyOpenedStdlib(moduleName)
            }
          })
        }
      })

    switch result {
    | Ok() => ()
    | Error(error) =>
      switch error {
      | CommandNotFound => Js.log2("Command not found:", commandArguments->Js.Array2.joinWith(" "))
      | IllegalOption({optionName}) => Js.log2("Illegal option:", optionName)
      | BsConfigParsingFailure(reason) => Js.log2(`Failed to parse "bsconfig.json":`, reason)
      | SourceDirsParsingFailure(reason) =>
        Js.log2(
          `Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error:`,
          reason,
        )
      | LintErrorHasGlobalyOpenedStdlib(moduleName) =>
        Js.log(`Lint failed: Found globally opened module ${moduleName}`)
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
