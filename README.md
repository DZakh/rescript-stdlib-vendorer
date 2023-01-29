[![CI](https://github.com/DZakh/rescript-stdlib-vendorer/actions/workflows/ci.yml/badge.svg)](https://github.com/DZakh/rescript-stdlib-vendorer/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/DZakh/rescript-stdlib-vendorer/branch/main/graph/badge.svg?token=40G6YKKD6J)](https://codecov.io/gh/DZakh/rescript-stdlib-vendorer)
[![npm](https://img.shields.io/npm/dm/rescript-stdlib-vendorer)](https://www.npmjs.com/package/rescript-stdlib-vendorer)

# The ultimate answer to Belt vs Js in ReScript

Probably every developer that comes to [ReScript](https://rescript-lang.org) stumbles upon a dilemma about which module from the standard library they should use to work with JavaScript API.

- Should I take the [Js](https://rescript-lang.org/docs/manual/latest/api/js) module with a familiar design for JavaScript developers and runtime-free bindings? 🧐
- Or should I take the more powerful [Belt](https://rescript-lang.org/docs/manual/latest/api/belt)? 🤔
- Wait, I heard something about [rescript-js](https://github.com/bloodyowl/rescript-js)! Maybe that’s what I need? 😅

Those are pretty familiar thoughts, right? I’ve seen a lot of discussions about which one you should use, but there were never solid answers, and the result was either “it depends” or “I personally like one over another because of X”.

My lovely [Carla](https://www.carla.se/) colleague [Daggala](https://twitter.com/daggala) has written a very detailed [article](https://www.daggala.com/belt_vs_js_array_in_rescript/) about the problem, so I won’t repeat her and continue.

## Problem 2: Multiple sources of truth

No matter what we choose, sometimes we still need to use another module. It’s because some functions which exist in `Js` don’t exist in `Belt` and vise-versa.

![Multiple sources of truth](./assets/multiple-sources-of-truth.png)

But it might happen that a function doesn’t exist in both of the modules, eg infamous [padStart](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart). At [Carla](https://www.carla.se/), we used to solve the problem by creating a lot of `StringExtra`, `OptionExtra`, and `WhateverExtra` modules to add missing helper functions.

This leads to another problem when developers don’t know where they can find the desired helper:

- Will it be in `Belt` that we agreed to use as default, or the helper doesn’t exist there, and I should use `Js` instead, or maybe `StringExtra`?

A few times, we even end up using `Pervasives` by mistake.

## Problem 3: Creating guidelines

Depending on the project, we may have rules for the team to follow. For example, `Belt.Option.getExn` raises a ReScript exception which is very difficult to trace, so at [Carla](https://www.carla.se/) we decided to use our own `OptionExtra.getExnWithMessage` instead. Although there's an agreement, it's very easy to forget about and continue using `Belt.Option.getExn`. We want a way to prevent the usage of `Belt.Option.getExn` whatsoever.

## Solution

I will not create intrigue and say that the solution I suggest is to create your own vendored standard library and enforce its usage across the codebase. You can reuse existing modules like `Js`, `Belt`, or `RescriptJs`, and adjust them for our needs.

The enforcing is the most crucial part here because if we don't automate it with CI, our colleagues and even ourselves will continue using all different modules instead of the single vendored one.

And to solve the problem, I've created [rescript-stdlib-vendorer](https://github.com/DZakh/rescript-stdlib-vendorer), an easy-to-use linter to support the usage of a vendored standard library.

### Linter

The linter does a straightforward thing - It checks all project files and detects the usage of `Js`, `Belt`, and `ReScriptJs` modules. So you can easily find and replace them with your `Stdlib`.

To start using the linter in your project, install it as a dev dependency:

```sh
npm install -D rescript-stdlib-vendorer
```

Let's also add an npm run script for convenience and immediately use it:

```sh
npm pkg set scripts.lint:stdlib="rescript-stdlib-vendorer lint"
npm run lint:stdlib
```

So if we have a project created from the [official template repository](https://github.com/rescript-lang/rescript-project-template), which has a single ReScript file with `Js.log("Hello, World!")`, we’ll get the following error:

```
~/rescript-project-template/src/Demo.res:1
  Found "Js" module usage.

Use the vendored standard library instead. Read more at: https://github.com/DZakh/rescript-stdlib-vendorer
```

To fix it, let’s create a directory `stdlib` and add the first vendored module:

```sh
cd src
mkdir stdlib
cd stdlib
echo 'include Js.Console' >> Console.res
```

We can now update the `Demo.res` by replacing `Js.log` with `Console.log`.

Let’s run the linter again and see that there’s no error:

```sh
npm run lint:stdlib
```

In the following way, you can create reexports for other modules and adjust them to make them better suit you.

For example, for the `Array` module, you can redefine some functions with `Belt`’s implementation to make the code safer:

```rescript
// src/stdlib/Array.res
include Js.Array
let get = Belt.Array.get
```

This way, the usage of square brackets to get an array item will return `option`, which’s more correct:

```rescript
let array = [1, 2, 3]
let item = array[3]
// The item will have the option<int> type instead of the default int one
Console.log(item)
```

Returning to the `Belt.Option.getExn`, mentioned in the third problem, instead of reexporting all functions from `Js`/`Belt`, we can explicitly reexport only the functions we need and replace the ones we consider harmful:

```rescript
// src/stdlib/Option.res
let forEach = Belt.Option.forEach
let mapWithDefault = Belt.Option.mapWithDefault
let map = Belt.Option.map
let flatMap = Belt.Option.flatMap
let isSome = Belt.Option.isSome
let isNone = Belt.Option.isNone

let getExnWithMessage = (x, message) =>
  switch x {
  | Some(x) => x
  | None => Js.Exn.raiseError(message)
  }
```

## Reusing the vendored stdlib

I’ve shown how to start vendoring stdlib in a short way. But having multiple projects following the same guidelines, you’d soon want to start reusing the vendored stdlib. It’s very easy to do by moving the code from the `stdlib` directory featured above to a separate package.

For my personal projects, I copied [Gabriel](https://twitter.com/___zth___)'s repository with a proposal for a new ReScript stdlib, which did not burn out. Afterward, I modified it to suit my taste better and published it to npm, making it easy to use.

> I recommend taking a look at it as a reference [@dzakh/rescript-stdlib](https://github.com/DZakh/rescript-stdlib), but I don’t bring it to your own projects. You'll lose a very good part of vendoring - full control over the code.

At [Carla](https://www.carla.se/), we had a different situation. Having a huge codebase with `Js`, `Belt`, and `WhateverExtra` all over the place, it would be too much work to take some existing customized stdlibs like [rescript-js](https://github.com/bloodyowl/rescript-js) or [@dzakh/rescript-stdlib](https://github.com/DZakh/rescript-stdlib) and update old code with them.

> First of all, since at [Carla](https://www.carla.se/) we have different guidelines compared to my personal projects, it would be a bad idea to use [@dzakh/rescript-stdlib](https://github.com/DZakh/rescript-stdlib) from the get-go. As I said before, it'd lose the whole point of vendoring.

So, to migrate the whole codebase, we’ve started with creating a small stdlib package in our pnpm mono repository that simply reexported functions from `Belt` or `Js`. And started updating file by file, replacing `open Belt` with `open Stdlib` and `Js.Array2` with `Array`, etc.

Also, you can use a tool like [Comby](https://comby.dev/) to transform the whole codebase in one go.

> Before you start the migration to the vendored stdlib, I highly recommend replacing `Js.String` and `Pervasives.String` with `Js.String2`. Since some of the functions have the same API, but different logic, there’s a chance of missing one of them and getting a runtime error.

But we didn’t rush with the migration, and to avoid regressions of the process, we ran the linter script in CI with the `--ignore-without-stdlib-open` flag to skip files not containing `open Stdlib`.

After every file was updated, we removed `open Stdlib` from the beginning of the files and opened it globally via `bsconfig.json`. When it was done, we could finally start gradually adjusting the `Stdlib` to make the process of writing ReScript code more convenient and reliable.

If you have any questions feel free to ping me on [Twitter](https://twitter.com/dzakh_dev).
