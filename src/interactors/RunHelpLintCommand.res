module Console = NodeJs.Console

let make = () => {
  (. ()) => {
    Console.console->Console.log(
      [
        "",
        "Lint that you use your vendored ReScript standard library over Js, Belt, etc.",
        "",
        "Options:",
        ` ${"--project-path"->Colorette.bold} - Path to the project directory. It should point to where bsconfig.json is located (defaults to the current directory).`,
        "",
      ]->Array.joinWith("\n"),
    )
  }
}
