" Lua as GD++ macros see it: lua.vim, for Lua 5.1 like GD++'s, with GD++'s
" comments, the gd and ctx tables, and the templates and macros that a
" macro's body may declare.
"
" syntax/gdpp.vim loads this file with :syntax include, like gdpp/cpp.vim, so
" lua.vim's TOP contains the groups here too. Don't load it any other way.

" lua.vim reads its version from global variables. Set them for this file only.
let s:saved = {}
for s:name in ['lua_version', 'lua_subversion']
  if exists('g:' . s:name)
    let s:saved[s:name] = g:{s:name}
  endif
endfor
let g:lua_version = 5
let g:lua_subversion = 1
runtime! syntax/lua.vim
unlet! b:current_syntax g:lua_version g:lua_subversion
for [s:name, s:value] in items(s:saved)
  let g:{s:name} = s:value
endfor
unlet! s:saved s:name s:value

" GD++ removes its own comments from a macro's body, so they work in Lua too. Block comments nest.
syntax match gdppLuaLineComment "//.*$" contains=luaTodo,@Spell
syntax region gdppLuaComment start="/\*" end="\*/" contains=gdppLuaComment,luaTodo,@Spell extend

" What macros see besides their parameters: gd's functions, and ctx.
syntax keyword gdppLuaGlobal gd ctx
syntax match gdppLuaApi "\%(\<gd\.\)\@3<=\h\w*"

" Templates and macros declared in a macro's body, e.g. template slot(name) { ... }.
syntax match gdppLuaTemplate "\<template\>\ze\s\+\h\w*\s*(" nextgroup=gdppTemplateName skipwhite
syntax match gdppLuaMacro "\<macro\>\ze\s\+\h\w*\s*(" nextgroup=gdppMacroName skipwhite
