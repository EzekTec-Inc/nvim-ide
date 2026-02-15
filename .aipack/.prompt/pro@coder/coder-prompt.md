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
Investigate these errors and ensure to identify the root cause and apply the accurate corrective fixes to ensure they do NOT re-occur:

Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
stack traceback:
        ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: in function 'ts_highlighter'
        ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:119: in function 'highlighter'
        .../share/nvim/lazy/ui/lua/telescope/_extensions/themes.lua:27: in function 'define_preview'
        ...scope.nvim/lua/telescope/previewers/buffer_previewer.lua:392: in function 'preview'
        ...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:1088: in function 'refresh_previewer'
        ...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:1041: in function 'set_selection'
        ...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:1379: in function '_do_selection'
        ...share/nvim/lazy/telescope.nvim/lua/telescope/pickers.lua:1335: in function ''
        vim/_editor.lua: in function <vim/_editor.lua:0>

====
>   Info: Duration: 2m 4s | ~$0.1412 | Prompt Tokens: 62,497 (cached: 49,920) | Completion Tokens: 7,890 (reasoning: 7,223) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 75 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Harden Telescope ft_to_lang shim to prevent nil calls"
</suggested_git_command>

- Root cause: your Telescope version still calls the removed Neovim API `vim.treesitter.language.ft_to_lang()`. Even though you set it early, at runtime that field can become `nil` again (for example, if something clears it during plugin load), so Telescope previewers crash inside a scheduled callback.
- Fix: harden the shim by installing a metatable `__index` fallback on `vim.treesitter.language`, so `ft_to_lang` always resolves to the shim even if the key is later cleared. This keeps behavior minimal and avoids adding more load order hacks.




====
>   Info: Duration: 3m 7s | ~$0.2405 | Prompt Tokens: 57,899 (cached: 13,952) | Completion Tokens: 11,514 (reasoning: 10,782) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 75 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Harden treesitter ft_to_lang shim for telescope previewers"
</suggested_git_command>




====
>   Info: Duration: 3m 14s | ~$0.1922 | Prompt Tokens: 58,932 (cached: 56,960) | Completion Tokens: 12,769 (reasoning: 11,352) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 75 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Fix Telescope ft_to_lang shim persistence"
</suggested_git_command>

Root cause: Neovim 0.10 removed `vim.treesitter.language.ft_to_lang`, Telescope (and NvChad themes preview) still calls it, and the current shim can be lost when `vim.treesitter.language` is replaced or the key gets cleared later. Fix: install a small proxy for `vim.treesitter.language` that always supplies `ft_to_lang`, and ensure future `vim.treesitter.language = ...` assignments get wrapped too.






