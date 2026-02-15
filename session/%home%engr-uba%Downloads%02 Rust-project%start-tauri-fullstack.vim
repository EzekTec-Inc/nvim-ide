let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/start-tauri-fullstack
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 Cargo.toml
badd +1 app/Cargo.toml
badd +16 app/src/app.rs
badd +54 app/src/shell.rs
badd +67 PREREQUISITES.md
badd +31 README.md
badd +22 app/src/domain/home/page_home.rs
badd +0 app/src/components/layout/app_bottom_nav.rs
argglobal
%argdel
$argadd .
edit app/src/components/layout/app_bottom_nav.rs
argglobal
balt app/src/domain/home/page_home.rs
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
sil! 6,7fold
sil! 5,11fold
sil! 18,21fold
sil! 34,36fold
sil! 32,42fold
sil! 29,42fold
sil! 29,43fold
sil! 27,44fold
sil! 24,47fold
sil! 14,47fold
let &fdl = &fdl
let s:l = 48 - ((33 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 48
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
