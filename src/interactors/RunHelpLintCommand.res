module Console = NodeJs.Console

let make = () => {
  (. ()) => {
    Console.console->Console.log(
      [
        "",
        "Lint that you use your vendored ReScript standard library over Js, Belt, etc.",
        "",
        "Options:",
        ` ${"--project-path String"->Colorette.bold} - Path to the project directory. It should point to where bsconfig.json is located (defaults to the current directory).`,
        ` ${"--ignore-without-stdlib-open"->Colorette.bold} - Whether linter should ignore files that don't have globally opened vendored stdlib. Convenient for gradual adoption.`,
        ` ${"--ignore-path [String]"->Colorette.bold} - Paths of files to ignore.`,
        "",
      ]->Array.joinWith("\n"),
    )
  }
}
