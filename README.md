

Docker-rfactor2
===============

**Work in progress. Please test, Clean up is needed, and is not in progress.**
![alt text](docker_rfactor2_diagram.png "Diagram")

Grab the package here  ghcr.io/joeyjoey1234/ptero-rfactor2:latest
Server needs atleast 4 ports and the steam ports possibly

EXPOSE 22  SSH Server
EXPOSE 54297 Game Port
EXPOSE 64297 Game Port
EXPOSE 5900 VNC Server

YOU MUST HAVE A password VAR in your env.
This will be the VNC password


