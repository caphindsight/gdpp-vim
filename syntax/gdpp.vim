" Vim syntax file
" Language: GD++ (https://github.com/caphindsight/gdpp)
" Filenames: *.gd++, *.gdpp, *.gg
"
" GD++ has a declaration scope, whose syntax looks like GDScript, and C++ code
" in braces: function bodies, initial values, decl and impl blocks and so on.
" This file highlights the declarations itself, and gdpp/cpp.vim the C++ code.

if exists("b:current_syntax")
  finish
endif

" C++ code, with GD++'s rewrites and Godot's types: the cluster @gdppCpp.
execute 'syntax include @gdppCpp ' . fnameescape(expand('<sfile>:p:h:h') . '/gdpp/cpp.vim')
unlet! b:current_syntax
syntax sync clear

" A type: a name, with type arguments in brackets, e.g. Dictionary[String, Array[int]].
let s:type = '\h\w*\%(\_s*\[\%(\_[^][]\|\[\%(\_[^][]\|\[\_[^][]*\]\)*\]\)*\]\)\='
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
syntax region gdppAnnotationArgs start="(" end=")" contained contains=gdppString,gdppChar,gdppNumber,@gdppComments

" C++ code: a block in braces, or a value after "=", which runs to the end of
" the line (or a comment there), or to a "," or ")" in parameters, while no
" bracket is open.
syntax region gdppCppBlock matchgroup=gdppBrace start="{" end="}" contains=@gdppCpp fold
syntax region gdppValue matchgroup=gdppOperator start="=" end="\ze\s*\%(//.*\|/\*.*\)\=$" end="\ze[,)]" contains=gdppNodePath,@gdppCpp
syntax match gdppNodePath +\%(=\s*\)\@<=[$%]\%(\s*\%(\h\w*\|"\%(\\.\|[^"\\]\)*"\|'\%(\\.\|[^'\\]\)*'\|%\|/[/*]\@!\)\)*+ contained

" Types, after ":", "->", extends, import and noimport.
execute 'syntax match gdppTypeHint ":\_s*' . s:type . '" contained contains=@gdppTypes nextgroup=gdppPropBody skipwhite skipempty'
execute 'syntax match gdppReturnType "->\_s*' . s:type . '" contained contains=@gdppTypes nextgroup=gdppCppBlock skipwhite skipempty'
execute 'syntax match gdppTypeRef "' . s:type . '\%(\.\h\w*\)\=" contained contains=@gdppTypes'

" Classes and externs.
syntax keyword gdppKeyword class_name extern_name enum_name nextgroup=gdppDefName skipwhite skipempty
syntax keyword gdppKeyword class extern nextgroup=gdppClassName skipwhite skipempty
syntax keyword gdppExtends extends nextgroup=gdppTypeRef skipwhite skipempty
syntax keyword gdppImport import noimport nextgroup=gdppTypeRef skipwhite skipempty
syntax match gdppDefName "\h\w*" contained
syntax match gdppClassName "\h\w*" contained nextgroup=gdppClassBody skipwhite skipempty
syntax region gdppClassBody matchgroup=gdppBrace start="{" end="}" contained contains=@gdppDecl fold

" Functions and signals.
syntax keyword gdppKeyword func nextgroup=gdppFuncName skipwhite skipempty
syntax keyword gdppKeyword signal nextgroup=gdppSignalName skipwhite skipempty
syntax match gdppFuncName "\h\w*" contained nextgroup=gdppParams skipwhite skipempty
syntax match gdppSignalName "\h\w*" contained nextgroup=gdppParams skipwhite skipempty
syntax region gdppParams matchgroup=gdppParen start="(" end=")" contained contains=gdppTypeHint,gdppValue,@gdppComments nextgroup=gdppReturnType,gdppCppBlock skipwhite skipempty

" Variables and properties.
syntax keyword gdppKeyword var nextgroup=gdppVarName skipwhite skipempty
syntax match gdppVarName "\h\w*" contained nextgroup=gdppTypeHint,gdppPropBody skipwhite skipempty
syntax region gdppPropBody matchgroup=gdppBrace start="{" end="}" contained contains=gdppAccessor,gdppCode,gdppAnnotation,@gdppComments fold
syntax keyword gdppAccessor get contained nextgroup=gdppCppBlock skipwhite skipempty
syntax keyword gdppAccessor set contained nextgroup=gdppSetParams skipwhite skipempty
syntax region gdppSetParams matchgroup=gdppParen start="(" end=")" contained contains=gdppTypeHint,@gdppComments nextgroup=gdppCppBlock skipwhite skipempty

" Enums and constants.
syntax keyword gdppKeyword enum nextgroup=gdppEnumName,gdppConstName skipwhite skipempty
syntax match gdppEnumName "\h\w*" contained nextgroup=gdppEnumBody skipwhite skipempty
syntax match gdppConstName "\h\w*\ze\_s*=" contained
syntax region gdppEnumBody matchgroup=gdppBrace start="{" end="}" contained contains=gdppEnumValue,gdppExtends,gdppValue,gdppAnnotation,gdppDocLine,gdppDocBlock,@gdppComments fold
syntax match gdppEnumValue "\h\w*" contained

" Lifecycle, and C++ blocks.
syntax keyword gdppKeyword ctor dtor nextgroup=gdppCppBlock skipwhite skipempty
syntax keyword gdppKeyword notif nextgroup=gdppNotifArgs skipwhite skipempty
syntax region gdppNotifArgs matchgroup=gdppParen start="(" end=")" contained contains=gdppNotifName,@gdppComments nextgroup=gdppCppBlock skipwhite skipempty
syntax match gdppNotifName "\h\w*" contained
" Engine blocks, e.g. ready { ... } and process(delta) { ... }. Their words are names elsewhere, e.g. in "var ready",
" so they're keywords only where they start a block.
syntax match gdppEngine "\<\%(ready\|enter_tree\|exit_tree\|draw\)\>\ze\_s*{" nextgroup=gdppCppBlock skipwhite skipempty
syntax match gdppEngine "\<\%(process\|physics_process\)\>\ze\_s*(" nextgroup=gdppEngineArgs skipwhite skipempty
syntax region gdppEngineArgs matchgroup=gdppParen start="(" end=")" contained contains=gdppEngineParam,@gdppComments nextgroup=gdppCppBlock skipwhite skipempty
syntax match gdppEngineParam "\h\w*" contained
syntax keyword gdppCode decl nextgroup=gdppCode,gdppCppBlock skipwhite skipempty
syntax keyword gdppCode impl nextgroup=gdppCppBlock skipwhite skipempty

" What a class's body holds, like the top of a file.
syntax cluster gdppDecl contains=@gdppComments,gdppDocLine,gdppDocBlock,gdppAnnotation,gdppKeyword,gdppEngine,gdppExtends,gdppImport,gdppCode,gdppValue,gdppCppBlock

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
highlight default link gdppNotifName Constant
highlight default link gdppEngine Keyword
highlight default link gdppEngineParam Identifier
highlight default link gdppFuncName Function
highlight default link gdppSignalName Function
highlight default link gdppVarName Identifier

" In C++ code, from gdpp/cpp.vim.
highlight default link gdppRewrite Keyword
highlight default link gdppThis Keyword
highlight default link gdppMacro Keyword
highlight default link gdppGd Type
highlight default link gdppRuntimeType Type
highlight default link gdppUserType Type

let b:current_syntax = "gdpp"
