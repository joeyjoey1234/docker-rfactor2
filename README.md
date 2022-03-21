

pterodactyl-rfactor2
===============

**Work in progress. Please test, Clean up is needed, and is in progress.**
![alt text](docker_rfactor2_diagram.png "Diagram")

Install the eggie in your pterodactyl server
Server needs atleast 4 ports.

EXPOSE 22  *in egg as Variable*
EXPOSE 54297 *Static* You have to get this to open.
EXPOSE 64297 *Static*
EXPOSE 5900 *in egg as Variable*

VAR's in egg
:VAR SSH_PORT: self explaintory port for the ssh server
:VAR VNC_PORT: self explaintory port for the VNC Server
:VAR PASSWORD: Sets the docker user password every machine start


