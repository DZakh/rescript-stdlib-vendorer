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
        `You can find more information about the reasoning behind the tool in the article: ${"https://satin-lodge-4d6.notion.site/The-ultimate-answer-to-Belt-vs-Js-in-ReScript-b23caf1278144a2a81117bebf9d17617"->Colorette.underline}`,
        "",
      ]->Array.joinWith("\n"),
    )
  }
}
