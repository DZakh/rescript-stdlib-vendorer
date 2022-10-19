open NodeJs

@module("minimist")
external parseCommandArguments: (array<string>, unit) => S.unknown = "default"
@module("colorette")
external modifyCliTextToBold: string => string = "bold"
@module("colorette")
external modifyCliTextToUnderline: string => string = "underline"

type error =
  | CommandNotFound
  | IllegalOption({optionName: string})
  | LintCommandError(Ports.RunLintCommand.error)
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
            LintCommandError(lintCommandError)
          })
        }
      })

    switch result {
    | Ok() => ()
    | Error(error) =>
      switch error {
      | CommandNotFound => Js.log2("Command not found:", commandArguments->Js.Array2.joinWith(" "))
      | IllegalOption({optionName}) => Js.log2("Illegal option:", optionName)
      | LintCommandError(#BS_CONFIG_PARSE_FAILURE(reason)) =>
        Js.log2(`Failed to parse "bsconfig.json":`, reason)
      | LintCommandError(#SOURCE_DIRS_PARSE_FAILURE(reason)) =>
        Js.log2(
          `Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error:`,
          reason,
        )
      | LintCommandError(#BS_CONFIG_HAS_OPENED_PROHIBITED_MODULE(moduleName)) =>
        Js.log(`Lint failed: Found globally opened module ${moduleName}`)
      | LintCommandError(#LINT_FAILED_WITH_ISSUES(lintIssues)) => {
          lintIssues->Js.Array2.forEach(lintIssue => {
            Js.log4(
              lintIssue->LintIssue.getLink->modifyCliTextToUnderline,
              "\n",
              lintIssue->LintIssue.getMessage,
              "\n",
            )
          })
          Js.log("Use your custom standard library instead."->modifyCliTextToBold)
        }
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
