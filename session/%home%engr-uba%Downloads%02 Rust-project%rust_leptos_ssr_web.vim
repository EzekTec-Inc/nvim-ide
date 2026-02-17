let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/rust_leptos_ssr_web
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +2 src/main.rs
badd +75 src/app.rs
badd +61 src/error_template.rs
badd +5 src/lib.rs
argglobal
%argdel
$argadd .
edit src/app.rs
argglobal
balt src/main.rs
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 1,6fold
sil! 16,17fold
sil! 27,29fold
sil! 24,30fold
sil! 15,38fold
sil! 9,39fold
sil! 42,50fold
sil! 53,71fold
sil! 80,82fold
sil! 75,99fold
sil! 110,111fold
sil! 128,131fold
sil! 127,131fold
sil! 127,132fold
sil! 126,133fold
sil! 125,134fold
sil! 122,135fold
sil! 121,136fold
sil! 113,139fold
sil! 103,139fold
let &fdl = &fdl
let s:l = 75 - ((16 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 75
normal! 010|
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
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
