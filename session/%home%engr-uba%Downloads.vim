let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +654 ~/.bashrc
argglobal
%argdel
$argadd ~/.bashrc
edit ~/.bashrc
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
sil! 6,7fold
sil! 11,12fold
sil! 16,17fold
sil! 18,19fold
sil! 76,78fold
sil! 79,81fold
sil! 239,243fold
sil! 251,265fold
sil! 266,267fold
sil! 250,268fold
sil! 249,269fold
sil! 273,281fold
sil! 293,294fold
sil! 296,297fold
sil! 290,298fold
sil! 288,299fold
sil! 285,301fold
sil! 306,307fold
sil! 308,309fold
sil! 305,310fold
sil! 315,316fold
sil! 317,318fold
sil! 314,319fold
sil! 323,325fold
sil! 332,333fold
sil! 336,337fold
sil! 329,339fold
sil! 345,346fold
sil! 347,348fold
sil! 344,349fold
sil! 353,354fold
sil! 365,367fold
sil! 368,370fold
sil! 371,373fold
sil! 374,376fold
sil! 377,379fold
sil! 380,382fold
sil! 387,389fold
sil! 390,392fold
sil! 393,395fold
sil! 396,398fold
sil! 399,401fold
sil! 402,404fold
sil! 386,404fold
sil! 385,405fold
sil! 383,409fold
sil! 364,409fold
sil! 362,410fold
sil! 358,413fold
sil! 418,419fold
sil! 420,421fold
sil! 431,432fold
sil! 433,434fold
sil! 430,437fold
sil! 438,440fold
sil! 441,443fold
sil! 444,446fold
sil! 447,449fold
sil! 450,452fold
sil! 454,455fold
sil! 456,458fold
sil! 453,460fold
sil! 429,460fold
sil! 425,461fold
sil! 470,472fold
sil! 473,475fold
sil! 476,486fold
sil! 487,489fold
sil! 490,492fold
sil! 493,495fold
sil! 469,495fold
sil! 465,496fold
sil! 503,505fold
sil! 506,508fold
sil! 501,513fold
sil! 518,519fold
sil! 520,521fold
sil! 517,522fold
sil! 527,528fold
sil! 529,530fold
sil! 531,534fold
sil! 526,535fold
sil! 540,541fold
sil! 542,543fold
sil! 544,545fold
sil! 546,547fold
sil! 548,549fold
sil! 550,553fold
sil! 539,554fold
sil! 559,560fold
sil! 561,562fold
sil! 563,564fold
sil! 565,566fold
sil! 567,568fold
sil! 569,570fold
sil! 571,574fold
sil! 558,575fold
sil! 580,584fold
sil! 588,590fold
sil! 592,595fold
sil! 599,601fold
sil! 602,604fold
sil! 609,611fold
sil! 612,613fold
sil! 598,614fold
sil! 625,627fold
let &fdl = &fdl
let s:l = 655 - ((38 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 655
normal! 045|
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
