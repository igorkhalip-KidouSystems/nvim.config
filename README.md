# Neovim Configuration

Personal Neovim setup with modern plugins and LSP support.

## Installation

1. Clone this repository:
```bash
git clone <your-repo-url> ~/.config/nvim
```

2. Run the setup script:
```bash
cd ~/.config/nvim
chmod +x setup.sh
./setup.sh
```

3. Install clipboard manager (required for system clipboard integration):
```bash
sudo apt update && sudo apt install xclip
```

4. Add Neovim to your PATH (if not done automatically):
```bash
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
source ~/.bashrc
```

5. Start Neovim:
```bash
nvim
```

The setup script will automatically download and install the latest Neovim version and configure all plugins.

## Features

- **LSP Support**: C++, Python, Lua with autocompletion and diagnostics
- **Syntax Highlighting**: Enhanced with Treesitter
- **File Explorer**: nvim-tree for project navigation
- **Fuzzy Finder**: Telescope for quick file/text search
- **Git Integration**: Visual git changes with gitsigns
- **Dark Theme**: Tokyo Night theme
- **System Clipboard**: Integrated with system clipboard (requires xclip)
- **Keybinding Hints**: which-key shows available commands

## Keybindings

**Leader Key:** `<Space>`

### General
- `<Esc>` - Clear search highlights
- `<Esc><Esc>` - Exit terminal mode (in terminal buffers)
- `<leader>q` - Open diagnostic quickfix list

### File Navigation
- `<leader>e` - Toggle file explorer (nvim-tree)
- `<leader>ff` - Find files (fuzzy search)
- `<leader>fg` - Live grep (search text in files)
- `<leader>fb` - Find buffers (switch between open files)
- `<leader>fh` - Help tags (search Neovim help)

### Autocompletion (when popup appears)
- `<C-Space>` - Trigger autocomplete manually
- `<CR>` (Enter) - Accept selected completion
- `<Tab>` - Next completion item
- `<S-Tab>` - Previous completion item
- `<C-n>` - Next completion item (Vim-style)
- `<C-p>` - Previous completion item (Vim-style)
- `<C-e>` - Close completion menu
- `<C-b>` - Scroll documentation up
- `<C-f>` - Scroll documentation down

### System Integration
- `y` - Yank (copy) to system clipboard
- `p` - Paste from system clipboard
- `d` - Delete and copy to system clipboard

## Docker Integration

This configuration includes Docker container development support for seamless remote development.

### Setup for Docker Development

1. **Add alias to your shell** (recommended):
```bash
echo 'alias ndex="~/.config/nvim/scripts/attach_docker.sh"' >> ~/.bashrc
source ~/.bashrc
```

2. **Usage** (Two-step process):

   **Step 1:** Start your Docker container first:
   ```bash
   cd ~/github/AIRCoM_main/docker
   ./run_docker.sh /path/to/AIRCoM_main
   ```

   **Step 2:** Attach with Neovim (in a new terminal):
   ```bash
   ndex
   # or directly: ~/.config/nvim/scripts/attach_docker.sh
   ```

### How it works

- **First time**: Script automatically installs Neovim v0.11.3 and xclip in container
- **Subsequent runs**: Connects immediately with your full nvim configuration
- **Environment**: All your plugins, LSP, and settings work inside the container
- **File access**: Direct access to container filesystem and mounted volumes

### Container Features

- Full Neovim configuration with all plugins
- LSP support for container-specific dependencies  
- System clipboard integration with xclip
- Container aliases: `cb` (colcon build), `cbps` (build package), `ssb` (source build)

**Note:** The container must be running before using the attach script. If the container stops, restart it with step 1 above.
