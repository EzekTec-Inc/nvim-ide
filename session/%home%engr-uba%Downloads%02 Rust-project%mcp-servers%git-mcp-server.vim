let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/mcp-servers/git-mcp-server
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 ~/Downloads/02\ Rust-project/mcp-servers/git-mcp-server
badd +33 src/git_server/status.rs
argglobal
%argdel
$argadd ~/Downloads/02\ Rust-project/mcp-servers/git-mcp-server
edit src/git_server/status.rs
argglobal
balt ~/Downloads/02\ Rust-project/mcp-servers/git-mcp-server
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 2,5fold
sil! 1,7fold
sil! 16,18fold
sil! 20,23fold
sil! 27,31fold
sil! 38,39fold
sil! 45,46fold
sil! 47,48fold
sil! 49,50fold
sil! 56,58fold
sil! 55,60fold
sil! 62,63fold
sil! 64,65fold
sil! 68,72fold
sil! 68,73fold
sil! 24,74fold
sil! 20,74fold
sil! 15,75fold
sil! 79,81fold
sil! 85,117fold
sil! 78,118fold
let &fdl = &fdl
let s:l = 33 - ((11 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 33
normal! 031|
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
