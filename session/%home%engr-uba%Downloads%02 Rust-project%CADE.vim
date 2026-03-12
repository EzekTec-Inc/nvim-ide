let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/CADE
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +16 README.md
badd +0 ARCHITECTURE.md
argglobal
%argdel
$argadd .
edit ARCHITECTURE.md
argglobal
balt README.md
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 7,9fold
sil! 5,9fold
sil! 15,18fold
sil! 13,18fold
sil! 22,28fold
sil! 20,28fold
sil! 32,34fold
sil! 30,34fold
sil! 11,34fold
sil! 40,45fold
sil! 38,45fold
sil! 49,54fold
sil! 47,54fold
sil! 58,59fold
sil! 56,59fold
sil! 63,64fold
sil! 61,64fold
sil! 36,64fold
sil! 68,74fold
sil! 66,74fold
sil! 78,82fold
sil! 76,82fold
sil! 85,88fold
sil! 84,88fold
sil! 91,96fold
sil! 90,96fold
sil! 1,96fold
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 022|
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
