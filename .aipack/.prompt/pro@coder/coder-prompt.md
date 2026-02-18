```yaml
#!meta (parametric prompt)

# See README.md for more documentation

## (relative to workspace dir, i.e. .aipack/ parent dir)
knowledge_globs:
  # - /rel/or/abs/path/to/**/*.md      # Any relatively or absolute path/globs to markdown
  - pro@coder/README.md              # To ask question about this pro@coder AIPack
  # - core@doc/**/*.md                 # To help build .aip AIPack agents
  - pro@rust10x/guide/base/**/*.md   # Example of best practices about Rust coding

## (relative to workspace dir)
base_dir: "" 

## File path & content included in prompt
## (relative to base_dir)
context_globs:
  # - package.json  # e.g., for Node.js
  # - Cargo.toml    # e.g., for Rust
  # - README.md 
  # - src/**/*.*      # Narrow glob when more than 10 files
  - lua/**/*.*
  - init.lua

## Only file paths included in prompt

## Only matched file paths included in prompt
## (relative to base_dir)
structure_globs:
  # - src/**/*.*
  - lua/**/*.*
  - init.lua

## Working Globs - Create a task per file or file group.
## (relative to base_dir)
working_globs:
  # - lua/**/*.*
  - init.lua
  - lua/configs/lspconfig.lua
  - lua/custom/configs/lspconfig.lua
#   - src/**/*.js
#   - ["css/*.css"]
input_concurrency: 3

# max_files_size_kb: 1000
cache_explicit: false  # (default false) Explicit cache for pro@coder prompt and knowledge files (Anthropic only)

# model_aliases:
#   my-model: gemini-pro-latest # example of any alias (see ~/.aipack-base/config-default.toml)

## Set to true to write the files
write_mode: true

## "udiffx" Experimental for now, will probably become the default.
# file_content_mode: udiffx 

# Full model names (any model name for available API Keys) 
# or aliases "opus" (Opus 4.5), "flash" (Gemini flash 3) (see aliases ~/.aipack-base/config-default.toml)
# Customize reasoning effort with -high, -medium, or -low suffix (e.g., "opus-high", "gpro-low")
model: gpt-5.2-high

## See README.md for more info
```
<rules>
- Ensure not to create bloat or introduce complexities to my nvim.
- Ensure to NOT EVER hallucinate about code or configurations of my nvim.
- Ensure to adhere strictly to the instructions I give to you.
- Ensure to always create a restore point should the user need to reverse the lastest changes applied to this nvim.
</rules>
Investigate and ensure that am able to copy contents from outside of my terminal and paste into nvim, and vice-versa.

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
