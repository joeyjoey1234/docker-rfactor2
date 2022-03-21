#!/bin/bash

# restarts the xdm service
#cd /home/docker/.wine/drive_c/racing/STEAMCMD/
#wine /home/docker/.wine/drive_c/racing/STEAMCMD/steamcmd.exe +login anonymous +force_install_dir ../rFactor2-Dedicated +app_update 400300 +quit
#cp /home/docker/.wine/drive_c/racing/rfactor2-dedicated/Bin64/ModMgr.exe /home/docker/.wine/drive_c/racing/rfactor2-dedicated/MogMgr.exe
#cp /home/docker/.wine/drive_c/racing/rfactor2-dedicated/Bin64/rFactor2\ Dedicated.exe ../rFactor2\ Dedicated.exe
#cp /home/docker/.wine/drive_c/racing/rfactor2-dedicated/Support/Tools/MAS2_x64.exe /home/docker/.wine/drive_c/racing/rfactor2-dedicated/MAS2_x64.exe


/etc/init.d/xdm restart 

# Start the ssh service
/usr/sbin/sshd
sudo -i -u container bash << EOF
x11vnc -auth /home/docker/.Xauthority -display :10 -create -forever 

