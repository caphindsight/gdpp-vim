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
- C++ code, with Vim's C++ highlighting: function bodies, initial and default values, `ctor`, `dtor`, `notif`, `get`, `set`, `decl` and `impl` blocks,
  and engine blocks: `ready`, `enter_tree`, `exit_tree`, `process(delta)`, `physics_process(delta)` and `draw`. Their words are keywords only where they start a block, so `var ready` stays a name.
- GD++'s rewrites, where GD++ rewrites them: `emit`, `rpc`, `is_cancelled`, `string_name "..."`, `is_done`, `claim`, `cancel`, `create`, `destroy`, `queue_destroy`, `as` and `assert`.
  So `rpc("ping")`, `task.is_done()`, `Image::create(1, 1)`, a variable named `claim` and `assert = 1;` stay plain.
  C++'s `new` and `delete`, and godot-cpp's `memnew` and `memdelete`, stay plain too, so that `create` and `destroy` stand out.
- Comments, which nest like in GD++: `/* a /* b */ still a comment */`. Doc comments (`///` and `/** */`) stand out in declarations.
- Godot's types. Refcounted classes (`Resource`, `Mesh`, ...) get a color of their own, apart from other classes (`Node`, `Object`, ...),
  since GD++ uses them differently. Other names in PascalCase, e.g. your own classes, are types too.

The colors of Godot's classes are defaults, for dark and light backgrounds. To pick your own, set the groups `godotRefClass`, `godotObjClass`
and `godotNodeClass` (which links to `godotObjClass`) in your vimrc, e.g.:

```vim
autocmd ColorScheme * highlight godotRefClass ctermfg=110 guifg=#87AFD7
```

## Updating Godot's classes

`gdpp/godot.vim` lists Godot's types. To regenerate it from your Godot version, with `godot` on your `PATH`:

```
$ make gen
```
