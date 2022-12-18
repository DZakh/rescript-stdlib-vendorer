open Ava

test("Loads bs config without bscFlags", t => {
  let loadBsConfig = LoadBsConfig.make(~projectPath="fixtures/LoadBsConfig/withoutBscFlags")

  t->Assert.deepEqual(loadBsConfig(.), Ok(BsConfig.TestData.make(~bscFlags=[])), ())
})

test("Loads bs config with bscFlags", t => {
  let loadBsConfig = LoadBsConfig.make(~projectPath="fixtures/LoadBsConfig/withBscFlags")

  t->Assert.deepEqual(loadBsConfig(.), Ok(BsConfig.TestData.make(~bscFlags=["-open Belt"])), ())
})

test("Returns error when bsconfig is invalid", t => {
  let loadBsConfig = LoadBsConfig.make(~projectPath="fixtures/LoadBsConfig/withInvalidBsconfig")

  t->Assert.deepEqual(
    loadBsConfig(.),
    Error(ParsingFailure("Failed parsing at [bsc-flags]. Reason: Expected Array, received String")),
    (),
  )
})

test("Throws when bsconfig.json is missing", t => {
  let loadBsConfig = LoadBsConfig.make(~projectPath="fixtures/LoadBsConfig/withoutBsconfig")

  t->Assert.throws(
    () => {
      loadBsConfig(.)
    },
    ~expectations={
      code: "ENOENT"->Obj.magic,
    },
    (),
  )
})
