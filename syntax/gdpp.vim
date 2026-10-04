" Vim syntax file
" Language: GD++ (https://github.com/caphindsight/gdpp)
" Filenames: *.gd++, *.gdpp, *.gg
"
" GD++ has a declaration scope, whose syntax looks like GDScript, and C++ code
" in braces: function bodies, initial values, decl and impl blocks and so on.
" Macros hold Lua code, and templates GD++ code with ${...} holes.
" This file highlights the declarations itself, gdpp/cpp.vim the C++ code, and
" gdpp/lua.vim the Lua code.

if exists("b:current_syntax")
  finish
endif

" C++ code, with GD++'s rewrites and Godot's types: the cluster @gdppCpp.
execute 'syntax include @gdppCpp ' . fnameescape(expand('<sfile>:p:h:h') . '/gdpp/cpp.vim')
unlet! b:current_syntax
" Lua code, for macros: the cluster @gdppLua.
execute 'syntax include @gdppLua ' . fnameescape(expand('<sfile>:p:h:h') . '/gdpp/lua.vim')
unlet! b:current_syntax
" lua.vim flags a stray ")", "}" or "end" as an error. Included, it also flags the parentheses of an if's
" condition, and the "}" that ends a macro's body, so leave them out. (:syntax clear doesn't work during the include.)
syntax clear luaParenError luaError
syntax sync clear

" A name, which in a template may have holes, e.g. ${T}Pool.
let s:name = '\%(\h\|\${[^}]*}\)\%(\w\|\${[^}]*}\)*'
" A type: a name, with type arguments in brackets, e.g. Dictionary[String, Array[int]].
let s:type = s:name . '\%(\_s*\[\%(\_[^][]\|\[\%(\_[^][]\|\[\_[^][]*\]\)*\]\)*\]\)\='
syntax cluster gdppTypes contains=godotBuiltinType,godotObjClass,godotRefClass,godotNodeClass,gdppRuntimeType,gdppUserType,cType,cppType

" Comments. Block comments nest, and /// and /** are doc comments, but //// and /*** aren't.
syntax keyword gdppTodo contained TODO FIXME XXX NOTE
syntax match gdppCommentError "\*/"
syntax match gdppLineComment "//.*$" contains=gdppTodo,@Spell
syntax region gdppComment matchgroup=gdppComment start="/\*" end="\*/" contains=gdppComment,gdppTodo,@Spell fold extend
syntax match gdppDocLine "///\%(/\)\@!.*$" contains=gdppTodo,@Spell
syntax region gdppDocBlock matchgroup=gdppDocBlock start="/\*\*\%([*/]\)\@!" end="\*/" contains=gdppDocBlockNest,gdppTodo,@Spell fold extend
syntax region gdppDocBlockNest matchgroup=gdppDocBlockNest start="/\*" end="\*/" contained contains=gdppDocBlockNest,gdppTodo,@Spell extend
syntax cluster gdppComments contains=gdppCommentError,gdppLineComment,gdppComment

" Literals, in annotation arguments.
syntax region gdppString start=+\%(u8\|[uUL]\)\="+ skip=+\\\\\|\\"+ end=+"+ end=+$+ oneline contains=cSpecial
syntax match gdppChar +\%(u8\|[uUL]\)\='\%(\\.\|[^'\\]\)*'+ contains=cSpecial
syntax match gdppNumber "\%(\<\|\.\)\d\%([eEpP][+-]\|'\w\|[0-9A-Za-z_.]\)*"

" Annotations, e.g. @export_range(0, 100, "or_greater").
syntax match gdppAnnotation "@\h\w*" nextgroup=gdppAnnotationArgs
syntax region gdppAnnotationArgs start="(" end=")" contained contains=gdppString,gdppChar,gdppNumber,gdppHole,@gdppComments

" C++ code: a block in braces, or a value after "=", which runs to the end of
" the line (or a comment there), or to a "," or ")" in parameters, while no
" bracket is open.
syntax region gdppCppBlock matchgroup=gdppBrace start="{" end="}" contains=@gdppCpp fold
syntax region gdppValue matchgroup=gdppOperator start="=" end="\ze\s*\%(//.*\|/\*.*\)\=$" end="\ze[,)]" contains=gdppNodePath,gdppValueMacro,@gdppCpp
syntax match gdppNodePath +\%(=\s*\)\@<=[$%]\%(\s*\%(\h\w*\|"\%(\\.\|[^"\\]\)*"\|'\%(\\.\|[^'\\]\)*'\|%\|/[/*]\@!\)\)*+ contained

" A macro block as a value, e.g. var cells: int = macro { ... }. In C++ blocks, gdpp/cpp.vim matches it.
syntax match gdppValueMacro "\%(=\s*\)\@<=\<macro\>\ze\_s*{" contained nextgroup=gdppMacroBody skipwhite skipempty

" Types, after ":", "->", extends, import and noimport.
execute 'syntax match gdppTypeHint ":\_s*' . s:type . '" contained contains=@gdppTypes,gdppHole nextgroup=gdppPropBody skipwhite skipempty'
execute 'syntax match gdppReturnType "->\_s*' . s:type . '" contained contains=@gdppTypes,gdppHole nextgroup=gdppCppBlock skipwhite skipempty'
execute 'syntax match gdppTypeRef "' . s:type . '\%(\.\h\w*\)\=" contained contains=@gdppTypes,gdppHole'

" Classes and externs.
syntax keyword gdppKeyword class_name extern_name enum_name nextgroup=gdppDefName skipwhite skipempty
syntax keyword gdppKeyword class extern nextgroup=gdppClassName skipwhite skipempty
syntax keyword gdppExtends extends nextgroup=gdppTypeRef skipwhite skipempty
syntax keyword gdppImport import noimport nextgroup=gdppTypeRef skipwhite skipempty
execute 'syntax match gdppDefName "' . s:name . '" contained contains=gdppHole'
execute 'syntax match gdppClassName "' . s:name . '" contained contains=gdppHole nextgroup=gdppClassBody skipwhite skipempty'
syntax region gdppClassBody matchgroup=gdppBrace start="{" end="}" contained contains=@gdppDecl fold

" Functions and signals.
syntax keyword gdppKeyword func nextgroup=gdppFuncName skipwhite skipempty
syntax keyword gdppKeyword signal nextgroup=gdppSignalName skipwhite skipempty
execute 'syntax match gdppFuncName "' . s:name . '" contained contains=gdppHole nextgroup=gdppParams skipwhite skipempty'
execute 'syntax match gdppSignalName "' . s:name . '" contained contains=gdppHole nextgroup=gdppParams skipwhite skipempty'
syntax region gdppParams matchgroup=gdppParen start="(" end=")" contained contains=gdppTypeHint,gdppValue,gdppHole,@gdppComments nextgroup=gdppReturnType,gdppCppBlock skipwhite skipempty

" Variables and properties.
syntax keyword gdppKeyword var nextgroup=gdppVarName skipwhite skipempty
execute 'syntax match gdppVarName "' . s:name . '" contained contains=gdppHole nextgroup=gdppTypeHint,gdppPropBody skipwhite skipempty'
syntax region gdppPropBody matchgroup=gdppBrace start="{" end="}" contained contains=gdppAccessor,gdppCode,gdppAnnotation,@gdppComments fold
syntax keyword gdppAccessor get contained nextgroup=gdppCppBlock skipwhite skipempty
syntax keyword gdppAccessor set contained nextgroup=gdppSetParams skipwhite skipempty
syntax region gdppSetParams matchgroup=gdppParen start="(" end=")" contained contains=gdppTypeHint,@gdppComments nextgroup=gdppCppBlock skipwhite skipempty

" Enums and constants.
syntax keyword gdppKeyword enum nextgroup=gdppEnumName,gdppConstName skipwhite skipempty
execute 'syntax match gdppEnumName "' . s:name . '" contained contains=gdppHole nextgroup=gdppEnumBody skipwhite skipempty'
execute 'syntax match gdppConstName "' . s:name . '\ze\_s*=" contained contains=gdppHole'
syntax region gdppEnumBody matchgroup=gdppBrace start="{" end="}" contained contains=gdppEnumValue,gdppExtends,gdppValue,gdppAnnotation,gdppDocLine,gdppDocBlock,@gdppComments fold
execute 'syntax match gdppEnumValue "' . s:name . '" contained contains=gdppHole'

" Lifecycle, and C++ blocks.
syntax keyword gdppKeyword ctor dtor nextgroup=gdppCppBlock skipwhite skipempty
" on blocks, e.g. on ready { ... }, on process(delta: float) { ... } and on(what: int) { ... }. "on" is a name
" elsewhere, e.g. in "var on", so it's a keyword only where it starts a block. Godot's notifications, from
" gdpp/notifications.vim, are keywords after it; other names, e.g. a class's own notifications, are constants.
syntax match gdppOn "\<on\>\ze\%(\_s\+\h\w*\)\=\_s*[({]" nextgroup=gdppNotification,gdppOnName,gdppOnArgs,gdppCppBlock skipwhite skipempty
syntax match gdppOnName "\h\w*" contained nextgroup=gdppOnArgs,gdppCppBlock skipwhite skipempty
syntax region gdppOnArgs matchgroup=gdppParen start="(" end=")" contained contains=gdppOnParam,gdppTypeHint,@gdppComments nextgroup=gdppCppBlock skipwhite skipempty
syntax match gdppOnParam "\h\w*" contained
execute 'source ' . fnameescape(expand('<sfile>:p:h:h') . '/gdpp/notifications.vim')
syntax keyword gdppCode decl nextgroup=gdppCode,gdppCppBlock skipwhite skipempty
syntax keyword gdppCode impl nextgroup=gdppCppBlock skipwhite skipempty

" Macros (Lua) and templates (GD++ with holes): inline, or with macro_name or template_name for the rest of the
" file. A parameter's default is Lua. A macro block, macro { ... }, is a macro without a name or parameters.
syntax match gdppMacroKeyword "\<macro\>\ze\s\+\h\w*\s*(" nextgroup=gdppMacroName skipwhite
syntax match gdppMacroKeyword "\<template\>\ze\s\+\h\w*\s*(" nextgroup=gdppTemplateName skipwhite
syntax match gdppMacroKeyword "\<macro\>\ze\_s*{" nextgroup=gdppMacroBody skipwhite skipempty
syntax keyword gdppMacroKeyword macro_name nextgroup=gdppMacroFileName skipwhite skipempty
syntax keyword gdppMacroKeyword template_name nextgroup=gdppTemplateFileName skipwhite skipempty
syntax match gdppMacroName "\h\w*" contained nextgroup=gdppMacroParams skipwhite
syntax match gdppTemplateName "\h\w*" contained nextgroup=gdppTemplateParams skipwhite
syntax match gdppMacroFileName "\h\w*" contained nextgroup=gdppMacroFileParams skipwhite
syntax match gdppTemplateFileName "\h\w*" contained nextgroup=gdppTemplateFileParams skipwhite
syntax cluster gdppMacroParam contains=gdppMacroParam,gdppMacroDefault,@gdppComments
syntax region gdppMacroParams matchgroup=gdppParen start="(" end=")" contained contains=@gdppMacroParam nextgroup=gdppMacroBody skipwhite skipempty
syntax region gdppTemplateParams matchgroup=gdppParen start="(" end=")" contained contains=@gdppMacroParam nextgroup=gdppTemplateBody skipwhite skipempty
syntax region gdppMacroFileParams matchgroup=gdppParen start="(" end=")" contained contains=@gdppMacroParam nextgroup=gdppMacroFile skipwhite skipempty
syntax region gdppTemplateFileParams matchgroup=gdppParen start="(" end=")" contained contains=@gdppMacroParam nextgroup=gdppTemplateFile skipwhite skipempty
syntax match gdppMacroParam "\h\w*" contained
syntax region gdppMacroDefault matchgroup=gdppOperator start="=" end="\ze[,)]" contained contains=@gdppLua
syntax region gdppMacroBody matchgroup=gdppBrace start="{" end="}" contained contains=@gdppLua fold
syntax region gdppTemplateBody matchgroup=gdppBrace start="{" end="}" contained contains=@gdppDecl fold
syntax region gdppMacroFile start="\S" end="\%$" contained contains=@gdppLua
syntax region gdppTemplateFile start="\S" end="\%$" contained contains=@gdppDecl

" Invocations of macros and templates: invoke NAME(args), or invoke NAME { a Lua table }. In C++ code, gdpp/cpp.vim
" matches "invoke". An argument is a value, or NAME = value, and a value may be a list, a dictionary or code { ... }.
syntax match gdppInvoke "\<invoke\>\ze\s\+\h\w*\s*[({]" nextgroup=gdppInvokeName skipwhite
syntax match gdppInvokeName "\h\w*" contained nextgroup=gdppInvokeArgs,gdppInvokeTable skipwhite skipempty
syntax cluster gdppArgs contains=gdppArgName,gdppArgConstant,gdppArgCode,gdppArgList,gdppArgDict,gdppString,gdppChar,gdppNumber,gdppHole,@gdppComments
syntax region gdppInvokeArgs matchgroup=gdppParen start="(" end=")" contained contains=@gdppArgs
syntax region gdppInvokeTable matchgroup=gdppBrace start="{" end="}" contained contains=@gdppLua
syntax region gdppArgList matchgroup=gdppParen start="\[" end="]" contained contains=@gdppArgs
syntax region gdppArgDict matchgroup=gdppBrace start="{" end="}" contained contains=@gdppArgs
syntax match gdppArgName "\h\w*\ze\s*=\%(=\)\@!" contained
syntax keyword gdppArgConstant true false null contained
syntax match gdppArgCode "\<code\>\ze\_s*{" contained nextgroup=gdppCppBlock skipwhite skipempty

" What a class's body holds, like the top of a file. A template's body holds the same, and holes.
syntax cluster gdppDecl contains=@gdppComments,gdppDocLine,gdppDocBlock,gdppAnnotation,gdppKeyword,gdppOn,gdppExtends,gdppImport,gdppCode,gdppValue,gdppCppBlock,gdppMacroKeyword,gdppInvoke,gdppHole

" Block comments nest, and C++ blocks can be long, so only the whole file tells what's what.
syntax sync fromstart
syntax spell notoplevel

" Refcounted classes stand out from the others. The colors are defaults, so
" a colorscheme or vimrc can set its own.
function! s:GodotColors() abort
  if &background ==# 'dark'
    highlight default godotObjClass ctermfg=205 guifg=#FF5FAF
    highlight default godotRefClass ctermfg=141 guifg=#AF87FF
  else
    highlight default godotObjClass ctermfg=162 guifg=#D70087
    highlight default godotRefClass ctermfg=97  guifg=#875FD7
  endif
endfunction
call s:GodotColors()
augroup gdppGodotColors
  autocmd!
  " A colorscheme clears the colors, and may change 'background'.
  autocmd ColorScheme * call s:GodotColors()
augroup END
highlight default link godotNodeClass godotObjClass
highlight default link godotBuiltinType Type

highlight default link gdppTodo Todo
highlight default link gdppCommentError Error
highlight default link gdppLineComment Comment
highlight default link gdppComment Comment
highlight default link gdppDocLine SpecialComment
highlight default link gdppDocBlock SpecialComment
highlight default link gdppDocBlockNest SpecialComment
highlight default link gdppString String
highlight default link gdppChar Character
highlight default link gdppNumber Number
highlight default link gdppAnnotation PreProc
highlight default link gdppNodePath String
highlight default link gdppKeyword Keyword
highlight default link gdppExtends Keyword
highlight default link gdppImport Keyword
highlight default link gdppAccessor Keyword
highlight default link gdppCode Keyword
highlight default link gdppDefName Type
highlight default link gdppClassName Type
highlight default link gdppEnumName Type
highlight default link gdppConstName Constant
highlight default link gdppEnumValue Constant
highlight default link gdppOn Keyword
highlight default link gdppNotification Keyword
highlight default link gdppOnName Constant
highlight default link gdppOnParam Identifier
highlight default link gdppFuncName Function
highlight default link gdppSignalName Function
highlight default link gdppVarName Identifier
highlight default link gdppMacroKeyword Keyword
highlight default link gdppMacroName Function
highlight default link gdppTemplateName Function
highlight default link gdppMacroFileName Function
highlight default link gdppTemplateFileName Function
highlight default link gdppMacroParam Identifier
highlight default link gdppValueMacro Keyword
highlight default link gdppInvoke Keyword
highlight default link gdppInvokeName Function
highlight default link gdppArgName Identifier
highlight default link gdppArgConstant Boolean
highlight default link gdppArgCode Keyword
highlight default link gdppHoleDelim PreProc

" In C++ code, from gdpp/cpp.vim.
highlight default link gdppRewrite Keyword
highlight default link gdppThis Keyword
highlight default link gdppMacro Keyword
highlight default link gdppMacroBlock Keyword
highlight default link gdppGd Type
highlight default link gdppRuntimeType Type
highlight default link gdppUserType Type

" In Lua code, from gdpp/lua.vim.
highlight default link gdppLuaLineComment Comment
highlight default link gdppLuaComment Comment
highlight default link gdppLuaGlobal Type
highlight default link gdppLuaApi Function
highlight default link gdppLuaTemplate Keyword
highlight default link gdppLuaMacro Keyword

let b:current_syntax = "gdpp"
