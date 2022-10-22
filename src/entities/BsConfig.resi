type t

let lint: (
  t,
  ~prohibitedModules: array<ModuleName.t>,
) => result<unit, [#HAS_OPENED_PROHIBITED_MODULE(ModuleName.t)]>

let struct: S.t<t>
