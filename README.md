

Docker-rfactor2
===============

This was a failed pterodactyl egg/image that was reverted back for general use as a docker conatiner 
**Finished), Clean up is needed, and is not in progress.**
![alt text](docker_rfactor2_diagram.png "Diagram")

Grab the package here  ghcr.io/joeyjoey1234/ptero-rfactor2:latest
Server needs atleast 4 ports and the steam ports possibly

EXPOSE 22  SSH Server  
EXPOSE 54297 Game Port
EXPOSE 64297 Game Port
EXPOSE 5900 VNC Server

YOU MUST HAVE A password VAR in your env.
This will be the VNC password and ssh password

Scripts to start each important part of the program are included in /home/container
ive allso added a script to download mods.

How to run this bad boi
=========================
Spin up container with image
Login via ssh or VNC (Perfered VNC) (default password is password)
use the script located in /home/container to install the game. (install_update_game.sh)
use the scripts located in /home/container to run the executables. (MAS2.exe etc.) they should all be there.
Make sure you have those game ports forwarded etc



Troubleshooting 
YOU WILL GET THE BELOW ERROR IF THE PASSWORD ENV VAR IS BLANK
============================================================
21/03/2022 23:39:11 passing arg to libvncserver: -passwd
21/03/2022 23:39:11 x11vnc version: 0.9.16 lastmod: 2019-01-05  pid: 44
21/03/2022 23:39:11 
21/03/2022 23:39:11 wait_for_client: WAIT:cmd=FINDCREATEDISPLAY-Xvfb
21/03/2022 23:39:11 
21/03/2022 23:39:11 initialize_screen: fb_depth/fb_bpp/fb_Bpl 24/32/2560
21/03/2022 23:39:11 *** unrecognized option(s) ***
21/03/2022 23:39:11 	[1]  20
21/03/2022 23:39:11 For a list of options run: x11vnc -opts
21/03/2022 23:39:11 or for the full help: x11vnc -help
21/03/2022 23:39:11 
21/03/2022 23:39:11 Here is a list of removed or obsolete options:
21/03/2022 23:39:11 
21/03/2022 23:39:11 removed: -hints, -nohints
21/03/2022 23:39:11 removed: -cursorposall
21/03/2022 23:39:11 removed: -nofilexfer, now the default.
21/03/2022 23:39:11 
21/03/2022 23:39:11 renamed: -old_copytile, use -onetile
21/03/2022 23:39:11 renamed: -mouse,   use -cursor
21/03/2022 23:39:11 renamed: -mouseX,  use -cursor X
21/03/2022 23:39:11 renamed: -X,       use -cursor X
21/03/2022 23:39:11 renamed: -nomouse, use -nocursor
21/03/2022 23:39:11 renamed: -old_pointer, use -pointer_mode 1

