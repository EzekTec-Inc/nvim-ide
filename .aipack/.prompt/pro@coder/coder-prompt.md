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
>   Info: Duration: 2m 26s | ~$0.1623 | Prompt Tokens: 65,205 (cached: 52,096) | Completion Tokens: 9,306 (reasoning: 8,113) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 74 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "^ nvim - Fix system clipboard copy/paste (restore default y/p) and add restore point"
</suggested_git_command>





If copy and paste still does not work after this change:

- Run `:checkhealth provider` and ensure you have a clipboard provider installed for your OS (for example, `wl-clipboard` on Wayland, `xclip` or `xsel` on X11, `pbcopy/pbpaste` on macOS).
- Verify the mappings were actually removed, run `:verbose nmap y` and `:verbose nmap p`, they should not point to `'"0y'` or `'"0p'`.
====
>   Info: Duration: 3m 44s | ~$0.2953 | Prompt Tokens: 59,048 | Completion Tokens: 13,713 (reasoning: 12,377) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 74 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Fix clipboard copy and paste integration"
</suggested_git_command>






====
>   Info: Duration: 4m 9s | ~$0.222 | Prompt Tokens: 60,152 (cached: 57,984) | Completion Tokens: 14,862 (reasoning: 14,271) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 74 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Fix system clipboard yank and paste mappings"
</suggested_git_command>




