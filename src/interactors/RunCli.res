open Stdlib
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
    let commandArguments = Process.process->Process.argv->Array.sliceFrom(2)
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
      ->Result.mapError((. error) => {
        switch error.code {
        | InvalidUnion(unionErrors) => {
            let maybeIllegalOptionName =
              unionErrors
              ->Array.find(error =>
                switch error.code {
                | ExcessField(_) => true
                | _ => false
                }
              )
              ->Option.map(excessFieldError => {
                switch excessFieldError.code {
                | ExcessField(illegalOptionName) => illegalOptionName
                | _ => Exn.raiseError("The excessFieldError always must have the ExcessField code")
                }
              })

            switch maybeIllegalOptionName {
            | Some(illegalOptionName) => IllegalOption({optionName: illegalOptionName})
            | None => CommandNotFound
            }
          }

        | _ => Exn.raiseError("Parsed error always must have the InvalidUnion code")
        }
      })
      ->Result.flatMap((. command) => {
        switch command {
        | Help => runHelpCommand(.)->Ok
        | LintHelp => runLintHelpCommand(.)->Ok
        | Lint =>
          runLintCommand(.)->Result.mapError((. lintCommandError) => {
            LintCommandError(lintCommandError)
          })
        }
      })

    switch result {
    | Ok() => ()
    | Error(error) =>
      switch error {
      | CommandNotFound =>
        Console.console->Console.logMany([
          "Command not found:",
          commandArguments->Array.joinWith(" "),
        ])
      | IllegalOption({optionName}) =>
        Console.console->Console.logMany(["Illegal option:", optionName])
      | LintCommandError(#BS_CONFIG_PARSE_FAILURE(reason)) =>
        Console.console->Console.logMany([`Failed to parse "bsconfig.json":`, reason])
      | LintCommandError(#SOURCE_DIRS_PARSE_FAILURE(reason)) =>
        Console.console->Console.logMany([
          `Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error:`,
          reason,
        ])
      | LintCommandError(#BS_CONFIG_HAS_OPENED_PROHIBITED_MODULE(moduleName)) =>
        Console.console->Console.log(
          `Lint failed: Found globally opened module ${moduleName->ModuleName.toString}`,
        )
      | LintCommandError(#LINT_FAILED_WITH_ISSUES(lintIssues)) => {
          lintIssues->Array.forEach(lintIssue => {
            Console.console->Console.logMany([
              lintIssue->LintIssue.getLink->modifyCliTextToUnderline,
              "\n",
              lintIssue->LintIssue.getMessage,
              "\n",
            ])
          })
          Console.console->Console.log(
            "Use your custom standard library instead."->modifyCliTextToBold,
          )
        }
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
