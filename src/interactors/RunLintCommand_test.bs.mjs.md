# Snapshot report for `src/interactors/RunLintCommand_test.bs.mjs`

The actual snapshot is saved in `RunLintCommand_test.bs.mjs.snap`.

Generated by [AVA](https://avajs.dev).

## Handles BsConfigParseFailure error

> Snapshot 1

    [
      'Failed to parse "bsconfig.json": Something went wrong',
    ]

## Handles RescriptCompilerArtifactsNotFound error

> Snapshot 1

    [
      'Couldn\'t find rescript compiler artifacts in the "./lib/bs/" directory. Try to run compiler before the lint script.',
    ]

## Handles SourceDirsParseFailure error

> Snapshot 1

    [
      'Failed to parse ".sourcedirs.json". Check that you use compatible ReScript version. Parsing error: Something went wrong',
    ]

## Handles BsConfigHasOpenedProhibitedModule error

> Snapshot 1

    [
      'Lint failed: Found globally opened module Js',
    ]

## Handles LintFailedWithIssues error

> Snapshot 1

    [
      `[4m/path/LintIssue_test.res:5[24m␊
      Found "Js" module include.␊
      ␊
      [4m/path/LintIssue_test.res[24m␊
      The "stdlib" is an invalid directory name for custom standary library related files. Put the files to the directory with the name "stdlib" to make it easier to find them.␊
      ␊
      [1mUse custom standard library. Read more in the documentation: [4mhttps://github.com/DZakh/rescript-stdlib-vendorer[24m[22m`,
    ]