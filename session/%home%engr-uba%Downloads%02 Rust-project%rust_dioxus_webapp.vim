let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/rust_dioxus_webapp
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 src/main.rs
badd +1 Cargo.toml
badd +13 src/components/product_page.rs
argglobal
%argdel
$argadd .
edit src/main.rs
argglobal
balt Cargo.toml
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 1,3fold
sil! 6,8fold
sil! 5,9fold
sil! 12,27fold
sil! 35,36fold
sil! 35,37fold
sil! 32,38fold
sil! 31,38fold
sil! 31,39fold
sil! 30,40fold
sil! 46,48fold
sil! 50,54fold
sil! 49,55fold
sil! 45,55fold
sil! 45,56fold
sil! 44,57fold
sil! 43,60fold
let &fdl = &fdl
43
sil! normal! zo
44
sil! normal! zo
45
sil! normal! zo
45
sil! normal! zo
let s:l = 61 - ((33 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 61
normal! 0
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
