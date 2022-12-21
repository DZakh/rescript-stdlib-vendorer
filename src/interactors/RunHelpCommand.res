module Console = NodeJs.Console

let make = () => {
  (. ()) => {
    Console.console->Console.log(
      [
        "Usage: cli [command] [options]",
        "",
        "Commands:",
        `  ${"help"->Colorette.bold} - Display this message`,
        `  ${"help <command>"->Colorette.bold} - Show more information about a command`,
        `  ${"lint"->Colorette.bold} - Lint that you use your vendored ReScript standard library over Js, Belt, etc`,
        "",
        `You can find more information about the reasoning behind the tool in the documentation: ${"https://github.com/DZakh/rescript-stdlib-vendorer"->Colorette.underline}`,
        "",
      ]->Array.joinWith("\n"),
    )
  }
}
