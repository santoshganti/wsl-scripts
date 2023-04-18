#!/bin/bash
# Commands to give all permissions to a directory - sudo chmod a+rwx /var/szDirectoryName
# Please enter relevant required information below for git config
echo 'export BROWSER=wslview' >>  ~/.bashrc

# First update
sudo apt-get update
sudo apt-get -y upgrade

# Install required packages
package_list="apt-utils \
        openssh-client \
        gnupg2 \
        dirmngr \
        iproute2 \
        procps \
        lsof \
        htop \
        net-tools \
        default-jre \
        psmisc \
        curl \
        wget \
        rsync \
        ca-certificates \
        unzip \
        zip \
        nano \
        vim-tiny \
        less \
        jq \
        lsb-release \
        apt-transport-https \
        dialog \
        libc6 \
        libgcc1 \
        libkrb5-3 \
        libgssapi-krb5-2 \
        libicu[0-9][0-9] \
        liblttng-ust[0-9] \
        libstdc++6 \
        zlib1g \
        locales \
        sudo \
        ncdu \
        man-db \
        strace \
        manpages \
        manpages-dev \
        x11-apps \
        nmap \
        gedit \
        nautilus \
        emacs \
        php \
        libnotify4 \
        libgbm1 \
        gnome-keyring \
        xdg-utils \
        libgbm1 \
        build-essential \
        init-system-helpers"
        
sudo apt -y install --no-install-recommends ${package_list}

# Setting up git config
git config --global user.name "Santosh Ganti"
git config --global user.email "santosh.ganti@live.com"

# Add git gcm of Windows as credential manager
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Install Github CLI
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y



# Add required feeds
# Adding microsoft packages for dotnet sdk
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Script for Azure Cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install dotnet and azure functions core tools and CUDA
sudo apt update
sudo apt install -y dotnet-sdk-7.0 dotnet-sdk-6.0 azure-functions-core-tools-4 powershell

# Install Azure Aritfact Credential Provider
wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash

# Clean up command
sudo apt autoremove

# script for NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

# Add Browser Config
echo 'export PATH="/mnt/c/Program Files (x86)/Microsoft/Edge Dev/Application:$PATH"' >> ~/.bashrc

# Set the browser Variable
echo 'export BROWSER="msedge.exe"' >> ~/.bashrc

# Reload configuration
source ~/.bashrc

# Install node 14
nvm install 14

# Install required global packages
npm install -g tslint prettier local-cors-proxy gulp yarn vsts-npm-auth better-vsts-npm-auth

# Copy WSL Config to /etc/wsl.conf
# IMPORTANT NOTE: Please update the hostname and username as required in wsl configuration
sudo cp ../3.wsl-config-files/wsl.conf /etc