let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +13 .claude.json
argglobal
%argdel
$argadd .claude.json
edit .claude.json
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
sil! 3,5fold
sil! 2,6fold
sil! 12,14fold
sil! 11,16fold
sil! 18,43fold
sil! 59,61fold
sil! 75,76fold
sil! 83,86fold
sil! 46,115fold
sil! 124,126fold
sil! 128,138fold
sil! 154,159fold
sil! 177,183fold
sil! 185,191fold
sil! 176,192fold
sil! 195,216fold
sil! 144,217fold
sil! 229,234fold
sil! 252,258fold
sil! 260,266fold
sil! 251,267fold
sil! 270,291fold
sil! 219,292fold
sil! 319,325fold
sil! 327,333fold
sil! 318,334fold
sil! 337,358fold
sil! 294,359fold
sil! 368,371fold
sil! 365,373fold
sil! 364,374fold
sil! 399,406fold
sil! 361,407fold
sil! 416,418fold
sil! 413,420fold
sil! 412,421fold
sil! 445,452fold
sil! 409,453fold
sil! 143,454fold
sil! 457,458fold
sil! 460,461fold
sil! 456,462fold
sil! 468,469fold
sil! 472,474fold
sil! 476,478fold
sil! 480,482fold
sil! 484,486fold
sil! 488,490fold
sil! 492,494fold
sil! 496,498fold
sil! 500,502fold
sil! 504,506fold
sil! 508,510fold
sil! 512,514fold
sil! 516,518fold
sil! 520,522fold
sil! 524,526fold
sil! 471,527fold
sil! 532,533fold
sil! 1,534fold
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
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
