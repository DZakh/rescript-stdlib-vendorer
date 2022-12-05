type t = array<string>

let getProjectDirs = sourceDirs => sourceDirs

let struct = S.object(o => o->S.field("dirs", S.array(S.string())))
