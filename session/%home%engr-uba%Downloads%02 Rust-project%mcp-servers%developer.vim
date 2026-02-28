let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/mcp-servers/developer
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +76 src/developer/agents.rs
badd +1 Cargo.toml
badd +653 src/developer/mod.rs
argglobal
%argdel
$argadd ~/Downloads/02\ Rust-project/mcp-servers/developer/
edit src/developer/agents.rs
argglobal
balt src/developer/mod.rs
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 12,13fold
sil! 18,20fold
sil! 17,21fold
sil! 25,28fold
sil! 30,31fold
sil! 36,38fold
sil! 34,38fold
sil! 16,39fold
sil! 42,45fold
sil! 48,50fold
sil! 47,51fold
sil! 55,58fold
sil! 62,63fold
sil! 68,70fold
sil! 66,70fold
sil! 46,71fold
sil! 11,72fold
sil! 81,83fold
sil! 93,95fold
sil! 80,96fold
sil! 76,97fold
let &fdl = &fdl
11
sil! normal! zo
46
sil! normal! zo
47
sil! normal! zo
let s:l = 44 - ((30 * winheight(0) + 21) / 43)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 44
normal! 019|
lcd ~/Downloads/02\ Rust-project/mcp-servers/developer
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
