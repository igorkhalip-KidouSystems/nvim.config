#!/bin/bash

set -e

NVIM_VERSION="0.11.3"
INSTALL_DIR="/opt/nvim-linux64"

echo "Setting up Neovim $NVIM_VERSION..."

echo "Downloading Neovim $NVIM_VERSION..."
curl -L -o nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux-x86_64.tar.gz"

echo "Verifying download..."
if ! file nvim-linux64.tar.gz | grep -q "gzip compressed"; then
    echo "Error: Downloaded file is not a valid gzip archive"
    echo "File contents:"
    cat nvim-linux64.tar.gz
    exit 1
fi

echo "Installing Neovim to $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR"
sudo tar -C /opt -xzf nvim-linux64.tar.gz

echo "Adding Neovim to PATH..."
if ! grep -q "/opt/nvim-linux-x86_64/bin" ~/.bashrc; then
    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
    echo "Added to ~/.bashrc"
else
    echo "Already in ~/.bashrc"
fi

if ! grep -q "/opt/nvim-linux-x86_64/bin" ~/.zshrc 2>/dev/null; then
    if [ -f ~/.zshrc ]; then
        echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
        echo "Added to ~/.zshrc"
    fi
fi

echo "Cleaning up..."
rm -f nvim-linux64.tar.gz

echo "Neovim $NVIM_VERSION installed successfully!"
echo "Run 'source ~/.bashrc' or restart your terminal to use nvim"
echo "Then run 'nvim' to start!"
