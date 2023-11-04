open Ava

test("Loads bs config without bscFlags", t => {
  let loadResConfig = LoadResConfig.make()

  t->Assert.deepEqual(
    loadResConfig(
      ~config=Config.make(
        ~projectPath="fixtures/LoadResConfig/withoutBscFlags",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Ok(ResConfig.TestData.make(~bscFlags=[])),
    (),
  )
})

test("Loads rescript.json", t => {
  let loadResConfig = LoadResConfig.make()

  t->Assert.deepEqual(
    loadResConfig(
      ~config=Config.make(
        ~projectPath="fixtures/LoadResConfig/withRescriptJson",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Ok(ResConfig.TestData.make(~bscFlags=[])),
    (),
  )
})

test("Loads bs config with bscFlags", t => {
  let loadResConfig = LoadResConfig.make()

  t->Assert.deepEqual(
    loadResConfig(
      ~config=Config.make(
        ~projectPath="fixtures/LoadResConfig/withBscFlags",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Ok(ResConfig.TestData.make(~bscFlags=["-open Belt"])),
    (),
  )
})

test("Returns error when bsconfig is invalid", t => {
  let loadResConfig = LoadResConfig.make()

  t->Assert.deepEqual(
    loadResConfig(
      ~config=Config.make(
        ~projectPath="fixtures/LoadResConfig/withInvalidBsconfig",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Error(
      ParsingFailure(`Failed parsing at ["bsc-flags"]. Reason: Expected Option(Array(String)), received "-open Belt"`),
    ),
    (),
  )
})

test("Throws when ReScript config is missing", t => {
  let loadResConfig = LoadResConfig.make()

  t->Assert.throws(
    () => {
      loadResConfig(
        ~config=Config.make(
          ~projectPath="fixtures/LoadResConfig/withoutBsconfig",
          ~ignoreWithoutStdlibOpen=false,
          ~ignorePaths=[],
        ),
      )
    },
    ~expectations={
      message: `ENOENT: no such file or directory, open '${NodeJs.Path.resolve([
          "fixtures/LoadResConfig/withoutBsconfig/rescript.json",
        ])}'`,
    },
    (),
  )
})
