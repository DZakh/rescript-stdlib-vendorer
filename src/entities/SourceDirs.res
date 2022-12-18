type t = array<string>

let getProjectDirs = projectDirs => projectDirs

let struct = S.json(S.object(o => o->S.field("dirs", S.array(S.string()))))

let fromJsonString = jsonString => jsonString->S.parseWith(struct)->S.Result.mapErrorToString

module TestData = {
  let make = (~projectDirs) => projectDirs
}
