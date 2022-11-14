# Introduction
This repo contains some scripts for setting up a ubuntu or debian wsl instance with required packages. 
IMPORTANT: This script works with Ubuntu 20.05 LTS because Microsoft Dotnet 3.1 and 5.0 are not supported on Ubuntu-22.04 LTS natively.

# Important Setup
Please update the below files

## Update wsl.conf
Please fill out the required information in wsl.conf file under ConfigurationFiles directory. Add your username for the distro and your desired hostname for the wsl instance. Its good practice to have hostname determine the purpose of the instance.
This will be copied to /etc/wsl.conf

## wsl simple script
Update the git config in the file accordingly, added required packages for general development, feel free to edit this script when running.

## OPTIONAL: Copy .wslgcongfig and .wslconfig
1. To manually control wsl settings in windows .wslconfig file is used, please copy this file to User's home folder in windows. Ex: C:\Users\<YourUser>
2. x-apps settings are managed by .wslgcongfig and currently the only way to change framerate for gui applications running in linux.

# NOTE
More information about the extended scripts will be updated soon.
