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
badd +290 src/mcp/client.rs
badd +21 README.md
badd +1 examples/mcp_client.rs
argglobal
%argdel
$argadd .
edit examples/mcp_client.rs
argglobal
balt src/mcp/client.rs
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 15,20fold
sil! 24,31fold
sil! 35,40fold
sil! 44,49fold
sil! 53,56fold
sil! 64,66fold
sil! 63,66fold
sil! 60,69fold
sil! 59,69fold
sil! 74,77fold
sil! 79,81fold
sil! 73,82fold
sil! 86,93fold
sil! 104,105fold
sil! 110,112fold
sil! 109,114fold
sil! 116,119fold
sil! 131,138fold
sil! 152,156fold
sil! 159,160fold
sil! 163,166fold
sil! 162,170fold
sil! 175,177fold
sil! 173,177fold
sil! 186,187fold
sil! 188,189fold
sil! 183,192fold
sil! 195,198fold
sil! 201,205fold
sil! 200,207fold
sil! 210,214fold
sil! 217,218fold
sil! 216,220fold
sil! 222,224fold
sil! 215,225fold
sil! 209,226fold
sil! 228,230fold
sil! 208,231fold
sil! 181,235fold
sil! 238,241fold
sil! 237,244fold
sil! 180,245fold
sil! 148,248fold
sil! 145,249fold
sil! 259,262fold
sil! 267,271fold
sil! 275,280fold
sil! 274,281fold
sil! 284,287fold
sil! 288,290fold
sil! 273,291fold
sil! 295,300fold
sil! 293,303fold
sil! 272,304fold
sil! 266,305fold
sil! 309,314fold
sil! 307,317fold
sil! 265,318fold
sil! 255,320fold
sil! 253,321fold
sil! 332,334fold
sil! 331,338fold
sil! 342,344fold
sil! 341,345fold
sil! 346,347fold
sil! 358,360fold
sil! 356,361fold
sil! 355,363fold
sil! 353,363fold
sil! 370,371fold
sil! 372,373fold
sil! 369,376fold
sil! 367,379fold
sil! 382,384fold
sil! 381,387fold
sil! 366,388fold
sil! 327,390fold
sil! 325,391fold
sil! 398,401fold
sil! 404,407fold
sil! 417,418fold
sil! 422,424fold
sil! 421,425fold
sil! 427,429fold
sil! 419,430fold
sil! 97,433fold
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 042|
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
