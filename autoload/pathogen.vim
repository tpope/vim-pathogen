" pathogen.vim - path option manipulation
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Version:      1.3

" Install in ~/.vim/autoload (or ~\vimfiles\autoload).
"
" For management of individually installed plugins in ~/.vim/bundle
" (or $HOME/vimfiles/bundle), adding 'call pathogen#infect()' to your
" .vimrc prior to 'fileype plugin indent on' is the only other setup necessary.
"
" API is documented below.

if exists("g:loaded_pathogen") || &cp
  finish
endif
let g:loaded_pathogen = 1

" Point of entry for basic default usage.
function! pathogen#infect(...) abort " {{{1
  let source_path = a:0 ? a:1 : 'bundle'
  call pathogen#runtime_append_all_bundles(source_path)
  call pathogen#cycle_filetype()
endfunction " }}}1

" Split a path into a list.
function! pathogen#split(path) abort " {{{1
  if type(a:path) == type([]) | return a:path | endif
  let split = split(a:path,'\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val,''\\\([\\,]\)'',''\1'',"g")')
endfunction " }}}1

" Convert a list to a path.
function! pathogen#join(...) abort " {{{1
  if type(a:1) == type(1) && a:1
    let i = 1
    let space = ' '
  else
    let i = 0
    let space = ''
  endif
  let path = ""
  while i < a:0
    if type(a:000[i]) == type([])
      let list = a:000[i]
      let j = 0
      while j < len(list)
        let escaped = substitute(list[j],'[,'.space.']\|\\[\,'.space.']\@=','\\&','g')
        let path .= ',' . escaped
        let j += 1
      endwhile
    else
      let path .= "," . a:000[i]
    endif
    let i += 1
  endwhile
  return substitute(path,'^,','','')
endfunction " }}}1

" Convert a list to a path with escaped spaces for 'path', 'tag', etc.
function! pathogen#legacyjoin(...) abort " {{{1
  return call('pathogen#join',[1] + a:000)
endfunction " }}}1

" Remove duplicates from a list.
function! pathogen#uniq(list) abort " {{{1
  let i = 0
  let seen = {}
  while i < len(a:list)
    if has_key(seen,a:list[i])
      call remove(a:list,i)
    else
      let seen[a:list[i]] = 1
      let i += 1
    endif
  endwhile
  return a:list
endfunction " }}}1

" \ on Windows unless shellslash is set, / everywhere else.
function! pathogen#separator() abort " {{{1
  return !exists("+shellslash") || &shellslash ? '/' : '\'
endfunction " }}}1

" Convenience wrapper around glob() which returns a list.
function! pathogen#glob(pattern) abort " {{{1
  let files = split(glob(a:pattern),"\n")
  return map(files,'substitute(v:val,"[".pathogen#separator()."/]$","","")')
endfunction "}}}1

" Like pathogen#glob(), only limit the results to directories.
function! pathogen#glob_directories(pattern) abort " {{{1
  return filter(pathogen#glob(a:pattern),'isdirectory(v:val)')
endfunction "}}}1

" Turn filetype detection off and back on again if it was already enabled.
function! pathogen#cycle_filetype() " {{{1
  if exists('g:did_load_filetypes')
    filetype off
    filetype on
  endif
endfunction " }}}1

" Checks if a bundle is 'disabled'. A bundle is considered 'disabled' if
" its 'basename()' is included in g:pathogen_disabled[]'.
function! pathogen#is_disabled(path) " {{{1
  if !exists("g:pathogen_disabled")
    return 0
  endif
  let sep = pathogen#separator()
  return index(g:pathogen_disabled, strpart(a:path, strridx(a:path, sep)+1)) != -1
endfunction "}}}1

" Prepend all subdirectories of path to the rtp, and append all 'after'
" directories in those subdirectories.
function! pathogen#runtime_prepend_subdirectories(path) " {{{1
  let sep    = pathogen#separator()
  let before = filter(pathogen#glob_directories(a:path.sep."*[^~]"), '!pathogen#is_disabled(v:val)')
  let after  = filter(pathogen#glob_directories(a:path.sep."*[^~]".sep."after"), '!pathogen#is_disabled(v:val[0:-7])')
  let rtp = pathogen#split(&rtp)
  let path = expand(a:path)
  call filter(rtp,'v:val[0:strlen(path)-1] !=# path')
  let &rtp = pathogen#join(pathogen#uniq(before + rtp + after))
  return &rtp
endfunction " }}}1

" For each directory in rtp, check for a subdirectory named dir.  If it
" exists, add all subdirectories of that subdirectory to the rtp, immediately
" after the original directory.  If no argument is given, 'bundle' is used.
" Repeated calls with the same arguments are ignored.
function! pathogen#runtime_append_all_bundles(...) " {{{1
  let sep = pathogen#separator()
  let name = a:0 ? a:1 : 'bundle'
  if "\n".s:done_bundles =~# "\\M\n".name."\n"
    return ""
  endif
  let s:done_bundles .= name . "\n"
  let list = []
  for dir in pathogen#split(&rtp)
    if dir =~# '\<after$'
      let list +=  filter(pathogen#glob_directories(substitute(dir,'after$',name,'').sep.'*[^~]'.sep.'after'), '!pathogen#is_disabled(v:val[0:-7])') + [dir]
    else
      let list +=  [dir] + filter(pathogen#glob_directories(dir.sep.name.sep.'*[^~]'), '!pathogen#is_disabled(v:val)')
    endif
  endfor
  let &rtp = pathogen#join(pathogen#uniq(list))
  return 1
endfunction

let s:done_bundles = ''
" }}}1

" Invoke :helptags on all non-$VIM doc directories in runtimepath.
function! pathogen#helptags() " {{{1
  for dir in pathogen#split(&rtp)
    if dir[0 : strlen($VIMRUNTIME)-1] !=# $VIMRUNTIME && filewritable(dir.'/doc') == 2 && !empty(glob(dir.'/doc/*')) && (!filereadable(dir.'/doc/tags') || filewritable(dir.'/doc/tags'))
      helptags `=dir.'/doc'`
    endif
  endfor
endfunction " }}}1

command! -bar Helptags :call pathogen#helptags()

" vim:set ft=vim ts=8 sw=2 sts=2:
