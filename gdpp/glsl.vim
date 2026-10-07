" GLSL as GD++ shaders see it: the bodies of shaders, shader blocks and shader
" libraries. Vim has no GLSL syntax of its own, so this file defines it, with
" GD++'s comments, which nest.
"
" syntax/gdpp.vim loads this file with :syntax include, so its TOP is the
" cluster @gdppGlsl. Don't load it any other way.

" Comments. GD++ removes them before GLSL sees the code, so they nest like GD++'s.
syntax keyword gdppGlslTodo contained TODO FIXME XXX NOTE
syntax match gdppGlslLineComment "//.*$" contains=gdppGlslTodo,@Spell
syntax region gdppGlslComment start="/\*" end="\*/" contains=gdppGlslComment,gdppGlslTodo,@Spell extend

" Literals and the preprocessor.
syntax match gdppGlslNumber "\%(\<\|\.\)\d\%([eE][+-]\|[0-9A-Za-z_.]\)*"
syntax keyword gdppGlslBoolean true false
syntax match gdppGlslPreProc "^\s*#\s*\h\w*"

" Statements and qualifiers.
syntax keyword gdppGlslStatement if else for while do return switch case break continue default discard
syntax keyword gdppGlslStructure struct
syntax keyword gdppGlslQualifier const in out inout uniform buffer shared layout highp mediump lowp precise coherent volatile restrict readonly writeonly

" Types.
syntax keyword gdppGlslType void bool int uint float double
syntax keyword gdppGlslType vec2 vec3 vec4 ivec2 ivec3 ivec4 uvec2 uvec3 uvec4 bvec2 bvec3 bvec4
syntax keyword gdppGlslType mat2 mat3 mat4 mat2x2 mat2x3 mat2x4 mat3x2 mat3x3 mat3x4 mat4x2 mat4x3 mat4x4 sampler2D image2D

" The built-in functions that shaders use, and their built-in variables.
syntax keyword gdppGlslFunction radians degrees sin cos tan asin acos atan sinh cosh tanh asinh acosh atanh pow exp log exp2 log2 sqrt inversesqrt
syntax keyword gdppGlslFunction abs sign floor trunc round roundEven ceil fract mod modf min max clamp mix step smoothstep isnan isinf fma
syntax keyword gdppGlslFunction floatBitsToInt floatBitsToUint intBitsToFloat uintBitsToFloat packHalf2x16 unpackHalf2x16 packUnorm4x8 unpackUnorm4x8
syntax keyword gdppGlslFunction length distance dot cross normalize faceforward reflect refract matrixCompMult outerProduct transpose determinant inverse
syntax keyword gdppGlslFunction lessThan lessThanEqual greaterThan greaterThanEqual equal notEqual any all not bitCount findLSB findMSB bitfieldReverse
syntax keyword gdppGlslFunction texture textureLod texelFetch textureSize imageLoad imageStore imageSize
syntax keyword gdppGlslFunction atomicAdd atomicMin atomicMax atomicAnd atomicOr atomicXor atomicExchange atomicCompSwap
syntax keyword gdppGlslFunction barrier memoryBarrier memoryBarrierShared memoryBarrierBuffer memoryBarrierImage groupMemoryBarrier
syntax keyword gdppGlslBuiltin gl_GlobalInvocationID gl_LocalInvocationID gl_WorkGroupID gl_NumWorkGroups gl_WorkGroupSize gl_LocalInvocationIndex

" What GD++ adds to shaders' bodies: the cell, and index(p), its element in an array.
syntax keyword gdppGlslCell id
syntax match gdppGlslCell "\<index\ze\s*("

" Nested braces, so that the "}" of an if doesn't end the shader's body.
syntax region gdppGlslBraces matchgroup=gdppGlslBrace start="{" end="}" contains=TOP transparent
