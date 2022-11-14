#!/bin/bash
#script for NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source bashrc
source ~/.bashrc

# Install node lts and 10
echo "##############################  Installing Node lts and Node 10   ##############################"
nvm install 14
npm install -g gulp yarn tslint vsts-npm-auth better-vsts-npm-auth
