if exists("b:current_syntax")
  finish
end

runtime! syntax/cpp.vim

syntax match gdppCommentSingle "//.*$"
syntax region gdppCommentMulti start="/\*[^\*]" end="\*/" contains=gdppCommentMulti
syntax match gdppDocCommentSingle "///.*$"
syntax region gdppDocCommentMulti start="/\*\*" end="\*/" contains=gdppDocCommentMulti

syntax keyword gdppKeyword class class_name ctor decl dtor enum enum_name extends extern extern_name func get impl import noimport set signal var
syntax keyword gdppCppKeyword emit memdelete memdeleteext memnew memnewext null

" Godot structs act as types.
syntax keyword godotStruct Variant void bool int float String StringName NodePath Vector2 Vector2i Rect2 Vector3 Vector3i Transform2D Vector4 Vector4i Plane Quaternion AABB Basis Transform3D Projection Color RID Callable Signal Dictionary Array PackedByteArray PackedInt32Array PackedInt64Array PackedFloat32Array PackedFloat64Array PackedStringArray PackedVector2Array PackedVector3Array PackedVector4Array PackedColorArray
highlight default link godotStruct Type

" Generated Godot classes act as types.
execute 'source ' . expand('<sfile>:p:h') . '/classes.vim'
if &background ==# 'dark'
  highlight godotObjClass  ctermfg=205 guifg=#FF5FAF
  highlight godotNodeClass ctermfg=205  guifg=#FF5FAF
  highlight godotRefClass  ctermfg=141 guifg=#AF87FF
else
  highlight godotObjClass  ctermfg=162 guifg=#D70087
  highlight godotNodeClass ctermfg=162  guifg=#D70087
  highlight godotRefClass  ctermfg=97  guifg=#875FD7
endif

syntax match gdppAnnotation "\v\@[a-zA-Z0-9_]+(\(.*\))?"

highlight default link gdppCommentSingle Comment
highlight default link gdppCommentMulti Comment
highlight default link gdppDocCommentSingle SpecialComment
highlight default link gdppDocCommentMulti SpecialComment
highlight default link gdppKeyword Keyword
highlight default link gdppCppKeyword Keyword
highlight default link gdppAnnotation PreProc

let b:current_syntax = "gdpp"
