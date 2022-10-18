type t = array<string>

let getProjectDirs = sourceDirs => sourceDirs

let struct = S.object1(. ("dirs", S.array(S.string())))
