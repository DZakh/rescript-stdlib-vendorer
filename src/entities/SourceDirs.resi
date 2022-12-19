type t

let getProjectDirs: t => array<string>

let fromJsonString: string => result<t, string>

module TestData: {
  let make: (~projectDirs: array<string>) => t
}
