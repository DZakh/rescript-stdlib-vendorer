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

I will not create intrigue and say that the solution is to group everything together in one module and enforce the usage of this sole module across the codebase.

Having a dedicated module, we will be able to reuse whatever module is for our liking `Js` / `Belt` / `RescriptJs`, and extend it with project-specific helper functions. The part with enforcing is even more crucial because if we don’t have it automated, people will continue using all different modules instead of the only one `PerfectStdLib.res` we’ve just created.

To achieve these two parts as effortlessly as possible, I’ve created a cli with two commands: `init` and `lint`.

> At the time of writing the article, the cli exists only in my head, but I write as if it exists in real life to get your feedback.

Open your ReScript project and run:

```bash
npx rescript-stdlib-cli init
```

It will do the following things:

1. Create a `Stdlib.res` module containing following code:

```reason
include RescriptJs.Js
module Option = Belt.Option
module Result = Belt.Result
```

1. Add `rescript-js` to `dependencies` and `bs-dependencies`
2. Add an npm script `"lint-rescript-stdlib": "rescript-stdlib-cli lint"`

> If you don’t like rescript-js or some other defaults, you can configure everything with your own hands and only use the lint script.

As of `rescript-stdlib-cli lint`, it’ll try to find the usage of `Js`, `Belt`, or `RescriptJs` in the project and report an error if there is some.

## ReScriptJs as default

The [ReScriptJs](https://github.com/bloodyowl/rescript-js) is a little bit controversial, in my opinion. The usage of userland standard libraries is not supported by the core team.

> **From the website**: we do not recommend other userland standard library alternatives (unless it’s DOM bindings). These cause confusion and split points for the community.

At the same time, you can hear from some members that `ReScriptJs` is considered a future replacement for `Js` module.

Personally, I find it a good choice in the `Belt` vs `Js` argument because it has taken the safety-first approach from `Belt` and keeps familiar JavaScript APIs like `Js`. Another advantage is that it ships as an npm module with the ability to version.

There’s still a big area for improvement, such as missing tests. But contributions are accepted, and the API is stable with a minimum risk of breaking changes.

## Migration guide

Here I’ll write how to use code modes to migrate an existing codebase to be able to use `rescript-stdlib-cli lint`.
