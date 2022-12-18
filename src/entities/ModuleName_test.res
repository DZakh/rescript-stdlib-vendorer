open Ava

module FromPath = {
  test("fromPath works with .res file", t => {
    t->Assert.deepEqual(
      ModuleName.fromPath("/path/to/ModuleName.res"),
      Some(ModuleName.unsafeFromString("ModuleName")),
      (),
    )
  })

  test("fromPath works with .resi file", t => {
    t->Assert.deepEqual(
      ModuleName.fromPath("/path/to/ModuleName.resi"),
      Some(ModuleName.unsafeFromString("ModuleName")),
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
      ModuleName.unsafeFromString("ModuleName")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.unsafeFromString("ModuleName"),
      ),
      false,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.unsafeFromString("ModuleName_Foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.unsafeFromString("ModuleName"),
      ),
      true,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.unsafeFromString("ModuleName_foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.unsafeFromString("ModuleName"),
      ),
      true,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.unsafeFromString("ModuleName__foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.unsafeFromString("ModuleName"),
      ),
      true,
      (),
    )
    t->Assert.deepEqual(
      ModuleName.unsafeFromString("ModuleNames_Foo")->ModuleName.isSubmodule(
        ~ofModule=ModuleName.unsafeFromString("ModuleName"),
      ),
      false,
      (),
    )
  })
}
