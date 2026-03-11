let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/AgentFlow
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 l
badd +75 src/core/flow.rs
badd +42 README.md
argglobal
%argdel
$argadd l
edit src/core/flow.rs
argglobal
balt l
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 56,62fold
sil! 68,72fold
sil! 67,73fold
sil! 81,83fold
sil! 88,91fold
sil! 96,97fold
sil! 95,100fold
sil! 110,113fold
sil! 109,113fold
sil! 122,123fold
sil! 124,125fold
sil! 134,136fold
sil! 132,138fold
sil! 147,151fold
sil! 145,151fold
sil! 156,159fold
sil! 160,161fold
sil! 162,163fold
sil! 131,164fold
sil! 121,168fold
sil! 182,183fold
sil! 184,185fold
sil! 194,195fold
sil! 192,196fold
sil! 205,209fold
sil! 203,209fold
sil! 214,217fold
sil! 218,219fold
sil! 220,221fold
sil! 191,222fold
sil! 181,226fold
sil! 230,231fold
sil! 237,240fold
sil! 236,240fold
sil! 65,241fold
sil! 245,246fold
sil! 244,247fold
sil! 253,254fold
sil! 256,260fold
sil! 251,261fold
sil! 250,262fold
sil! 266,267fold
sil! 265,268fold
sil! 281,283fold
sil! 280,285fold
sil! 289,291fold
sil! 288,293fold
sil! 308,311fold
sil! 277,312fold
sil! 272,313fold
let &fdl = &fdl
let s:l = 75 - ((20 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 75
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
