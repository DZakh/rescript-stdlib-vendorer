include Opaque.String

let defaultStdlibModuleName = "Stdlib"
let defaultProhibitedModuleNames = ["Belt", "Js", "ReScriptJs"]

let fromBscFlag = bscFlag => {
  switch bscFlag->String.includes("-open") {
  | true =>
    bscFlag->String.replace("-open", "")->String.trim->String.split(".")->Array.getUnsafe(0)->Some
  | false => None
  }
}

let fromPath = path => {
  let pathWithoutResExtension = path->String.replaceRegExp(%re("/\.resi?$/"), "")
  if path->String.length === pathWithoutResExtension->String.length {
    None
  } else {
    Some(
      pathWithoutResExtension
      ->String.split("/")
      ->Array.last
      ->Option.getExnWithMessage(
        "After splitting path by slashes there should always be at least one item.",
      ),
    )
  }
}

let isSubmodule = (moduleName, ~ofModule) => {
  moduleName->String.startsWith(`${ofModule}_`)
}

module TestData = {
  let make = moduleName => moduleName
}
