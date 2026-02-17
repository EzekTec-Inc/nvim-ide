let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/rr-lambda-book
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +4 lambdas/get_links/Cargo.toml
badd +97 lambdas/get_links/src/main.rs
argglobal
%argdel
$argadd .
edit lambdas/get_links/src/main.rs
argglobal
balt lambdas/get_links/Cargo.toml
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 1,2fold
sil! 1,8fold
sil! 10,12fold
sil! 24,27fold
sil! 22,28fold
sil! 13,29fold
sil! 10,29fold
sil! 32,45fold
sil! 49,59fold
sil! 70,76fold
sil! 69,79fold
sil! 68,79fold
sil! 62,92fold
sil! 104,110fold
sil! 103,113fold
sil! 102,113fold
sil! 95,129fold
sil! 132,153fold
sil! 48,154fold
let &fdl = &fdl
let s:l = 64 - ((33 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 64
normal! 017|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
