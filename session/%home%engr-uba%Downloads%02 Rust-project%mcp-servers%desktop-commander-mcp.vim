let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/mcp-servers/desktop-commander-mcp
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 ~/Downloads/02\ Rust-project/mcp-servers/desktop-commander-mcp
badd +471 src/desktop_commander.rs
badd +42 README.md
badd +1 web-calls.rest
argglobal
%argdel
$argadd ~/Downloads/02\ Rust-project/mcp-servers/desktop-commander-mcp
edit src/desktop_commander.rs
argglobal
balt README.md
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 1,7fold
sil! 1,11fold
sil! 15,22fold
sil! 28,29fold
sil! 30,31fold
sil! 26,37fold
sil! 25,38fold
sil! 24,39fold
sil! 45,47fold
sil! 50,54fold
sil! 57,63fold
sil! 66,69fold
sil! 72,76fold
sil! 79,81fold
sil! 90,92fold
sil! 95,103fold
sil! 106,108fold
sil! 111,116fold
sil! 119,121fold
sil! 124,128fold
sil! 131,134fold
sil! 137,140fold
sil! 143,147fold
sil! 150,158fold
sil! 161,167fold
sil! 170,172fold
sil! 178,180fold
sil! 183,189fold
sil! 195,198fold
sil! 201,205fold
sil! 207,212fold
sil! 214,218fold
sil! 221,228fold
sil! 231,233fold
sil! 230,234fold
sil! 239,246fold
sil! 238,247fold
sil! 253,255fold
sil! 251,256fold
sil! 249,257fold
sil! 261,263fold
sil! 270,276fold
sil! 264,279fold
sil! 261,279fold
sil! 282,284fold
sil! 291,297fold
sil! 285,300fold
sil! 282,300fold
sil! 303,304fold
sil! 306,308fold
sil! 312,314fold
sil! 311,316fold
sil! 325,331fold
sil! 309,334fold
sil! 306,334fold
sil! 339,340fold
sil! 337,341fold
sil! 351,357fold
sil! 342,360fold
sil! 337,360fold
sil! 365,367fold
sil! 363,368fold
sil! 378,384fold
sil! 369,387fold
sil! 363,387fold
sil! 390,392fold
sil! 399,405fold
sil! 393,408fold
sil! 390,408fold
sil! 411,413fold
sil! 420,426fold
sil! 414,429fold
sil! 411,429fold
sil! 432,434fold
sil! 441,447fold
sil! 435,450fold
sil! 432,450fold
sil! 453,455fold
sil! 462,468fold
sil! 456,471fold
sil! 453,471fold
sil! 477,481fold
sil! 475,482fold
sil! 486,488fold
sil! 485,490fold
sil! 498,504fold
sil! 483,507fold
sil! 475,507fold
sil! 510,512fold
sil! 519,525fold
sil! 513,528fold
sil! 510,528fold
sil! 533,536fold
sil! 531,537fold
sil! 541,543fold
sil! 540,545fold
sil! 554,560fold
sil! 538,563fold
sil! 531,563fold
sil! 566,568fold
sil! 572,574fold
sil! 571,576fold
sil! 581,587fold
sil! 569,590fold
sil! 566,590fold
sil! 593,595fold
sil! 599,601fold
sil! 598,603fold
sil! 611,617fold
sil! 596,620fold
sil! 593,620fold
sil! 625,627fold
sil! 623,628fold
sil! 632,634fold
sil! 631,636fold
sil! 644,650fold
sil! 629,653fold
sil! 623,653fold
sil! 658,660fold
sil! 656,661fold
sil! 665,667fold
sil! 664,669fold
sil! 677,683fold
sil! 662,686fold
sil! 656,686fold
sil! 689,691fold
sil! 695,697fold
sil! 694,699fold
sil! 707,713fold
sil! 692,716fold
sil! 689,716fold
sil! 719,721fold
sil! 728,734fold
sil! 722,737fold
sil! 719,737fold
sil! 743,747fold
sil! 741,748fold
sil! 758,764fold
sil! 749,767fold
sil! 741,767fold
sil! 772,775fold
sil! 770,776fold
sil! 786,792fold
sil! 777,795fold
sil! 770,795fold
sil! 798,800fold
sil! 807,813fold
sil! 801,816fold
sil! 798,816fold
sil! 819,821fold
sil! 828,834fold
sil! 822,837fold
sil! 819,837fold
sil! 840,841fold
sil! 845,849fold
sil! 843,850fold
sil! 860,866fold
sil! 851,869fold
sil! 843,869fold
sil! 873,875fold
sil! 882,888fold
sil! 876,891fold
sil! 873,891fold
sil! 894,896fold
sil! 906,912fold
sil! 897,915fold
sil! 894,915fold
sil! 917,918fold
sil! 922,924fold
sil! 920,925fold
sil! 935,941fold
sil! 926,944fold
sil! 920,944fold
sil! 237,945fold
sil! 950,959fold
sil! 949,960fold
sil! 962,965fold
sil! 968,973fold
sil! 967,975fold
sil! 967,976fold
sil! 966,977fold
sil! 962,977fold
sil! 979,982fold
sil! 990,992fold
sil! 1000,1001fold
sil! 1000,1002fold
sil! 985,1003fold
sil! 1009,1011fold
sil! 1019,1020fold
sil! 1019,1021fold
sil! 1004,1022fold
sil! 1028,1030fold
sil! 1038,1039fold
sil! 1038,1040fold
sil! 1023,1041fold
sil! 1044,1045fold
sil! 1042,1046fold
sil! 984,1048fold
sil! 983,1049fold
sil! 979,1049fold
sil! 1051,1054fold
sil! 1061,1064fold
sil! 1058,1065fold
sil! 1056,1066fold
sil! 1056,1067fold
sil! 1055,1068fold
sil! 1051,1068fold
sil! 1070,1073fold
sil! 1079,1080fold
sil! 1083,1084fold
sil! 1088,1090fold
sil! 1086,1091fold
sil! 1086,1092fold
sil! 1076,1093fold
sil! 1075,1095fold
sil! 1074,1096fold
sil! 1070,1096fold
sil! 1098,1101fold
sil! 1103,1105fold
sil! 1103,1106fold
sil! 1102,1107fold
sil! 1098,1107fold
sil! 1109,1112fold
sil! 1114,1118fold
sil! 1113,1120fold
sil! 1109,1120fold
sil! 948,1121fold
let &fdl = &fdl
let s:l = 464 - ((0 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 464
normal! 014|
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
