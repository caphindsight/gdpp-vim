# GD++ syntax highlighting for Vim

GD++ is a DSL and a meta-object compiler for quick development of performant code for the Godot engine.
Read more about the GD++ language [here](https://github.com/caphindsight/gdpp).

## Installation

With [pathogen](https://github.com/tpope/vim-pathogen):

```
$ cd ~/.vim/bundle
$ git clone https://github.com/caphindsight/gdpp-vim
```

Or with Vim's own packages:

```
$ git clone https://github.com/caphindsight/gdpp-vim ~/.vim/pack/plugins/start/gdpp-vim
```

That's it. You can now edit GD++ files (`.gd++`, `.gdpp` and `.gg`), i.e.

```
$ vim my_godot_node.gd++
```

## What it highlights

- Declarations, like GD++ itself reads them: `func`, `var`, `signal`, `enum` and the rest are keywords only in declarations, so `node->set("x", 1)` in C++ code stays plain.
  Function, signal and variable names, types, enum values, annotations and node paths (`$Hud/Score`, `%Health`) have their own colors.
- C++ code, with Vim's C++ highlighting: function bodies, initial and default values, `ctor`, `dtor`, `get`, `set`, `decl` and `impl` blocks,
  and `on` blocks: `on ready { ... }`, `on process(delta: float) { ... }`, `on(what: int) { ... }` and the like. `on` is a keyword only where it starts a block, so `var on` stays a name.
  Godot's notifications after it, e.g. `ready` and `predelete`, are keywords too, and other names, e.g. a class's own notifications, are constants.
- GD++'s rewrites, where GD++ rewrites them: `emit`, `rpc`, `is_cancelled`, `string_name "..."`, `is_done`, `claim`, `cancel`, `create`, `destroy`, `queue_destroy`, `as` and `assert`.
  So `rpc("ping")`, `task.is_done()`, `Image::create(1, 1)`, a variable named `claim` and `assert = 1;` stay plain.
  C++'s `new` and `delete`, and godot-cpp's `memnew` and `memdelete`, stay plain too, so that `create` and `destroy` stand out.
- Templates and macros (`gd++ man templates` and `gd++ man macros`): `template`, `template_name`, `macro` and `macro_name`, and their invocations, `invoke name(...)` and `invoke name { ... }`.
  A macro's body is Lua, with Vim's Lua highlighting, GD++'s comments, and `gd` and `ctx`. So are parameters' defaults and the Lua tables of invocations.
  A template's body is GD++, with its `${...}` holes highlighted as Lua, also inside names, e.g. `class ${T}Pool`, and in C++ code.
  In C++ code, `invoke` is a keyword only where a name and `(` or `{` follow, so `std::invoke(f)` stays plain. In C++ blocks, invocations end with `;`, e.g. `invoke log("hit");`.
- Comments, which nest like in GD++: `/* a /* b */ still a comment */`. Doc comments (`///` and `/** */`) stand out in declarations.
- Godot's types. Refcounted classes (`Resource`, `Mesh`, ...) get a color of their own, apart from other classes (`Node`, `Object`, ...),
  since GD++ uses them differently. Other names in PascalCase, e.g. your own classes, are types too.

The colors of Godot's classes are defaults, for dark and light backgrounds. To pick your own, set the groups `godotRefClass`, `godotObjClass`
and `godotNodeClass` (which links to `godotObjClass`) in your vimrc, e.g.:

```vim
autocmd ColorScheme * highlight godotRefClass ctermfg=110 guifg=#87AFD7
```

## Updating Godot's classes and notifications

`gdpp/godot.vim` lists Godot's types, and `gdpp/notifications.vim` its notifications. To regenerate them from your Godot version, e.g. when a new one comes out, with `godot` on your `PATH`:

```
$ make gen
```
