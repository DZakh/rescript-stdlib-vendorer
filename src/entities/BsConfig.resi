type t

let lint: (
  t,
  ~prohibitedModules: array<string>,
) => result<unit, [#HAS_OPENED_PROHIBITED_MODULE(string)]>

let struct: S.t<t>
