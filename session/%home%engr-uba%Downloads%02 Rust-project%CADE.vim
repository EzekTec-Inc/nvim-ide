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
badd +1 .
argglobal
%argdel
$argadd .
edit .
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 27 + 22) / 45)
exe 'vert 1resize ' . ((&columns * 14 + 95) / 191)
exe '2resize ' . ((&lines * 27 + 22) / 45)
exe 'vert 2resize ' . ((&columns * 176 + 95) / 191)
exe '3resize ' . ((&lines * 15 + 22) / 45)
argglobal
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("term://~/Downloads/02\ Rust-project/CADE//231853:/bin/bash", ":p")) | buffer term://~/Downloads/02\ Rust-project/CADE//231853:/bin/bash | else | edit term://~/Downloads/02\ Rust-project/CADE//231853:/bin/bash | endif
if &buftype ==# 'terminal'
  silent file term://~/Downloads/02\ Rust-project/CADE//231853:/bin/bash
endif
balt .
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
let s:l = 31 - ((26 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 31
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("term://~/Downloads/02\ Rust-project/CADE//232141:/bin/bash;\#toggleterm\#1", ":p")) | buffer term://~/Downloads/02\ Rust-project/CADE//232141:/bin/bash;\#toggleterm\#1 | else | edit term://~/Downloads/02\ Rust-project/CADE//232141:/bin/bash;\#toggleterm\#1 | endif
if &buftype ==# 'terminal'
  silent file term://~/Downloads/02\ Rust-project/CADE//232141:/bin/bash;\#toggleterm\#1
endif
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
let s:l = 467 - ((14 * winheight(0) + 7) / 15)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 467
normal! 0
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 27 + 22) / 45)
exe 'vert 1resize ' . ((&columns * 14 + 95) / 191)
exe '2resize ' . ((&lines * 27 + 22) / 45)
exe 'vert 2resize ' . ((&columns * 176 + 95) / 191)
exe '3resize ' . ((&lines * 15 + 22) / 45)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
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
