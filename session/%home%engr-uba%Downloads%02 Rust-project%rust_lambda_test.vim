let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/rust_lambda_test
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +21 Cargo.toml
badd +30 src/main.rs
badd +1 src/helpers/actions.rs
argglobal
%argdel
$argadd .
edit src/helpers/actions.rs
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt src/main.rs
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 1,2fold
sil! 7,11fold
sil! 6,14fold
sil! 16,19fold
sil! 4,24fold
sil! 28,37fold
sil! 43,49fold
sil! 42,50fold
sil! 39,51fold
sil! 55,60fold
sil! 54,61fold
sil! 53,62fold
sil! 64,66fold
sil! 68,71fold
sil! 75,76fold
sil! 80,89fold
sil! 78,90fold
sil! 77,91fold
sil! 73,92fold
sil! 107,110fold
sil! 111,119fold
sil! 128,135fold
sil! 137,145fold
sil! 136,146fold
sil! 128,146fold
sil! 148,153fold
sil! 156,157fold
sil! 164,165fold
sil! 163,167fold
sil! 161,168fold
sil! 180,181fold
sil! 180,182fold
sil! 178,184fold
sil! 173,188fold
sil! 190,198fold
sil! 154,199fold
sil! 202,206fold
sil! 207,210fold
sil! 226,229fold
sil! 211,230fold
sil! 207,230fold
sil! 234,236fold
sil! 237,269fold
sil! 272,275fold
sil! 285,287fold
sil! 284,288fold
sil! 301,304fold
sil! 299,305fold
sil! 298,308fold
sil! 276,309fold
sil! 311,313fold
sil! 316,319fold
sil! 314,321fold
sil! 323,328fold
sil! 329,331fold
sil! 338,340fold
sil! 336,341fold
sil! 346,348fold
sil! 349,351fold
sil! 353,355fold
sil! 357,358fold
sil! 352,360fold
sil! 345,361fold
sil! 343,362fold
sil! 363,366fold
sil! 342,366fold
sil! 368,370fold
sil! 371,373fold
sil! 335,374fold
sil! 334,375fold
sil! 376,378fold
sil! 333,379fold
sil! 332,381fold
sil! 329,381fold
sil! 385,393fold
sil! 398,405fold
sil! 410,421fold
sil! 426,429fold
sil! 430,447fold
sil! 426,447fold
sil! 452,454fold
sil! 456,458fold
sil! 455,472fold
sil! 452,472fold
sil! 477,479fold
sil! 480,483fold
sil! 506,514fold
sil! 504,514fold
sil! 515,517fold
sil! 484,521fold
sil! 477,521fold
sil! 524,526fold
sil! 527,533fold
sil! 540,547fold
sil! 539,547fold
sil! 548,550fold
sil! 537,550fold
sil! 551,553fold
sil! 534,557fold
sil! 524,557fold
sil! 127,558fold
sil! 560,564fold
sil! 567,568fold
sil! 574,576fold
sil! 572,578fold
sil! 566,579fold
let &fdl = &fdl
let s:l = 579 - ((0 * winheight(0) + 17) / 34)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 579
normal! 0
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
