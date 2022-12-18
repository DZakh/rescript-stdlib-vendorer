open Ava

module GetProjectDirs = {
  test("getProjectDirs wroks", t => {
    t->Assert.deepEqual(
      SourceDirs.TestData.make(~projectDirs=["src", "__tests__"])->SourceDirs.getProjectDirs,
      ["src", "__tests__"],
      (),
    )
  })
}
