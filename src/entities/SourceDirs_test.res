open Ava

module FromJsonString = {
  test("fromJsonString successfully parses with dirs field provided", t => {
    t->Assert.deepEqual(
      SourceDirs.fromJsonString(`{"dirs":["src","__tests__"]}`),
      Ok(SourceDirs.TestData.make(~projectDirs=["src", "__tests__"])),
      (),
    )
  })

  test("fromJsonString fails parses with dirs field missing", t => {
    t->Assert.deepEqual(
      SourceDirs.fromJsonString(`{}`),
      Error("Failed parsing at [dirs]. Reason: Expected Array, received Option"),
      (),
    )
  })
}

module GetProjectDirs = {
  test("getProjectDirs wroks", t => {
    t->Assert.deepEqual(
      SourceDirs.TestData.make(~projectDirs=["src", "__tests__"])->SourceDirs.getProjectDirs,
      ["src", "__tests__"],
      (),
    )
  })
}
