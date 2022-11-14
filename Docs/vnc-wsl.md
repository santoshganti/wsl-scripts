# WSL2 with GUI using Xvnc

In this tutorial, we will setup GUI in WSL2, and access it using VNC. No additional software outside WSL (like VcXsrv) is required, except, of course, a VNC Viewer ([RealVNC](https://www.realvnc.com/pt/connect/download/viewer/), [TightVNC](https://www.tightvnc.com/download.php), [TigerVNC](https://bintray.com/tigervnc/stable/tigervnc/1.10.1), [UVNC](https://www.uvnc.com/downloads/ultravnc.html), etc, all of them might work flawlessly).

The key components we need to install are `tigervnc-standalone-server` and [`systemd-genie`](https://github.com/arkane-systems/genie).

For this setup, I will use Ubuntu 20.04 LTS (Focal Fossa), and install GNOME Desktop. Since the key components aren't bound to Ubuntu or GNOME, you can use your favorite distro and GUI. Check the [Sample screenshots](https://gist.github.com/tdcosta100/385636cbae39fc8cd0937139e87b1c74#sample-screenshots) section for examples.

So let's go. First, we need a working [WSL2](https://docs.microsoft.com/pt-br/windows/wsl/wsl2-index) installation.

Before going to real business, let's make sure we are updated.

```
sudo apt update
sudo apt upgrade
```

If you are trying to use Debian, you also will need:

```
sudo apt install curl wget
```

Now we are ready to go.

## Installing components

### Installing GUI

1. Ubuntu has a handy component installer called `tasksel`, but it's not installed by default. So let's install it.
   ```
   sudo apt install tasksel
   ```

1. Once we have it installed, let's run it.
   ```
   sudo tasksel
   ```

1. At the package list, select your favorite GUI package. Use spacebar to select the package, and Tab to confirm your choice. I selected Ubuntu Desktop. The installation will take a while, so be patient.

### Installing VNC Server

Pretty easy, one command and you are done:

```
sudo apt install tigervnc-standalone-server
```

### Installing dotnet-runtime

systemd-genie requires dotnet-runtime, but it ins't installed automatically. Follow the [install instructions](https://docs.microsoft.com/en-us/dotnet/core/install/linux). Here are the commands to install dotnet-runtime-5.0 on Ubuntu 20.04 LTS (Focal Fossa):

```
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install dotnet-runtime-5.0
```

If you are using Debian, the commands are almost the same:

```
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install dotnet-runtime-5.0
```

### Installing systemd-genie

Now we will install systemd-genie, which is responsible for turning the minimalist WSL into a more complete Linux instance, with systemd and other related stuff. This is necessary to run GDM (GNOME Display Manager) and LightDM properly, giving the user a full graphic interface experience, with login and everything. Here are the [install instructions](https://github.com/arkane-systems/genie#installation). As of April 6th, 2021, these following commands are needed to install it (and I only guarantee they will work Ubuntu and Debian. For other distros, you must check how to get the appropriate package for your system):

```
sudo apt install apt-transport-https
sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg
source /etc/os-release
cat << EOF | sudo tee /etc/apt/sources.list.d/wsl-transdebian.list
deb https://arkane-systems.github.io/wsl-transdebian/apt/ $VERSION_CODENAME main
deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $VERSION_CODENAME main
EOF
sudo apt update
sudo apt install systemd-genie
```

The installation process is finally done.

## Configuring the environment

### Creating VNC Server passwords

1. In this setup, each user has a different VNC password. So you have to configure at least three passwords, one for the current user, other for root, and other for gdm, who whill present the login screen. If you don't configure the password, you won't able to access the login screen, or the user's desktop. First, let's configure the VNC password current user:
   ```
   vncpasswd
   ```

1. Now, let's configure the VNC password for root (needed if you use LightDM instead GDM):
   ```
   sudo -H vncpasswd
   ```

1. Finally, let's configure the VNC password for GDM (you need to skip this step if you didn't install GNOME):
   ```
   sudo -H -u gdm vncpasswd
   ```
   
   **Tip:** In Debian, the GDM user is Debian-gdm.

   You can repeat the process for other existing users.

### Replacing default X by Xvnc

By default, the display manager call multiple X instances, one for each user session, including the login screen, provided by gdm. So we will replace Xorg script by a new version which calls Xvnc instead the classic X/Xorg. This IS the real magic we are trying to do.

1. First, let's backup the original Xorg script.
   ```
   sudo mv /usr/bin/Xorg /usr/bin/Xorg_old
   ```

2. Then, we create a new Xorg script.
   ```
   sudo nano /usr/bin/Xorg_new
   ```

3. Paste the following content in the editor (remember, WSL shell uses CTRL + SHIFT + V for pasting, instead our traditional CTRL + V key combination):

   ```
   #!/bin/bash
   for arg do
     shift
     case $arg in
       # Xvnc doesn't support vtxx argument. So we convert to ttyxx instead
       vt*)
         set -- "$@" "${arg//vt/tty}"
         ;;
       # -keeptty is not supported at all by Xvnc
       -keeptty)
         ;;
       # -novtswitch is not supported at all by Xvnc
       -novtswitch)
         ;;
       # other arguments are kept intact
       *)
         set -- "$@" "$arg"
         ;;
     esac
   done
   
   # Here you can change or add options to fit your needs
   command=("/usr/bin/Xvnc" "-geometry" "1024x768" "-PasswordFile" "${HOME:-/root}/.vnc/passwd" "$@") 
   
   systemd-cat -t /usr/bin/Xorg echo "Starting Xvnc:" "${command[@]}"
   
   exec "${command[@]}"
   ```
   
   Please note the resolution of the virtual screen. You can change that to fit your needs (1366x768, 1920x1080, etc). Also, you can change the ```-PasswordFile``` option to point to a fixed location instead the home of current user, so you don't need to have a password for each user.

4. Finally, we set the correct permissions for the file and create a link to it:
   ```
   sudo chmod 0755 /usr/bin/Xorg_new
   sudo ln -sf Xorg_new /usr/bin/Xorg
   ```
   
   **Attention:** sometimes, system updates replace Xorg link with the original version. Just repeat this step if this happens, and Xvnc will work again as Xorg replacement.

## Running systemd-genie

Finally, it's time to put everything together.
```
genie -s
```

If you are using Debian, you need one extra step:
```
echo "LANG=en_US.UTF-8" | sudo tee -a /etc/default/locale
```

Doing this is like booting Linux again, this time with systemd. Because of systemd, gdm will start automatically, and will create a X instance to display the login interface. We changed this process to make it create Xvnc instances, so we can access them. The first instance will listen to port 5900, the second instance will listen to port 5901, and so on.

**Attention:** When running `genie` for the first time, it will take a lot of time, and probably will show an error message. After that, you must check what `systemd` units have failed. You can check that with a `systemctl list-units --failed`, then you must check [this page](https://github.com/arkane-systems/genie/wiki/Systemd-units-known-to-be-problematic-under-WSL) to see what to do with each failed unit. Most of them can be simply disabled/masked with no harm or side effects, and after doing that, `genie` will start much faster and without any error messages.

## Accessing the VNC screen

After a while (usually 30 seconds, but it can take more if you don't have a SSD, maybe one minute or two), you can test if it's working properly. Use your favorite VNC Viewer to connect to your localhost port 5900. Use the VNC password set for user gdm. The login screen must appear.

After logging in, the screen will be blank. This is because a new instance of Xvnc was created for user desktop, listening to port 5901. Connect to this screen now. The logged user's desktop must appear. When you log out, the screen at port 5900 will show the login interface again. This applies to GDM (which is the case if you installed Ubuntu Desktop). You can change this behavior changing the configuration file like this:

1. `sudo nano /etc/gdm3/custom.conf`

1. Uncomment and edit the following lines:
   ```
    AutomaticLoginEnable=true
    AutomaticLogin=[your username without the brackets]
    ```

If you are using LightDM, the desktop screen will appear in port 5900, so there's no need to connect to port 5901.

## Shutting down

One important thing is: once you start systemd services, you cannot just stop your Linux instance. You must perform a standard Linux shutdown. You can do one of one alternatives below:

- Power off option on GUI menu
- `sudo init 0`, inside the genie bottle
- `genie -u`, outside the genie bottle

After doing that, you can safely shut down your WSL instance, either by `wsl --terminate` or `wsl --shutdown`. Not doing the shutdown process may cause damage to your WSL instance. So be careful.

## Tips and tricks

- VNC is a very adaptive protocol, and by default tries to use the most aggressive compression available, for better networking performance. But in our case, doing this only adds unnecessary CPU extra load, since you are connecting to localhost ("infinite" bandwith, near zero ping). To remove all compression algorithms and reduce lagging, force your VNC Viewer to connect using RAW encoding. The performance gain is noticeable, specially when playing videos (not a spectacular performance in this particular scenario, though).

- If you are trying to use Debian, you need to do the following or some apps will not launch (at least in Buster):
  ```
  echo "LANG=en_US.UTF-8" | sudo tee -a /etc/default/locale
  ```

## Troubleshooting

1. If it doesn't work at first, try to check your journalctl logs:
   ```
   journalctl -b -t /usr/lib/gdm3/gdm-x-session -t /usr/bin/Xorg --no-pager
   ```
   
   If you are using Debian, then the command is:
   ```
   journalctl -b -t /usr/libexec/gdm-x-session -t /usr/bin/Xorg --no-pager
   ```

   In the output, you must see what command line was generated for Xvnc, and which error messages appear. Of course, even if it works correctly, you can check the logs just to see what is happening, or for debugging.

1. You must check if the custom Xorg script was not replaced by the default version of it. If it was the case, just repeat the steps of [Replacing default X by Xvnc](https://gist.github.com/tdcosta100/385636cbae39fc8cd0937139e87b1c74#replacing-default-x-by-xvnc) section.

1. Check if Xorg is your default display server, not Xephyr or Wayland. If it's not, you must change it to have Xorg as your default display server.

1. If you are using LightDM, you also need to check logs at /var/log/lightdm (you will need to use sudo to cat files in that directory). The Xvnc output will be in the file /var/log/lightdm/x-0.log.

1. If you can connect to 59XX ports, but receive an error like ```Authentication failure: No password configured for VNC Auth```, the file $HOME/.vnc/passwd is missing for that particular user (on port 5900, the user is gdm). Try to repeat the steps described in section [Creating VNC Server passwords](https://gist.github.com/tdcosta100/385636cbae39fc8cd0937139e87b1c74#creating-vnc-server-passwords) and try to connect again.

1. If it still doesn't work, you can try to restart WSL. Open a Windows PowerShell command prompt, and execute the following command (don't forget to save everything that is unsaved before, because WSL will shut down completely):
   ```
   PS > wsl --terminate <your distro name>
   ```

   After that, open your distro shell again and repeat the steps of section [Running systemd-genie](https://gist.github.com/tdcosta100/385636cbae39fc8cd0937139e87b1c74#running-systemd-genie).

## Sample screenshots

### GDM
![GDM](https://user-images.githubusercontent.com/708549/86651126-cce7c480-bfd2-11ea-8f74-b1127bc36a77.png)


### LightDM
![LightDM](https://user-images.githubusercontent.com/708549/86651404-06203480-bfd3-11ea-8275-e7914f80b1b2.png)


### GNOME
![GNOME](https://user-images.githubusercontent.com/708549/86651633-37990000-bfd3-11ea-9b06-f48c6dce22a9.png)


### KDE
![KDE](https://user-images.githubusercontent.com/708549/86651717-4a133980-bfd3-11ea-8c67-7349351e5bba.png)


### Xfce
![Xfce](https://user-images.githubusercontent.com/708549/86651798-5ac3af80-bfd3-11ea-993e-d8ed938f7262.png)


### Budgie Desktop
![Budgie Desktop](https://user-images.githubusercontent.com/708549/86843363-f9184980-c095-11ea-986d-9466cf54a035.png)


## Contributors

Thanks to this guys, whose feedback made this tutorial reach the current level of quality and completeness (and it will be more and more complete as more feedback is given).

- [nselimis](https://www.reddit.com/user/nselimis/)
- [rkzdota](https://www.reddit.com/user/rkzdota/)
- [WSL_subreddit_mod](https://www.reddit.com/user/WSL_subreddit_mod/)
- [ptflp](https://gist.github.com/ptflp)
- [ROBYER1](https://gist.github.com/ROBYER1)
- [vdevan](https://gist.github.com/vdevan)
- [Greasy-Monkey](https://gist.github.com/Greasy-Monkey)
- [siegLoesch](https://github.com/siegLoesch)
- [adamgranthendry](https://github.com/adamgranthendry)
- [cerebrate](https://github.com/cerebrate) - Creator of `systemd-genie`
- [hdhnl](https://gist.github.com/hdhnl)
- [MrRendroc](https://github.com/MrRendroc)
