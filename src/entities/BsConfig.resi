type t

let lint: (
  t,
  ~prohibitedModuleNames: array<ModuleName.t>,
) => result<unit, [#HAS_OPENED_PROHIBITED_MODULE(ModuleName.t)]>

let hasGloballyOpenedModule: (t, ~moduleName: ModuleName.t) => bool

let fromJsonString: string => result<t, string>

module TestData: {
  let make: (~bscFlags: array<string>) => t
}
