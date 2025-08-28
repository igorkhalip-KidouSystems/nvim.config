#!/bin/bash

# Script to attach to AIRCoM Docker container with Neovim
# Usage: ./attach_docker.sh or nvim-docker (if aliased)

CONTAINER_NAME="ros2_dev_container"
NVIM_CONFIG_PATH="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

echo "Attaching to Docker container with Neovim..."

# Check if container is running
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo "Error: Container '$CONTAINER_NAME' is not running."
    echo ""
    echo "Start the container first:"
    echo "  cd ~/github/AIRCoM_main/docker"
    echo "  ./run_docker.sh /path/to/AIRCoM_main"
    echo ""
    echo "Then run this script again to attach with Neovim."
    exit 1
fi

echo "Container found. Setting up Neovim environment..."

# Execute into container with nvim setup
docker exec -it \
    -e TERM=xterm-256color \
    --user dev \
    "$CONTAINER_NAME" bash -c "
        set -e
        
        # Install Neovim if not present
        if [ ! -f /opt/nvim-linux64/bin/nvim ]; then
            echo 'Installing Neovim v0.11.3...'
            cd /tmp
            curl -LO https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.tar.gz
            sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
            rm nvim-linux-x86_64.tar.gz
            echo 'Neovim installed successfully.'
        fi
        
        # Install xclip for clipboard integration if not present
        if ! command -v xclip &> /dev/null; then
            echo 'Installing xclip for clipboard support...'
            sudo apt update -q && sudo apt install -y xclip
        fi
        
        # Copy nvim config if not present or outdated
        if [ ! -d ~/.config/nvim ] || [ ! -f ~/.config/nvim/init.lua ]; then
            echo 'Setting up Neovim configuration...'
            mkdir -p ~/.config
            # Mount the host nvim config (this will be available via docker exec)
            # For now, we'll copy from a temp location that needs to be mounted
            if [ -d /tmp/host_nvim_config ]; then
                cp -r /tmp/host_nvim_config ~/.config/nvim
            else
                echo 'Warning: Neovim config not found. You may need to set it up manually.'
            fi
        fi
        
        # Set up environment and start bash with nvim in PATH
        export PATH=\"/opt/nvim-linux64/bin:\$PATH\"
        cd /home/dev/github/AIRCoM_main
        
        echo ''
        echo '🚀 Ready! Neovim is available as \"nvim\"'
        echo '📁 Working directory: /home/dev/github/AIRCoM_main' 
        echo '⚡ Container aliases: cb (colcon build), cbps (build package), ssb (source build)'
        echo ''
        
        exec bash
    "