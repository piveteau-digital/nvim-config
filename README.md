# 🚀 Ultimate TypeScript/React Neovim Configuration

A complete, modular Neovim configuration optimized for TypeScript, React, NextJS, React Native, and monorepo development with IntelliJ-style shortcuts.

## ✨ Features

### 🎯 Core Technologies
- **TypeScript/JavaScript** with enhanced LSP support
- **React 19+** with JSX/TSX auto-completion
- **React Native 0.81+** development support
- **NextJS 15+** framework integration
- **Turbo Monorepo** workspace management
- **TailwindCSS V3/V4** with intelligent suggestions

### 🔧 Development Tools
- **Enhanced LSP** with TypeScript Tools
- **Auto-formatting** with Prettier & ESLint
- **Testing** with Jest & Vitest integration
- **Debugging** with DAP for Node.js & Chrome
- **Git integration** with GitHub support
- **Package management** for npm/yarn/pnpm

### 🎨 UI & UX
- **Tokyo Night** theme with custom highlights
- **IntelliJ-style shortcuts** (Cmd+P, Cmd+F, etc.)
- **File explorer** with project detection
- **Fuzzy finding** with Telescope
- **Terminal integration** with ToggleTerm
- **Status line** with LSP info

## 📁 File Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua         # Vim options & settings
│   │   ├── keymaps.lua         # Key mappings & shortcuts
│   │   └── autocmds.lua        # Auto commands & events
│   └── plugins/
│       ├── init.lua            # Plugin manager setup
│       ├── ui.lua              # Theme, statusline, file explorer
│       ├── treesitter.lua      # Syntax highlighting
│       ├── telescope.lua       # Fuzzy finder & search
│       ├── lsp.lua             # Language server protocol
│       ├── completion.lua      # Auto-completion & snippets
│       ├── formatting.lua      # Code formatting
│       ├── react.lua           # React/TypeScript specific
│       ├── testing.lua         # Testing & debugging
│       ├── git.lua             # Git integration
│       └── utils.lua           # Utility plugins
└── README.md                   # This file
```

## ⚡ Quick Start

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone or copy this configuration**:
   ```bash
   # Copy the files to ~/.config/nvim/
   ```

3. **Install dependencies**:
   ```bash
   # Install Node.js, npm, and required tools
   npm install -g typescript prettier eslint
   ```

4. **Launch Neovim**:
   ```bash
   nvim
   ```
   Plugins will auto-install on first launch.

## 🎮 Key Mappings

### 🍎 macOS IntelliJ-Style Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+P` | Find Files | Quick file finder |
| `Cmd+F` | Search in Files | Global text search |
| `Cmd+E` | Recent Files | Recently opened files |
| `Cmd+R` | Find References | LSP references |
| `Cmd+B` | Go to Definition | Jump to definition |
| `Cmd+/` | Toggle Comment | Comment/uncomment lines |
| `Cmd+D` | Duplicate Line | Duplicate current line |
| `Cmd+S` | Save File | Save current file |
| `Cmd+W` | Close Buffer | Close current buffer |
| `Cmd+1` | File Explorer | Toggle file tree |
| `Cmd+Enter` | Code Actions | Show available actions |
| `Cmd+Shift+F` | Format Code | Format document |
| `Cmd+Shift+R` | Rename Symbol | Rename variable/function |

### 🚀 Leader Key Shortcuts (Space)

#### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files

#### LSP & Code
- `<leader>ca` - Code actions
- `<leader>rn` - Rename
- `<leader>f` - Format
- `<leader>rf` - File references (TypeScript)
- `<leader>oi` - Organize imports
- `<leader>ai` - Add missing imports

#### Git
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line

#### Testing & Debug
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>td` - Debug test
- `<leader>b` - Toggle breakpoint

#### Package Management
- `<leader>ns` - Show package versions
- `<leader>nu` - Update package
- `<leader>ni` - Install package

## 🔧 TypeScript/React Features

### 🎯 Enhanced TypeScript Support
- **TypeScript Tools** with advanced features
- **Auto imports** and import organization
- **Inlay hints** for parameters and types
- **File references** and rename file
- **Go to source definition**
- **Remove unused imports/variables**

### ⚛️ React Development
- **JSX/TSX auto-completion**
- **Component snippets** (ES7+ React snippets)
- **Auto-closing tags**
- **Import cost display**
- **Tailwind CSS integration**
- **Package.json management**

### 📱 React Native Support
- **React Native snippets**
- **Debugging configuration**
- **Metro bundler integration**
- **Device simulation support**

### 🏗️ Monorepo Features
- **Turbo/Nx workspace detection**
- **Multi-package testing**
- **Project-specific settings**
- **Workspace-aware file search**

## 🧪 Testing & Debugging

### Testing Frameworks
- **Jest** with watch mode
- **Vitest** for modern projects
- **React Testing Library** support
- **Coverage reports**

### Debugging Capabilities
- **Node.js debugging**
- **Chrome browser debugging**
- **Jest test debugging**
- **React Native debugging**
- **Breakpoints and watch variables**

## 🌈 Customization

### Changing Theme
Edit `lua/plugins/ui.lua`:
```lua
-- Replace 'tokyonight' with your preferred theme
vim.cmd.colorscheme('your-theme')
```

### Adding Custom Keymaps
Edit `lua/config/keymaps.lua`:
```lua
vim.keymap.set('n', '<your-key>', '<your-action>', { desc = 'Description' })
```

### Project-Specific Settings
The config auto-detects project types and applies appropriate settings:
- **Node.js projects** (package.json) → 2-space indentation
- **Rust projects** (Cargo.toml) → 4-space indentation
- **Python projects** (pyproject.toml) → 4-space indentation

## 🛠️ Dependencies

### Required
- **Neovim 0.9.0+**
- **Node.js 18+**
- **Git**
- **ripgrep** (for telescope)
- **fd** (optional, for better file finding)

### Language Servers (Auto-installed)
- `typescript-language-server`
- `eslint-lsp`
- `tailwindcss-language-server`
- `css-lsp`
- `html-lsp`
- `json-lsp`
- `emmet-ls`

### Formatters (Auto-installed)
- `prettier`
- `stylua`
- `black` (Python)
- `rustfmt` (Rust)

## 🎯 Pro Tips

1. **Use `jk` or `jj`** to exit insert mode quickly
2. **Press `Space`** and wait to see available shortcuts
3. **Use `s` + 2 characters** for quick navigation (Hop)
4. **Press `gcc`** to comment/uncomment lines
5. **Use `Ctrl+\`** to toggle terminal
6. **Press `]d` / `[d`** to navigate diagnostics
7. **Use `]h` / `[h`** to navigate git hunks

## 🐛 Troubleshooting

### Plugin Issues
```vim
:Lazy sync          " Update all plugins
:Lazy clean         " Remove unused plugins
:Mason              " Manage LSP servers
```

### LSP Issues
```vim
:LspInfo            " Check LSP status
:LspRestart         " Restart LSP
:TSToolsFixAll      " Fix TypeScript issues
```

### Performance Issues
- Disable unused plugins in respective config files
- Reduce `updatetime` in `options.lua`
- Use `:Lazy profile` to identify slow plugins

## 🤝 Contributing

Feel free to:
- Report issues
- Suggest improvements
- Add new features
- Share your customizations

## 📄 License

This configuration is free to use and modify. Enjoy coding! 🎉

---

**Happy coding with the ultimate TypeScript/React Neovim setup!** 🚀 