#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install curl git -y

# Remove any existing Neovim installation and download the latest version
rm -rf /opt/nvim
curl -Lo /opt/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -xvzf /opt/nvim-linux64.tar.gz -C /opt

# Add Neovim to PATH
export PATH="$PATH:/opt/nvim-linux64/bin"
source ~/.bashrc

# Clone the nvim-python repository
git clone https://github.com/AdolisPali/nvim-python.git /tmp/nvim-python

# Remove .git folder from the cloned repository and move files to home directory
rm -rf /tmp/nvim-python/.git
mv /tmp/nvim-python/.[!.]* ~
mv /tmp/nvim-python/* ~ 

# Clean up temporary files
rm -rf /tmp/nvim-python

# Download Node.js (v18.20.5) and extract it to /opt
curl -Lo /opt/node-v18.20.5-linux-x64.tar.gz https://nodejs.org/dist/v18.20.5/node-v18.20.5-linux-x64.tar.gz
tar -xvzf /opt/node-v18.20.5-linux-x64.tar.gz -C /opt

# Add Node.js to PATH
export PATH=/opt/node-v18.20.5-linux-x64/bin:$PATH
source ~/.bashrc

# Install Pyright globally using npm
npm install -g pyright

apt install python3-pip -y
pip3 install pydebug
pip3 install neovim
