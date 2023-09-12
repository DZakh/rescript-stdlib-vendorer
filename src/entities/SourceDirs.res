type t = array<string>

let getProjectDirs = projectDirs => projectDirs

let struct = S.object(s => s.field("dirs", S.array(S.string)))

let fromJsonString = jsonString =>
  jsonString->S.parseJsonStringWith(struct)->Result.mapError(S.Error.message)

module TestData = {
  let make = (~projectDirs) => projectDirs
}
