" C++ as GD++ code blocks see it: cpp.vim, with GD++'s comments, rewrites,
" runtime names and Godot's types.
"
" syntax/gdpp.vim loads this file with :syntax include, so every group here
" shares one include tag with cpp.vim's, and C's ALLBUT regions, e.g. cParen,
" contain GD++'s additions too. Don't load it any other way.

runtime! syntax/cpp.vim
unlet! b:current_syntax

" Line comments don't continue after a backslash, and block comments nest.
syntax clear cCommentL cComment
syntax match cCommentL "//.*$" contains=@cCommentGroup,cSpaceError,@Spell
syntax region cComment matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cComment,cSpaceError,@Spell fold extend

" Rewrites (gd++ man rewrites), highlighted where GD++ rewrites them.
syntax keyword gdppRewrite emit
syntax match gdppRewrite "\%(\.\|->\|::\)\@3<!\<is_cancelled\>\%(\s*(\)\@!"
syntax match gdppRewrite "\%(\.\|->\|::\)\@3<!\<rpc\>\ze\%(\s*([^()]*)\)\=\s*\h\w*\%(\s*\%(\.\|->\)\s*\h\w*\)*\s*("
syntax match gdppRewrite "\<string_name\>\ze\s*\%(u8\|[uUL]\)\=R\=\""
syntax match gdppRewrite "\%(\.\|->\|::\)\@3<!\<\%(is_done\|claim\|cancel\)\>\ze\s\+\%(\h\|::\)"
syntax match gdppRewrite "\%(\%(\w\|[)\]]\)\s*\)\@80<=\<as\>\ze\s\+\%(\h\|::\)"
syntax match gdppRewrite "\%(\%(^\|[{};:)]\|\<\%(else\|do\)\>\)\s*\)\@80<=\%(\.\|->\|::\)\@3<!\<assert\>\ze\s*\%([[:alnum:]_"'(]\|[!*&][=&]\@!\)"

" The runtime (gd++ man runtime), and godot-cpp's helpers.
syntax keyword gdppThis This
syntax match gdppGd "\<gd\ze\s*::"
syntax keyword gdppRuntimeType Async Emitted Ext ExtPtr ExtRef float64_t real_t Ref TypedArray TypedDictionary
syntax keyword gdppMacro memnew memnew_arr memnew_placement memdelete memdelete_arr memalloc memrealloc memfree
syntax keyword gdppMacro memnew_ext memdelete_ext callable_mp callable_mp_static

" Other types: names in PascalCase, like the compiler's own highlighting.
syntax match gdppUserType "\<\u\w*\l\w*\>"

" Godot's types, split into built-in types, refcounted classes, nodes and other objects.
execute 'source ' . fnameescape(expand('<sfile>:p:h') . '/godot.vim')
