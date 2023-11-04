open Ava

module Lint = {
  test("lint complains on prohibited modules opened using bsc-flags", t => {
    t->Assert.deepEqual(
      ResConfig.TestData.make(~bscFlags=["-open Belt"])->ResConfig.lint(
        ~prohibitedModuleNames=[ModuleName.TestData.make("Belt")],
      ),
      Error(#HAS_OPENED_PROHIBITED_MODULE(ModuleName.TestData.make("Belt"))),
      (),
    )
  })

  test(
    "lint doesn't complain on modules opened using bsc-flags if they are not in the prohibited list",
    t => {
      t->Assert.deepEqual(
        ResConfig.TestData.make(~bscFlags=["-open Belt"])->ResConfig.lint(
          ~prohibitedModuleNames=[ModuleName.TestData.make("Js")],
        ),
        Ok(),
        (),
      )
    },
  )
}
