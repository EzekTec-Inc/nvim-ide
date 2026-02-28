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
badd +1 ~/Downloads/02\ Rust-project/mcp-servers/developer
badd +92 src/developer/agents.rs
badd +46 Cargo.toml
badd +561 src/developer/mod.rs
badd +98 src/developer/screen_capture.rs
argglobal
%argdel
$argadd ~/Downloads/02\ Rust-project/mcp-servers/developer
edit src/developer/mod.rs
argglobal
balt src/developer/screen_capture.rs
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 2,9fold
sil! 22,23fold
sil! 19,35fold
sil! 39,45fold
sil! 52,53fold
sil! 49,55fold
sil! 62,63fold
sil! 59,65fold
sil! 76,77fold
sil! 82,83fold
sil! 86,87fold
sil! 90,91fold
sil! 94,95fold
sil! 69,97fold
sil! 104,105fold
sil! 108,109fold
sil! 101,111fold
sil! 115,117fold
sil! 121,125fold
sil! 129,137fold
sil! 141,143fold
sil! 147,151fold
sil! 179,181fold
sil! 177,184fold
sil! 185,187fold
sil! 176,188fold
sil! 192,194fold
sil! 195,197fold
sil! 191,198fold
sil! 202,204fold
sil! 205,207fold
sil! 201,208fold
sil! 212,222fold
sil! 226,227fold
sil! 225,228fold
sil! 241,242fold
sil! 248,250fold
sil! 246,250fold
sil! 254,257fold
sil! 260,261fold
sil! 259,270fold
sil! 233,271fold
sil! 278,279fold
sil! 276,280fold
sil! 274,281fold
sil! 284,285fold
sil! 299,301fold
sil! 298,303fold
sil! 296,304fold
sil! 289,305fold
sil! 232,309fold
sil! 335,342fold
sil! 333,343fold
sil! 352,353fold
sil! 351,355fold
sil! 358,359fold
sil! 361,362fold
sil! 364,366fold
sil! 357,366fold
sil! 369,371fold
sil! 349,372fold
sil! 344,373fold
sil! 380,383fold
sil! 378,384fold
sil! 385,386fold
sil! 390,391fold
sil! 393,394fold
sil! 397,398fold
sil! 402,404fold
sil! 400,405fold
sil! 406,407fold
sil! 411,412fold
sil! 414,416fold
sil! 417,422fold
sil! 332,426fold
sil! 457,466fold
sil! 455,467fold
sil! 471,480fold
sil! 468,483fold
sil! 487,488fold
sil! 454,488fold
sil! 499,502fold
sil! 497,503fold
sil! 504,509fold
sil! 495,513fold
sil! 519,521fold
sil! 522,527fold
sil! 518,531fold
sil! 538,540fold
sil! 541,546fold
sil! 550,551fold
sil! 537,551fold
sil! 563,567fold
sil! 561,568fold
sil! 570,572fold
sil! 569,572fold
sil! 576,577fold
sil! 579,581fold
sil! 582,583fold
sil! 586,587fold
sil! 589,591fold
sil! 592,593fold
sil! 559,594fold
sil! 602,606fold
sil! 600,608fold
sil! 599,609fold
sil! 612,615fold
sil! 618,620fold
sil! 617,622fold
sil! 616,623fold
sil! 626,629fold
sil! 633,634fold
sil! 635,636fold
sil! 632,637fold
sil! 641,642fold
sil! 639,643fold
sil! 647,648fold
sil! 645,649fold
sil! 631,650fold
sil! 630,651fold
sil! 654,657fold
sil! 664,667fold
sil! 661,668fold
sil! 659,669fold
sil! 658,670fold
sil! 673,676fold
sil! 682,683fold
sil! 680,684fold
sil! 686,687fold
sil! 691,693fold
sil! 689,694fold
sil! 679,695fold
sil! 678,697fold
sil! 677,698fold
sil! 701,704fold
sil! 706,708fold
sil! 705,709fold
sil! 712,715fold
sil! 717,720fold
sil! 716,722fold
sil! 598,723fold
sil! 731,733fold
sil! 737,743fold
sil! 750,754fold
sil! 755,759fold
sil! 747,760fold
sil! 768,771fold
sil! 764,772fold
sil! 777,781fold
sil! 782,786fold
sil! 776,787fold
sil! 792,795fold
sil! 796,798fold
sil! 791,799fold
sil! 807,808fold
sil! 809,810fold
sil! 803,811fold
sil! 727,815fold
let &fdl = &fdl
232
sil! normal! zo
289
sil! normal! zo
332
sil! normal! zo
559
sil! normal! zo
561
sil! normal! zo
let s:l = 561 - ((25 * winheight(0) + 21) / 43)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 561
normal! 022|
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
