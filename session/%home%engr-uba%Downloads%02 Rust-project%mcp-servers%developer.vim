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
badd +57 src/developer/screen_capture.rs
badd +1 README.md
badd +116 src/developer/save_actions.rs
badd +57 src/developer/text_editor.rs
argglobal
%argdel
$argadd .
edit src/developer/text_editor.rs
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
sil! 2,5fold
sil! 1,9fold
sil! 11,12fold
sil! 14,15fold
sil! 18,25fold
sil! 28,30fold
sil! 27,31fold
sil! 35,39fold
sil! 34,40fold
sil! 43,47fold
sil! 42,48fold
sil! 50,53fold
sil! 59,61fold
sil! 58,63fold
sil! 57,65fold
sil! 56,66fold
sil! 55,68fold
sil! 77,78fold
sil! 82,83fold
sil! 89,92fold
sil! 88,94fold
sil! 87,96fold
sil! 104,106fold
sil! 103,108fold
sil! 102,110fold
sil! 112,117fold
sil! 120,122fold
sil! 125,129fold
sil! 125,130fold
sil! 76,130fold
sil! 133,135fold
sil! 132,137fold
sil! 132,138fold
sil! 131,139fold
sil! 70,140fold
sil! 151,153fold
sil! 150,155fold
sil! 149,157fold
sil! 162,165fold
sil! 161,167fold
sil! 160,169fold
sil! 179,180fold
sil! 178,182fold
sil! 192,194fold
sil! 197,201fold
sil! 197,202fold
sil! 142,203fold
sil! 205,209fold
sil! 219,221fold
sil! 218,223fold
sil! 217,225fold
sil! 233,236fold
sil! 232,238fold
sil! 240,242fold
sil! 239,244fold
sil! 285,287fold
sil! 290,294fold
sil! 290,295fold
sil! 210,296fold
sil! 205,296fold
sil! 308,309fold
sil! 311,312fold
sil! 311,313fold
sil! 306,313fold
sil! 315,317fold
sil! 315,318fold
sil! 314,319fold
sil! 305,319fold
sil! 321,323fold
sil! 321,324fold
sil! 320,325fold
sil! 298,326fold
sil! 331,334fold
sil! 335,336fold
sil! 330,337fold
sil! 338,339fold
sil! 347,350fold
sil! 328,352fold
sil! 33,353fold
sil! 357,359fold
sil! 370,373fold
sil! 362,386fold
sil! 397,400fold
sil! 406,410fold
sil! 389,421fold
sil! 432,435fold
sil! 441,445fold
sil! 424,462fold
sil! 477,479fold
sil! 465,482fold
sil! 489,491fold
sil! 485,492fold
sil! 513,516fold
sil! 518,520fold
sil! 522,524fold
sil! 527,530fold
sil! 532,534fold
sil! 539,542fold
sil! 495,556fold
sil! 567,570fold
sil! 576,579fold
sil! 559,602fold
sil! 614,617fold
sil! 621,623fold
sil! 605,626fold
sil! 643,645fold
sil! 629,648fold
sil! 660,663fold
sil! 670,674fold
sil! 668,677fold
sil! 680,685fold
sil! 692,694fold
sil! 651,697fold
sil! 708,711fold
sil! 700,731fold
sil! 356,732fold
let &fdl = &fdl
33
sil! normal! zo
55
sil! normal! zo
56
sil! normal! zo
57
sil! normal! zo
let s:l = 327 - ((37 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 327
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
