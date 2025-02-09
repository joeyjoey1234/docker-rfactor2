# Container to be able to run an rFactor2 server 
#
# It Contains:
# SSH server:  (ran on port specfied by egg vars)
# X server: The graphical user interface core. (xvfb + xdm)
# JWM desktop: The graphical desktop interface.
# VNC server: To access the desktop remotely. 
# Wine: Windows implementation to be able to install and run rFactor 2
# 


FROM debian:latest

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server xdm xvfb jwm sudo xterm cabextract rox-filer x11vnc links


# Install some tools required for creating the image
RUN apt-get update -y \
	&& apt-get install -y --no-install-recommends \
		curl \
		unzip \
		wget \
		gnupg2 \
		unzip \
		software-properties-common
		

RUN dpkg --add-architecture i386 		
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/debian/
RUN apt update
RUN wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/Release.key | apt-key add -    
RUN echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11 ./" | tee /etc/apt/sources.list.d/wine-obs.list
# Install wine and related packages





# Use the latest version of winetricks
RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
		&& chmod +x /usr/local/bin/winetricks


# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive


# Configuring xdm to allow connections from any IP address and ssh to allow X11 Forwarding. 
RUN sed -i 's/DisplayManager.requestPort/!DisplayManager.requestPort/g' /etc/X11/xdm/xdm-config
RUN sed -i '/#any host/c\*' /etc/X11/xdm/Xaccess
RUN ln -s /usr/bin/Xorg /usr/bin/X
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Fix PAM login issue with sshd
RUN sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd

# Upstart and DBus have issues inside container. We work around in order to install firefox.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl


# Set locale (fix the locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Copy the files into the container
## ADD . /src

# Expose ssh, rfactor 2 web and simulation ports, and vnc port.
EXPOSE 22
EXPOSE 54297
EXPOSE 64297
EXPOSE 5900
# 
# Create the directory needed to run the sshd daemon
RUN mkdir /var/run/sshd 

# Add container user and generate a random password with 12 characters that includes at least one capital letter and number.
RUN adduser --home /home/container container
#TODO password is container, change it
RUN sed -Ei 's/adm:x:4:/container:x:4:container/' /etc/group
RUN adduser container sudo

# Set the default shell as bash for container user.
RUN chsh -s /bin/bash container

RUN echo 'export WINEDLLOVERRIDES="msvcr110,msvcp110=n,b"' >> /home/container/.bashrc
RUN echo '#!/bin/bash \n x11vnc -auth /home/someuser/.Xauthority -display :10 -create -forever &' >> /home/container/startvnc.sh
RUN chown container:container /home/container/startvnc.sh
RUN chmod +x /home/container/startvnc.sh

RUN echo '#!/bin/bash \n jwm & \n xterm &' >> /home/container/.xsession
RUN chmod +x /home/container/.xsession
RUN chown container:container /home/container/.xsession

RUN cd /home/container/
RUN apt update
RUN apt install -y --install-recommends winehq-stable
#RUN wget http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi
#RUN wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi
#RUN wget https://dl.winehq.org/wine/wine-mono/7.1.1/wine-mono-7.1.1-x86.msi

#RUN wine msiexec /i wine-mono-7.1.1-x86.msi

#RUN wine msiexec /i wine-gecko-2.47.2-x86_64.msi
#RUN wine msiexec /i wine-gecko-2.47.1-x86.msi

RUN echo '#!/bin/bash \n cd /home/container/.wine/drive_c/racing/STEAMCMD/ \n wine /home/container/.wine/drive_c/racing/STEAMCMD/steamcmd.exe +login anonymous +force_install_dir ../rFactor2-Dedicated +app_update 400300 +quit \n cp /home/container/.wine/drive_c/racing/rfactor2-dedicated/Bin64/ModMgr.exe /home/container/.wine/drive_c/racing/rfactor2-dedicated/ModMgr.exe \n cp /home/container/.wine/drive_c/racing/rfactor2-dedicated/Bin64/rFactor2\ Dedicated.exe /home/container/.wine/drive_c/racing/rfactor2-dedicated/rFactor2\ Dedicated.exe \n cp /home/container/.wine/drive_c/racing/rfactor2-dedicated/Support/Tools/MAS2_x64.exe /home/container/.wine/drive_c/racing/rfactor2-dedicated/MAS2_x64.exe' >> /home/container/download_update_game.sh
RUN echo '#!/bin/bash \n wine /home/container/.wine/drive_c/racing/rfactor2-dedicated/ModMgr.exe ' >> /home/container/start_modmgr.sh
RUN echo '#!/bin/bash \n wine /home/container/.wine/drive_c/racing/rfactor2-dedicated/MAS2_x64.exe ' >> /home/container/start_MAS.sh
RUN echo '#!/bin/bash \n wine /home/container/.wine/drive_c/racing/rfactor2-dedicated/Bin64/rFactor2\ Dedicated.exe ' >> /home/container/start_Server.sh

RUN echo '#!/bin/bash \n echo "paste download link has to be in a zip file or download link from https://steamworkshopdownloader.io/" \n read LINK \n cd ~/.wine/drive_c/racing/rfactor2-dedicated/Packages/ \n wget -O lmao.zip $LINK \n unzip *.zip' >> /home/container/download_mod.sh

RUN chmod +x /home/container/*.sh


RUN mkdir -p /home/container/.wine/drive_c/racing/
RUN mkdir /home/container/.wine/drive_c/racing/STEAMCMD/
RUN cd /home/container/.wine/drive_c/racing/STEAMCMD/
RUN wget http://media.steampowered.com/installer/steamcmd.zip
RUN unzip ./steamcmd.zip
RUN mv steamcmd.exe /home/container/.wine/drive_c/racing/STEAMCMD/steamcmd.exe
RUN chown -R container:container /home/container/*
RUN chown -R container:container /home/container/.*
RUN pwd
###RUN wine /home/container/.wine/drive_c/racing/STEAMCMD/steamcmd.exe +login anonymous +force_install_dir ../rFactor2-Dedicated +app_update 400300 +quit


ADD . /src
# Start xdm and ssh services.
ENV password password
CMD ["/bin/bash", "/src/startup.sh"]
