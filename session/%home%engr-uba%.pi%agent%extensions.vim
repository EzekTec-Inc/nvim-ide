let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.pi/agent/extensions
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 ~/.pi/agent/extensions
badd +14 OLD_mcp-bridge.md
badd +1 model-status.ts
badd +29 notify.ts
badd +1 overlay-qa-tests.ts
badd +1 overlay-test.ts
badd +1 rainbow-editor.ts
badd +1 reload-runtime.ts
badd +45 summarize.ts
badd +25 tools.ts
argglobal
%argdel
$argadd ~/.pi/agent/extensions
edit summarize.ts
argglobal
balt tools.ts
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 6,10fold
sil! 15,17fold
sil! 13,18fold
sil! 22,23fold
sil! 26,27fold
sil! 32,33fold
sil! 37,38fold
sil! 31,39fold
sil! 21,42fold
sil! 46,47fold
sil! 52,53fold
sil! 57,58fold
sil! 51,62fold
sil! 45,65fold
sil! 72,73fold
sil! 80,81fold
sil! 89,90fold
sil! 86,91fold
sil! 94,95fold
sil! 98,99fold
sil! 71,100fold
sil! 68,103fold
sil! 107,114fold
sil! 106,115fold
sil! 118,119fold
sil! 137,138fold
sil! 136,139fold
sil! 133,140fold
sil! 122,141fold
sil! 117,142fold
sil! 153,154fold
sil! 152,156fold
sil! 159,160fold
sil! 164,165fold
sil! 169,170fold
sil! 173,174fold
sil! 178,181fold
sil! 177,182fold
sil! 187,190fold
sil! 148,192fold
sil! 146,193fold
sil! 145,194fold
let &fdl = &fdl
let s:l = 45 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 45
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
