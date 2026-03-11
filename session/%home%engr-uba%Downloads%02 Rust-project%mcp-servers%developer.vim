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
badd +1 Cargo.toml
badd +8 README.md
argglobal
%argdel
$argadd .
edit README.md
argglobal
balt Cargo.toml
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 7,19fold
sil! 5,19fold
sil! 23,30fold
sil! 21,32fold
sil! 45,47fold
sil! 34,49fold
sil! 53,59fold
sil! 62,63fold
sil! 51,65fold
sil! 71,80fold
sil! 85,87fold
sil! 91,93fold
sil! 97,101fold
sil! 105,107fold
sil! 82,109fold
sil! 67,109fold
sil! 113,116fold
sil! 113,118fold
sil! 120,132fold
sil! 111,138fold
sil! 140,149fold
sil! 164,166fold
sil! 153,166fold
sil! 168,176fold
sil! 178,187fold
sil! 189,191fold
sil! 193,200fold
sil! 202,216fold
sil! 218,228fold
sil! 230,239fold
sil! 241,247fold
sil! 249,256fold
sil! 258,263fold
sil! 265,271fold
sil! 151,271fold
sil! 278,284fold
sil! 277,284fold
sil! 287,292fold
sil! 286,292fold
sil! 295,299fold
sil! 294,299fold
sil! 302,307fold
sil! 301,307fold
sil! 310,317fold
sil! 309,317fold
sil! 320,324fold
sil! 319,324fold
sil! 327,331fold
sil! 326,331fold
sil! 334,339fold
sil! 333,341fold
sil! 273,341fold
sil! 345,357fold
sil! 359,373fold
sil! 343,375fold
sil! 381,407fold
sil! 379,407fold
sil! 411,422fold
sil! 409,422fold
sil! 426,432fold
sil! 424,432fold
sil! 436,447fold
sil! 434,447fold
sil! 451,461fold
sil! 449,461fold
sil! 465,469fold
sil! 463,471fold
sil! 377,471fold
sil! 475,483fold
sil! 473,485fold
sil! 487,489fold
sil! 1,489fold
let &fdl = &fdl
let s:l = 8 - ((7 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 8
normal! 03|
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
