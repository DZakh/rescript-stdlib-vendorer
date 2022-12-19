module Process = NodeJs.Process
module Console = NodeJs.Console

@module("minimist")
external parseCommandArguments: (array<string>, unit) => unknown = "default"

type error =
  | CommandNotFound
  | IllegalOption({optionName: string})

type command = Help | Lint | LintHelp

let make = (~runLintCommand, ~runHelpCommand, ~runHelpLintCommand) => {
  (. ()) => {
    let commandArguments = Process.process->Process.argv->Array.sliceFrom(2)
    let result =
      commandArguments
      ->parseCommandArguments()
      ->S.parseWith(
        S.union([
          S.object(o => {
            o->S.discriminant(
              "_",
              S.union([S.tuple0(.), S.tuple1(. S.literalVariant(String("help"), ()))]),
            )
            Help
          })->S.Object.strict,
          S.object(o => {
            o->S.discriminant("_", S.tuple2(. S.literal(String("help")), S.literal(String("lint"))))
            LintHelp
          })->S.Object.strict,
          S.object(o => {
            o->S.discriminant("_", S.tuple1(. S.literal(String("lint"))))
            Lint
          })->S.Object.strict,
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
      ->Result.map((. command) => {
        switch command {
        | Help => runHelpCommand(.)
        | LintHelp => runHelpLintCommand(.)
        | Lint => runLintCommand(.)
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
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
