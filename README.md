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

3. Add Neovim to your PATH (if not done automatically):
```bash
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
source ~/.bashrc
```

4. Start Neovim:
```bash
nvim
```

The setup script will automatically download and install the latest Neovim version and configure all plugins.
