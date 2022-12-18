open Ava

module Lint = {
  test("lint complains on prohibited modules opened using bsc-flags", t => {
    t->Assert.deepEqual(
      BsConfig.TestData.make(~bscFlags=["-open Belt"])->BsConfig.lint(
        ~prohibitedModuleNames=[ModuleName.unsafeFromString("Belt")],
      ),
      Error(#HAS_OPENED_PROHIBITED_MODULE(ModuleName.unsafeFromString("Belt"))),
      (),
    )
  })

  test(
    "lint doesn't complain on modules opened using bsc-flags if they are not in the prohibited list",
    t => {
      t->Assert.deepEqual(
        BsConfig.TestData.make(~bscFlags=["-open Belt"])->BsConfig.lint(
          ~prohibitedModuleNames=[ModuleName.unsafeFromString("Js")],
        ),
        Ok(),
        (),
      )
    },
  )
}
