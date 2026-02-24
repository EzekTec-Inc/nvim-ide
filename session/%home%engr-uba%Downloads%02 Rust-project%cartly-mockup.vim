let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/cartly-mockup
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +153 src/components/main_content.rs
badd +42 src/models.rs
badd +10 src/components/header.rs
argglobal
%argdel
$argadd .
edit src/components/main_content.rs
argglobal
balt src/components/header.rs
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 8,10fold
sil! 12,14fold
sil! 16,18fold
sil! 20,22fold
sil! 24,26fold
sil! 28,30fold
sil! 7,31fold
sil! 35,38fold
sil! 40,43fold
sil! 45,48fold
sil! 34,49fold
sil! 53,59fold
sil! 61,67fold
sil! 69,75fold
sil! 77,83fold
sil! 85,91fold
sil! 52,92fold
sil! 96,101fold
sil! 103,108fold
sil! 110,115fold
sil! 95,116fold
sil! 121,125fold
sil! 130,132fold
sil! 129,133fold
sil! 127,134fold
sil! 120,135fold
sil! 119,136fold
sil! 6,137fold
sil! 147,150fold
sil! 146,150fold
sil! 145,152fold
sil! 144,152fold
sil! 162,164fold
sil! 167,169fold
sil! 161,170fold
sil! 160,171fold
sil! 159,172fold
sil! 157,173fold
sil! 156,174fold
sil! 155,175fold
sil! 140,176fold
sil! 183,185fold
sil! 182,186fold
sil! 181,187fold
sil! 180,188fold
sil! 179,189fold
sil! 195,197fold
sil! 194,199fold
sil! 193,200fold
sil! 192,201fold
sil! 210,212fold
sil! 209,213fold
sil! 208,214fold
sil! 206,215fold
sil! 205,216fold
sil! 204,217fold
sil! 222,225fold
sil! 221,226fold
sil! 220,227fold
sil! 234,236fold
sil! 233,237fold
sil! 239,241fold
sil! 246,248fold
sil! 250,252fold
sil! 249,253fold
sil! 245,254fold
sil! 243,255fold
sil! 257,259fold
sil! 232,260fold
sil! 231,261fold
sil! 230,261fold
let &fdl = &fdl
let s:l = 153 - ((18 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 153
normal! 07|
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
