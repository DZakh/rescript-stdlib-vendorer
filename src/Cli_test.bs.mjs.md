# Snapshot report for `src/Cli_test.bs.mjs`

The actual snapshot is saved in `Cli_test.bs.mjs.snap`.

Generated by [AVA](https://avajs.dev).

## Shows help when command is not specified

> Snapshot 1

    `Usage: cli [command] [options]␊
    ␊
    Commands:␊
      help - Display this message␊
      help <command> - Show more information about a command␊
      lint - Lint that you use your vendored ReScript standard library over Js, Belt, etc␊
    ␊
    You can find more information about the reasoning behind the tool in the documentation: https://github.com/DZakh/rescript-stdlib-vendorer␊
    `

## Shows help when help command provided

> Snapshot 1

    `Usage: cli [command] [options]␊
    ␊
    Commands:␊
      help - Display this message␊
      help <command> - Show more information about a command␊
      lint - Lint that you use your vendored ReScript standard library over Js, Belt, etc␊
    ␊
    You can find more information about the reasoning behind the tool in the documentation: https://github.com/DZakh/rescript-stdlib-vendorer␊
    `

## Shows error message when unknown command provided

> Snapshot 1

    'Command not found: foo'

## Shows error message when unknown option provided

> Snapshot 1

    'Illegal option: foo'

## Shows help lint

> Snapshot 1

    `␊
    Lint that you use your vendored ReScript standard library over Js, Belt, etc.␊
    ␊
    Options:␊
     --project-path String - Path to the project directory. It should point to where bsconfig.json is located (defaults to the current directory).␊
     --ignore-without-stdlib-open - Whether linter should ignore files that don't have globally opened vendored stdlib. Convenient for gradual adoption.␊
     --ignore-path [String] - Paths of files to ignore.␊
    `
