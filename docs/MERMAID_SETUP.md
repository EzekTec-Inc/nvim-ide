# Live Preview + Mermaid Configuration Guide

## ✅ Configuration Complete

Your Neovim has been configured with **live-preview.nvim** for rendering mermaid diagrams and markdown files in real-time.

### What's Installed

1. **live-preview.nvim** (`brianhuster/live-preview.nvim`)
   - Real-time markdown/HTML preview in browser
   - Automatic mermaid diagram rendering
   - Auto-refresh on file save
   - Runs on localhost:5500

### Key Features Enabled

- ✅ Mermaid diagram support
- ✅ Auto-refresh on save
- ✅ Firefox browser integration (configurable)
- ✅ Support for markdown, HTML, and Vue files

### Keybindings

| Keymap | Action |
|--------|--------|
| `<leader>lp` | Toggle Live Preview |
| `<leader>ls` | Stop Live Preview |

### How to Use

#### 1. **Start Live Preview**
```bash
# Open a markdown file in Neovim
nvim example.md

# Then in Normal mode:
:LivePreview
# Or press: <leader>lp
```

#### 2. **Preview Mermaid Diagrams**
Create a markdown file with a mermaid code block:

```markdown
# My Diagram

Here's a flowchart:

\`\`\`mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Process]
    B -->|No| D[End]
    C --> D
\`\`\`
```

Save the file → Browser preview updates automatically with rendered diagram

#### 3. **Stop Preview**
```vim
:LivePreviewStop
# Or press: <leader>ls
```

### Supported Mermaid Diagram Types

See `~/.config/nvim/snippets/mermaid_diagrams.md` for templates:

- Flowchart
- Sequence Diagram
- Gantt Chart
- State Diagram
- Class Diagram
- Pie Chart
- Git Graph
- Entity Relationship Diagram

### Prerequisites

Ensure you have these installed:

```bash
# Node.js (required for live-preview.nvim)
node --version

# Firefox or Chrome (browser for preview)
firefox --version
```

### Customization

Edit `~/.config/nvim/lua/plugins/live_preview_nvim.lua` to:

- Change browser: `browser = "chrome"` or `"chromium"`
- Change port: `port = 8000`
- Toggle auto-refresh: `auto_refresh = false`

### Troubleshooting

**Issue: "npm install failed"**
- Solution: Ensure Node.js is installed: `npm --version`

**Issue: Browser doesn't open**
- Solution: Change browser setting in live_preview_nvim.lua to one available on your system

**Issue: Diagrams not rendering**
- Solution: Ensure code block language is `mermaid`:
  ````
  ```mermaid
  flowchart...
  ```
  ````

### Next Steps

1. Run `:Lazy` to sync plugins
2. Open a markdown file with mermaid diagrams
3. Press `<leader>lp` to preview
4. Edit and save → preview updates automatically

---

**Last configured**: 2026-03-11
**Configuration file**: `~/.config/nvim/lua/plugins/live_preview_nvim.lua`
**Keymaps**: `~/.config/nvim/lua/mappings.lua`
**Templates**: `~/.config/nvim/snippets/mermaid_diagrams.md`
