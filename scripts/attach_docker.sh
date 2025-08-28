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

# Check if setup is already complete
SETUP_NEEDED=$(docker exec "$CONTAINER_NAME" bash -c "
    [ -f /opt/nvim-linux64/bin/nvim ] || [ -f /opt/nvim-linux-x86_64/bin/nvim ] && 
    [ -d ~/.config/nvim ] && 
    [ -f ~/.config/nvim/init.lua ] && 
    [ -d ~/.local/share/nvim/lazy/lazy.nvim ] && 
    command -v xclip >/dev/null 2>&1 && 
    echo 'ready' || echo 'setup_needed'
")

if [ "$SETUP_NEEDED" = "ready" ]; then
    echo "Connecting to container..."
else
    echo "Container found. Setting up Neovim environment..."
    
    # Copy nvim config to container first
    echo "Copying Neovim configuration to container..."
    docker cp "$NVIM_CONFIG_PATH" "$CONTAINER_NAME:/tmp/host_nvim_config"
fi

# Execute into container with nvim setup
docker exec -it \
    -e TERM=xterm-256color \
    --user dev \
    "$CONTAINER_NAME" bash -c "
        set -e
        
        # Only do setup if needed
        if [ '$SETUP_NEEDED' != 'ready' ]; then
            # Install Neovim if not present
            if [ ! -f /opt/nvim-linux64/bin/nvim ] && [ ! -f /opt/nvim-linux-x86_64/bin/nvim ]; then
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
                if [ -d /tmp/host_nvim_config ]; then
                    cp -r /tmp/host_nvim_config ~/.config/nvim
                    echo 'Neovim configuration copied successfully.'
                else
                    echo 'Warning: Neovim config not found. You may need to set it up manually.'
                fi
            fi
            
            # Fix permissions for nvim directories
            echo 'Setting up Neovim directories with proper permissions...'
            sudo mkdir -p ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ~/.config/nvim
            sudo chown -R dev:dev ~/.local ~/.cache ~/.config/nvim
            sudo chmod -R 755 ~/.local ~/.cache ~/.config/nvim
            
            # Install lazy.nvim plugin manager if not present
            if [ ! -d ~/.local/share/nvim/lazy/lazy.nvim ]; then
                echo 'Installing lazy.nvim plugin manager...'
                git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
                echo 'lazy.nvim installed successfully.'
            fi
        fi
        
        # Set up PATH for nvim (silently)
        if [ -f /opt/nvim-linux64/bin/nvim ]; then
            export PATH=\"/opt/nvim-linux64/bin:\$PATH\"
        elif [ -f /opt/nvim-linux-x86_64/bin/nvim ]; then
            export PATH=\"/opt/nvim-linux-x86_64/bin:\$PATH\"
        fi
        
        # Redirect nvim logs to proper location (not working directory)
        export NVIM_LOG_FILE=~/.local/state/nvim/log
        
        # Only show debug info if setup was needed
        if [ '$SETUP_NEEDED' != 'ready' ]; then
            # Find the actual nvim binary location for first-time setup
            NVIM_BIN=''
            if [ -f /opt/nvim-linux64/bin/nvim ]; then
                NVIM_BIN='/opt/nvim-linux64/bin/nvim'
            elif [ -f /opt/nvim-linux-x86_64/bin/nvim ]; then
                NVIM_BIN='/opt/nvim-linux-x86_64/bin/nvim'
            fi
            
            if [ -n \"\$NVIM_BIN\" ]; then
                echo \"Neovim binary found at \$NVIM_BIN\"
                \$NVIM_BIN --version | head -1
                echo ''
                echo '🚀 Ready! Neovim is available as \"nvim\"'
                echo '📁 Working directory: /home/dev/github/AIRCoM_main' 
                echo '⚡ Container aliases: cb (colcon build), cbps (build package), ssb (source build)'
                echo ''
            fi
        fi
        
        cd /home/dev/github/AIRCoM_main
        
        exec bash
    "