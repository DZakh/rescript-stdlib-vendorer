include Opaque.String

let defaultStdlibModuleName: t
let defaultProhibitedModuleNames: array<t>

let fromBscFlag: string => option<t>

let fromPath: string => option<t>

let isSubmodule: (t, ~ofModule: t) => bool

module TestData: {
  let make: string => t
}
