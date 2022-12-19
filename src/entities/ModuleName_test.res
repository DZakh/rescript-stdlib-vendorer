open Ava

module FromBscFlag = {
  test("fromBscFlag works with Belt", t => {
    t->Assert.deepEqual(
      ModuleName.fromBscFlag("-open Belt"),
      Some(ModuleName.TestData.make("Belt")),
      (),
    )
  })

  test("fromBscFlag returns the parent module from a nested one", t => {
    t->Assert.deepEqual(
      ModuleName.fromBscFlag("-open Stdlib.Array"),
      Some(ModuleName.TestData.make("Stdlib")),
      (),
    )
  })

  test("fromBscFlag returns None if it's not an -open bscFlag", t => {
    t->Assert.deepEqual(ModuleName.fromBscFlag("-smthelse"), None, ())
  })
}

module FromPath = {
  test("fromPath works with .res file", t => {
    t->Assert.deepEqual(
      ModuleName.fromPath("/path/to/ModuleName.res"),
      Some(ModuleName.TestData.make("ModuleName")),
      (),
    )
  })

  test("fromPath works with .resi file", t => {
    t->Assert.deepEqual(
      ModuleName.fromPath("/path/to/ModuleName.resi"),
      Some(ModuleName.TestData.make("ModuleName")),
      (),
    )
  })

  test("fromPath returns None with .js file", t => {
    t->Assert.deepEqual(ModuleName.fromPath("/path/to/ModuleName.js"), None, ())
  })
}

module IsSubmodule = {
  test("isSubmodule works", t => {
    t->Assert.deepEqual(
      ModuleName.TestData.make("ModuleName")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.TestData.make("ModuleName"),
      ),
      false,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.TestData.make("ModuleName_Foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.TestData.make("ModuleName"),
      ),
      true,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.TestData.make("ModuleName_foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.TestData.make("ModuleName"),
      ),
      true,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.TestData.make("ModuleName__foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.TestData.make("ModuleName"),
      ),
      true,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.TestData.make("ModuleNames_Foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.TestData.make("ModuleName"),
      ),
      false,
      (),
    )
  })
}
