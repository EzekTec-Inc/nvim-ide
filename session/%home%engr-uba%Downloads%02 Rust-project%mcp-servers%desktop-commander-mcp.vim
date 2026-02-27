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
badd +72 Cargo.toml
badd +470 src/desktop_commander.rs
argglobal
%argdel
$argadd ./
edit src/desktop_commander.rs
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
sil! 84,86fold
sil! 95,97fold
sil! 100,108fold
sil! 111,113fold
sil! 116,121fold
sil! 124,126fold
sil! 129,133fold
sil! 136,139fold
sil! 142,145fold
sil! 148,152fold
sil! 155,163fold
sil! 166,172fold
sil! 175,177fold
sil! 183,185fold
sil! 188,194fold
sil! 200,203fold
sil! 206,210fold
sil! 219,221fold
sil! 226,232fold
sil! 234,239fold
sil! 242,250fold
sil! 253,255fold
sil! 252,256fold
sil! 261,269fold
sil! 260,270fold
sil! 276,278fold
sil! 274,279fold
sil! 272,280fold
sil! 284,286fold
sil! 293,299fold
sil! 287,302fold
sil! 284,302fold
sil! 305,307fold
sil! 314,320fold
sil! 308,323fold
sil! 305,323fold
sil! 326,327fold
sil! 329,331fold
sil! 335,337fold
sil! 334,339fold
sil! 348,354fold
sil! 332,357fold
sil! 329,357fold
sil! 362,363fold
sil! 360,364fold
sil! 374,380fold
sil! 365,383fold
sil! 360,383fold
sil! 388,390fold
sil! 386,391fold
sil! 401,407fold
sil! 392,410fold
sil! 386,410fold
sil! 413,415fold
sil! 422,428fold
sil! 416,431fold
sil! 413,431fold
sil! 434,436fold
sil! 443,449fold
sil! 437,452fold
sil! 434,452fold
sil! 455,457fold
sil! 464,470fold
sil! 458,473fold
sil! 455,473fold
sil! 476,478fold
sil! 485,491fold
sil! 479,494fold
sil! 476,494fold
sil! 497,499fold
sil! 506,512fold
sil! 500,515fold
sil! 497,515fold
sil! 519,521fold
sil! 528,534fold
sil! 522,537fold
sil! 519,537fold
sil! 540,542fold
sil! 549,555fold
sil! 543,558fold
sil! 540,558fold
sil! 561,563fold
sil! 570,576fold
sil! 564,579fold
sil! 561,579fold
sil! 583,585fold
sil! 592,598fold
sil! 586,601fold
sil! 583,601fold
sil! 606,610fold
sil! 604,611fold
sil! 615,617fold
sil! 614,619fold
sil! 627,633fold
sil! 612,636fold
sil! 604,636fold
sil! 639,641fold
sil! 648,654fold
sil! 642,657fold
sil! 639,657fold
sil! 662,665fold
sil! 660,666fold
sil! 670,672fold
sil! 669,674fold
sil! 683,689fold
sil! 667,692fold
sil! 660,692fold
sil! 695,697fold
sil! 701,703fold
sil! 700,705fold
sil! 710,716fold
sil! 698,719fold
sil! 695,719fold
sil! 722,724fold
sil! 728,730fold
sil! 727,732fold
sil! 740,746fold
sil! 725,749fold
sil! 722,749fold
sil! 754,756fold
sil! 752,757fold
sil! 761,763fold
sil! 760,765fold
sil! 773,779fold
sil! 758,782fold
sil! 752,782fold
sil! 787,789fold
sil! 785,790fold
sil! 794,796fold
sil! 793,798fold
sil! 806,812fold
sil! 791,815fold
sil! 785,815fold
sil! 818,820fold
sil! 824,826fold
sil! 823,828fold
sil! 836,842fold
sil! 821,845fold
sil! 818,845fold
sil! 848,850fold
sil! 857,863fold
sil! 851,866fold
sil! 848,866fold
sil! 872,876fold
sil! 870,877fold
sil! 887,893fold
sil! 878,896fold
sil! 870,896fold
sil! 901,904fold
sil! 899,905fold
sil! 915,921fold
sil! 906,924fold
sil! 899,924fold
sil! 927,929fold
sil! 936,942fold
sil! 930,945fold
sil! 927,945fold
sil! 948,950fold
sil! 957,963fold
sil! 951,966fold
sil! 948,966fold
sil! 969,970fold
sil! 974,978fold
sil! 972,979fold
sil! 989,995fold
sil! 980,998fold
sil! 972,998fold
sil! 1002,1004fold
sil! 1011,1017fold
sil! 1005,1020fold
sil! 1002,1020fold
sil! 1023,1025fold
sil! 1035,1041fold
sil! 1026,1044fold
sil! 1023,1044fold
sil! 1046,1047fold
sil! 1051,1053fold
sil! 1049,1054fold
sil! 1064,1070fold
sil! 1055,1073fold
sil! 1049,1073fold
sil! 259,1074fold
sil! 1079,1088fold
sil! 1078,1089fold
sil! 1091,1094fold
sil! 1097,1102fold
sil! 1096,1104fold
sil! 1096,1105fold
sil! 1095,1106fold
sil! 1091,1106fold
sil! 1108,1111fold
sil! 1119,1121fold
sil! 1129,1130fold
sil! 1129,1131fold
sil! 1114,1132fold
sil! 1138,1140fold
sil! 1148,1149fold
sil! 1148,1150fold
sil! 1133,1151fold
sil! 1157,1159fold
sil! 1167,1168fold
sil! 1167,1169fold
sil! 1152,1170fold
sil! 1173,1174fold
sil! 1171,1175fold
sil! 1113,1177fold
sil! 1112,1178fold
sil! 1108,1178fold
sil! 1180,1183fold
sil! 1190,1193fold
sil! 1187,1194fold
sil! 1185,1195fold
sil! 1185,1196fold
sil! 1184,1197fold
sil! 1180,1197fold
sil! 1199,1202fold
sil! 1208,1209fold
sil! 1212,1213fold
sil! 1217,1219fold
sil! 1215,1220fold
sil! 1215,1221fold
sil! 1205,1222fold
sil! 1204,1224fold
sil! 1203,1225fold
sil! 1199,1225fold
sil! 1227,1230fold
sil! 1232,1234fold
sil! 1232,1235fold
sil! 1231,1236fold
sil! 1227,1236fold
sil! 1238,1241fold
sil! 1243,1247fold
sil! 1242,1249fold
sil! 1238,1249fold
sil! 1077,1250fold
let &fdl = &fdl
let s:l = 478 - ((28 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 478
normal! 049|
lcd ~/Downloads/02\ Rust-project/mcp-servers/desktop-commander-mcp
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
