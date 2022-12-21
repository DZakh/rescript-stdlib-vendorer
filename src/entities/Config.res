type t = {projectPath: string}

let make = (~projectPath) => {
  projectPath: projectPath,
}

let getProjectPath = config => config.projectPath
