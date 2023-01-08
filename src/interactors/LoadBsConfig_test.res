open Ava

test("Loads bs config without bscFlags", t => {
  let loadBsConfig = LoadBsConfig.make()

  t->Assert.deepEqual(
    loadBsConfig(.
      ~config=Config.make(
        ~projectPath="fixtures/LoadBsConfig/withoutBscFlags",
        ~ignoreWithoutStdlibOpen=false,
      ),
    ),
    Ok(BsConfig.TestData.make(~bscFlags=[])),
    (),
  )
})

test("Loads bs config with bscFlags", t => {
  let loadBsConfig = LoadBsConfig.make()

  t->Assert.deepEqual(
    loadBsConfig(.
      ~config=Config.make(
        ~projectPath="fixtures/LoadBsConfig/withBscFlags",
        ~ignoreWithoutStdlibOpen=false,
      ),
    ),
    Ok(BsConfig.TestData.make(~bscFlags=["-open Belt"])),
    (),
  )
})

test("Returns error when bsconfig is invalid", t => {
  let loadBsConfig = LoadBsConfig.make()

  t->Assert.deepEqual(
    loadBsConfig(.
      ~config=Config.make(
        ~projectPath="fixtures/LoadBsConfig/withInvalidBsconfig",
        ~ignoreWithoutStdlibOpen=false,
      ),
    ),
    Error(ParsingFailure("Failed parsing at [bsc-flags]. Reason: Expected Array, received String")),
    (),
  )
})

test("Throws when bsconfig.json is missing", t => {
  let loadBsConfig = LoadBsConfig.make()

  t->Assert.throws(
    () => {
      loadBsConfig(.
        ~config=Config.make(
          ~projectPath="fixtures/LoadBsConfig/withoutBsconfig",
          ~ignoreWithoutStdlibOpen=false,
        ),
      )
    },
    ~expectations={
      message: `ENOENT: no such file or directory, open '${NodeJs.Path.resolve([
          "fixtures/LoadBsConfig/withoutBsconfig/bsconfig.json",
        ])}'`,
    },
    (),
  )
})
