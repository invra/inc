project('swaywpo', 'c')
cc = meson.get_compiler('c')

add_project_arguments([
  '-D_POSIX_C_SOURCE=200809L',
  '-Wundef',
  '-Wno-unused-parameter',
  '-Wno-missing-braces',
  '-Wno-cpp',
  cc.get_supported_arguments([
    '-Wno-builtin-declaration-mismatch',      # gcc
    '-Wno-incompatible-library-redeclaration' # clang
  ])
], language: 'c')

executable('swaywpo', 'main.c',
  install: true)
