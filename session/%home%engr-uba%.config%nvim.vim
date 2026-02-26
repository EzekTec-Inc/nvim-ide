let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 init.lua
badd +242 lua/mappings.lua
badd +8 conductor/index.md
badd +1 conductor/code_styleguides/typescript.md
badd +88 conductor/workflow.md
argglobal
%argdel
$argadd ./
edit conductor/workflow.md
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
sil! 22,25fold
sil! 27,29fold
sil! 31,33fold
sil! 35,39fold
sil! 41,45fold
sil! 47,50fold
sil! 55,59fold
sil! 52,59fold
sil! 61,63fold
sil! 65,67fold
sil! 78,81fold
sil! 75,81fold
sil! 83,87fold
sil! 92,112fold
sil! 89,112fold
sil! 114,116fold
sil! 118,120fold
sil! 122,124fold
sil! 126,129fold
sil! 131,133fold
sil! 202,205fold
sil! 207,211fold
sil! 213,216fold
sil! 218,222fold
sil! 224,227fold
sil! 229,233fold
let &fdl = &fdl
let s:l = 88 - ((15 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 88
normal! 0
lcd ~/.config/nvim
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
