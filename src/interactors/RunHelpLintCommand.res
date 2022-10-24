open Stdlib
module Console = NodeJs.Console

let make = () => {
  (. ()) => {
    Console.console->Console.log(
      ["", "Lint rescript standard libriries usage.", ""]->Array.joinWith("\n"),
    )
  }
}
