#!/bin/bash
# Commands to give all permissions to a directory - sudo chmod a+rwx /var/szDirectoryName
# Please enter relevant required information below for git config
echo 'export BROWSER=wslview' >>  ~/.bashrc

# First update
sudo apt-get update
sudo apt-get -y upgrade

# Install git
sudo apt-get -y install git

# Setting up git config
git config --global user.name "Your Name"
git config --global user.email "youremail@domain.com"

# Add git gcm of Windows as credential manager
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"

# Install required packages
sudo apt-get -y install python3 python php curl wget nmap net-tools unzip gedit nautilus x11-apps default-jre apt-transport-https

# Add required feeds
# Adding microsoft packages for dotnet sdk
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Add NVIDIA CUDA Feed - only if your system has NVIDIA drivers. See - https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-wsl-ubuntu-11-7-local_11.7.1-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-11-7-local_11.7.1-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/

# Add Sources for Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Install CUDA Driver
sudo apt-get update
# sudo apt-get install -y cuda

# Script for Azure Cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install dotnet and azure functions core tools and CUDA
sudo apt-get install -y dotnet-sdk-6.0 dotnet-sdk-5.0 dotnet-sdk-3.1 azure-functions-core-tools-4 powershell
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Clean up command
sudo apt autoremove

# script for NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

# Optionally setting variable nvm for the current sesssion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Reload configuration
source ~/.bashrc

# Install node 14
nvm install 14

# Install required global packages
npm install -g tslint prettier local-cors-proxy gulp yarn vsts-npm-auth better-vsts-npm-auth

# Copy WSL Config to /etc/wsl.conf
# IMPORTANT NOTE: Please update the hostname and username as required in wsl configuration
sudo cp ../WSLConfigFiles/wsl.conf /etc

# SQL Server Setup 
# sudo /opt/mssql/bin/mssql-conf setup
# systemctl status mssql-server --no-pager

# Install GUI Apps
## Google Chrome
# cd /tmp
# sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb 
# sudo apt install --fix-broken -y
# sudo dpkg -i google-chrome-stable_current_amd64.deb

## Microsoft Teams
# cd /tmp
# sudo curl -L -o "./teams.deb" "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=linux&arch=x64&download=true&linuxArchiveType=deb"
# sudo apt install ./teams.deb -y

## Microsoft Edge Dev Browser
# sudo curl https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_101.0.1193.0-1_amd64.deb -o /tmp/edge.deb
# sudo apt install /tmp/edge.deb -y