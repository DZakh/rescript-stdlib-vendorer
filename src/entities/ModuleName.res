open Stdlib

include Opaque.String

let defaultStdlibModuleName = "Stdlib"
let defaultProhibitedModuleNames = ["Belt", "Js", "ReScriptJs"]

let fromPath = path => {
  let pathWithoutResExtension = path->String.replaceByRe(%re("/\.resi?$/"), "")
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
