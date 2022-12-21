open Ava
open Execa

let execCli = (~arguments) => {
  execa(
    "node",
    [NodeJs.Path.resolve(["cli.mjs"])]->Array.concat(arguments),
    ~options={env: Dict.fromArray([("NO_COLOR", "")])},
    (),
  )
}

asyncTest("Shows help when command is not specified", async t => {
  let {stdout} = await execCli(~arguments=[])

  t->Assert.snapshot(stdout, ())
})

asyncTest("Shows help when help command provided", async t => {
  let {stdout} = await execCli(~arguments=["help"])

  t->Assert.snapshot(stdout, ())
})

asyncTest("Shows error message when unknown command provided", async t => {
  try {
    let _ = await execCli(~arguments=["foo"])
  } catch {
  | Exn.Error(error) => {
      let {stdout} = error->Obj.magic

      t->Assert.snapshot(stdout, ())
    }
  }
})

asyncTest("Shows error message when unknown option provided", async t => {
  try {
    let _ = await execCli(~arguments=["lint", "--foo"])
  } catch {
  | Exn.Error(error) => {
      let {stdout} = error->Obj.magic

      t->Assert.snapshot(stdout, ())
    }
  }
})

asyncTest("Shows help lint", async t => {
  let {stdout} = await execCli(~arguments=["help", "lint"])

  t->Assert.snapshot(stdout, ())
})

asyncTest("Succseefully lints the project", async t => {
  let {stdout} = await execCli(~arguments=["lint"])

  t->Assert.deepEqual(stdout, "", ())
})

asyncTest("Succseefully lints invalid project", async t => {
  try {
    let _ = await execCli(~arguments=["lint", "--project-path=fixtures/Cli/invalid"])
  } catch {
  | Exn.Error(error) => {
      let {stdout} = error->Obj.magic
      let projectPath = NodeJs.Path.resolve([""])

      t->Assert.deepEqual(
        stdout,
        [
          `${projectPath}/fixtures/Cli/invalid/src/Demo.res:1`,
          `Found "Js" module usage.`,
          "",
          `Use custom standard library. Read more in the documentation: https://github.com/DZakh/rescript-stdlib-vendorer`,
        ]->Array.joinWith("\n"),
        (),
      )
    }
  }
})
