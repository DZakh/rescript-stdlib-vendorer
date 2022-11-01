module Console = NodeJs.Console

let make = () => {
  (. ()) => {
    Console.console->Console.log(
      [
        "",
        "Available commands are:",
        "",
        `* ${"help"->Colorette.bold} - Display this message`,
        `* ${"help <command>"->Colorette.bold} - Show more information about a command`,
        `* ${"lint"->Colorette.bold} - Lint rescript standard libriries usage`,
        "",
        `You can find more information about the reasoning behind the tool in the documentation: ${"https://github.com/DZakh/rescript-stdlib-cli"->Colorette.underline}`,
        "",
      ]->Array.joinWith("\n"),
    )
  }
}
