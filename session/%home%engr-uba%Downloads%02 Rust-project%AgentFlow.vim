let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/02\ Rust-project/AgentFlow
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +556 README.md
badd +25 Cargo.toml
badd +64 examples/agent.rs
badd +43 examples/workflow.rs
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
sil! 11,16fold
sil! 10,25fold
sil! 67,70fold
sil! 66,71fold
sil! 62,76fold
sil! 83,85fold
sil! 106,109fold
sil! 105,110fold
sil! 113,116fold
sil! 112,117fold
sil! 103,123fold
sil! 130,135fold
sil! 163,167fold
sil! 190,193fold
sil! 189,194fold
sil! 198,201fold
sil! 197,202fold
sil! 185,207fold
sil! 214,217fold
sil! 241,245fold
sil! 263,264fold
sil! 261,269fold
sil! 260,270fold
sil! 296,298fold
sil! 376,378fold
sil! 446,450fold
sil! 445,451fold
sil! 443,459fold
sil! 470,472fold
sil! 478,481fold
let &fdl = &fdl
let s:l = 553 - ((19 * winheight(0) + 20) / 40)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 553
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
