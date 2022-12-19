open Ava
open Execa

let cliPath = NodeJs.Path.resolve(["cli.mjs"])

asyncTest("Shows help when command is not specified", async t => {
  let {stdout} = await execa(
    "node",
    [cliPath],
    ~options={env: Dict.fromArray([("NO_COLOR", "")])},
    (),
  )

  t->Assert.deepEqual(
    stdout,
    [
      "",
      "Available commands are:",
      "",
      "* help - Display this message",
      "* help <command> - Show more information about a command",
      "* lint - Lint rescript standard libriries usage",
      "",
      "You can find more information about the reasoning behind the tool in the documentation: https://github.com/DZakh/rescript-stdlib-lint",
      "",
    ]->Array.joinWith("\n"),
    (),
  )
})
