include Opaque.String

let defaultStdlibModuleName: t
let defaultProhibitedModuleNames: array<t>

let fromPath: string => option<t>

let isSubmodule: (t, ~ofModule: t) => bool
