#!/bin/bash

# restarts the xdm service
cd /home/docker/.wine/drive_c/racing/STEAMCMD/
wine /home/docker/.wine/drive_c/racing/STEAMCMD/steamcmd.exe +login anonymous +force_install_dir ../rFactor2-Dedicated +app_update 400300 +quit
/etc/init.d/xdm restart

# Start the ssh service
/usr/sbin/sshd -D
