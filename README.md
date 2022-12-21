[![CI](https://github.com/DZakh/rescript-stdlib-vendorer/actions/workflows/ci.yml/badge.svg)](https://github.com/DZakh/rescript-stdlib-vendorer/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/DZakh/rescript-stdlib-vendorer/branch/main/graph/badge.svg?token=40G6YKKD6J)](https://codecov.io/gh/DZakh/rescript-stdlib-vendorer)
[![npm](https://img.shields.io/npm/dm/rescript-stdlib-vendorer)](https://www.npmjs.com/package/rescript-stdlib-vendorer)

# The ultimate answer to Belt vs Js in ReScript

Probably every developer that comes to [ReScript](https://rescript-lang.org/) stumbles upon a dilemma about which module from the standard library they should use to work with JavaScript API.

- Should I take the [Js](https://rescript-lang.org/docs/manual/latest/api/js) module with a familiar design for JavaScript developers and runtime-free bindings? 🧐
- Or should I take the more powerful [Belt](https://rescript-lang.org/docs/manual/latest/api/belt)? 🤔
- Wait, I heard something about [rescript-js](https://github.com/bloodyowl/rescript-js)! Maybe it’s what I need? 😅

Those are pretty familiar thoughts, right? I’ve seen a lot of discussions about which one you should use, but there were never solid answers, and the result was either “it depends” or “I personally like one over another because of X”.

My lovely [Carla](https://www.carla.se/) colleague [Daggala](https://twitter.com/daggala) has written a very detailed [article](https://www.daggala.com/belt_vs_js_array_in_rescript/) about the problem, so I won’t repeat her and continue.

## Problem 2: Multiple sources of truth

No matter what we choose, sometimes we still need to use another module. It’s because some functions which exist in `Js` don’t exist in `Belt` and vise-versa.

![Multiple sources of truth](./assets/multiple-sources-of-truth.png)

But it might happen that a function doesn’t exist in both of the modules, eg infamous [padStart](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart). At [Carla](https://www.carla.se/), we used to solve the problem by creating a lot of `StringExtra`, `OptionExtra`, and `WhateverExtra` modules to add missing helper functions.

This leads to another problem when developers don’t know where they can find the desired helper:

- Will it be in `Belt` that we agreed to use as default, or the helper doesn’t exist there, and I should use `Js` instead, or maybe `StringExtra`?

A few times, we even end up using `Pervasives` by mistake.

## Solution

I will not create intrigue and say that the solution is to group everything in a vendored standard library and enforce its usage across the codebase. Opening an opportunity to reuse any existing module like `Js`, `Belt`, or `RescriptJs`; and extend them for project-specific needs.

The enforcing part is even more crucial because if we don't have it automated, developers will continue using all different modules instead of the single `Stdlib.res` we vendored.

I've created a CLI that anyone can easily use to achieve these two parts. For now, it only has the `lint` command, but I'm going to add `init` and `migrate` for easier adoption.

### Create vendored standard library

TBD. You can use the CLI library repository as a reference.

### Linting

The linting script I've mentioned above does a straightforward thing - It checks all project files and detects the usage of prohibited modules.

By default, prohibited modules are `Js`, `Belt`, and `ReScriptJs`. In future versions, the linter will also complain on private modules like `Js_Dict`, including the ones prefixed with `Stdlib_`.

Opening a prohibited module with a `bs-flag` will also cause an error.

To start using the linter in your project, install `rescript-stdlib-vendorer` as a dev dependency. Let's also add an npm run script for convenience.

```
npm install -D rescript-stdlib-vendorer
npm pkg set scripts.lint:stdlib="rescript-stdlib-vendorer lint"
```

As a result, we should get a `package.json` like this:

```diff
{
  "name": "your-awesome-project",
  "scripts": {
+   "lint:stdlib": "rescript-stdlib-vendorer lint"
  },
  "dependencies": {
    "stdlib": "file:stdlib"
  },
  "devDependencies": {
+   "rescript-stdlib-vendorer": "*"
  }
}
```

The only thing is left to run:

```
npm run lint:stdlib
```

## Migration guide

TBD. Here I'll describe how to migrate a big codebase to the desired solution painlessly.
