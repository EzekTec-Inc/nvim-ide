====
>   Info: Duration: 2m 38s | ~$0.1669 | Prompt Tokens: 63,181 (cached: 57,088) | Completion Tokens: 10,446 (reasoning: 9,400) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 73 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "^ nvim - lock lsp keymaps (gD/gd/K) and restore gk/gq in lsp buffers"
</suggested_git_command>




====
>   Info: Duration: 3m 35s | ~$0.2178 | Prompt Tokens: 57,821 (cached: 52,096) | Completion Tokens: 14,188 (reasoning: 12,994) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 73 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Stabilize core lsp keymaps (gD/gd/K/gk) and preserve gq formatting"
</suggested_git_command>




====
>   Info: Duration: 6m 10s | ~$0.4476 | Prompt Tokens: 58,885 | Completion Tokens: 24,613 (reasoning: 23,483) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 73 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "^ nvim - Harden core LSP keymaps (gD, gd, K, gK)"
</suggested_git_command>







- Investigation results, from the files you provided:
  - `gD` and `gd` were only being set inside LSP `on_attach` functions, which means any LSP client that does not call your shared `on_attach` could miss them.
  - `K` was not mapped in your shared LSP mapping code, and Rust specific tooling can define its own `K` mapping.
  - I did not find any explicit mappings for `gk` or `gq` in the provided config files, so if those are changing it is likely coming from a plugin. You can confirm with `:verbose nmap gk` and `:verbose nmap gq` in the affected buffer.
- What the change does:
  - Adds an early `LspAttach` autocmd in `init.lua` that applies buffer local mappings for `gD`, `gd`, `K`, and `gK` after attach, so they win even if other code sets mappings during attach.
