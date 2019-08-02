" pathogen.vim - path option manipulation
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      2.4

if exists("g:loaded_pathogen") || &cp
  finish
endif
let g:loaded_pathogen = 1

command! -bar Helptags :call pathogen#helptags()

" vim: et sw=2
