#!/bin/bash
# Echo into bashrc
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
echo 'export BROWSER=wslview' >>~/.bashrc

# Source bashrc
source ~/.bashrc
cd BashScripts/Components || exit
chmod +x -R .

# Update repositories
echo "##############################  Performing initial updates  ##############################"
sudo apt-get update
sudo apt-get -y upgrade

# Install git from Src
echo "##############################  Installing git from Src   ##############################"
./git-from-src-ubuntu.sh &

# Install git lfs
echo "##############################  Installing git lfs  ##############################"
./git-lfs-ubuntu.sh &

# Install python
echo "##############################  Installing python  ##############################"
sudo ./python-ubuntu.sh

# Install Common Packages
echo "##############################  Installing Common Packages  ##############################"
sudo ./common-ubuntu.sh &

# Install Java
echo "##############################  Installing Java  ##############################"
sudo ./java-ubuntu.sh

# Install Nvidia Cuda
echo "##############################  Installing Nvidia Cuda Drivers  ##############################"
./nvidia-cuda-ubuntu.sh

# Install go
echo "##############################  Installing go  ##############################"
sudo ./go-ubuntu.sh

# Install rust
echo "##############################  Installing rust  ##############################"
sudo ./rust-ubuntu.sh

# Install ruby
echo "##############################  Installing ruby  ##############################"
sudo ./ruby-ubuntu.sh

# Install azure cli
echo "##############################  Installing azure cli  ##############################"
sudo ./azcli-ubuntu.sh

# Install dotnet
echo "##############################  Installing dotnet  ##############################"
sudo ./dotnet-ubuntu.sh

# Azure Functions
echo "##############################  Installing Azure Functions   ##############################"
./AzureFunctionsV4-Ubuntu.sh

# Install github
echo "##############################  Installing github gui and cli  ##############################"
./Github.sh

# Install Gitkraken
echo "##############################  Installing Gitkraken  ##############################"
./GitKraken.sh

# Install Sublime Text
./sublime-text.sh

# Install Maven
echo "##############################  Installing Maven  ##############################"
sudo ./maven-ubuntu.sh

# Install Gradle
echo "##############################  Installing Gradle  ##############################"
sudo ./gradle-ubuntu.sh

# Install mssql
echo "##############################  Installing mssql  ##############################"
sudo ./mssql-ubuntu.sh

# Install powershell
echo "##############################  Installing powershell  ##############################"
sudo ./powershell-ubuntu.sh

# Install sshd
echo "##############################  Installing sshd  ##############################"
sudo ./sshd-ubuntu.sh

# Install homebrew
echo "##############################  Installing homebrew   ##############################"
./homebrew-ubuntu.sh

# Install NVM
sudo ./node-ubuntu.sh

# Install Ananconda - Env for PyTorch, Pandas and ML related utilities
echo "##############################  Performing Ananconda  - Env for PyTorch, Pandas and ML related utilities  ##############################"
./anaconda.sh

echo "##############################  Done   ##############################"